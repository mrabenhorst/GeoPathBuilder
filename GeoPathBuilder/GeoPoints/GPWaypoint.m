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
    [self elevation] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_ELEVATION attributeVals:nil attributeKeys:nil andValue:[NSString stringWithFormat:@"%f",self.elevation] useCDATA:FALSE]] : nil;
    [self time] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_TIME attributeVals:nil attributeKeys:nil andValue:[GPUtilities dateToGPXFormat:self.time] useCDATA:FALSE]] : nil;
    [self name] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_NAME attributeVals:nil attributeKeys:nil andValue:self.name useCDATA:FALSE]] : nil;
    [self comment] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_COMMENT attributeVals:nil attributeKeys:nil andValue:self.comment useCDATA:TRUE]] : nil;
    [self description] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_DESCRIPTION attributeVals:nil attributeKeys:nil andValue:self.description useCDATA:TRUE]] : nil;
    [self src] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_SOURCE attributeVals:nil attributeKeys:nil andValue:self.src useCDATA:FALSE]] : nil;
    [self url] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_URL attributeVals:nil attributeKeys:nil andValue:self.url useCDATA:FALSE]] : nil;
    [self urlname] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_URLNAME attributeVals:nil attributeKeys:nil andValue:self.urlname useCDATA:FALSE]] : nil;
    [self symbol] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_SYMBOL attributeVals:nil attributeKeys:nil andValue:self.symbol useCDATA:FALSE]] : nil;
    [self type] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_TYPE attributeVals:nil attributeKeys:nil andValue:self.type useCDATA:FALSE]] : nil;
    
    // Create RoutePoint attributes (lat/lon)
    NSArray *values = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%f",self.location.latitude],[NSString stringWithFormat:@"%f",self.location.longitude], nil];
    NSArray *keys = [NSArray arrayWithObjects:kGPXTAG_LATITUDE,kGPXTAG_LONGITUDE, nil];
    
    // Add the tag data into the main tag 
    NSString *GPXTagString = [NSString stringWithString:[GPUtilities createTagWithName:kGPXTAG_WAYPOINT attributeVals:values attributeKeys:keys andValue:GPXDataString useCDATA:FALSE]];
    
    return GPXTagString;
}

@end
