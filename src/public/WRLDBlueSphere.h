#pragma once

#import <CoreGraphics/CoreGraphics.h>
#import <CoreLocation/CoreLocation.h>
#import "WRLDElevationMode.h"

NS_ASSUME_NONNULL_BEGIN

/// A Blue Sphere is a model that is used to visualize a user on a map.
/// The blue sphere can change location and rotate and can also be place in indoor maps.
@interface WRLDBlueSphere : NSObject

/// The location of the blue sphere.
@property (nonatomic) CLLocationCoordinate2D coordinate;

/// The heading the blue sphere is facing in degrees from north.
@property (nonatomic) CLLocationDirection heading;

/// The ID of the indoor map the blue sphere is associated with - if any.
@property (nonatomic, readonly, copy) NSString* indoorMapId;

/// The index of the floor the blue sphere is associated with - if any.
@property (nonatomic) NSInteger indoorFloorId;

/// For outdoor maps, the height above ground of the sphere model's center, in meters.
/// For indoor maps, the height above the floor of the base of the leader-line, in meters.
@property (nonatomic) CLLocationDistance elevation;

/// The property that determines if the blue sphere should be displayed and assets loaded.
@property (nonatomic) bool enabled;

/// The property that determines if the accracy ring should be displayed.
@property (nonatomic) bool accuracyRingEnabled;

/// The property that determines radius of accuracy ring in meters.
@property (nonatomic) float accuracyInMeters;

/*!
 Place the blue sphere inside an indoor map on a specific floor.
 @param indoorMapId The ID of an indoor map the bue sphere should be inside. (See WRLDIndoorMap).
 @param indoorMapFloorId An index specifying which floor of the indoor map the blue sphere should be on. (See WRLDIndoorMap).
*/
- (void)setIndoorMap:(NSString * _Nonnull)indoorMapId
withIndoorMapFloorId:(NSInteger)indoorMapFloorId;

/*!
 Set the location of the blue sphere and the heading it is facing.
 @param coordinate The location of the blue sphere.
 @param heading The heading the blue sphere is facing in degrees from north.
*/
- (void)setCoordinate:(CLLocationCoordinate2D)coordinate
            heading:(CLLocationDirection) heading;


/// The property that determines if the blue sphere should display orientation information.
@property (nonatomic) bool showOrientation;


@end

NS_ASSUME_NONNULL_END
