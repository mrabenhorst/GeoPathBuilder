//
//  GPPath.h
//  GeoPathBuilder
//
//  Created by Mark Rabenhorst on 2/1/12.
//  Copyright (c) 2012 Intl Mapping. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPPath : NSObject {
    NSMutableArray *geoPoints;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *comment;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *src;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *urlname;
@property (nonatomic) double *number;

-(id)init;


@end
