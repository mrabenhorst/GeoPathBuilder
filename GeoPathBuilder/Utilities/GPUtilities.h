//
//  GPUtilities.h
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

#import <Foundation/Foundation.h>
#import "GPConstants.h"

@interface GPUtilities : NSObject

// General Utilities
+ (NSString*)createTagWithName: (NSString*)tagName attributeVals: values attributeKeys: keys andValue: (NSString*)value useCDATA: (BOOL) cdata;

// Returns an array of dictionaries - one for each tag found.
//      Dictionary:
//          Attributes: Dictionary with lowercase attribute names (keys) and their values (values)
//          Value: String representation of all data within the tag
+ (NSArray*)getValueAndAttributesFromString: (NSString*) string withTag: (NSString*) tag;

// GPX Utilities
+ (NSString*)dateToGPXFormat: (NSDate*)date;
+ (NSDate*)dateFromGPXFormat: (NSString*) dateString;

+ (NSString*)GPBoundsToGPXFormat: (GPBounds) bounds;
+ (GPXTag)getGPXTagForGPXTagName:(NSString*) tagName;
+ (GPXElementType)getGPXElementTypeByName:(NSString*) elementName;

+ (NSString*)getUUID;

+ (double) CalculateDistanceInPointsInArray: (NSMutableArray*) pointsArray;
+ (double) CalculateKilometerDistanceFrom: (CLLocationCoordinate2D) point1 To: (CLLocationCoordinate2D) point2;
@end
