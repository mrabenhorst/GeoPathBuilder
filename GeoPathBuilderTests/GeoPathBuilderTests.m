//
//  GeoPathBuilderTests.m
//  GeoPathBuilderTests
//
//  Created by Mark Rabenhorst on 1/31/12.
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
@synthesize fromFile;

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

    [self testPathStats];
    
    [self testDynamicBounds];
}

-(void)testCreateCollectionFromScratch {
    
    STAssertNotNil(collection, @"Failed to create collection");
    
}

-(void)testCreateGPCollectionFromGPXFile {
    
    NSString *path = [[NSBundle bundleWithIdentifier:@"com.ima.GeoPathBuilderTests"] bundlePath];
    NSString *gpxFileLocation = [path stringByAppendingPathComponent:@"mystic_basin_trail.gpx"];
    NSData *gpxFileData = [NSData dataWithContentsOfFile:gpxFileLocation];
    
    fromFile = [GPCollection newCollectionFromGPXFile:gpxFileData];
    
    STAssertNotNil(fromFile, @"Failed to create GPCollection");
    
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

-(void)testPathStats {
    
    GPTrack *longTrack = [[fromFile getTracksWithName:[NSString stringWithString:@"LONG TRACK"] caseInsensitive:FALSE] objectAtIndex:0];
    
    NSLog(@"longTrack getTotalDistance: %f", [longTrack getTotalDistance] );
    NSLog(@"longTrack getTotalAscent: %f", [longTrack getTotalAscent] );
    NSLog(@"longTrack getTotalDescent: %f", [longTrack getTotalDescent] );
    NSLog(@"longTrack getAvgSpeed: %f", [longTrack getAvgSpeed] );
    NSLog(@"longTrack getMinSpeed: %f", [longTrack getMinSpeed] );
    NSLog(@"longTrack getMaxSpeed: %f", [longTrack getMaxSpeed] );
    NSLog(@"longTrack getAvgElevation: %f", [longTrack getAvgElevation] );
    NSLog(@"longTrack getMinElevation: %f", [longTrack getMinElevation] );
    NSLog(@"longTrack getMaxElevation: %f", [longTrack getMaxElevation] );
    
    GPRoute *longRoute = [[fromFile getRoutesWithName:[NSString stringWithString:@"LONG LOOP"] caseInsensitive:FALSE] objectAtIndex:0];
    
    NSLog(@"longRoute getTotalDistance: %f", [longRoute getTotalDistance] );
    NSLog(@"longRoute getTotalAscent: %f", [longRoute getTotalAscent] );
    NSLog(@"longRoute getTotalDescent: %f", [longRoute getTotalDescent] );
    NSLog(@"longRoute getAvgSpeed: %f", [longRoute getAvgSpeed] );
    NSLog(@"longRoute getMinSpeed: %f", [longRoute getMinSpeed] );
    NSLog(@"longRoute getMaxSpeed: %f", [longRoute getMaxSpeed] );
    NSLog(@"longRoute getAvgElevation: %f", [longRoute getAvgElevation] );
    NSLog(@"longRoute getMinElevation: %f", [longRoute getMinElevation] );
    NSLog(@"longRoute getMaxElevation: %f", [longRoute getMaxElevation] );
    
}

-(void)testDynamicBounds {
    
    [collection updateBounds];
    GPBounds newBounds = [collection bounds];
    NSLog(@"Bounds, N: %f, E: %f, S: %f, W: %f", newBounds.north, newBounds.east, newBounds.south, newBounds.west );
    
}


@end
