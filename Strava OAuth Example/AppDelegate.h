//
//  AppDelegate.h
//  Strava OAuth Example
//
//  Created by Jeff Remer on 12/7/12.
//  Copyright (c) 2012 Strava. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

#import "OAuthWindowController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, OAuthWindowControllerDelegate>

@property (weak) IBOutlet NSWindow *window;

- (IBAction)connectWithStrava:(id)sender;
@end
