//
//  OAuthConnectionHandler.m
//  Strava OAuth Example
//
//  Created by Jeff Remer on 12/7/12.
//  Copyright (c) 2012 Strava. All rights reserved.
//

#import "OAuthConnectionHandler.h"
#import "NSURL+Utils.h"

NSString *const OAuthConnectionHandlerDidStartNotification = @"OAuthConnectionHandlerDidStart";
NSString *const OAuthConnectionHandlerErrorDomain = @"OAuthConnectionHandlerErrorDomain";

@class GCDAsyncSocket;

@implementation OAuthConnectionHandler

- (void)startConnection
{
    [super startConnection];
	[[NSNotificationCenter defaultCenter] postNotificationName:OAuthConnectionHandlerDidStartNotification object:self];
}

- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)path
{
    DDLogVerbose(@"[%@]: %@", method, path);
    
    NSDictionary* params = [[NSURL URLWithString:[NSString stringWithFormat:@"http://localhost%@", path]] queryStringValues];
    NSString* requestToken = nil;
    if ((requestToken = [params valueForKey:@"code"])) {
        [self.delegate connectionHandler:self didRecieveOAuthRequestToken:requestToken];
    } else {
        NSError* error =    [NSError errorWithDomain:OAuthConnectionHandlerErrorDomain
                                                code:OAuthConnectionHandlerErrorUnknown
                                            userInfo:nil];
        NSString* errorCode = nil;
        if ((errorCode = [params valueForKey:@"error"])) {
            if ([errorCode isEqualToString:@"invalid_scope"]) {
                error = [NSError errorWithDomain:OAuthConnectionHandlerErrorDomain
                                            code:OAuthConnectionHandlerInvalidScope
                                        userInfo:nil];
            } else if ([errorCode isEqualToString:@"access_denied"]) {
                error = [NSError errorWithDomain:OAuthConnectionHandlerErrorDomain
                                            code:OAuthConnectionHandlerAccessDenied
                                        userInfo:nil];
            }
        }
        [self.delegate connectionHandler:self didFail:error];
    }
    return [super supportsMethod:method atPath:path];
}
@end
