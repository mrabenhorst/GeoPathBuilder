//
//  GPCollection.m
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

-(id)initWithCreator: (NSString*) theCreator {
    waypoints = [[NSMutableArray alloc] init];
    routes = [[NSMutableArray alloc] init];
    tracks = [[NSMutableArray alloc] init];
    [self setCreator:theCreator];
    return self;
}

- (NSObject*)getObjectWithUUID: (NSString*) matchUUID {
    
    NSObject *match = nil;
    BOOL matchFound = false;
    
    for( int i = 0;(i < [waypoints count] && matchFound != true); i++ ) {
        if( [[[waypoints objectAtIndex:i] UUID] isEqualToString:matchUUID] ) {
            match = [waypoints objectAtIndex:i];
            matchFound = true;
        }
    }
    
    for( int i = 0;(i < [routes count] && matchFound != true); i++ ) {
        if( [[[routes objectAtIndex:i] UUID] isEqualToString:matchUUID] ) {
            match = [routes objectAtIndex:i];
            matchFound = true;
        } else {
            if( !match ) {
                match = [[routes objectAtIndex:i] getObjectWithUUID:matchUUID];
                matchFound = true;
            }
        }
    }
    
    for( int i = 0;(i < [tracks count] && matchFound != true); i++ ) {
        // Check the track's UUID
        if( [[[tracks objectAtIndex:i] UUID] isEqualToString:matchUUID] ) {
            match = [tracks objectAtIndex:i];
            matchFound = true;
        } else {
            // Track the track segments in the track
            if( !match ) {
                match = [[tracks objectAtIndex:i] getObjectWithUUID:matchUUID];
                if( match ) {
                    matchFound = true;
                }
            }
        }
    }
    
    return match;
    
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

-(NSArray*)getWaypointsWithName: (NSString*) nameToMatch caseInsensitive: (BOOL) caseInsensitive {
    
    NSMutableArray *matches = [NSMutableArray array];
    
    for( int i = 0; i < [waypoints count]; i++ ) {
        if( caseInsensitive ) {
            // case insensitive match
            if( [[nameToMatch lowercaseString] isEqualToString:[[[waypoints objectAtIndex:i] name] lowercaseString]] ) {
                [matches addObject:[waypoints objectAtIndex:i]];
            }
        } else {
            if( [nameToMatch isEqualToString:[[waypoints objectAtIndex:i] name]] ) {
                [matches addObject:[waypoints objectAtIndex:i]];
            }
        }
    }
    
    return matches;
    
}

-(GPWaypoint*)getWaypointWithUUID: (NSString*) UUID {
    
    GPWaypoint *match;
    
    for( int i = 0; i < [waypoints count]; i++ ) {
        if( [[[waypoints objectAtIndex:i] UUID] isEqualToString:UUID] ) {
            match = [waypoints objectAtIndex:i];
        }
    }
    
    return match;
    
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


-(NSArray*)getRoutesWithName: (NSString*) nameToMatch caseInsensitive: (BOOL) caseInsensitive {
    
    NSMutableArray *matches = [NSMutableArray array];
    
    for( int i = 0; i < [routes count]; i++ ) {
        if( caseInsensitive ) {
            // case insensitive match
            if( [[nameToMatch lowercaseString] isEqualToString:[[[routes objectAtIndex:i] name] lowercaseString]] ) {
                [matches addObject:[routes objectAtIndex:i]];
            }
        } else {
            if( [nameToMatch isEqualToString:[[routes objectAtIndex:i] name]] ) {
                [matches addObject:[routes objectAtIndex:i]];
            }
        }
    }
    
    return matches;
    
}


-(GPWaypoint*)getRouteWithUUID: (NSString*) UUID {
    
    GPWaypoint *match;
    
    for( int i = 0; i < [routes count]; i++ ) {
        if( [[[routes objectAtIndex:i] UUID] isEqualToString:UUID] ) {
            match = [routes objectAtIndex:i];
        }
    }
    
    return match;
    
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

// Returns all tracks with a name based on case sensitivity
-(NSArray*)getTracksWithName: (NSString*) nameToMatch caseInsensitive: (BOOL) caseInsensitive {
    NSMutableArray *matches = [NSMutableArray array];
    
    for( int i = 0; i < [tracks count]; i++ ) {
        if( caseInsensitive ) {
            // case insensitive match
            if( [[nameToMatch lowercaseString] isEqualToString:[[[tracks objectAtIndex:i] name] lowercaseString]] ) {
                [matches addObject:[tracks objectAtIndex:i]];
            }
        } else {
            if( [nameToMatch isEqualToString:[[tracks objectAtIndex:i] name]] ) {
                [matches addObject:[tracks objectAtIndex:i]];
            }
        }
    }
    
    return matches;
}

// Returns the track with matching UUID or nil if there are no matches
-(GPWaypoint*)getTrackWithUUID: (NSString*) UUID {
    GPWaypoint *match;
    
    for( int i = 0; i < [tracks count]; i++ ) {
        if( [[[tracks objectAtIndex:i] UUID] isEqualToString:UUID] ) {
            match = [tracks objectAtIndex:i];
        }
    }
    
    return match;
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
