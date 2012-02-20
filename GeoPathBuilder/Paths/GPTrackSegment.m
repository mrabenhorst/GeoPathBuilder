//
//  GPTrackSegment.m
//  GeoPathBuilder
//
//  Created by Mark Rabenhorst on 2/1/12.
//  Copyright (c) 2012 Intl Mapping. All rights reserved.
//

#import "GPTrackSegment.h"
#import "GPTrackPoint.h"
#import "GPUtilities.h"
#import "GPConstants.h"

@implementation GPTrackSegment 

@synthesize UUID;

-(id)init {
    geoPoints = [[NSMutableArray alloc] init];
    
    [self setUUID:[GPUtilities getUUID]];
    
    return self;
}

- (NSObject*)getObjectWithUUID: (NSString*) matchUUID {
    
    NSObject *match;
    BOOL matchFound = false;
    
    for( int i = 0;(i < [geoPoints count] && matchFound != true); i++ ) {
        if( [[[geoPoints objectAtIndex:i] UUID] isEqualToString:matchUUID] ) {
            match = [geoPoints objectAtIndex:i];
            matchFound = true;
        }
    }
    
    return match;
    
}

-(void)addPoint: (GPTrackPoint*) point {
    [geoPoints addObject:point];
}
-(BOOL)removePoint: (GPTrackPoint*) point {
    if( [geoPoints containsObject:point] ) {
        [geoPoints removeObject:point];
        return TRUE;
    } else {
        return FALSE;
    }
}

- (NSString*)getGPXString {
    
    NSMutableString *GPXDataString = [[[NSMutableString alloc] initWithString:@""] autorelease];
    
    for( int i = 0; i < [geoPoints count]; i++ ) {
        [GPXDataString appendString:[((GPTrackPoint*)[geoPoints objectAtIndex:i]) getGPXString]];
    }
    
    // Add the tag data into the main tag 
    NSString *GPXTagString = [NSString stringWithString:[GPUtilities createTagWithName:kGPXTAG_TRACKSEG attributeVals:nil attributeKeys:nil andValue:GPXDataString useCDATA:FALSE]];
    
    return GPXTagString;
}


- (double) getTotalDistance {
    
    NSMutableArray *pointCoords = [NSMutableArray array];
    for( int i = 0; i < [geoPoints count]; i++ ) {
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:((GPTrackPoint*)[geoPoints objectAtIndex:i]).location.latitude longitude:((GPTrackPoint*)[geoPoints objectAtIndex:i]).location.longitude];
        [pointCoords addObject:loc];
        [loc release];
    }
    
    return [GPUtilities CalculateDistanceInPointsInArray:pointCoords];
}

- (double) getTotalAscent {
    
    double totalAscent = 0;
    
    if( [geoPoints count] > 1 ) {
        
        double prevAltitude = ((GPGeoPoint*)[geoPoints objectAtIndex:0]).elevation;
        
        for( int i = 1; i < [geoPoints count]; i++ ) {
            double currentAltitude = ((GPGeoPoint*)[geoPoints objectAtIndex:i]).elevation;
            if( currentAltitude > prevAltitude ) {
                totalAscent += (currentAltitude - prevAltitude);
            }
            prevAltitude = currentAltitude;
        }
        
    } else {
        totalAscent = 0;
    }
    
    return totalAscent;
    
}
- (double) getTotalDescent {
    
    double totalDescent = 0;
    
    if( [geoPoints count] > 1 ) {
        
        double prevAltitude = ((GPGeoPoint*)[geoPoints objectAtIndex:0]).elevation;
        
        for( int i = 1; i < [geoPoints count]; i++ ) {
            double currentAltitude = ((GPGeoPoint*)[geoPoints objectAtIndex:i]).elevation;
            if( currentAltitude < prevAltitude ) {
                totalDescent += (prevAltitude - currentAltitude);
            }
            prevAltitude = currentAltitude;
        }
        
    } else {
        totalDescent = 0;
    }
    
    return totalDescent;
    
}

- (double) getAvgSpeed {
    
    double totalSpeed = 0;
    
    for( int i = 0; i < [geoPoints count]; i++ ) {
        totalSpeed += ((GPGeoPoint*)[geoPoints objectAtIndex:i]).speed;
    }
    
    return totalSpeed/[geoPoints count];
}

- (double) getMinSpeed {
    double minSpeed = INFINITY;
    
    for( int i = 0; i < [geoPoints count]; i++ ) {
        double speed = ((GPGeoPoint*)[geoPoints objectAtIndex:i]).speed;
        if( speed < minSpeed && speed != -1 ) {
            minSpeed = speed;
        }
    }
    
    return minSpeed;
}
- (double) getMaxSpeed {
    double maxSpeed = -INFINITY;
    
    for( int i = 0; i < [geoPoints count]; i++ ) {
        double speed = ((GPGeoPoint*)[geoPoints objectAtIndex:i]).speed;
        if( speed > maxSpeed ) {
            maxSpeed = speed;
        }
    }
    
    return maxSpeed;
}

- (double) getAvgElevation {
    double totalElevation = 0;
    
    for( int i = 0; i < [geoPoints count]; i++ ) {
        totalElevation += ((GPGeoPoint*)[geoPoints objectAtIndex:i]).elevation;
    }
    
    return totalElevation/[geoPoints count];
}
- (double) getMinElevation {
    double minElevation = INFINITY;
    
    for( int i = 0; i < [geoPoints count]; i++ ) {
        double elevation = ((GPGeoPoint*)[geoPoints objectAtIndex:i]).elevation;
        if( elevation < minElevation && elevation != -1) {
            minElevation = elevation;
        }
    }
    
    return minElevation;
}
- (double) getMaxElevation {
    double maxElevation = -INFINITY;
    
    for( int i = 0; i < [geoPoints count]; i++ ) {
        double elevation = ((GPGeoPoint*)[geoPoints objectAtIndex:i]).elevation;
        if( elevation > maxElevation ) {
            maxElevation = elevation;
        }
    }
    
    return maxElevation;
}

@end
