//
//  GPGeoPoint.h
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

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GPGeoPoint : NSObject {

    
}

@property (nonatomic, retain) NSString       *name;
@property (nonatomic, retain) NSString       *description;
@property (nonatomic, retain) NSString       *comment;

@property (nonatomic) CLLocationCoordinate2D  location;
@property (nonatomic) double                  elevation;
@property (nonatomic, retain) NSDate         *time;
@property (nonatomic) double                  course;
@property (nonatomic) double                  speed;

@property (nonatomic, retain) NSString       *src;
@property (nonatomic, retain) NSString       *url;
@property (nonatomic, retain) NSString       *urlname;
@property (nonatomic, retain) NSString       *symbol;
@property (nonatomic, retain) NSString       *type;
@property (nonatomic, retain) NSString       *UUID;


- (id)initWithCoordinate: (CLLocationCoordinate2D) locPoint;
- (id)initWithLocation: (CLLocation*) loc;


@end
