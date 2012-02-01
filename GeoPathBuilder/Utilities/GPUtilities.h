//
//  GPUtilities.h
//  GeoPathBuilder
//
//  Created by Mark Rabenhorst on 1/31/12.
//  Copyright (c) 2012 Intl Mapping. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPConstants.h"

@interface GPUtilities : NSObject

// General Utilities
+ (NSString*)createTagWithName: (NSString*)tagName attributes: (NSDictionary*)attributes andValue: (NSString*)value useCDATA: (BOOL) cdata;

// GPX Utilities
+ (NSString*)dateToGPXFormat: (NSDate*)date;
+ (NSString*)GPBoundsToGPXFormat: (GPBounds) bounds;

@end
