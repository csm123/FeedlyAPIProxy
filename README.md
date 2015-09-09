**My focus has shifted to [RSS Proxy](https://github.com/csm123/rssproxy), which does not depend on Feedly so is not subject to its API limits. This app is functional, however, so feel free to adapt it for your use.**

# Feedly API Proxy for RSS Feeds

This app allows you retrieve the contents of an RSS feed via the [Feedly Cloud API](https://developer.feedly.com/), using JavaScript on your web site.

The Feedly Cloud API is not directly accessible via JavaScript, since it does not allow cross-origin requests. This app provides a proxy to the Feedly API you can directly access through JavaScript.

## Usage

### Direct

`https://DOMAIN_FOR_THIS_APP/v3/streams/contents?url=http://www.nytimes.com/services/xml/rss/nyt/HomePage.xml&count=8`

### JQuery

```javascript
$.ajax(
  {url: "https://DOMAIN_FOR_THIS_APP/v3/streams/contents?url=http://www.nytimes.com/services/xml/rss/nyt/HomePage.xml&count=8"})
.done(function(data) {
  alert("Found " + data.items.length + " items");
});
```

Parameter | Description
--------- | -----------
`url`    | The URL of the RSS feed. Alternatively, you can specify a `stream_id` as defined in Feedly's API reference. Either the `url` or `stream_id` is required.
`count`   | The number of entries to retrieve from the feed. Default is `DEFAULT_COUNT` or 10. Optional.
`key`     | Set a key that will be required to make a request to this app. This is not a Feedly API key and not passed to Feedly. Required if the `API_KEY` configuration variable exists. 

This returns [Feedly stream contents](https://developer.feedly.com/v3/streams/#get-the-content-of-a-stream) in JSON format, containing an `items` array with [Feedly entries](https://developer.feedly.com/v3/entries/).

## Configuration variables

The app uses these configruation variables, though none are required. If you use the Deploy to Heroku button below, you'll be prompted for these.

Config Variable | Description
--------------- | -----------
`ORIGINS`       | A comma-delimited list of domains that are allowed to submit cross-domain requests to the app.  No need for commas if you're specifying just one domain.<br/><br/>Examples:<br/>`http://mydomain.com/,http://someotherdomain.com/`<br/>`http://mydomain.com/`
`API_KEY`       | Set a key that will be required to make a request to this app.
`DEFAULT_COUNT` | If `count` is not specified for a request, the count that is used. If this is not specified, the default is 10.

## Setup

### Local
1. Extract into a directory and run `bundle`
2. Run `bundle exec rackup config.ru`

### Heroku
[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

## Other Feedly API tasks

The Feedly Cloud API can do a lot, but this app is limited to retrieving a specific RSS feed. Feel free to submit requests under Issues, and I'll do what I can!

## Toolset

- Ruby
- Sinatra
- [Feedlr gem](https://github.com/khelll/feedlr)
