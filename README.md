# Strava OAuth Example in Objective-C

This example project contains sample code for authorizing against the
[Strava V3 API](http://developer.strava.com) in iOS and Mac Apps in Objective-C.
This example project uses either built-in libraries for each platform or easy to
install and use 3rd-party open source libraries where noted. This project aims to
be easily adaptable into your own code base with the objective of making the
Strava V3 API easy to consume by native iOS and Mac developers.

# Dependencies

This project requires two dependencies as [CocoaPods](http://cocoapods.org).

* [AFNetworking](https://github.com/AFNetworking/AFNetworking)
* [CocoaHTTPServer](https://github.com/robbiehanson/CocoaHTTPServer)

AFNetworking is used primarily for convenience to making consuming REST resources
more concise and readable. You can use any HTTP networking library or code to hit
the Strava V3 API.

CocoaHTTPServer is used to run a local HTTP server as the OAuth client. It comes bundled
with a couple of dependencies of its own but should not require additional setup.

After cloning or downloading this repository you don't need to do
anything special to add the dependencies but you can always optionally
run `pod update` to get the latest versions.

# Requirements

* > OSX 10.8 - this project has a deployment target of Mountain Lion or
  newer and hasn't been tested on older versions.
* ARC - if you want to use any of the included code in a non-ARC project make
sure to disable ARC on those files in the Compile Sources build phase using the
`-fno-objc-arc` compiler flag.

# Setup

1. Register a Strava OAuth application and set `localhost` as the domain.
2. Clone or download this repository - the dependencies are vendored as
CocoaPods, but you can optionally run `pod update` to get the latest
versions.
3. Open `Strava OAuth Example.xcworkspace` - do not use `Strava OAuth Example.xcproj`.
4. Update `StravaOAuthCredentials.m` with your client ID and secret.

# OAuth Workflow

1. The user presses the "Connect with Strava" in the Main Menu window
2. The application spawns an `OAuthWindowController` with a new window and embedded `WebView`
		pointing to http://strava.com/oauth/authorize passing `client_id`, `redirect_uri`, `response_type=code`,
		the requested scopes (`view_private` and/or `write`, space separated), and `approval_prompt=force`.
		It also starts an HTTP server listening on an available localhost
    port using an `HTTPConnection` subclass called `OAuthConnectionHandler` to monitor incoming connections
    by overriding the `HTTPConnection` method `-supportsMethod:atPath`.
3. The user logs in to Strava, then chooses to authorize or not authorize.
4. Strava redirects the user back to the localhost redirect URI where the HTTP server monitors the
		request.
5. If successful and the user authorizes the local web server will receive a request token in the
		`code` parameter.
6. The `OAuthWindowController` then requests an access token from Strava by POSTing the request token,
		the `client_id`, and `client_secret` to http://strava.com/oauth/token.
7. If successful Strava will respond with a JSON object containing an access token. This access token
		can then be used to access resources in the Strava V3 API by passing it as a query parameter named
		`access_token` or in an HTTP header named `Authorization` in the format `access_token %@` where
		`%@` is the access token.

# Contributing

This piece Strava sample code is meant to be a standalone educational resource, we won't
be accepting feature requests or pull requests for additional features. That said, if you
see a bug or have a suggestion, feel free to submit an issue or pull request.

# License

See LICENSE, which applies only to code supplied by Strava. See pertinent license material
for any 3rd-party source code.
