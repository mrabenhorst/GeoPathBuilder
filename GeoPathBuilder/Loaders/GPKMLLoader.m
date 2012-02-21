//
//  GPKMLLoader.m
//  GeoPathBuilder
//
//  Created by Mark Rabenhorst on 2/21/12.
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

#import <CoreLocation/CoreLocation.h>
#import "GPKMLLoader.h"
#import "GPUtilities.h"

@implementation GPKMLLoader

-(id)init {
    return self;
}

-(GPCollection*)getCollection {
    return collection;
}

-(void)  parser:(NSXMLParser *)parser 
didStartElement:(NSString *)elementName 
   namespaceURI:(NSString *)namespaceURI 
  qualifiedName:(NSString *)qName 
     attributes:(NSDictionary *)attributeDict {
    
    
    switch ( [GPUtilities getKMLElementTypeByName:elementName] ) {
        case keKML_OBJECT:
            [self processObjectWithTag:elementName andAttributes:attributeDict];
            break;
        case keKML_PROPERTY:
            [self processPropertyWithTag:elementName andAttributes:attributeDict];
            break;
        default:
            break;
    }
    
    
}

-(void)  parser:(NSXMLParser *)parser 
foundCharacters:(NSString *)string {
    
    if( currentValue ) {
        [currentValue release];
        currentValue = nil;
    }
    currentValue = [[NSMutableString alloc] initWithString:string];
    
    [self assignProperty:currentTag toValue:currentValue withAttributes:currentTagAttributes];
}

