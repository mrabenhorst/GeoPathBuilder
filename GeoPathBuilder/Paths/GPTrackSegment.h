//
//  GPTrackSegment.h
//  GeoPathBuilder
//
//  Created by Mark Rabenhorst on 2/1/12.
//  Copyright (c) 2012 Intl Mapping. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPTrackPoint.h"

@interface GPTrackSegment : NSObject {
    NSMutableArray *trackPoints;
}

-(id)init;
-(void)addPoint: (GPTrackPoint*) point;
-(BOOL)removePoint: (GPTrackPoint*) point;

// Returns a string version of the Waypoint in GPX format
- (NSString*)getGPXString;

/*
 * To code:
 */
- (void)fromGPXString;

- (NSString*)getKMLString;
- (void)fromKMLString;

@end
