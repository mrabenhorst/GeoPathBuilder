//
//  GPRoutePoint.h
//  GeoPathBuilder
//
//  Created by Mark Rabenhorst on 2/1/12.
//  Copyright (c) 2012 Intl Mapping. All rights reserved.
//

#import "GPGeoPoint.h"

@interface GPRoutePoint : GPGeoPoint {
    
}

// Returns a string version of the Waypoint in GPX format
- (NSString*)getGPXString;

/*
 * To code:
 */

//- (NSString*)getKMLString;
//- (void)fromKMLString;

@end
