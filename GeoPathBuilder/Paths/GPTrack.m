//
//  GPTrack.m
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

#import "GPTrack.h"
#import "GPTrackSegment.h"
#import "GPUtilities.h"
#import "GPConstants.h"

@implementation GPTrack

-(id)init {
    
    self = [super init];
    
    segments = [[NSMutableArray alloc] init];
    [self setUUID:[GPUtilities getUUID]];
    
    return self;
}

- (NSObject*)getObjectWithUUID: (NSString*) matchUUID {
    
    NSObject *match = nil;
    BOOL matchFound = false;
    
    for( int i = 0;(i < [segments count] && matchFound != true); i++ ) {
        // Check the segment's UUID
        if( [[[segments objectAtIndex:i] UUID] isEqualToString:matchUUID] ) {
            match = [segments objectAtIndex:i];
            matchFound = true;
        } else {
            // Check the points in the segment
            if( !match ) {
                match = [[segments objectAtIndex:i] getObjectWithUUID:matchUUID];
                if( match ) {
                    matchFound = true;
                }
            }
        }
    }
    
    return match;
    
}

- (void)addSegment: (GPTrackSegment*) segment {
    [segments addObject:segment];
}
- (BOOL)removeSegment: (GPTrackSegment*) segment {
    if( [segments containsObject:segment] ) {
        [segments removeObject:segment];
        return TRUE;
    } else {
        return FALSE;
    }
}

- (NSArray*)getSegments {
    return segments;
}

- (NSArray*)getPoints {
    NSMutableArray *allPoints = [NSMutableArray array];
    for( int i = 0; i < [segments count]; i++ ) {
        [allPoints addObjectsFromArray:[[segments objectAtIndex:i] getPoints]];
    }
    return allPoints;
}

- (NSString*)getGPXString {
    
    NSMutableString *GPXDataString = [[[NSMutableString alloc] initWithString:@""] autorelease];
    
    // If attribute exists, add the tag. If not, don't do anything
    [self name] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_NAME attributeVals:nil attributeKeys:nil andValue:self.name useCDATA:FALSE]] : nil;
    [self comment] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_COMMENT attributeVals:nil attributeKeys:nil andValue:self.comment useCDATA:TRUE]] : nil;
    [self description] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_DESCRIPTION attributeVals:nil attributeKeys:nil andValue:self.description useCDATA:TRUE]] : nil;
    [self src] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_SOURCE attributeVals:nil attributeKeys:nil andValue:self.src useCDATA:FALSE]] : nil;
    [self url] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_URL attributeVals:nil attributeKeys:nil andValue:self.url useCDATA:FALSE]] : nil;
    [self urlname] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_URLNAME attributeVals:nil attributeKeys:nil andValue:self.urlname useCDATA:FALSE]] : nil;
    [self number] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_NUMBER attributeVals:nil attributeKeys:nil andValue:[NSString stringWithFormat:@"%f",self.number] useCDATA:FALSE]] : nil;
    
    // Get the GPX String of each point
    for( int i = 0; i < [segments count]; i++ ) {
        [GPXDataString appendString:[((GPTrackSegment*)[segments objectAtIndex:i]) getGPXString]];
    }
    
    // Add the tag data into the main tag 
    NSString *GPXTagString = [NSString stringWithString:[GPUtilities createTagWithName:kGPXTAG_TRACK attributeVals:nil attributeKeys:nil andValue:GPXDataString useCDATA:FALSE]];
    
    return GPXTagString;
}


- (double) getTotalDistance {
    
    double totalDistance = 0;
    
    for( int i = 0; i < [segments count]; i++ ) {
        totalDistance += [[segments objectAtIndex:i] getTotalDistance];
    }
    
    return totalDistance;
}

- (double) getTotalAscent {
    
    double totalAscent = 0;
    
    for( int i = 0; i < [segments count]; i++ ) {
        totalAscent += [[segments objectAtIndex:i] getTotalAscent];
    }
    
    return totalAscent;
    
}
- (double) getTotalDescent {
    
    double totalDescent = 0;
    
    for( int i = 0; i < [segments count]; i++ ) {
        totalDescent += [[segments objectAtIndex:i] getTotalDescent];
    }
    
    return totalDescent;
    
}

- (double) getAvgSpeed {
    
    double totalAvgSpeed = 0;
    
    for( int i = 0; i < [segments count]; i++ ) {
        totalAvgSpeed += [[segments objectAtIndex:i] getAvgSpeed];
    }
    
    return totalAvgSpeed/[segments count];
}

- (double) getMinSpeed {
    
    double minSpeed = INFINITY;
    
    for( int i = 0; i < [segments count]; i++ ) {
        double speed = [[segments objectAtIndex:i] getMinSpeed];
        if( speed < minSpeed && speed != -1 ) {
            minSpeed = speed;
        }
    }
    
    return minSpeed;
}
- (double) getMaxSpeed {
    double maxSpeed = -INFINITY;
    
    for( int i = 0; i < [segments count]; i++ ) {
        double speed = [[segments objectAtIndex:i] getMaxSpeed];
        if( speed > maxSpeed ) {
            maxSpeed = speed;
        }
    }
    
    return maxSpeed;
}

- (double) getAvgElevation {
    double totalAvgElevation = 0;
    
    for( int i = 0; i < [segments count]; i++ ) {
        totalAvgElevation += [[segments objectAtIndex:i] getAvgElevation];
    }
    
    return totalAvgElevation/[segments count];
}

- (double) getMinElevation {
    double minElevation = INFINITY;
    
    for( int i = 0; i < [segments count]; i++ ) {
        double elevation = [[segments objectAtIndex:i] getMinElevation];
        if( elevation < minElevation && elevation != -1) {
            minElevation = elevation;
        }
    }
    
    return minElevation;
}

- (double) getMaxElevation {
    double maxElevation = -INFINITY;
    
    for( int i = 0; i < [segments count]; i++ ) {
        double elevation = [[segments objectAtIndex:i] getMaxElevation];
        if( elevation > maxElevation ) {
            maxElevation = elevation;
        }
    }
    
    return maxElevation;
}

-(void)dealloc {
    segments ? [segments release] : nil;
}

@end
