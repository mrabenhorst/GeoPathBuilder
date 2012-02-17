//
//  GPCollection.h
//  GeoPathBuilder
//
//  Created by Mark Rabenhorst on 2/1/12.
//  Copyright (c) 2012 Intl Mapping. All rights reserved.
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

// Returns a string version of the GPCollection in GPX format
- (NSString*)getGPXString;

- (NSObject*)getObjectWithUUID: (NSString*) UUID;

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
-(GPWaypoint*)getRouteWithUUID: (NSString*) UUID;


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
-(GPWaypoint*)getTrackWithUUID: (NSString*) UUID;

/*
 * To code:
 */


- (NSString*)getKMLString;
- (void)fromKMLString;

@end
