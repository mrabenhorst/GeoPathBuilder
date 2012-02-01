//
//  GPConstants.h
//  GeoPathBuilder
//
//  Created by Mark Rabenhorst on 1/31/12.
//  Copyright (c) 2012 Intl Mapping. All rights reserved.
//

#ifndef GeoPathBuilder_GPConstants_h
#define GeoPathBuilder_GPConstants_h

/*
 * Structs
*/
struct GPBounds {
    double west;
    double east;
    double north;
    double south;
};

/*
 *  GPX CONSTANTS
*/
#define kGPX_SCHEMA_VERSION     1.1

#define kGPXTAG_NAME            @"name"
#define kGPXTAG_DESCRIPTION     @"desc"
#define kGPXTAG_CREATOR         @"creator"
#define kGPXTAG_VERSION         @"version"
#define kGPXTAG_AUTHOR          @"author"
#define kGPXTAG_EMAIL           @"email"
#define kGPXTAG_URL             @"url"
#define kGPXTAG_URLNAME         @"urlname"
#define kGPXTAG_TIME            @"time"
#define kGPXTAG_KEYWORDS        @"keywords"
#define kGPXTAG_BOUNDS          @"bounds"

#define kGPXTAG_LATITUDE        @"lat"
#define kGPXTAG_LONGITUDE       @"lon"
#define kGPXTAG_ELEVATION       @"ele"
#define kGPXTAG_COURSE          @"course"
#define kGPXTAG_SPEED           @"speed"

#define kGPXTAG_COMMENT         @"cmt"
#define kGPXTAG_SOURCE          @"src"
#define kGPXTAG_SYMBOL          @"sym"
#define kGPXTAG_TYPE            @"type"

#define kGPXTAG_WAYPOINT        @"wpt"
#define kGPXTAG_ROUTE           @"rte"
#define kGPXTAG_ROUTEPT         @"rtept"

#endif
