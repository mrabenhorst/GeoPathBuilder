//
//  GPUtilities.m
//  GeoPathBuilder
//
//  Created by Mark Rabenhorst on 1/31/12.
//  Copyright (c) 2012 Intl Mapping. All rights reserved.
//

#import "GPUtilities.h"
#import "GPConstants.h"

@implementation GPUtilities

+ (NSString*)createTagWithName: (NSString*)tagName attributes: (NSDictionary*)attributes andValue: (NSString*)value useCDATA: (BOOL) cdata {
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

+ (NSArray*)getValueAndAttributesFromString: (NSString*) string withTag: (NSString*) tag {
    
    //@"\<gpx\(.*?)\</gpx\>"
    NSString *regexString = [NSString stringWithFormat:@"%@%@%@%@%@", @"\<", tag, @"\(.*?)\</", tag, @"\>"];
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexString options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
       
    NSMutableArray *matchingObjects = [[NSMutableArray alloc] init];
    
    // Get matches and put them into an array
    for (NSTextCheckingResult *match in matches) {
        NSRange matchRange = [match range];
        //NSLog(@"%@",[string substringWithRange:matchRange]);
        NSMutableDictionary *matchData = [[NSMutableDictionary alloc] init];
        [matchData setObject:[NSString stringWithString:[string substringWithRange:matchRange]] forKey:@"Match String"];
        [matchingObjects addObject:matchData];
    }
    
    // Now get the string of attributes for each
    for( int i = 0; i < [matchingObjects count]; i++ ) {
        
        NSString *attributesRegexString = [NSString stringWithFormat:@"%@%@%@%@", @"\<", tag, @"(.*?)", @">"];
        NSError *error = NULL;
        NSRegularExpression *attributesRegex = [NSRegularExpression regularExpressionWithPattern:attributesRegexString options:NSRegularExpressionCaseInsensitive error:&error];
        NSRange rangeOfMatch = [attributesRegex rangeOfFirstMatchInString:[[matchingObjects objectAtIndex:i] objectForKey:@"Match String"] options:0 range:NSMakeRange(0, [[[matchingObjects objectAtIndex:i] objectForKey:@"Match String"] length])];
        [[matchingObjects objectAtIndex:i] setObject:[NSString stringWithString:[[[matchingObjects objectAtIndex:i] objectForKey:@"Match String"] substringWithRange:rangeOfMatch]] forKey:@"Attributes String"];
        //NSLog(@"%@", [[[matchingObjects objectAtIndex:i] objectForKey:@"Match String"] substringWithRange:rangeOfMatch]);
    }
    
    // Now parse the string into attributes
    // 
    for( int i = 0; i < [matchingObjects count]; i++ ) {
        
        // get all the names of attributes
        NSString *attributeNameRegexString = [NSString stringWithFormat:@"%@", @"(\\S)+="];
        NSError *error = NULL;
        NSRegularExpression *attributeNameRegex = [NSRegularExpression regularExpressionWithPattern:attributeNameRegexString options:NSRegularExpressionCaseInsensitive error:&error];
        NSArray *allAttributeNames = [attributeNameRegex matchesInString:[[matchingObjects objectAtIndex:i] objectForKey:@"Attributes String"] options:0 range:NSMakeRange(0, [[[matchingObjects objectAtIndex:i] objectForKey:@"Attributes String"] length])];
        
        // put these names into an array
        NSMutableArray *attributeNames = [NSMutableArray array];        
        for (NSTextCheckingResult *attributeName in allAttributeNames) {
            NSRange matchRange = [attributeName range];
            matchRange.length -= 1; // This gets rid of the = sign which is included in the regex to get the correct string.
            NSString *attributeName = [NSString stringWithString:[[[matchingObjects objectAtIndex:i] objectForKey:@"Attributes String"] substringWithRange:matchRange]];
            //NSLog(@"%@",attributeName);
            [attributeNames addObject:[attributeName lowercaseString]]; // All names will be lowercase for accessing ease.
        }
        
        // get all the values of attributes
        NSString *attributeValueRegexString = [NSString stringWithFormat:@"%@", @"=\".+?\""];
        NSRegularExpression *attributeValueRegex = [NSRegularExpression regularExpressionWithPattern:attributeValueRegexString options:NSRegularExpressionCaseInsensitive error:&error];
        NSArray *allAttributeValues = [attributeValueRegex matchesInString:[[matchingObjects objectAtIndex:i] objectForKey:@"Attributes String"] options:0 range:NSMakeRange(0, [[[matchingObjects objectAtIndex:i] objectForKey:@"Attributes String"] length])];
        
        // put these names into an array
        NSMutableArray *attributeValues = [NSMutableArray array];        
        for (NSTextCheckingResult *attributeValue in allAttributeValues) {
            NSRange matchRange = [attributeValue range];
            
            matchRange.location += 2; // This gets rid of the =" prefix which is included in the regex to get the correct string.
            matchRange.length -= 3;   // This gets rid of the " suffix which is included in the regex to get the correct string.
            NSString *attributeValue = [NSString stringWithString:[[[matchingObjects objectAtIndex:i] objectForKey:@"Attributes String"] substringWithRange:matchRange]];
            //NSLog(@"%@",attributeValue);
            
            [attributeValues addObject:attributeValue];
        }
        
        // Put attribute names and values into dictionary
        NSDictionary *allAttributes = [NSDictionary dictionaryWithObjects:attributeValues forKeys:attributeNames];
        
        // Add attributes to the object
        [[matchingObjects objectAtIndex:i] setObject:allAttributes forKey:@"Attributes"];
        
    }
    
    // Now get the data contained by the tag
    for( int i = 0; i < [matchingObjects count]; i++ ) {
        
        // Data starts where the attributes string ends
        int beginningDataLength = [[[matchingObjects objectAtIndex:i] objectForKey:@"Attributes String"] length];
        int trailingDataLength = [[NSString stringWithFormat:@"%@%@%@", @"</", tag, @">"] length];
        
        NSString *tagData = [[NSString alloc] initWithString:[[[matchingObjects objectAtIndex:i] objectForKey:@"Match String"] substringWithRange:NSMakeRange(beginningDataLength, [[[matchingObjects objectAtIndex:i] objectForKey:@"Match String"] length]-beginningDataLength-trailingDataLength)]];
        //NSLog(@"%@",tagData);
        [[matchingObjects objectAtIndex:i] setObject:tagData forKey:@"Data"];
    }
    
    
    return matchingObjects;
    
}

+ (NSString*)dateToGPXFormat: (NSDate*)date {
    NSDateFormatter *UTCDateFormat = [NSDateFormatter new];
    [UTCDateFormat setDateFormat:@"yyyy-MM-DD'T'HH:MM:SS'Z'"];
    [UTCDateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    return [UTCDateFormat stringFromDate:date];
}

+ (NSString*)GPBoundsToGPXFormat: (GPBounds) bounds {
    return [NSString stringWithFormat:@"minlat=\"%f\" minlon=\"%f\" maxlat=\"%f\" maxlon=\"%f\"", bounds.south, bounds.east, bounds.north, bounds.west];
}

@end
