//
//  GPRoutePoint.m
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

#import "GPRoutePoint.h"
#import "GPGeoPoint.h"
#import "GPUtilities.h"
#import "GPConstants.h"

@implementation GPRoutePoint

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
    NSString *GPXTagString = [NSString stringWithString:[GPUtilities createTagWithName:kGPXTAG_ROUTEPT attributeVals:values attributeKeys:keys andValue:GPXDataString useCDATA:FALSE]];
    
    return GPXTagString;
}


@end
