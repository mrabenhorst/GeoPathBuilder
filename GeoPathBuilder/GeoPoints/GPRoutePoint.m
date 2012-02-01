//
//  GPRoutePoint.m
//  GeoPathBuilder
//
//  Created by Mark Rabenhorst on 2/1/12.
//  Copyright (c) 2012 Intl Mapping. All rights reserved.
//

#import "GPRoutePoint.h"
#import "GPGeoPoint.h"
#import "GPUtilities.h"
#import "GPConstants.h"

@implementation GPRoutePoint

- (NSString*)getGPXString {
    
    NSMutableString *GPXDataString = [[[NSMutableString alloc] initWithString:@""] autorelease];
    
    // If attribute exists, add the tag. If not, don't do anything
    [self elevation] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_ELEVATION atttributes:nil andValue:[NSString stringWithFormat:@"%f",self.elevation] useCDATA:FALSE]] : nil;
    [self time] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_TIME atttributes:nil andValue:[GPUtilities dateToGPXFormat:self.time] useCDATA:FALSE]] : nil;
    [self name] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_NAME atttributes:nil andValue:self.name useCDATA:FALSE]] : nil;
    [self comment] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_COMMENT atttributes:nil andValue:self.comment useCDATA:TRUE]] : nil;
    [self description] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_DESCRIPTION atttributes:nil andValue:self.description useCDATA:TRUE]] : nil;
    [self src] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_SOURCE atttributes:nil andValue:self.src useCDATA:FALSE]] : nil;
    [self url] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_URL atttributes:nil andValue:self.url useCDATA:FALSE]] : nil;
    [self urlname] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_URLNAME atttributes:nil andValue:self.urlname useCDATA:FALSE]] : nil;
    [self symbol] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_SYMBOL atttributes:nil andValue:self.symbol useCDATA:FALSE]] : nil;
    [self type] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_TYPE atttributes:nil andValue:self.type useCDATA:FALSE]] : nil;
    
    // Create RoutePoint attributes (lat/lon)
    NSDictionary *pointAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",self.location.latitude],kGPXTAG_LATITUDE, [NSString stringWithFormat:@"%f",self.location.longitude], kGPXTAG_LONGITUDE, nil];
    
    // Add the tag data into the main tag 
    NSString *GPXTagString = [NSString stringWithString:[GPUtilities createTagWithName:kGPXTAG_ROUTEPT atttributes:pointAttributes andValue:GPXDataString useCDATA:FALSE]];
    
    return GPXTagString;
}


@end
