//
//  StravaClient.m
//  Strava OAuth Example
//
//  Created by Jeff Remer on 12/10/12.
//  Copyright (c) 2012 Strava. All rights reserved.
//

#import "StravaClient.h"

@implementation StravaClient

+ (StravaClient*)sharedClient
{
    static StravaClient* sharedClient = nil;
    if (!sharedClient) {
        NSURL *url = [NSURL URLWithString:@"https://www.strava.com"];
        sharedClient = [[super alloc] initWithBaseURL:url];
    }
    return sharedClient;
}

+ (void)setAccessToken:(NSString*)accessToken
{
    [[self sharedClient] setDefaultHeader:@"Authorization"
                                    value:[NSString stringWithFormat:@"access_token %@", accessToken]];
}
@end
