//
//  GPUtilities.m
//  GeoPathBuilder
//
//  Created by Mark Rabenhorst on 1/31/12.
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

#import "GPUtilities.h"
#import "GPConstants.h"
#import "GPTrackPoint.h"

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
        tagString = [NSString stringWithFormat:@"<%@%@><![CDATA[%@]]></%@>",tagName,attributesString,value,tagName];
    } else {
        tagString = [NSString stringWithFormat:@"<%@%@>%@</%@>",tagName,attributesString,value,tagName];
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
       
    NSMutableArray *matchingObjects = [NSMutableArray array];
    
    // Get matches and put them into an array
    for (NSTextCheckingResult *match in matches) {
        NSRange matchRange = [match range];
        //NSLog(@"%@",[string substringWithRange:matchRange]);
        NSMutableDictionary *matchData = [NSMutableDictionary dictionary];
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
        
        NSString *tagData = [NSString stringWithString:[[[matchingObjects objectAtIndex:i] objectForKey:@"Match String"] substringWithRange:NSMakeRange(beginningDataLength, [[[matchingObjects objectAtIndex:i] objectForKey:@"Match String"] length]-beginningDataLength-trailingDataLength)]];
        //NSLog(@"%@",tagData);
        [[matchingObjects objectAtIndex:i] setObject:tagData forKey:@"Data"];
    }
    
    
    return matchingObjects;
    
}

