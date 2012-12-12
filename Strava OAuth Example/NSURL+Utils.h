//
//  NSURL+Utils.h
//  Strava OAuth Example
//
//  Created by Jeff Remer on 12/7/12.
//  Copyright (c) 2012 Strava. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Utils)
/* Provides a NSDictionary of query string paramter names and values */
- (NSDictionary *)queryStringValues;
@end
