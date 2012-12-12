//
//  NSURL+Utils.m
//  Strava OAuth Example
//
//  Created by Jeff Remer on 12/7/12.
//  Copyright (c) 2012 Strava. All rights reserved.
//

#import "NSURL+Utils.h"

@implementation NSURL (Utils)
static NSString* ampersandKey = @"&";
static NSString* equalsKey = @"=";

- (NSDictionary *)queryStringValues
{
    NSString* query = [self query];
    NSMutableDictionary* vals = [[NSMutableDictionary alloc] init];
    for(NSString* queryVal in [query componentsSeparatedByString:ampersandKey]) {
        NSArray* pair = [queryVal componentsSeparatedByString:equalsKey];
        if([pair count] == 2) {
            NSString* escaped = [pair objectAtIndex:1];
            [vals setValue:escaped forKey:[pair objectAtIndex:0]];
        }
    }
    return vals;
}

@end
