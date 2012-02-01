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
typedef struct {
    double west;
    double east;
    double north;
    double south;
} GPBounds;

/*
 *  GPX CONSTANTS
*/

#define kGPX_SCHEMA_VERSION     @"1.1"

#define kGPXTAG_MASTER          @"gpx"

#define kGPX_SCHEMA_LOC_ATTR    @"xsi:schemaLocation"
#define kGPX_SCHEMA_LOC_VAL     @"http://www.topografix.com/GPX/1/0 http://www.topografix.com/GPX/1/0/gpx.xsd"
#define kGPX_XSI_ATTR           @"xmlns:xsi"
#define kGPX_XSI_VAL            @"http://www.w3.org/2001/XMLSchema-instance"
#define kGPX_XMLNS_ATTR         @"xmlns:"
#define kGPX_XMLNS_VAL          @"http://www.topografix.com/GPX/1/0"

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
#define kGPXTAG_NUMBER          @"number"

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
#define kGPXTAG_TRACK           @"trk"
#define kGPXTAG_TRACKSEG        @"trkseg"
#define kGPXTAG_TRACKPT         @"trkpt"

#endif
