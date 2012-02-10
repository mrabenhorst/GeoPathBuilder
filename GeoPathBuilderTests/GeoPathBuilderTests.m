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

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    
    GPCollection *testGPXFile = [[GPCollection alloc] initWithCreator:@"GeoPathBuilder"];
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
    [testGPXFile addTrack:testTrack];
    NSString *gpxFileString = [testGPXFile getGPXString];
    
    NSArray *tags = [NSArray arrayWithArray:[GPUtilities getValueAndAttributesFromString:gpxFileString withTag:@"gpx"]];
    

}

@end
