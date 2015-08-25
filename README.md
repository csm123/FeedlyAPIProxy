# Feedly Cloud API Proxy for Streams

This app allows you retrieve the contents of an RSS feed via the Feedly Cloud API, using JavaScript.

The [Feedly Cloud API](https://developer.feedly.com/) is not directly accessible via JavaScript, since it does not allow cross-origin requests.

## Usage

`http://yourapp.com/v3/streams/contents?url=http://www.nytimes.com/services/xml/rss/nyt/HomePage.xml&count=10&key=your_key_here`

Parameter | Description
--------- | -----------
`url`    | Required. The URL of the RSS feed. Alternatively, you can specify a `stream_id` as defined in Feedly's API reference.
`count`   | Optional. The number of entries to retrieve from the feed. Default is `DEFAULT_COUNT` or 10.
`key`     | Required if the `API_KEY` configuration variable exists. This is not a Feedly API key, but a key that you set that guards access to this app.

This returns [Feedly stream contents](https://developer.feedly.com/v3/streams/#get-the-content-of-a-stream) in JSON format, containing an `items` array with [Feedly entries](https://developer.feedly.com/v3/entries/).

## Configuration variables

Both variables below must be set on the server hosting this app. It's easy to [set config variables in Heroku](https://devcenter.heroku.com/articles/config-vars).

Config Variable | Description
--------------- | -----------
`ORIGINS`       | A comma-delimited list of domains that are allowed to submit cross-domain requests to the app.  No need for commas if you're specifying just one domain.<br/><br/>Examples:<br/>`http://mydomain.com/,http://someotherdomain.com/`<br/>`http://mydomain.com/`
`API_KEY`       | Set a key that will be required to make a request to this app.
`DEFAULT_COUNT` | If `count` is not specified for a request, the count that is used. If this is not specified, the default is 10.

## Setup

### Local
Extract into a directory and run `bundle`. You can set the configuration varaibles locally, but none are required to test the app in your browser.

### Heroku


## Toolset

- Ruby
- Sinatra
- Feedlr gem
