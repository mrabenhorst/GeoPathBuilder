//
//  GPGPXLoader.h
//  GeoPathBuilder
//
//  Created by Mark Rabenhorst on 2/10/12.
//  Copyright (c) 2012 Intl Mapping. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPCollection.h"
#import "GPTrack.h"
#import "GPTrackSegment.h"
#import "GPTrackPoint.h"


@interface GPGPXLoader : NSObject <NSXMLParserDelegate> {
    
    GPCollection *collection;
    GPWaypoint *tempWaypoint;
    GPRoute *tempRoute;
    GPRoutePoint *tempRoutePoint;
    GPTrack *tempTrack;
    GPTrackSegment *tempTrackSegment;
    GPTrackPoint *tempTrackPoint;
    
    NSObject *currentParentObject;    
    NSString *currentParentObjectTag;
    
    GPXTag currentTag;
    NSDictionary *currentTagAttributes;
    
    NSMutableString *currentValue;
    
}

-(id)init;

-(GPCollection*)getCollection;

-(void)processObjectWithTag: (NSString*) objectTag andAttributes: (NSDictionary*) attributeDict;
-(void)processPropertyWithTag: (NSString*) propertyTag andAttributes: (NSDictionary*) attributeDict;
-(void)assignProperty: (GPXTag) property toValue: (NSString*) value withAttributes: (NSDictionary*) attributeDict;

@end
