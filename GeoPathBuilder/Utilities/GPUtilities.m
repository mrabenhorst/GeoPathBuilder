//
//  GPUtilities.m
//  GeoPathBuilder
//
//  Created by Mark Rabenhorst on 1/31/12.
//  Copyright (c) 2012 Intl Mapping. All rights reserved.
//

#import "GPUtilities.h"

@implementation GPUtilities

+ (NSString*)createTagWithName: (NSString*)tagName atttributes: (NSDictionary*)attributes andValue: (NSString*)value useCDATA: (BOOL) cdata {
    NSString *tagString;
    NSMutableString *attributesString = [NSMutableString stringWithString:@""];
    
    if( attributes != nil ) {
        NSArray *values = [NSArray arrayWithArray:[attributes allValues]];
        NSArray *keys = [NSArray arrayWithArray:[attributes allKeys]];
        for( int i = 0; i < [values count]; i++ ) {
            [attributesString appendFormat:@" %@=\"%@\"", [keys objectAtIndex:i], [values objectAtIndex:i]];
        }
    }
    
    if( cdata ) {
        tagString = [[NSString alloc] initWithFormat:@"<%@%@><![CDATA[%@]]</%@>",tagName,attributesString,value,tagName];
    } else {
        tagString = [[NSString alloc] initWithFormat:@"<%@%@>%@</%@>",tagName,attributesString,value,tagName];
    }
    
    return tagString;
}

+ (NSString*)dateToGPXFormat: (NSDate*)date {
    NSDateFormatter *UTCDateFormat = [NSDateFormatter new];
    [UTCDateFormat setDateFormat:@"yyyy-MM-DD'T'HH:MM:SS'Z'"];
    [UTCDateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    return [UTCDateFormat stringFromDate:date];
}

@end
