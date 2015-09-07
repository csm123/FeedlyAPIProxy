# RSS Proxy

RSS Proxy exposes an API for retrieving RSS feeds, and includes caching to increase speed.

Use cases:
- Use RSS feeds in your client-side JavaScript (rather difficult to do without a proxy)
- Speed up your existing RSS retrieval scenarios with simple caching

## Usage

RSS Proxy accepts GET requests for RSS feeds, and allows URL and number of articles to specified per request.

### Direct

`https://YOUR_DOMAIN/v1/feed?url=http://www.nytimes.com/services/xml/rss/nyt/HomePage.xml&count=8&key=YOUR_KEY`

### JQuery

```javascript
$.ajax(
  {url: "https://DOMAIN_FOR_THIS_APP/v3/streams/contents?url=http://www.nytimes.com/services/xml/rss/nyt/HomePage.xml&count=8&key=YOUR_KEY"})
.done(function(data) {
  alert("Found " + data.items.length + " items");
});
```

Parameter | Description
--------- | -----------
`url`    | The URL of the RSS feed. Alternatively, you can specify a `stream_id` as defined in Feedly's API reference. Either the `url` or `stream_id` is required.
`count`   | The number of entries to retrieve from the feed. Default is `DEFAULT_COUNT` or 10. Optional.
`key`     | If you set a key with the `API_KEY` configuration variable, this must match that key for the request to be processed.

### Results

**Fill in results here**

## Configuration variables

Only the REDIS_URL is required. If you use the Deploy to Heroku button below, you'll be prompted for these.

Config Variable | Description
--------------- | -----------
`ORIGINS`       | A comma-delimited list of domains that are allowed to submit cross-domain requests to the app.  No need for commas if you're specifying just one domain.<br/><br/>Examples:<br/>`http://mydomain.com/,http://someotherdomain.com/`<br/>`http://mydomain.com/`
`API_KEY`       | Set a key that will be required to make a request to this app.
`DEFAULT_COUNT` | If `count` is not specified for a request, the count that is used. If this is not specified, the default is 10.
`REDIS_URL` | Automatically set if you deploy to Heroku below. Specifies the location of the Redis server used for caching.

## Setup

### Heroku (recommended)

Heroku deployment is easy, and there's a free plan.


[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

### Local
1. Extract into a directory and run `bundle`
2. Run `bundle exec rackup config.ru`

## Toolset

- Ruby
- Sinatra
