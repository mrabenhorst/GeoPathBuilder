//
//  GPWaypoint.h
//  GeoPathBuilder
//
//  Created by Mark Rabenhorst on 1/31/12.
//  Copyright (c) 2012 Intl Mapping. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPGeoPoint.h"

@interface GPWaypoint : GPGeoPoint {
    
}

// Returns a string version of the Waypoint in GPX format
- (NSString*)getGPXString;

/*
 * To code:
 */

//- (NSString*)getKMLString;
//- (void)fromKMLString;

@end
