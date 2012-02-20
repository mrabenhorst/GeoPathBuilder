//
//  GPRoute.m
//  GeoPathBuilder
//
//  Created by Mark Rabenhorst on 2/1/12.
//  Copyright (c) 2012 Intl Mapping. All rights reserved.
//

#import "GPRoute.h"
#import "GPRoutePoint.h"
#import "GPUtilities.h"
#import "GPConstants.h"

@implementation GPRoute

-(id)init {
    geoPoints = [[NSMutableArray alloc] init];
    
    [self setUUID:[GPUtilities getUUID]];
    
    return self;
}

-(id)initWithName: (NSString*) pathName andPoints: (NSArray*) points {
    
    [self setName:pathName];
    geoPoints = [[NSMutableArray alloc] init];
    
    [self setUUID:[GPUtilities getUUID]];
    
    for( int i = 0; i < [points count]; i++ ) {
        [[points objectAtIndex:i] isKindOfClass:[GPRoutePoint class]] ? [geoPoints addObject:[points objectAtIndex:i]] : nil;
    }
    
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

- (void)addPoint: (GPRoutePoint*) point {
    [geoPoints addObject:point];
}

- (BOOL)removePoint: (GPRoutePoint*) point {
    if( [geoPoints containsObject:point] ) {
        [geoPoints removeObject:point];
        return TRUE;
    } else {
        return FALSE;
    }    
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
    for( int i = 0; i < [geoPoints count]; i++ ) {
        [GPXDataString appendString:[((GPRoutePoint*)[geoPoints objectAtIndex:i]) getGPXString]];
    }
    
    // Add the tag data into the main tag 
    NSString *GPXTagString = [NSString stringWithString:[GPUtilities createTagWithName:kGPXTAG_ROUTE attributeVals:nil attributeKeys:nil andValue:GPXDataString useCDATA:FALSE]];
    
    return GPXTagString;
}

- (double) getTotalDistance {
    
    NSMutableArray *pointCoords = [NSMutableArray array];
    for( int i = 0; i < [geoPoints count]; i++ ) {
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:((GPGeoPoint*)[geoPoints objectAtIndex:i]).location.latitude longitude:((GPGeoPoint*)[geoPoints objectAtIndex:i]).location.longitude];
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
