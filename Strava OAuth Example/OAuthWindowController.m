//
//  OAuthWindowController.m
//  Strava OAuth Example
//
//  Created by Jeff Remer on 12/10/12.
//  Copyright (c) 2012 Strava. All rights reserved.
//

#import "OAuthWindowController.h"

#import <WebKit/WebKit.h>

#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "HTTPServer.h"
#import "OAuthConnectionHandler.h"
#import "StravaClient.h"
#import "StravaOAuthApplication.h"

@interface OAuthWindowController ()
@property (nonatomic, strong) HTTPServer *httpServer;
@property (weak) IBOutlet WebView *webView;
@end

@implementation OAuthWindowController

#pragma mark - Initializer

- (id)initWithDelegate:(id<OAuthWindowControllerDelegate>)windowDelegate
{
    if(self = [super initWithWindowNibName:@"OAuthWindowController"]) {
        self.delegate = windowDelegate;
    }
    return self;
}

#pragma mark - Window wifecycle

- (void)windowDidLoad
{
    [super windowDidLoad];
    [self setup];
}

- (void)showWindow:(id)sender
{
    [super showWindow:sender];
    NSString* redirectURL = [NSString stringWithFormat: @"http://localhost:%d", self.httpServer.listeningPort];
    
    self.webView.frameLoadDelegate = self;
    NSString* path = [[NSString stringWithFormat:@"https://strava.com/oauth/authorize?client_id=%@&redirect_uri=%@&response_type=code&scope=view_private write&approval_prompt=force",
                       [StravaOAuthApplication currentApplication].clientId, redirectURL] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSURL* url = [NSURL URLWithString:path];
    [self.webView.mainFrame loadRequest:[NSURLRequest requestWithURL:url]];

    [self.window center];
}

- (void)dealloc
{
    [self teardown];
}

#pragma - HTTP Server setup and teardown

- (void)setup
{
    self.httpServer = [[HTTPServer alloc] init];
    [self.httpServer setType:@"_http._tcp."];
    [self.httpServer setConnectionClass:[OAuthConnectionHandler class]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(connectionDidStart:)
                                                 name:OAuthConnectionHandlerDidStartNotification
                                               object:nil];

    NSError* error = nil;
    if(![self.httpServer start:&error]) {
		DDLogError(@"Error starting HTTP Server: %@", error);
	} else {
        DDLogVerbose(@"Port: %d", self.httpServer.listeningPort);
    }    
}

- (void)teardown
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.httpServer stop];
}

#pragma mark - Connection notifications

- (void)connectionDidStart:(NSNotification *)notification
{
    if ([notification.object isMemberOfClass:[OAuthConnectionHandler class]]) {
        [notification.object setDelegate:self];
    }
}

#pragma mark - OAuthConnectionHandlerDelegate

- (void)connectionHandler:(OAuthConnectionHandler *)handler didRecieveOAuthRequestToken:(NSString *)requestToken
{
    [self.window close];
    [self teardown];
    handler.delegate = nil;
    
    DDLogVerbose(@"Received request token: %@", requestToken);
    
    NSDictionary *params = @{
        @"client_id": [StravaOAuthApplication currentApplication].clientId,
        @"client_secret": [StravaOAuthApplication currentApplication].clientSecret,
        @"code": requestToken
    };
    
    [[StravaClient sharedClient] postPath:@"/oauth/token"  parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary* JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:NULL];
        NSString* accessToken = [JSON valueForKey:@"access_token"];
        DDLogVerbose(@"Access token: %@", accessToken);
        [self.delegate windowController:self didReceiveAccessToken:accessToken];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DDLogVerbose(@"%@", error);
        [self.delegate windowController:self didFail:error];
    }];
}

- (void)connectionHandler:(OAuthConnectionHandler *)handler didFail:(NSError *)error
{
    DDLogError(@"%@", error);
    [self.window close];
    [self teardown];
}

@end
