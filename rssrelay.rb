class RSSRelay < Sinatra::Application

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

    cached_stream_contents = redis.get "stream_contents:#{params[:url]}"

    if cached_stream_contents
      return cached_stream_contents
    else
      client = Feedlr::Client.new
      stream_id = (params[:url] && ("feed/" + params[:url])) || params[:stream_id]
      count = params[:count] || ENV["DEFAULT_COUNT"] || 10
      
      stream_contents = client.stream_entries_contents(
        stream_id, 
        {
          count: count, 
          ranked: params[:ranked], 
          newerThan: params[:newerThan], 
          continuation: params[:continuation]
        }
        ).to_json

      redis.setex "stream_contents:#{params[:url]}", 3600, stream_contents
      return stream_contents
    end
  end

end