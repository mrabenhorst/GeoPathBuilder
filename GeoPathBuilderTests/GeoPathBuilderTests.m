//
//  GeoPathBuilderTests.m
//  GeoPathBuilderTests
//
//  Created by Mark Rabenhorst on 1/31/12.
//  Copyright (c) 2012 Intl Mapping. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

#import "GeoPathBuilderTests.h"
#import "GPUtilities.h"
#import "GPWaypoint.h"
#import "GPRoutePoint.h"
#import "GPRoute.h"
#import "GPCollection.h"
#import "GPTrack.h"
#import "GPTrackPoint.h"
#import "GPTrackSegment.h"

@implementation GeoPathBuilderTests

@synthesize collection;

- (void)setUp
{
    [super setUp];
    
    collection = [[GPCollection alloc] initWithCreator:@"GeoPathBuilder"];
    GPTrackSegment *trackSeg = [[GPTrackSegment alloc] init];
    for( int i = 0; i < 20; i++ ) {
        GPTrackPoint *tkpt = [[GPTrackPoint alloc] initWithCoordinate:CLLocationCoordinate2DMake(i, -i)];
        [tkpt setName:[NSString stringWithFormat:@"Trackpoint: %d",i]];
        [tkpt setElevation:i];
        [tkpt setSymbol:@"Waypoint"];
        [tkpt setTime:[NSDate date]];
        [trackSeg addPoint:tkpt];
    }
    GPTrack *testTrack = [[GPTrack alloc] init];
    [testTrack setName:@"Test Track"];
    [testTrack addSegment:trackSeg];
    [collection addTrack:testTrack];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    
    [self testCreateCollectionFromScratch];
    
    [self testCreateGPCollectionFromGPXFile];
    
    [self testFindingUUID];        

}

-(void)testCreateCollectionFromScratch {
    
    STAssertNotNil(collection, @"Failed to create collection");
    
}

-(void)testCreateGPCollectionFromGPXFile {
    
    NSString *path = [[NSBundle bundleWithIdentifier:@"com.ima.GeoPathBuilderTests"] bundlePath];
    NSString *gpxFileLocation = [path stringByAppendingPathComponent:@"mystic_basin_trail.gpx"];
    NSData *gpxFileData = [NSData dataWithContentsOfFile:gpxFileLocation];
    
    GPCollection *fromGPX = [GPCollection newCollectionFromGPXFile:gpxFileData];
    
    STAssertNotNil(fromGPX, @"Failed to create GPCollection");
    
}

-(void)testFindingUUID {
    
    GPWaypoint *waypointToFind = [[GPWaypoint alloc] initWithCoordinate:CLLocationCoordinate2DMake(7.0, 7.0)];
    [collection addWaypoint:waypointToFind];
    
    NSString *testUUID = [NSString stringWithString:[waypointToFind UUID]];    
    
    GPWaypoint *waypointByUUID = (GPWaypoint*)[collection getObjectWithUUID:testUUID];
    
    STAssertNotNil(waypointByUUID, @"UUID Search Failed");
    if( waypointByUUID ) {
        STAssertEqualObjects(waypointToFind, waypointByUUID, @"UUID search failed");
    }
}















@end
