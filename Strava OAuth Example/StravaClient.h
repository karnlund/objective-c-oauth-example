//
//  StravaClient.h
//  Strava OAuth Example
//
//  Created by Jeff Remer on 12/10/12.
//  Copyright (c) 2012 Strava. All rights reserved.
//

#import "AFHTTPClient.h"

/** StravaClient is a lightweight HTTP client */
@interface StravaClient : AFHTTPClient

/** StravaClient singleton */
+ (StravaClient*)sharedClient;

/** Sets the access token on the sharedClient */
+ (void)setAccessToken:(NSString*)accessToken;

@end
