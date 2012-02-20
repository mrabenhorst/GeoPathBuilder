//
//  GPTrack.h
//  GeoPathBuilder
//
//  Created by Mark Rabenhorst on 2/1/12.
//  Copyright (c) 2012 Intl Mapping. All rights reserved.
//

#import "GPPath.h"
#import "GPTrackSegment.h"

@interface GPTrack : GPPath {
    NSMutableArray *segments;
}

-(id)init;

- (NSObject*)getObjectWithUUID: (NSString*) matchUUID;

/*
 * Always adds point to array of GPRoutePoints
 */
- (void)addSegment: (GPTrackSegment*) segment;

/*
 * Returns TRUE if point is found and removed, FALSE if point isn't found
 */
- (BOOL)removeSegment: (GPTrackSegment*) segment;

/*
 * Returns a string version of the Waypoint in GPX format
 */
- (NSString*)getGPXString;


- (double)getTotalDistance;
- (double)getTotalAscent;
- (double)getTotalDescent;
- (double)getAvgSpeed;
- (double)getMinSpeed;
- (double)getMaxSpeed;
- (double)getAvgElevation;
- (double)getMinElevation;
- (double)getMaxElevation;

/*
 * To code:
 */

//- (NSString*)getKMLString;
//- (void)fromKMLString;

@end
