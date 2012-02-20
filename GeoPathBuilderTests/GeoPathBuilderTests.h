//
//  GeoPathBuilderTests.h
//  GeoPathBuilderTests
//
//  Created by Mark Rabenhorst on 1/31/12.
//  Copyright (c) 2012 Intl Mapping. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "GPCollection.h"

@interface GeoPathBuilderTests : SenTestCase

@property (nonatomic, retain) GPCollection *collection;
@property (nonatomic, retain) GPCollection *fromFile;


-(void)testCreateCollectionFromScratch;
-(void)testCreateGPCollectionFromGPXFile;
-(void)testFindingUUID;
-(void)testPathStats;

@end
