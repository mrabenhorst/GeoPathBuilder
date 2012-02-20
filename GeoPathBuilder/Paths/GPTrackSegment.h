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
    NSMutableArray *geoPoints;
}

@property (nonatomic, retain) NSString *UUID;

-(id)init;

- (NSObject*)getObjectWithUUID: (NSString*) matchUUID;

-(void)addPoint: (GPTrackPoint*) point;
-(BOOL)removePoint: (GPTrackPoint*) point;

// Returns a string version of the Waypoint in GPX format
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
