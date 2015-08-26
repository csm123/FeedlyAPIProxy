require "redis"
require "feedlr"

redis = (ENV["REDIS_URL"] && Redis.new(:url => ENV["REDIS_URL"])) || Redis.new
feed_urls = redis.smembers "feed_urls"

feed_urls.each do |feed_url|

  client = Feedlr::Client.new

  stream_contents = client.stream_entries_contents(
  "feed/" + feed_url, 
  {
    count: 10
  }
  )
  
  redis.set "stream_contents:#{feed_url}", stream_contents.to_json

end