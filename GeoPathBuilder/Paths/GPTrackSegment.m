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

-(id)init {
    trackPoints = [[NSMutableArray alloc] init];
    return self;
}

-(void)addPoint: (GPTrackPoint*) point {
    [trackPoints addObject:point];
}
-(BOOL)removePoint: (GPTrackPoint*) point {
    if( [trackPoints containsObject:point] ) {
        [trackPoints removeObject:point];
        return TRUE;
    } else {
        return FALSE;
    }
}

- (NSString*)getGPXString {
    
    NSMutableString *GPXDataString = [[[NSMutableString alloc] initWithString:@""] autorelease];
    
    for( int i = 0; i < [trackPoints count]; i++ ) {
        [GPXDataString appendString:[((GPTrackPoint*)[trackPoints objectAtIndex:i]) getGPXString]];
    }
    
    // Add the tag data into the main tag 
    NSString *GPXTagString = [NSString stringWithString:[GPUtilities createTagWithName:kGPXTAG_TRACKSEG attributes:nil andValue:GPXDataString useCDATA:FALSE]];
    
    return GPXTagString;
}

@end
