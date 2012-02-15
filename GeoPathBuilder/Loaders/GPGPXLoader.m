//
//  GPGPXLoader.m
//  GeoPathBuilder
//
//  Created by Mark Rabenhorst on 2/10/12.
//  Copyright (c) 2012 Intl Mapping. All rights reserved.
//

#import "GPGPXLoader.h"
#import "GPUtilities.h"
#import "GPConstants.h"

@implementation GPGPXLoader

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
    
    
    switch ( [GPUtilities getGPXElementTypeByName:elementName] ) {
        case keGPX_OBJECT:
            [self processObjectWithTag:elementName andAttributes:attributeDict];
            break;
        case keGPX_PROPERTY:
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
    
    NSLog(@"Ending: %@",elementName);
    
    if( [GPUtilities getGPXElementTypeByName:elementName] == keGPX_OBJECT ) {
        switch( [GPUtilities getGPXTagForGPXTagName:elementName] ) {
            case keGPX_MASTER:
                // finished obtaining GPX file
                break;
            case keGPX_WAYPOINT:
                // add track to collection, then reset track
                [collection addWaypoint:tempWaypoint];
                [tempWaypoint release];
                tempWaypoint = nil;
                break; 
            case keGPX_ROUTE:
                // add track to collection, then reset track
                [collection addRoute:tempRoute];
                [tempRoute release];
                tempRoute = nil;
                break; 
            case keGPX_ROUTEPT:
                // add track to collection, then reset track
                [tempRoute addPoint:tempRoutePoint];
                [tempRoutePoint release];
                tempRoutePoint = nil;
                break; 
            case keGPX_TRACK:
                // add track to collection, then reset track
                [collection addTrack:tempTrack];
                [tempTrack release];
                tempTrack = nil;
                break;
            case keGPX_TRACKSEG:
                // add segment to track, then reset segment
                [tempTrack addSegment:tempTrackSegment];
                [tempTrackSegment release];
                tempTrackSegment = nil;
                break;
            case keGPX_TRACKPT:
                // add point to segment, then reset point
                [tempTrackSegment addPoint:tempTrackPoint];
                [tempTrackPoint release];
                tempTrackPoint = nil;
                break;
            default:
                break;
        }
    }
    
}

-(void)processObjectWithTag: (NSString*) objectTag andAttributes: (NSDictionary*) attributeDict {
    
    switch( [GPUtilities getGPXTagForGPXTagName:objectTag] ) {
        case keGPX_MASTER:
            if( collection ) {
                [collection release];
                collection = nil;
            }
            collection = [[GPCollection alloc] initWithCreator:[attributeDict objectForKey:kGPXTAG_CREATOR]];
            
            if( currentParentObjectTag ) {
                [currentParentObjectTag release];
                currentParentObjectTag = nil;
            }
            currentParentObjectTag = [[NSString alloc] initWithString:objectTag];
            currentParentObject = collection;
            break;
            
        case keGPX_WAYPOINT:
            if( tempWaypoint ) {
                [tempWaypoint release];
                tempWaypoint = nil;
            }
            tempWaypoint = [[GPWaypoint alloc] initWithCoordinate:CLLocationCoordinate2DMake([[attributeDict objectForKey:@"lat"] doubleValue], [[attributeDict objectForKey:@"lon"] doubleValue])];
            
            if( currentParentObjectTag ) {
                [currentParentObjectTag release];
                currentParentObjectTag = nil;
            }
            currentParentObjectTag = [[NSString alloc] initWithString:objectTag];
            currentParentObject = tempWaypoint;
            break;
            
        case keGPX_ROUTE:
            if( tempRoute ) {
                [tempRoute release];
                tempRoute = nil;
            }
            tempRoute = [[GPRoute alloc] init];
            
            if( currentParentObjectTag ) {
                [currentParentObjectTag release];
                currentParentObjectTag = nil;
            }
            currentParentObjectTag = [[NSString alloc] initWithString:objectTag];
            currentParentObject = tempRoute;
            break;
            
        case keGPX_ROUTEPT:
            if( tempRoutePoint ) {
                [tempRoutePoint release];
                tempRoutePoint = nil;
            }
            tempRoutePoint = [[GPRoutePoint alloc] initWithCoordinate:CLLocationCoordinate2DMake([[attributeDict objectForKey:@"lat"] doubleValue], [[attributeDict objectForKey:@"lon"] doubleValue])];
            
            if( currentParentObjectTag ) {
                [currentParentObjectTag release];
                currentParentObjectTag = nil;
            }
            currentParentObjectTag = [[NSString alloc] initWithString:objectTag];
            currentParentObject = tempRoutePoint;
            break;
            
        case keGPX_TRACK:
            if( tempTrack ) {
                [tempTrack release];
                tempTrack = nil;
            }
            tempTrack = [[GPTrack alloc] init];
            
            if( currentParentObjectTag ) {
                [currentParentObjectTag release];
                currentParentObjectTag = nil;
            }
            currentParentObjectTag = [[NSString alloc] initWithString:objectTag];
            currentParentObject = tempTrack;
            break;
        
        case keGPX_TRACKSEG:
            if( tempTrackSegment ) {
                [tempTrackSegment release];
                tempTrackSegment = nil;
            }
            tempTrackSegment = [[GPTrackSegment alloc] init];
            
            if( currentParentObjectTag ) {
                [currentParentObjectTag release];
                currentParentObjectTag = nil;
            }
            currentParentObjectTag = [[NSString alloc] initWithString:objectTag];
            
            currentParentObject = tempTrackSegment;
            break;
            
        case keGPX_TRACKPT:
            if( tempTrackPoint ) {
                [tempTrackPoint release];
                tempTrackPoint = nil;
            }
            CLLocationCoordinate2D ptLocation = CLLocationCoordinate2DMake([[attributeDict objectForKey:kGPXTAG_LATITUDE] doubleValue], [[attributeDict objectForKey:kGPXTAG_LONGITUDE] doubleValue]);
            tempTrackPoint = [[GPTrackPoint alloc] initWithCoordinate:ptLocation];
            
            if( currentParentObjectTag ) {
                [currentParentObjectTag release];
                currentParentObjectTag = nil;
            }
            currentParentObjectTag = [[NSString alloc] initWithString:objectTag];
            
            currentParentObject = tempTrackPoint;
            break;
            
        default:
            break;
    }
    
}


