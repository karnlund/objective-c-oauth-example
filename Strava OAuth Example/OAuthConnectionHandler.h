//
//  OAuthConnectionHandler.h
//  Strava OAuth Example
//
//  Created by Jeff Remer on 12/7/12.
//  Copyright (c) 2012 Strava. All rights reserved.
//

#import "HTTPConnection.h"

/** NSNotification constant posted when the connection opened */
extern NSString *const OAuthConnectionHandlerDidStartNotification;
/** NSError domain for OAuthConnectionHandler errors */
extern NSString *const OAuthConnectionHandlerErrorDomain;

/** Possible error codes returned in connectionHandler:didFail: */
NS_ENUM(NSUInteger, OAuthConnectionHandlerError) {
    OAuthConnectionHandlerErrorUnknown = 0,
    OAuthConnectionHandlerInvalidScope,
    OAuthConnectionHandlerAccessDenied
};

@protocol OAuthConnectionHandlerDelegate;

/** OAuthConnectionHandler is a HTTPConnection that listens for information from an OAuth provider */
@interface OAuthConnectionHandler : HTTPConnection

/** The OAuthConnectionHandlerDelegate recieves messages when the OAuth provider
 * provides a request token or throws an error.
 */
@property (nonatomic, assign) id<OAuthConnectionHandlerDelegate> delegate;

@end

@protocol OAuthConnectionHandlerDelegate <NSObject>

/* Called when the OAuthConnectionHandler receives a request token from the OAuth provider.
 * 
 * @param handler The receiving OAuthConnectionHandler
 * @param requestToken The request token provided by the OAuth provider
 */
- (void)connectionHandler:(OAuthConnectionHandler *)handler didRecieveOAuthRequestToken:(NSString *)requestToken;

/* Called when the OAuthConnectionHandler receives an error from the OAuth provider.
 *
 * @param handler The receiving OAuthConnectionHandler
 * @param error A error with an OAuthConnectionHandlerError error code
 */
- (void)connectionHandler:(OAuthConnectionHandler *)handler didFail:(NSError*)error;

@end
