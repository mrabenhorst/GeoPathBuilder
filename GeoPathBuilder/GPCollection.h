//
//  GPCollection.h
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

#import <Foundation/Foundation.h>
#import "GPConstants.h"
#import "GPWaypoint.h"
#import "GPRoute.h"
#import "GPTrack.h"

@interface GPCollection : NSObject {

    NSMutableArray *waypoints;
    NSMutableArray *routes;
    NSMutableArray *tracks;
    
}
@property (nonatomic, retain) NSString *creator;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *author;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *urlname;
@property (nonatomic, retain) NSDate *time;
@property (nonatomic, retain) NSString *keywords;
@property (nonatomic) GPBounds bounds;

// GPCollection creation
-(id)initWithCreator: (NSString*) creator;
+(id)newCollectionFromGPXFile: (NSData*) gpxFileData;
+(id)newCollectionFromKMLFile: (NSData*) kmlFileData;

-(NSArray*)getAllPoints;
-(void)updateBounds;

// Returns a string version of the GPCollection in GPX format
- (NSString*)getGPXString;

- (void)writeToGPXFileWithPath: (NSString*)gpxFilePath;

- (NSObject*)getObjectWithUUID: (NSString*) matchUUID;

/*******
 *
 * WAYPOINTS
 *
 *******/

// Adds a waypoint to the array of waypoints
-(void)addWaypoint: (GPWaypoint*) waypoint;

// Returns TRUE if waypoint found and removed, FALSE if waypoint was not found
-(BOOL)removeWaypoint: (GPWaypoint*) waypoint;

// Returns all waypoints with a name based on case sensitivity
-(NSArray*)getWaypointsWithName: (NSString*) nameToMatch caseInsensitive: (BOOL) caseInsensitive;

// Returns the waypoint with matching UUID or nil if there are no matches
-(GPWaypoint*)getWaypointWithUUID: (NSString*) UUID;

// Returns array of waypoints
-(NSArray*)getWaypoints;

/*******
 *
 * ROUTES
 *
 *******/

// Adds a route to the array of routes
-(void)addRoute: (GPRoute*) route;

// Returns TRUE if route found and removed, FALSE if route was not found
-(BOOL)removeRoute: (GPRoute*) route;

// Returns all routes with a name based on case sensitivity
-(NSArray*)getRoutesWithName: (NSString*) nameToMatch caseInsensitive: (BOOL) caseInsensitive;

// Returns the route with matching UUID or nil if there are no matches
-(GPRoute*)getRouteWithUUID: (NSString*) UUID;

// Returns array of routes
-(NSArray*)getRoutes;

/*******
 *
 * TRACKS
 *
 *******/

// Adds a track to the array od tracks
-(void)addTrack: (GPTrack*) track;

// Returns TRUE if track found and removed, FALSE if track was not found
-(BOOL)removeTrack: (GPTrack*) track;

// Returns all tracks with a name based on case sensitivity
-(NSArray*)getTracksWithName: (NSString*) nameToMatch caseInsensitive: (BOOL) caseInsensitive;

// Returns the track with matching UUID or nil if there are no matches
-(GPTrack*)getTrackWithUUID: (NSString*) UUID;

// Returns array of tracks
-(NSArray*)getTracks;

/*
 * To code:
 */


//- (NSString*)getKMLString;
//- (void)fromKMLString;

@end
