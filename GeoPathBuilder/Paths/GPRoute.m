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

-(id)initWithName: (NSString*) pathName andPoints: (NSArray*) points {
    
    [self setName:pathName];
    geoPoints = [[NSMutableArray alloc] init];
    
    for( int i = 0; i < [points count]; i++ ) {
        [[points objectAtIndex:i] isKindOfClass:[GPRoutePoint class]] ? [geoPoints addObject:[points objectAtIndex:i]] : nil;
    }
    
    return self;
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
    [self name] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_NAME atttributes:nil andValue:self.name useCDATA:FALSE]] : nil;
    [self comment] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_COMMENT atttributes:nil andValue:self.comment useCDATA:TRUE]] : nil;
    [self description] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_DESCRIPTION atttributes:nil andValue:self.description useCDATA:TRUE]] : nil;
    [self src] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_SOURCE atttributes:nil andValue:self.src useCDATA:FALSE]] : nil;
    [self url] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_URL atttributes:nil andValue:self.url useCDATA:FALSE]] : nil;
    [self urlname] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_URLNAME atttributes:nil andValue:self.urlname useCDATA:FALSE]] : nil;
    [self number] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_ELEVATION atttributes:nil andValue:[NSString stringWithFormat:@"%f",self.number] useCDATA:FALSE]] : nil;
    
    // Get the GPX String of each point
    for( int i = 0; i < [geoPoints count]; i++ ) {
        [GPXDataString appendString:[((GPRoutePoint*)[geoPoints objectAtIndex:i]) getGPXString]];
    }
    
    // Add the tag data into the main tag 
    NSString *GPXTagString = [NSString stringWithString:[GPUtilities createTagWithName:kGPXTAG_WAYPOINT atttributes:nil andValue:GPXDataString useCDATA:FALSE]];
    
    return GPXTagString;
}

@end
