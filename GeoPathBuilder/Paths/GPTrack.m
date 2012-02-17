//
//  GPTrack.m
//  GeoPathBuilder
//
//  Created by Mark Rabenhorst on 2/1/12.
//  Copyright (c) 2012 Intl Mapping. All rights reserved.
//

#import "GPTrack.h"
#import "GPTrackSegment.h"
#import "GPUtilities.h"
#import "GPConstants.h"

@implementation GPTrack

-(id)init {
    segments = [[NSMutableArray alloc] init];
    [self setUUID:[GPUtilities getUUID]];
    
    return self;
}

- (NSObject*)getObjectWithUUID: (NSString*) matchUUID {
    
    NSObject *match;
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


@end
