//
//  GPTrackPoint.h
//  GeoPathBuilder
//
//  Created by Mark Rabenhorst on 2/1/12.
//  Copyright (c) 2012 Intl Mapping. All rights reserved.
//

#import "GPGeoPoint.h"

@interface GPTrackPoint : GPGeoPoint {
    
}

// Returns a string version of the Track Point in GPX format
- (NSString*)getGPXString;

/*
 * To code:
 */
- (void)fromGPXString;

- (NSString*)getKMLString;
- (void)fromKMLString;

@end
