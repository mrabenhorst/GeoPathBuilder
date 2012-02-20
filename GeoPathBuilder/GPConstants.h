//
//  GPConstants.h
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


typedef enum {
    keGPX_MASTER,
    keGPX_WAYPOINT,
    keGPX_ROUTE,
    keGPX_ROUTEPT,
    keGPX_TRACK,
    keGPX_TRACKSEG,
    keGPX_TRACKPT,
    
    keGPX_SCHEMA_VERSION,
    keGPX_SCHEMA_LOC_ATTR,
    keGPX_SCHEMA_LOC_VAL,
    keGPX_XSI_ATTR,
    keGPX_XSI_VAL,
    keGPX_XMLNS_ATTR,
    keGPX_XMLNS_VAL,
    keGPX_MINLAT,
    keGPX_MAXLAT,
    keGPX_MINLON,
    keGPX_MAXLON,
    
    keGPX_NAME,
    keGPX_DESCRIPTION,
    keGPX_CREATOR,
    keGPX_VERSION,
    keGPX_AUTHOR,
    keGPX_EMAIL,
    keGPX_URL,
    keGPX_URLNAME,
    keGPX_TIME,
    keGPX_KEYWORDS,
    keGPX_BOUNDS,
    keGPX_NUMBER,
    keGPX_LATITUDE,
    keGPX_LONGITUDE,
    keGPX_ELEVATION,
    keGPX_COURSE,
    keGPX_SPEED,
    keGPX_COMMENT,
    keGPX_SOURCE,
    keGPX_SYMBOL,
    keGPX_TYPE
} GPXTag;

typedef enum {
    keGPX_OBJECT,
    keGPX_PROPERTY,
    keGPX_ATTRIBUTE
} GPXElementType;

/*
 *  GPX CONSTANTS
*/

/*
 * Objects
*/
#define kGPXTAG_MASTER          @"gpx"
#define kGPXTAG_WAYPOINT        @"wpt"
#define kGPXTAG_ROUTE           @"rte"
#define kGPXTAG_ROUTEPT         @"rtept"
#define kGPXTAG_TRACK           @"trk"
#define kGPXTAG_TRACKSEG        @"trkseg"
#define kGPXTAG_TRACKPT         @"trkpt"

/*
 * Attributes
 */
#define kGPX_SCHEMA_VERSION     @"1.1"
#define kGPX_SCHEMA_LOC_ATTR    @"xsi:schemaLocation"
#define kGPX_SCHEMA_LOC_VAL     @"http://www.topografix.com/GPX/1/0 http://www.topografix.com/GPX/1/0/gpx.xsd"
#define kGPX_XSI_ATTR           @"xmlns:xsi"
#define kGPX_XSI_VAL            @"http://www.w3.org/2001/XMLSchema-instance"
#define kGPX_XMLNS_ATTR         @"xmlns"
#define kGPX_XMLNS_VAL          @"http://www.topografix.com/GPX/1/0"
#define kGPX_MINLAT             @"minlat"
#define kGPX_MAXLAT             @"maxlat"
#define kGPX_MINLON             @"minlon"
#define kGPX_MAXLON             @"maxlon"

/*
 * Properties
 */
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



#endif
