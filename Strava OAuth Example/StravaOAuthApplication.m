//
//  StravaOAuthCredentials.m
//  Strava OAuth Example
//
//  Created by Jeff Remer on 12/10/12.
//  Copyright (c) 2012 Strava. All rights reserved.
//

#import "StravaOAuthApplication.h"

@implementation StravaOAuthApplication

+(StravaOAuthApplication*) currentApplication;
{
    static StravaOAuthApplication* application = NULL;

    @synchronized(self) {
        if (application == NULL) {
            application = [self new];
        }
    }
    return application;
}

#warning FIXME: Return your client ID here
- (NSString *)clientId
{
    NSString* clientId = nil;
    NSAssert(clientId, @"FIXME: Return your client ID here");
    return clientId;
}

#warning FIXME: Return your client secret here
- (NSString *)clientSecret
{
    NSString* clientSecret = nil;
    NSAssert(clientSecret, @"FIXME: Return your client secret here");
    return clientSecret;
}
@end
