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

+ (NSString*)createTagWithName: (NSString*)tagName attributeVals: values attributeKeys: keys andValue: (NSString*)value useCDATA: (BOOL) cdata {
    NSString *tagString;
    NSMutableString *attributesString = [NSMutableString stringWithString:@""];
    
    if( values != nil && keys != nil ) {
        for( int i = 0; i < [values count]; i++ ) {
            [attributesString appendFormat:@" %@=\"%@\"", [keys objectAtIndex:i], [values objectAtIndex:i]];
        }
    }
    
    if( cdata ) {
        tagString = [[NSString alloc] initWithFormat:@"<%@%@><![CDATA[%@]]></%@>",tagName,attributesString,value,tagName];
    } else {
        tagString = [[NSString alloc] initWithFormat:@"<%@%@>%@</%@>",tagName,attributesString,value,tagName];
    }
    
    return tagString;
}

+ (NSArray*)getValueAndAttributesFromString: (NSString*) string withTag: (NSString*) tag {
    
    //@"\<gpx\(.*?)\</gpx\>"
    //NSString *regexString = [NSString stringWithFormat:@"%@%@%@%@%@", @"\<", tag, @"\(.*?)\</", tag, @"\>"];
    NSString *regexString = [NSString stringWithFormat:@"%@%@%@%@%@", @"\\<", tag, @"\\(.*?)\\</", tag, @"\\>"];
    
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
        
        //NSString *attributesRegexString = [NSString stringWithFormat:@"%@%@%@%@", @"\<", tag, @"(.*?)", @">"];
        NSString *attributesRegexString = [NSString stringWithFormat:@"%@%@%@%@", @"\\<", tag, @"(.*?)", @">"];
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
    [UTCDateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    [UTCDateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    return [UTCDateFormat stringFromDate:date];
}

+ (NSDate*)dateFromGPXFormat: (NSString*) dateString {
    NSDateFormatter *UTCDateFormat = [[NSDateFormatter alloc] init];
    [UTCDateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    [UTCDateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [UTCDateFormat setCalendar:[[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease]];
    [UTCDateFormat setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
    NSLog(@"%@", [UTCDateFormat dateFromString:dateString]);
    return [UTCDateFormat dateFromString:dateString];
}

+ (NSString*)GPBoundsToGPXFormat: (GPBounds) bounds {
    return [NSString stringWithFormat:@"minlat=\"%f\" minlon=\"%f\" maxlat=\"%f\" maxlon=\"%f\"", bounds.south, bounds.east, bounds.north, bounds.west];
}

+ (GPXTag)getGPXTagForGPXTagName:(NSString*) tagName {
    
    
    // Objects
    
    if( [tagName isEqualToString:kGPXTAG_MASTER] ) {
        return keGPX_MASTER;
    } else if ( [tagName isEqualToString:kGPXTAG_WAYPOINT] ) {
        return keGPX_WAYPOINT;
    } else if ( [tagName isEqualToString:kGPXTAG_ROUTE] ) {
        return keGPX_ROUTE;
    } else if ( [tagName isEqualToString:kGPXTAG_ROUTEPT] ) {
        return keGPX_ROUTEPT;
    } else if ( [tagName isEqualToString:kGPXTAG_TRACK] ) {
        return keGPX_TRACK;
    } else if ( [tagName isEqualToString:kGPXTAG_TRACKSEG] ) {
        return keGPX_TRACKSEG;
    } else if ( [tagName isEqualToString:kGPXTAG_TRACKPT] ) {
        return keGPX_TRACKPT;
    }
    
    
    // Attributes
    
    
    
    
    // Properties
    
    else if ( [tagName isEqualToString:kGPXTAG_NAME] ) {
        return keGPX_NAME;
    } else if ( [tagName isEqualToString:kGPXTAG_DESCRIPTION] ) {
        return keGPX_DESCRIPTION;
    } else if ( [tagName isEqualToString:kGPXTAG_CREATOR] ) {
        return keGPX_CREATOR;
    } else if ( [tagName isEqualToString:kGPXTAG_VERSION] ) {
        return keGPX_VERSION;
    } else if ( [tagName isEqualToString:kGPXTAG_AUTHOR] ) {
        return keGPX_AUTHOR;
    } else if ( [tagName isEqualToString:kGPXTAG_EMAIL] ) {
        return keGPX_EMAIL;
    } else if ( [tagName isEqualToString:kGPXTAG_URL] ) {
        return keGPX_URL;
    } else if ( [tagName isEqualToString:kGPXTAG_URLNAME] ) {
        return keGPX_URLNAME;
    } else if ( [tagName isEqualToString:kGPXTAG_TIME] ) {
        return keGPX_TIME;
    } else if ( [tagName isEqualToString:kGPXTAG_KEYWORDS] ) {
        return keGPX_KEYWORDS;
    } else if ( [tagName isEqualToString:kGPXTAG_BOUNDS] ) {
        return keGPX_BOUNDS;
    } else if ( [tagName isEqualToString:kGPXTAG_NUMBER] ) {
        return keGPX_NUMBER;
    } else if ( [tagName isEqualToString:kGPXTAG_LATITUDE] ) {
        return keGPX_LATITUDE;
    } else if ( [tagName isEqualToString:kGPXTAG_LONGITUDE] ) {
        return keGPX_LONGITUDE;
    } else if ( [tagName isEqualToString:kGPXTAG_ELEVATION] ) {
        return keGPX_ELEVATION;
    } else if ( [tagName isEqualToString:kGPXTAG_COURSE] ) {
        return keGPX_COURSE;
    } else if ( [tagName isEqualToString:kGPXTAG_SPEED] ) {
        return keGPX_SPEED;
    } else if ( [tagName isEqualToString:kGPXTAG_COMMENT] ) {
        return keGPX_COMMENT;
    } else if ( [tagName isEqualToString:kGPXTAG_SOURCE] ) {
        return keGPX_SOURCE;
    } else if ( [tagName isEqualToString:kGPXTAG_SYMBOL] ) {
        return keGPX_SYMBOL;
    } else if ( [tagName isEqualToString:kGPXTAG_TYPE] ) {
        return keGPX_TYPE;
    }
    
    else return -1;
}

+ (GPXElementType)getGPXElementTypeByName:(NSString*) elementName {
    switch ( [GPUtilities getGPXTagForGPXTagName:elementName] ) {
        
        /* 
         * Objects
         */
        case keGPX_MASTER:
            return keGPX_OBJECT;
            break;
        case keGPX_WAYPOINT:
            return keGPX_OBJECT;
            break;
        case keGPX_ROUTE:
            return keGPX_OBJECT;
            break;
        case keGPX_ROUTEPT:
            return keGPX_OBJECT;
            break;
        case keGPX_TRACK:
            return keGPX_OBJECT;
            break;
        case keGPX_TRACKSEG:
            return keGPX_OBJECT;
            break;
        case keGPX_TRACKPT:
            return keGPX_OBJECT;
            break;
            
        /* 
         * Attributes
         */
        case keGPX_SCHEMA_VERSION:
            return keGPX_ATTRIBUTE;
            break;
        case keGPX_SCHEMA_LOC_ATTR:
            return keGPX_ATTRIBUTE;
            break;
        case keGPX_SCHEMA_LOC_VAL:
            return keGPX_ATTRIBUTE;
            break;
        case keGPX_XSI_ATTR:
            return keGPX_ATTRIBUTE;
            break;
        case keGPX_XSI_VAL:
            return keGPX_ATTRIBUTE;
            break;
        case keGPX_XMLNS_ATTR:
            return keGPX_ATTRIBUTE;
            break;
        case keGPX_XMLNS_VAL:
            return keGPX_ATTRIBUTE;
            break;
        case keGPX_MINLAT:
            return keGPX_ATTRIBUTE;
            break;
        case keGPX_MAXLAT:
            return keGPX_ATTRIBUTE;
            break;
        case keGPX_MINLON:
            return keGPX_ATTRIBUTE;
            break;
        case keGPX_MAXLON:
            return keGPX_ATTRIBUTE;
            break;
            
        /* 
         * Properties
         */
        case keGPX_NAME:
            return keGPX_PROPERTY;
            break;
        case keGPX_DESCRIPTION:
            return keGPX_PROPERTY;
            break;
        case keGPX_CREATOR:
            return keGPX_PROPERTY;
            break;
        case keGPX_VERSION:
            return keGPX_PROPERTY;
            break;
        case keGPX_AUTHOR:
            return keGPX_PROPERTY;
            break;
        case keGPX_EMAIL:
            return keGPX_PROPERTY;
            break;
        case keGPX_URL:
            return keGPX_PROPERTY;
            break;
        case keGPX_URLNAME:
            return keGPX_PROPERTY;
            break;
        case keGPX_TIME:
            return keGPX_PROPERTY;
            break;
        case keGPX_KEYWORDS:
            return keGPX_PROPERTY;
            break;
        case keGPX_BOUNDS:
            return keGPX_PROPERTY;
            break;
        case keGPX_NUMBER:
            return keGPX_PROPERTY;
            break;
        case keGPX_LATITUDE:
            return keGPX_PROPERTY;
            break;
        case keGPX_LONGITUDE:
            return keGPX_PROPERTY;
            break;
        case keGPX_ELEVATION:
            return keGPX_PROPERTY;
            break;
        case keGPX_COURSE:
            return keGPX_PROPERTY;
            break;
        case keGPX_SPEED:
            return keGPX_PROPERTY;
            break;
        case keGPX_COMMENT:
            return keGPX_PROPERTY;
            break;
        case keGPX_SOURCE:
            return keGPX_PROPERTY;
            break;
        case keGPX_SYMBOL:
            return keGPX_PROPERTY;
            break;
        case keGPX_TYPE:
            return keGPX_PROPERTY;
            break;
    } 
    
    return -1;
}
       

+(NSString*)getUUID {
    CFUUIDRef myUUID = CFUUIDCreate(CFAllocatorGetDefault());
    return [NSString stringWithFormat:@"%@", (CFUUIDCreateString(CFAllocatorGetDefault(), myUUID))];
}
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       

@end
