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

-(id)initWithCreator: (NSString*) creator;
+(id)getCollectionFromGPXFile: (NSData*) gpxFileData;

/*
 * Returns a string version of the Waypoint in GPX format
 */
- (NSString*)getGPXString;

-(void)addWaypoint: (GPWaypoint*) waypoint;

/*
 * Returns TRUE if waypoint found and removed, FALSE if waypoint was not found
 */
-(BOOL)removeWaypoint: (GPWaypoint*) waypoint;

-(void)addRoute: (GPRoute*) route;

/*
 * Returns TRUE if route found and removed, FALSE if route was not found
 */
-(BOOL)removeRoute: (GPRoute*) route;

-(void)addTrack: (GPTrack*) track;

/*
 * Returns TRUE if track found and removed, FALSE if track was not found
 */
-(BOOL)removeTrack: (GPTrack*) track;



/*
 * To code:
 */


- (NSString*)getKMLString;
- (void)fromKMLString;

@end