-(void) parser:(NSXMLParser *)parser 
    foundCDATA:(NSData *)CDATABlock {
    
    if( currentValue ) {
        [currentValue release];
        currentValue = nil;
    }
    currentValue = [[NSMutableString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    
    [self assignProperty:currentTag toValue:currentValue withAttributes:currentTagAttributes];
}

-(void) parser:(NSXMLParser *)parser 
 didEndElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qName {
    
    if( [GPUtilities getKMLElementTypeByName:elementName] == keKML_OBJECT ) {
        switch( [GPUtilities getKMLTagForKMLTagName:elementName] ) {
            case keKML_MASTER:
                // finished obtaining KML file
                break;
            case keKML_DOCUMENT:
                //
                // Does not support documents at this point
                //
                break; 
            case keKML_PLACEMARK:
                // Do nothing because this is handled by the specific placemark type
                break; 
            case keKML_LINE:
                // add track to collection, then reset track
                [collection addTrack:tempTrack];
                [tempTrack release];
                tempTrack = nil;
                break; 
            case keKML_POINT:
                // add track to collection, then reset track
                [collection addWaypoint:tempWaypoint];
                [tempWaypoint release];
                tempWaypoint = nil;
                break;
            default:
                break;
        }
    }
    
}

-(void)processObjectWithTag: (NSString*) objectTag andAttributes: (NSDictionary*) attributeDict {
    
    switch( [GPUtilities getKMLTagForKMLTagName:objectTag] ) {
        case keKML_MASTER:
            if( collection ) {
                [collection release];
                collection = nil;
            }
            collection = [[GPCollection alloc] initWithCreator:@""]; // CHANGE LATER ON
            
            if( currentParentObjectTag ) {
                [currentParentObjectTag release];
                currentParentObjectTag = nil;
            }
            currentParentObjectTag = [[NSString alloc] initWithString:objectTag];
            currentParentObject = collection;
            break;
            
        case keKML_DOCUMENT:
            //
            // Does not support documents at this point
            //
            break;
            
        case keKML_PLACEMARK:
            if( tempPlacemark ) {
                [tempPlacemark release];
                tempPlacemark = nil;
            }
            tempPlacemark = [[GPKMLPlacemark alloc] init];
            
            if( currentParentObjectTag ) {
                [currentParentObjectTag release];
                currentParentObjectTag = nil;
            }
            currentParentObjectTag = [[NSString alloc] initWithString:objectTag];
            currentParentObject = tempPlacemark;
            break;
            
        case keKML_LINE:
            
            // Init the track to hold the points based on placemark info
            if( tempTrack ) {
                [tempTrack release];
                tempTrack = nil;
            }
            tempTrack = [[GPTrack alloc] init];
            [tempTrack setName:[tempPlacemark name]];
            [tempTrack setDescription:[tempTrack description]];
            
            // Init the track segment and add the segment to the track
            if( tempTrackSegment ) {
                [tempTrackSegment release];
                tempTrackSegment = nil;
            }
            tempTrackSegment = [[GPTrackSegment alloc] init];
            [tempTrack addSegment:tempTrackSegment];
            
            if( currentParentObjectTag ) {
                [currentParentObjectTag release];
                currentParentObjectTag = nil;
            }
            currentParentObjectTag = [[NSString alloc] initWithString:objectTag];
            currentParentObject = tempTrackSegment;                 
            break;
            
        case keKML_POINT:
            if( tempWaypoint ) {
                [tempWaypoint release];
                tempWaypoint = nil;
            }
            tempWaypoint = [[GPWaypoint alloc] init];
            [tempWaypoint setName:[tempPlacemark name]];
            [tempWaypoint setDescription:[tempPlacemark description]];
            
            if( currentParentObjectTag ) {
                [currentParentObjectTag release];
                currentParentObjectTag = nil;
            }
            currentParentObjectTag = [[NSString alloc] initWithString:objectTag];
            currentParentObject = tempWaypoint;
            break;
            
        default:
            break;
    }
    
}


-(void)processPropertyWithTag: (NSString*) propertyTag andAttributes: (NSDictionary*) attributeDict {
    
    // Put data in storage for when the value is read    
    currentTag = [GPUtilities getKMLTagForKMLTagName:propertyTag];
    
    if( currentTagAttributes ) {
        [currentTagAttributes release];
        currentTagAttributes = nil;
    }
    currentTagAttributes = [[NSDictionary alloc] initWithDictionary:attributeDict];
    
}

-(void)assignProperty: (KMLTag) property toValue: (NSString*) value withAttributes: (NSDictionary*) attributeDict {
    
    switch ( property ) {
        case keKML_NAME:
            if( [currentParentObject respondsToSelector:@selector(setName:)] ) {
                [(GPGeoPoint*)currentParentObject setName:currentValue];
            }  
            break;
        case keKML_DESCRIPTION:
            if( [currentParentObject respondsToSelector:@selector(setDescription:)] ) {
                [(GPGeoPoint*)currentParentObject setDescription:currentValue];
            }
            break;
        case keKML_COORDINATES:
            switch( [GPUtilities getKMLTagForKMLTagName:currentParentObjectTag] ) {
                case keKML_LINE:
                    [tempTrackSegment addPointsFromArray:[GPUtilities getArrayOfTrackPointsFromKMLCoordinatesString:currentValue]];
                    break;
                case keKML_POINT: { // Braces for variable declaration
                    CLLocation *tempLoc = [GPUtilities getSingleCoordinateFromKMLCoordinatesString:currentValue];
                    [tempWaypoint setLocation:[tempLoc coordinate]];
                    [tempWaypoint setElevation:[tempLoc altitude]];
                    break;
                }
                default:
                    break;
            }
            break;
        default:
            break;
    }
    
    // reset the tag so repeated calls don't overwrite
    currentTag = -1;
    
}

-(void)dealloc {
    
    collection ? [collection release] : nil;
    tempPlacemark ? [tempPlacemark release] : nil;
    tempWaypoint ? [tempWaypoint release] : nil;
    tempRoute ? [tempRoute release] : nil;
    tempRoutePoint ? [tempRoutePoint release] : nil;
    tempTrack ? [tempTrack release] : nil;
    tempTrackSegment ? [tempTrackSegment release] : nil;
    tempTrackPoint ? [tempTrackPoint release] : nil;
    currentParentObject ? [currentParentObject release] : nil;
    currentParentObjectTag ? [currentParentObjectTag release] : nil;
    currentTagAttributes ? [currentTagAttributes release] : nil;
    currentValue? [currentValue release] : nil;
    
}

@end
