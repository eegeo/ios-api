#pragma once

#import <CoreLocation/CoreLocation.h>

#import "WRLDElevationMode.h"

#import "WRLDOverlay.h"

NS_ASSUME_NONNULL_BEGIN

/// A Polygon is a shape consisting of three or more vertices and is placed on or above the map.
/// Optionally polygons can contain one or more interior polygons which define cutout regions in the polygon.
/// Their color can also be modified.
@interface WRLDPolygon : NSObject<WRLDOverlay>

/*!
 Instantiate a polygon with coordinates.
 @param coords The array of coordinates that define the polygon. The data in this
 array is copied to the new object.
 @param count The number of items in the coordinates array.
 @returns A WRLDPolygon instance.
 */
+ (instancetype)polygonWithCoordinates:(CLLocationCoordinate2D *)coords
                                 count:(NSUInteger)count;

/*!
 Instantiate a polygon with coordinates.
 @param coords The array of coordinates that define the perimeter of the polygon.
 @param count The number of items in the coordinates array.
 @param interiorPolygons An array of WRLDPolygon objects that define cutout regions in the polygon.
 @returns A WRLDPolygon instance.
 */
+ (instancetype)polygonWithCoordinates:(CLLocationCoordinate2D *)coords
                                 count:(NSUInteger)count
                      interiorPolygons:(NSArray <WRLDPolygon *> *)interiorPolygons;

/*!
 Instantiate a polygon with coordinates.
 @param coords The array of coordinates that define the polygon. The data in this
 array is copied to the new object.
 @param count The number of items in the coordinates array.
 @param indoorMapId The id of the indoor map on which the polygon will be displayed.
 @param floorId The id of the indoor map floor on which the polygon will be displayed.
 @returns A WRLDPolygon instance.
 */
+ (instancetype)polygonWithCoordinates:(CLLocationCoordinate2D *)coords
                                 count:(NSUInteger)count
                           onIndoorMap:(NSString *)indoorMapId
                               onFloor:(NSInteger)floorId;

/*!
 Instantiate a polygon with coordinates.
 @param coords The array of coordinates that define the exterior polygon. The data 
 in this array is copied to the new object.
 @param count The number of items in the exterior coordinates array.
 @param interiorPolygons An array of WRLDPolygon objects that define cutout regions in the polygon
 @param indoorMapId The id of the indoor map on which the polygon will be displayed.
 @param floorId The id of the indoor map floor on which the polygon will be displayed.
 @returns A WRLDPolygon instance.
 */
+ (instancetype)polygonWithCoordinates:(CLLocationCoordinate2D *)coords
                              count:(NSUInteger)count
                   interiorPolygons:(NSArray <WRLDPolygon *> *)interiorPolygons
                        onIndoorMap:(NSString *)indoorMapId
                               onFloor:(NSInteger)floorId;


/// The color of the polygon.
@property (nonatomic, copy) UIColor* color;

/// The height of the polygon above either the ground, or sea-level, depending on the elevationMode property.
@property (nonatomic) CLLocationDistance elevation;

/*!
 Specifies how the elevation property of this polygon is interpreted:
 
 - `WRLDElevationModeHeightAboveSeaLevel`: The elevation is an absolute altitude above mean sea level, in meters.
 - `WRLDElevationModeHeightAboveGround`: The elevation is a height relative to the map's terrain, in meters.
 */
@property (nonatomic) WRLDElevationMode elevationMode;


/// For a polygon to be displayed on an indoor map, the id of the indoor map (else nil).
@property (nonatomic, copy) NSString* indoorMapId;

/// For an indoor map polygon, the floor id of the floor on which the polygon will be displayed
@property (nonatomic) NSInteger indoorFloorId;

@end

NS_ASSUME_NONNULL_END
