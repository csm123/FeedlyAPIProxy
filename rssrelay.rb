class RSSRelay < Sinatra::Application
  get "/v3/streams/contents" do

    content_type :json

    if ENV["ALLOW_ALL_ORIGINS"] && ENV["ALLOW_ALL_ORIGINS"].downcase == "true"
      cross_origin
    elsif ENV["ORIGINS"] && ENV["ORIGINS"].split(",")
      cross_origin :allow_origin => origins
    end

    client = Feedlr::Client.new
    
    if ENV["API_KEY"] && params[:key] != ENV["API_KEY"]
      halt 401, {:error => "Invalid key"}.to_json
    end

    if !params[:url] && !params[:stream_id]
      halt 422, {:error => "A URL or stream ID is required"}.to_json
    end

    stream_id = (params[:url] && ("feed/" + params[:url])) || params[:stream_id]

    count = params[:count] || ENV["DEFAULT_COUNT"] || 10

    client.stream_entries_contents(
      stream_id, 
      {
        count: count, 
        ranked: params[:ranked], 
        newerThan: params[:newerThan], 
        continuation: params[:continuation]
      }
      ).to_json

  end
end