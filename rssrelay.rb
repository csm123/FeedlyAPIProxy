class RSSRelay < Sinatra::Application

  require "open-uri"
  require "rss"

  redis = (ENV["REDIS_URL"] && Redis.new(:url => ENV["REDIS_URL"])) || Redis.new

  get "/v3/streams/contents" do

    content_type :json

    redis.sadd "feed_urls", params[:url]

    if ENV["ALLOW_ALL_ORIGINS"] && ENV["ALLOW_ALL_ORIGINS"].downcase == "true"
      cross_origin
    elsif ENV["ORIGINS"] && ENV["ORIGINS"].split(",")
      cross_origin :allow_origin => origins
    end
    
    if ENV["API_KEY"] && params[:key] != ENV["API_KEY"]
      halt 401, {:error => "Invalid key"}.to_json
    end

    if !params[:url] && !params[:stream_id]
      halt 422, {:error => "A URL or stream ID is required"}.to_json
    end

    cached_stream_contents = redis.get "items:#{params[:url]}"

    if cached_stream_contents
      parsed_cached_stream_contents = JSON.parse(cached_stream_contents)
      parsed_cached_stream_contents["from_proxy_cache"] = "true"
      return parsed_cached_stream_contents.to_json
    else

      items = nil

      open(params[:url]) do |rss|
        feed = RSS::Parser.parse(rss)
        items = feed.items.map{|item| {:title => item.title, :alternate => [{:href => item.link}], :published => item.pubDate}}
      end

      items = {:items => items[0, 10]}

      if items
        redis.setex "items:#{params[:url]}", 3600, items.to_json
      end

      return items && items.to_json
    end
  end

end