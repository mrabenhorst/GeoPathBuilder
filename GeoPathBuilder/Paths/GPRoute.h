//
//  GPRoute.h
//  GeoPathBuilder
//
//  Created by Mark Rabenhorst on 2/1/12.
//  Copyright (c) 2012 Intl Mapping. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPPath.h"
#import "GPRoutePoint.h"

@interface GPRoute : GPPath {
    NSMutableArray *geoPoints;
}

-(id)init;

/*
 * Convienince class for creating a path. Will not add any type of point 
 * in array except if it is of class type "GPRoutePoint"
 */
- (id)initWithName: (NSString*) pathName andPoints: (NSArray*) points;

- (NSObject*)getObjectWithUUID: (NSString*) matchUUID;

/*
 * Always adds point to array of GPRoutePoints
 */
- (void)addPoint: (GPRoutePoint*) point;

/*
 * Returns TRUE if point is found and removed, FALSE if point isn't found
 */
- (BOOL)removePoint: (GPRoutePoint*) point;

/*
 * Returns a string version of the Waypoint in GPX format
 */
- (NSString*)getGPXString;


/*
 * To code:
 */

//- (NSString*)getKMLString;
//- (void)fromKMLString;

@end
