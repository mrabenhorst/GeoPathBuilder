//
//  GPWaypoint.m
//  GeoPathBuilder
//
//  Created by Mark Rabenhorst on 1/31/12.
//  Copyright (c) 2012 Intl Mapping. All rights reserved.
//

#import "GPWaypoint.h"
#import "GPUtilities.h"
#import "GPConstants.h"

@implementation GPWaypoint

- (NSString*)getGPXString {
    
    NSMutableString *GPXDataString = [[[NSMutableString alloc] initWithString:@""] autorelease];
    
    // If attribute exists, add the tag. If not, don't do anything
    [self elevation] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_ELEVATION attributes:nil andValue:[NSString stringWithFormat:@"%f",self.elevation] useCDATA:FALSE]] : nil;
    [self time] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_TIME attributes:nil andValue:[GPUtilities dateToGPXFormat:self.time] useCDATA:FALSE]] : nil;
    [self name] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_NAME attributes:nil andValue:self.name useCDATA:FALSE]] : nil;
    [self comment] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_COMMENT attributes:nil andValue:self.comment useCDATA:TRUE]] : nil;
    [self description] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_DESCRIPTION attributes:nil andValue:self.description useCDATA:TRUE]] : nil;
    [self src] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_SOURCE attributes:nil andValue:self.src useCDATA:FALSE]] : nil;
    [self url] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_URL attributes:nil andValue:self.url useCDATA:FALSE]] : nil;
    [self urlname] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_URLNAME attributes:nil andValue:self.urlname useCDATA:FALSE]] : nil;
    [self symbol] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_SYMBOL attributes:nil andValue:self.symbol useCDATA:FALSE]] : nil;
    [self type] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_TYPE attributes:nil andValue:self.type useCDATA:FALSE]] : nil;
    
    // Create RoutePoint attributes (lat/lon)
    NSDictionary *pointAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",self.location.latitude],kGPXTAG_LATITUDE, [NSString stringWithFormat:@"%f",self.location.longitude], kGPXTAG_LONGITUDE, nil];
    
    // Add the tag data into the main tag 
    NSString *GPXTagString = [NSString stringWithString:[GPUtilities createTagWithName:kGPXTAG_WAYPOINT attributes:pointAttributes andValue:GPXDataString useCDATA:FALSE]];
    
    return GPXTagString;
}

@end