-(void)processPropertyWithTag: (NSString*) propertyTag andAttributes: (NSDictionary*) attributeDict {

    // Put data in storage for when the value is read    
    currentTag = [GPUtilities getGPXTagForGPXTagName:propertyTag];
    
    if( currentTagAttributes ) {
        [currentTagAttributes release];
        currentTagAttributes = nil;
    }
    currentTagAttributes = [[NSDictionary alloc] initWithDictionary:attributeDict];
    
}

-(void)assignProperty: (GPXTag) property toValue: (NSString*) value withAttributes: (NSDictionary*) attributeDict {
    
    switch ( property ) {
        case keGPX_NAME:
            if( [currentParentObject respondsToSelector:@selector(setName:)] ) {
                [(GPGeoPoint*)currentParentObject setName:currentValue];
            }  
            break;
        case keGPX_DESCRIPTION:
            if( [currentParentObject respondsToSelector:@selector(setDescription:)] ) {
                [(GPGeoPoint*)currentParentObject setDescription:currentValue];
            }
            break;
        case keGPX_CREATOR:
            if( [currentParentObject respondsToSelector:@selector(setCreator:)] ) {
                [(GPCollection*)currentParentObject setCreator:currentValue];
            }
            break;
        case keGPX_AUTHOR:
            if( [currentParentObject respondsToSelector:@selector(setAuthor:)] ) {
                [(GPCollection*)currentParentObject setAuthor:currentValue];
            }
            break;
        case keGPX_EMAIL:
            if( [currentParentObject respondsToSelector:@selector(setEmail:)] ) {
                [(GPCollection*)currentParentObject setEmail:currentValue];
            }
            break;
        case keGPX_URL:
            if( [currentParentObject respondsToSelector:@selector(setURL:)] ) {
                [(GPPath*)currentParentObject setUrl:currentValue];
            }
            break;
        case keGPX_URLNAME:
            if( [currentParentObject respondsToSelector:@selector(setUrlname:)] ) {
                [(GPPath*)currentParentObject setUrlname:currentValue];
            }
            break;
        case keGPX_TIME:
            if( [currentParentObject respondsToSelector:@selector(setTime:)] ) {
                [(GPGeoPoint*)currentParentObject setTime:[GPUtilities dateFromGPXFormat:currentValue]];
            }
            break;
        case keGPX_KEYWORDS:
            if( [currentParentObject respondsToSelector:@selector(setKeywords:)] ) {
                [(GPCollection*)currentParentObject setKeywords:currentValue];
            }
            break;
        case keGPX_BOUNDS:
            if( [currentParentObject respondsToSelector:@selector(setBounds:)] ) {
                GPBounds bounds;
                bounds.west = [[attributeDict objectForKey:@"minlon"] doubleValue];
                bounds.east = [[attributeDict objectForKey:@"maxlon"] doubleValue];
                bounds.south = [[attributeDict objectForKey:@"minlat"] doubleValue];
                bounds.north = [[attributeDict objectForKey:@"maxlat"] doubleValue];
                [(GPCollection*)currentParentObject setBounds:bounds];
            }
            break;
        case keGPX_NUMBER:
            if( [currentParentObject respondsToSelector:@selector(setNumber:)] ) {
                [(GPPath*)currentParentObject setNumber:[currentValue doubleValue]];
            }
            break;
        case keGPX_ELEVATION:
            if( [currentParentObject respondsToSelector:@selector(setElevation:)] ) {
                [(GPGeoPoint*)currentParentObject setElevation:[currentValue doubleValue]];
            }
            break;
        case keGPX_COURSE:
            if( [currentParentObject respondsToSelector:@selector(setCourse:)] ) {
                [(GPGeoPoint*)currentParentObject setCourse:[currentValue doubleValue]];
            }
            break;
        case keGPX_SPEED:
            if( [currentParentObject respondsToSelector:@selector(setSpeed:)] ) {
                [(GPGeoPoint*)currentParentObject setSpeed:[currentValue doubleValue]];
            }
            break;
        case keGPX_COMMENT:
            if( [currentParentObject respondsToSelector:@selector(setComment:)] ) {
                [(GPGeoPoint*)currentParentObject setComment:currentValue];
            }
            break;
        case keGPX_SOURCE:
            if( [currentParentObject respondsToSelector:@selector(setSrc:)] ) {
                [(GPGeoPoint*)currentParentObject setSrc:currentValue];
            }
            break;
        case keGPX_SYMBOL:
            if( [currentParentObject respondsToSelector:@selector(setSymbol:)] ) {
                [(GPGeoPoint*)currentParentObject setSymbol:currentValue];
            }
            break;
        case keGPX_TYPE:
            if( [currentParentObject respondsToSelector:@selector(setType:)] ) {
                [(GPGeoPoint*)currentParentObject setType:currentValue];
            }
            break;
        default:
            break;
    }
    
    // reset the tag so repeated calls don't overwrite
    currentTag = -1;
    
}





@end
