//
//  GPGeoPoint.m
//  GeoPathBuilder
//
//  Created by Mark Rabenhorst on 1/31/12.
//  Copyright (c) 2012 Intl Mapping. All rights reserved.
//

#import "GPGeoPoint.h"
#import "GPUtilities.h"

@implementation GPGeoPoint

@synthesize name;
@synthesize description;
@synthesize comment;

@synthesize location;
@synthesize elevation;
@synthesize time;
@synthesize course;
@synthesize speed;

@synthesize src;
@synthesize url;
@synthesize urlname;
@synthesize symbol;
@synthesize type;

@synthesize UUID;

- (id)initWithCoordinate: (CLLocationCoordinate2D) locPoint {
    
    [self setLocation:locPoint];
    
    [self setUUID:[GPUtilities getUUID]];
    
    return self;
    
}

- (id)initWithLocation: (CLLocation*) loc {
    
    [self setLocation: [loc coordinate]];
    [self setCourse:[loc course]];
    [self setSpeed:[loc speed]];
    [self setTime:[loc timestamp]];
    [self setElevation:[loc altitude]];

    [self setUUID:[GPUtilities getUUID]];
    
    return self;
}

@end
