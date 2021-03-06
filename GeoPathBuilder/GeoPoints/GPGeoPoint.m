//
//  GPGeoPoint.m
//  GeoPathBuilder
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
    [self setTime:[NSDate date]]; // Defaulty sets time to the time it was made so that it shows up
    
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
