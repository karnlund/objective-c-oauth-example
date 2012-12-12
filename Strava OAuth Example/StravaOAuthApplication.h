//
//  StravaOAuthCredentials.h
//  Strava OAuth Example
//
//  Created by Jeff Remer on 12/10/12.
//  Copyright (c) 2012 Strava. All rights reserved.
//

#import <Foundation/Foundation.h>

/** StravaOAuthCredentials is a convience wrapper for a client ID and secret */
@interface StravaOAuthApplication : NSObject

@property (nonatomic, readonly) NSString* clientId;
@property (nonatomic, readonly) NSString* clientSecret;
+(StravaOAuthApplication*) currentApplication;

@end
