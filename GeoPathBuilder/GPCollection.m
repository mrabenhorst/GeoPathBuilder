//
//  GPCollection.m
//  GeoPathBuilder
//
//  Created by Mark Rabenhorst on 2/1/12.
//  Copyright (c) 2012 Intl Mapping. All rights reserved.
//

#import "GPCollection.h"
#import "GPUtilities.h"
#import "GPConstants.h"
#import "GPWaypoint.h"
#import "GPRoute.h"
#import "GPGPXLoader.h"

@implementation GPCollection 

@synthesize creator;
@synthesize name;
@synthesize description;
@synthesize author;
@synthesize email;
@synthesize url;
@synthesize urlname;
@synthesize time;
@synthesize keywords;
@synthesize bounds;

-(id)initWithCreator: (NSString*) creator {
    waypoints = [[NSMutableArray alloc] init];
    routes = [[NSMutableArray alloc] init];
    tracks = [[NSMutableArray alloc] init];
    [self setCreator:creator];
    return self;
}

-(void)addWaypoint: (GPWaypoint*) waypoint {
    [waypoints addObject:waypoint];
}
-(BOOL)removeWaypoint: (GPWaypoint*) waypoint {
    if( [waypoints containsObject:waypoint] ) {
        [waypoints removeObject:waypoint];
        return TRUE;
    } else {
        return FALSE;
    }
}
-(void)addRoute: (GPRoute*) route {
    [routes addObject:route];
}
-(BOOL)removeRoute: (GPRoute*) route {
    if( [routes containsObject:route] ) {
        [routes removeObject:route];
        return TRUE;
    } else {
        return FALSE;
    }
}

-(void)addTrack: (GPTrack*) track {
    [tracks addObject:track];
}

-(BOOL)removeTrack: (GPTrack*) track {
    if( [tracks containsObject:track] ) {
        [tracks removeObject:track];
        return TRUE;
    } else {
        return FALSE;
    }
}



- (NSString*)getGPXString {
    
    NSMutableString *GPXDataString = [[[NSMutableString alloc] initWithString:@""] autorelease];
    
    // If attribute exists, add the tag. If not, don't do anything
    [self name] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_NAME attributeVals:nil attributeKeys:nil andValue:self.name useCDATA:FALSE]] : nil;
    [self description] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_DESCRIPTION attributeVals:nil attributeKeys:nil andValue:self.description useCDATA:TRUE]] : nil;
    [self author] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_AUTHOR attributeVals:nil attributeKeys:nil andValue:self.author useCDATA:FALSE]] : nil;
    [self email] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_EMAIL attributeVals:nil attributeKeys:nil andValue:self.email useCDATA:FALSE]] : nil;
    [self url] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_URL attributeVals:nil attributeKeys:nil andValue:self.url useCDATA:FALSE]] : nil;
    [self urlname] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_URLNAME attributeVals:nil attributeKeys:nil andValue:self.urlname useCDATA:FALSE]] : nil;
    [self time] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_TIME attributeVals:nil attributeKeys:nil andValue:[GPUtilities dateToGPXFormat:self.time] useCDATA:FALSE]] : nil;
    [self keywords] ? [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_KEYWORDS attributeVals:nil attributeKeys:nil andValue:self.keywords useCDATA:FALSE]] : nil;
    // If bounds are all 0, bounds haven't been set
    if( !(self.bounds.north == 0 && self.bounds.south == 0 && self.bounds.east == 0 && self.bounds.west == 0) ) {
        
        NSArray *values = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%f",self.bounds.north],[NSString stringWithFormat:@"%f",self.bounds.south],[NSString stringWithFormat:@"%f",self.bounds.east],[NSString stringWithFormat:@"%f",self.bounds.west], nil];
        NSArray *keys = [NSArray arrayWithObjects:@"minlat", @"minlon", @"maxlat", @"maxlon", nil];
        [GPXDataString appendString:[GPUtilities createTagWithName:kGPXTAG_BOUNDS attributeVals:values attributeKeys:keys andValue:@"" useCDATA:FALSE]];
    } 
    
    // Get the GPX String of each route
    for( int i = 0; i < [waypoints count]; i++ ) {
        [GPXDataString appendString:[((GPWaypoint*)[waypoints objectAtIndex:i]) getGPXString]];
    }
    
    // Get the GPX String of each waypoint
    for( int i = 0; i < [routes count]; i++ ) {
        [GPXDataString appendString:[((GPRoute*)[routes objectAtIndex:i]) getGPXString]];
    }
    
    // Get the GPX String of each track
    for( int i = 0; i < [tracks count]; i++ ) {
        [GPXDataString appendString:[((GPRoute*)[tracks objectAtIndex:i]) getGPXString]];
    }
    
    NSArray *gpxAttributeVals = [NSArray arrayWithObjects:kGPX_SCHEMA_VERSION,self.creator,kGPX_XSI_VAL,kGPX_XMLNS_VAL,kGPX_SCHEMA_LOC_VAL, nil];
    NSArray *gpxAttributeKeys = [NSArray arrayWithObjects:@"Version",@"Creator",kGPX_XSI_ATTR,kGPX_XMLNS_ATTR,kGPX_SCHEMA_LOC_ATTR, nil];
    
    // Add the tag data into the main tag 
    NSString *xmlHeaderTag = [NSString stringWithString:@"<?xml version=\"1.0\"?>"];
    NSString *GPXTagString = [NSString stringWithFormat:@"%@%@",xmlHeaderTag, [GPUtilities createTagWithName:kGPXTAG_MASTER attributeVals:gpxAttributeVals attributeKeys:gpxAttributeKeys andValue:GPXDataString useCDATA:FALSE]];
    
    return GPXTagString;
}

+(id)newCollectionFromGPXFile: (NSData*) gpxFileData {
    
    NSXMLParser *nsXmlParser = [[NSXMLParser alloc] initWithData:gpxFileData];
    GPGPXLoader *gpxLoader = [[GPGPXLoader alloc] init];
    
    [nsXmlParser setDelegate:gpxLoader];
    
    BOOL success = [nsXmlParser parse];
    if( success ) {
        
        // get data from gpxLoader
        return [gpxLoader getCollection];
    } else {
        
        // something very bad happened...
        return nil;
    }

}

@end
