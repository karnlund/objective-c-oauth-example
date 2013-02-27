# Strava OAuth Example in Objective-C

This example project contains sample code for authorizing against the [Strava V3 API](http://developer.strava.com) in iOS and Mac Apps in Objective-C. This
example project uses either built-in libraries for each platform or easy to
install and use 3rd-party open source libraries where noted. This project aims
to be easily adaptable into your own code base with the objective of making the
Strava V3 API easy to consume by native iOS and Mac developers.

# Dependencies

This project requires two dependencies as [CocoaPods](http://cocoapods.org).

* [AFNetworking](https://github.com/AFNetworking/AFNetworking)
* [CocoaHTTPServer](https://github.com/robbiehanson/CocoaHTTPServer)

AFNetworking is used primarily for convenience to making consuming REST
resources more concise and readable. You can use any HTTP networking library or
code to hit the Strava V3 API.

CocoaHTTPServer is used to run a local HTTP server as the OAuth client. It
comes bundled with a couple of dependencies of its own but should not require
additional setup.

After cloning or downloading this repository you don't need to do anything
special to add the dependencies but you can always optionally run `pod update`
to get the latest versions.

# Requirements

* > OSX 10.8 - this project has a deployment target of Mountain Lion or newer
and hasn't been tested on older versions.
* ARC - if you want to use any of the included code in a non-ARC project make
sure to disable ARC on those files in the Compile Sources build phase using the
`-fno-objc-arc` compiler flag.

# Setup

1. Register a Strava OAuth application and set `localhost` as the domain.
2. Clone or download this repository - the dependencies are vendored as
CocoaPods, but you can optionally run `pod update` to get the latest
versions.
3. Open `Strava OAuth Example.xcworkspace` - do not use `Strava OAuth
Example.xcodeproj`.
4. Update `StravaOAuthCredentials.m` with your client ID and secret.

# OAuth Workflow

OAuth
-----

OAuth is an authorization protocol that allows users of one application (the
OAuth Provider, Strava.com) to authenticate against that provider and grant 
some access to their information and capabilities from a third-party 
application (OAuth consumer, your app).

The point of OAuth is to safely authenticate users against an OAuth provider
without requiring their user credentials directly.

Basic Workflow
--------------

The general workflow for all Strava OAuth applications.

1. You redirect the user to Strava.com's authorization page
2. The user clicks "Authorize"
3. Strava.com redirects back to your size and includes a request token.
4. Your application uses the request token to fetch an access token.
5. Going forward your application can use the access token to request 
information and perform actions on behalf of the user.

The Specifics
------------

Here are the specifics of how this example application gets OAuth access to the
API. Typically OAuth applications are hosted web applications, so a native
desktop application needs to employ a few tricks to play nice with the OAuth
provider.

### Connecting with Strava

The first step is to send the user to Strava.com to authorize your application.
The user presses "Connect with Strava".

### Authorization Page

The application then spawns a new window controller, called
`OAuthWindowController`. The window has an embedded `WebView` which points to
`http://strava.com/oauth/authorize` and has the following query string
parameters:

* `client_id`
* `redirect_uri`
* `response_type`, `code` in this case
* `scopes`, `view_private` and or `write`, space separated
* `approval_prompt`, optional, `force` to always show the page even if the 
user has already authorized.

Simultaneously the window controller starts a local HTTP server listening on 
any available port. It sends the URL of the localhost server as the 
`redirect_uri` specified above.

The window controller registers a subclass of `HTTPConnection` called
`OAuthConnectionHandler` which will monitor incoming connections by overriding
the `-supportsMethod:atPath:` selector. Anytime the local HTTP server recieves
an incoming request it will path through `-supportsMethod:atPath:`.

The connection handler also initially sends an `NSNotification` to let the
window controller know that the connection has begun. This lets the window
controller know to register itself as the connection handler's delegate so that
it can be notified when a request token has been received.

At this point the user will see a window asking them to log into Strava.com,
then they will be redirected to a page asking them to choose if they authorize
your application or not.

### Request Token

If the user chooses "Authorize" then Strava will redirect to the localhost URI
specified as the `redirect_uri` above.

The `OAuthConnectionHandler` receives the incoming request and looks for a
request token in the `code` query string parameter. The handler then informs 
its delegate that it has received a request token.

That completes the first leg of the OAuth workflow.

## Access Token

Now that the sample application has a request token it can fetch an access token. The `OAuthWindowController` requests an access token from Strava by POSTing the the following paramters to `http://strava.com/oauth/token`:

* `code`, the request token
* `client_id`
* `client_secret`

If successful Strava will respond with a JSON object containing an access 
token, for example:

    {"access_token" : "f1d2d2f924e986ac86fdf7b36c94bcdf32beec15"}

The applciation can then access resources on the Strava V3 API on behalf of the user by passing a query string parameter named `access_token` or an HTTP header named `Authorization` in the format `Authorization: access_token %@` where `%@` is the access token.

# Contributing

This piece Strava sample code is meant to be a standalone educational resource,
we won't be accepting feature requests or pull requests for additional feature.
That said, if you see a bug or have a suggestion, feel free to submit an issue
or pull request.

# License

See LICENSE, which applies only to code supplied by Strava. See pertinent
license material for any 3rd-party source code.
