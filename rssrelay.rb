class RSSRelay < Sinatra::Application

  require "open-uri"
  require "rss"

  redis = (ENV["REDIS_URL"] && Redis.new(:url => ENV["REDIS_URL"])) || Redis.new

  get "/v1/feed" do

    content_type :json

    # Log all URL's retrieved. Placeholder for a feature to proactively fetch streams.
    # redis.sadd "feed_urls", params[:url]

    # Allow cross-origin JavaScript calls according to config vars
    if ENV["ALLOW_ALL_ORIGINS"] && ENV["ALLOW_ALL_ORIGINS"].downcase == "true"
      cross_origin
    elsif ENV["ORIGINS"] && ENV["ORIGINS"].split(",")
      cross_origin :allow_origin => origins
    end
    
    # Require correct API key if specified in config vars
    if ENV["API_KEY"] && params[:key] != ENV["API_KEY"]
      halt 401, {:error => "Invalid key"}.to_json
    end

    # Require a URL 
    if !params[:url]
      halt 422, {:error => "A URL is required"}.to_json
    end

    # Take either the count specified in parameters, the count specified in config 
    # vars, or 100
    number_of_items_requested = (params[:count] || ENV["DEFAULT_COUNT"] || 25).to_i

    # Look for a redis cache of the requested feed
    cached_items = redis.get "items:#{params[:url]}"

    # Grab cached stream contents, in order to count its items and see if it can
    # serve the number of items requested

    parsed_cached_items = nil

    if cached_items
      parsed_cached_items = JSON.parse(cached_items)
      number_of_items_cached = parsed_cached_items["items"].length
    end

    # If the cache can serve the requested number of items, serve them from cache
    if cached_items && number_of_items_cached >= number_of_items_requested
      parsed_cached_items["from_proxy_cache"] = "true"
      parsed_cached_items["items"] = parsed_cached_items["items"][0, number_of_items_requested]
      return parsed_cached_items.to_json

    # Otherwise, retrieve the feed directly
    else
      items = nil

      open(params[:url]) do |rss|
        feed = RSS::Parser.parse(rss, false)
        items = feed.items.map{|item| {:title => item.title, :alternate => [{:href => item.link}], :published => item.pubDate}}
      end

      number_of_items_to_cache = (ENV["NUMBER_OF_ITEMS_TO_CACHE_PER_FEED"] || 25).to_i

      # Cache 100 items
      items_to_cache = {:items => items[0, number_of_items_to_cache]}
      items_to_return = {:items => items[0, number_of_items_requested]}

      cache_life = (ENV["CACHE_LIFE"] || 3600).to_i

      if items
        redis.setex "items:#{params[:url]}", cache_life, items_to_cache.to_json
      end

      return items_to_return && items_to_return.to_json
    end
  end

end