+ (NSString*)dateToGPXFormat: (NSDate*)date {
    NSDateFormatter *UTCDateFormat = [[[NSDateFormatter alloc] init] autorelease];
    [UTCDateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    [UTCDateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    return [UTCDateFormat stringFromDate:date];
}

+ (NSDate*)dateFromGPXFormat: (NSString*) dateString {
    NSDateFormatter *UTCDateFormat = [[[NSDateFormatter alloc] init] autorelease];
    [UTCDateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    [UTCDateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [UTCDateFormat setCalendar:[[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar] autorelease]];
    [UTCDateFormat setLocale:[[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] autorelease]];
    return [UTCDateFormat dateFromString:dateString];
}

//
// This is NOT Used.
//
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

+ (KMLTag)getKMLTagForKMLTagName:(NSString*) tagName {
    
    // Objects
    
    if( [tagName isEqualToString:kKMLTAG_MASTER] ) {
        return keKML_MASTER;
    } else if ( [tagName isEqualToString:kKMLTAG_PLACEMARK] ) {
        return keKML_PLACEMARK;
    } else if ( [tagName isEqualToString:kKMLTAG_LINE] ) {
        return keKML_LINE;
    } else if ( [tagName isEqualToString:kKMLTAG_POINT] ) {
        return keKML_POINT;
    }     
    
    // Attributes
    
    
    
    
    // Properties
    
    else if ( [tagName isEqualToString:kKMLTAG_NAME] ) {
        return keKML_NAME;
    } else if ( [tagName isEqualToString:kKMLTAG_DESCRIPTION] ) {
        return keKML_DESCRIPTION;
    } else if ( [tagName isEqualToString:kKMLTAG_COORDINATES] ) {
        return keKML_COORDINATES;
    } 

    return -1;
    
}

    
+ (KMLElementType)getKMLElementTypeByName:(NSString*) elementName {
    
    switch ( [GPUtilities getKMLTagForKMLTagName:elementName] ) {
            
        /* 
         * Objects
         */
        case keKML_MASTER:
            return keKML_OBJECT;
            break;
        case keKML_DOCUMENT:
            return keKML_OBJECT;
            break;
        case keKML_PLACEMARK:
            return keKML_OBJECT;
            break;
        case keKML_LINE:
            return keKML_OBJECT;
            break;
        case keKML_POINT:
            return keKML_OBJECT;
            break;
            
        /* 
         * Attributes
         */
        
            
        /* 
         * Properties
         */
        case keKML_NAME:
            return keKML_PROPERTY;
            break;
        case keKML_DESCRIPTION:
            return keKML_PROPERTY;
            break;
        case keKML_COORDINATES:
            return keKML_PROPERTY;
            break;
            
    }
    
    return -1;
}

+ (NSArray*)getArrayOfTrackPointsFromKMLCoordinatesString:(NSString*) coordinatesString {
    
    NSString *coordinatesStringStrippedOfNewlinesAndTabs = [NSString stringWithString:[GPUtilities getStringFromStringWithoutNewlineAndTabCharacters:coordinatesString]];
    NSMutableArray *arrayOfPoints = [NSMutableArray array];
    
    // Model: "<lon>,<lat>,<elevation> <lon>,<lat>,<elevation> ..."
    
    // Split string into each set of coordinates ("<lon>,<lat>,<elevation> ")
    NSMutableArray *arrayOfCoordinates = [NSMutableArray arrayWithArray:[coordinatesStringStrippedOfNewlinesAndTabs componentsSeparatedByString:@" "]];
    
    // Check because of the extra "" that is recorded as an element which isnt a coordinate
    if( [[arrayOfCoordinates lastObject] isEqualToString:@""] ) {
        [arrayOfCoordinates removeLastObject];
    }
    for( int i = 0; i < [arrayOfCoordinates count]; i++ ) {
        // Make each set of coordinates into a point ("<lon>","<lat>","<elevation>")
        NSArray *coordinateValues = [[arrayOfCoordinates objectAtIndex:i] componentsSeparatedByString:@","];
        GPTrackPoint *tempTrackPoint = [[GPTrackPoint alloc] initWithCoordinate:CLLocationCoordinate2DMake([[coordinateValues objectAtIndex:1] doubleValue], [[coordinateValues objectAtIndex:0] doubleValue])];
        if( [coordinateValues count] > 2 ) {
            [tempTrackPoint setElevation:[[coordinateValues objectAtIndex:2] doubleValue]];
        }
        [arrayOfPoints addObject:tempTrackPoint];
        [tempTrackPoint release];
    }
    
    return arrayOfPoints;
}

+ (CLLocation*)getSingleCoordinateFromKMLCoordinatesString: (NSString*) coordinatesString {
    
    NSString *coordinatesStringStrippedOfNewlinesAndTabs = [NSString stringWithString:[GPUtilities getStringFromStringWithoutNewlineAndTabCharacters:coordinatesString]];
    NSArray *coordinateValues = [coordinatesStringStrippedOfNewlinesAndTabs componentsSeparatedByString:@","];
    
    CLLocation *tempLoc = [[[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake([[coordinateValues objectAtIndex:1] doubleValue], [[coordinateValues objectAtIndex:0] doubleValue]) altitude:[[coordinateValues  objectAtIndex:2] doubleValue] horizontalAccuracy:0 verticalAccuracy:0 timestamp:nil] autorelease];
    
    return tempLoc;
}

+(NSString*)getUUID {
    CFUUIDRef myUUID = CFUUIDCreate(CFAllocatorGetDefault());
    NSString *UUIDString = [NSString stringWithFormat:@"%@", myUUID];
    CFRelease(myUUID);
    return UUIDString;
}
         
+(NSString*)getStringFromStringWithoutNewlineAndTabCharacters:(NSString*) string {

    NSString *stringWithoutTabs = [NSString stringWithString:[string stringByReplacingOccurrencesOfString:@"\t" withString:@""]];
    NSString *stringWithoutTabsAndNewlines = [NSString stringWithString:[stringWithoutTabs stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
    
    return stringWithoutTabsAndNewlines;
}
       
+ (double) CalculateDistanceInPointsInArray: (NSMutableArray*) pointsArray {
    
    double totalDistance = 0;
    
    NSEnumerator *e = [pointsArray objectEnumerator];
    id object;
    id prevObject;
    int count = 0;
    while ( object = [e nextObject] )
    {
        //NSLog(@"Coordinate: %@", [object coordinate]);
        if( count == 0 ) {
            prevObject = object;
        } else {
            totalDistance += [self CalculateKilometerDistanceFrom:[prevObject coordinate] To:[object coordinate]];
            prevObject = object;
        }
        count++;
    }
    
    return totalDistance;
}


+ (double) CalculateKilometerDistanceFrom: (CLLocationCoordinate2D) point1 To: (CLLocationCoordinate2D) point2 {
    
    // Derrived from http://www.movable-type.co.uk/scripts/latlong.html
    
    //double nRadius = 6371; // Earth's radius in Kilometers
    double nRadius = 6378.15981; // Earth's radius in Kilometers
    // Get the difference between our two points
    // then convert the difference into radians
    
    double nLat1 = point1.latitude;
    double nLon1 = point1.longitude;
    double nLat2 = point2.latitude;
    double nLon2 = point2.longitude;
    
    double nDLat = (nLat2 - nLat1) * (M_PI/180);
    double nDLon = (nLon2 - nLon1) * (M_PI/180);
    
    // Here is the new line
    nLat1 =  (nLat1) * (M_PI/180);
    nLat2 =  (nLat2) * (M_PI/180);
    
    double nA = pow ( sin(nDLat/2), 2 ) + cos(nLat1) * cos(nLat2) * pow ( sin(nDLon/2), 2 );
    
    double nC = 2 * atan2( sqrt(nA), sqrt( 1 - nA ));
    double nD = nRadius * nC;
    
    return nD; // Return our calculated distance
    
}
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       
       

@end
