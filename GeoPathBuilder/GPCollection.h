//
//  GPCollection.h
//  GeoPathBuilder
//
//  Created by Mark Rabenhorst on 2/1/12.
//  Copyright (c) 2012 Intl Mapping. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPConstants.h"

@interface GPCollection : NSObject {

    NSMutableArray *waypoints;
    NSMutableArray *routes;
    
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *author;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *urlname;
@property (nonatomic, retain) NSDate *time;
@property (nonatomic, retain) NSString *keywords;
@property (nonatomic) struct GPBounds bounds;



@end
