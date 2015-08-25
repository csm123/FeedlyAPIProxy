# Feedly API Proxy for RSS Feeds

This app allows you retrieve the contents of an RSS feed via the [Feedly Cloud API](https://developer.feedly.com/), using JavaScript on your web site.

The Feedly Cloud API is not directly accessible via JavaScript, since it does not allow cross-origin requests. This app provides a proxy to the Feedly API you can directly access through JavaScript.

## Usage

### Direct

`https://DOMAIN_FOR_THIS_APP/?url=http://www.nytimes.com/services/xml/rss/nyt/HomePage.xml&count=8`

### JQuery

```javascript
$.ajax(
  {url: "https://DOMAIN_FOR_THIS_APP/?url=http://www.nytimes.com/services/xml/rss/nyt/HomePage.xml&count=8"})
.done(function(data) {
  alert("Found " + data.items.length + " items");
});
```

Parameter | Description
--------- | -----------
`url`    | Required. The URL of the RSS feed. Alternatively, you can specify a `stream_id` as defined in Feedly's API reference.
`count`   | Optional. The number of entries to retrieve from the feed. Default is `DEFAULT_COUNT` or 10.
`key`     | Required if the `API_KEY` configuration variable exists. This is not a Feedly API key, but a key that you set that guards access to this app.

This returns [Feedly stream contents](https://developer.feedly.com/v3/streams/#get-the-content-of-a-stream) in JSON format, containing an `items` array with [Feedly entries](https://developer.feedly.com/v3/entries/).

## Configuration variables

Both variables below must be set on the server hosting this app. If you use the Deploy to Heroku button below, you'll be prompted for them.

Config Variable | Description
--------------- | -----------
`ORIGINS`       | A comma-delimited list of domains that are allowed to submit cross-domain requests to the app.  No need for commas if you're specifying just one domain.<br/><br/>Examples:<br/>`http://mydomain.com/,http://someotherdomain.com/`<br/>`http://mydomain.com/`
`API_KEY`       | Set a key that will be required to make a request to this app.
`DEFAULT_COUNT` | If `count` is not specified for a request, the count that is used. If this is not specified, the default is 10.

## Setup

### Local
1. Extract into a directory and run `bundle`
2. Run `bundle exec rackup config.ru`

You can set the configuration varaibles locally, but none are required to test the app in your browser.

### Heroku
[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

## Other Feedly API tasks

This app allows you to retrieve the contents of an RSS feed with the Feedly API. The Feedly API contains other functionality, but this app does not support it. Please submit requests to the Issues tab and I'll do my best!

## Toolset

- Ruby
- Sinatra
- [Feedlr gem](https://github.com/khelll/feedlr)
