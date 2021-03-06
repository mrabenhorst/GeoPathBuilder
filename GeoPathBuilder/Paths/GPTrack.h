//
//  GPTrack.h
//  GeoPathBuilder
//
//  Created by Mark Rabenhorst on 2/1/12.
//  Copyright (c) 2012 Intl Mapping. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of 
//  this software and associated documentation files (the "Software"), to deal in 
//  the Software without restriction, including without limitation the rights to use, 
//  copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the 
//  Software, and to permit persons to whom the Software is furnished to do so, 
//  subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in all 
//  copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
//  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
//  PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT 
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF 
//  CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE 
//  OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
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

- (NSArray*)getSegments;
- (NSArray*)getPoints;

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
