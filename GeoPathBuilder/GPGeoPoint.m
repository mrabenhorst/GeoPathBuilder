//
//  GPGeoPoint.m
//  GeoPathBuilder
//
//  Created by Mark Rabenhorst on 1/31/12.
//  Copyright (c) 2012 Intl Mapping. All rights reserved.
//

#import "GPGeoPoint.h"

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

- (id)initWithCoordinate: (CLLocationCoordinate2D) locPoint {
    
    [self setLocation:locPoint];
    
    return self;
    
}

- (id)initWithLocation: (CLLocation*) loc {
    
    [self setLocation: [loc coordinate]];
    [self setCourse:[loc course]];
    [self setSpeed:[loc speed]];
    [self setTime:[loc timestamp]];
    [self setElevation:[loc altitude]];
    
    return self;
}

@end
