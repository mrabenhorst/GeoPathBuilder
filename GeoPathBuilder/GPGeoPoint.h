//
//  GPGeoPoint.h
//  GeoPathBuilder
//
//  Created by Mark Rabenhorst on 1/31/12.
//  Copyright (c) 2012 Intl Mapping. All rights reserved.
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


- (id)initWithCoordinate: (CLLocationCoordinate2D) locPoint;
- (id)initWithLocation: (CLLocation*) loc;


@end
