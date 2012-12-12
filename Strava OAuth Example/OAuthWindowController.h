//
//  OAuthWindowController.h
//  Strava OAuth Example
//
//  Created by Jeff Remer on 12/10/12.
//  Copyright (c) 2012 Strava. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "OAuthConnectionHandler.h"

@protocol OAuthWindowControllerDelegate;

/** OAuthWindowController shows a window with an embedded WebView and walks the user
 * through the OAuth authorization process.
 */
@interface OAuthWindowController : NSWindowController<OAuthConnectionHandlerDelegate>
@property (nonatomic, assign) id<OAuthWindowControllerDelegate> delegate;

/** Designated initializer
 *
 * @param delegate The OAuthWindowControllerDelegate that recieves callbacks when the user authorizes or cancels.
 */
- (id)initWithDelegate:(id<OAuthWindowControllerDelegate>)delegate;

@end

/** The OAuthWindowControllerDelegate that recieves callbacks when the user authorizes or cancels. */
@protocol OAuthWindowControllerDelegate <NSObject>
/** Called when the controller receives an access token from the OAuth provider */
- (void)windowController:(OAuthWindowController*)controller didReceiveAccessToken:(NSString*)accessToken;
/** Called when the controller fails to authorize */
- (void)windowController:(OAuthWindowController*)controller didFail:(NSError*)error;
@end
