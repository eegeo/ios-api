#import "WRLDBlueSphere.h"
#import "WRLDMapView.h"
#import "WRLDMapView+Private.h"

#include "EegeoBlueSphereApi.h"
#include "LatLongAltitude.h"
#include "MathFunc.h"

@implementation WRLDBlueSphere
{
    Eegeo::Api::EegeoBlueSphereApi* m_pBlueSphereApi;
}

- (instancetype)initWithMapView:(WRLDMapView *)mapView
{
    m_pBlueSphereApi = &[mapView getMapApi].GetBlueSphereApi();
    
    if (self = [super init])
    {
        [self setCoordinate:CLLocationCoordinate2DMake(0.0, 0.0)];
        [self setHeading: 0.0];
        [self setIndoorMap:@"" withIndoorMapFloorId:0];
        [self setElevation:0.0];
    }

    return self;
}

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate
{
    _coordinate = coordinate;
    m_pBlueSphereApi->SetCoordinate(Eegeo::Space::LatLong::FromDegrees(_coordinate.latitude, _coordinate.longitude));
}

- (void)setElevation:(CLLocationDistance)elevation
{
    _elevation = elevation;
    m_pBlueSphereApi->SetElevation(_elevation);
}

- (void)setHeading:(CLLocationDirection)heading
{
    _heading = heading;
    m_pBlueSphereApi->SetHeadingRadians(static_cast<float>(Eegeo::Math::Deg2Rad(_heading)));
}

- (void)setIndoorFloorId:(NSInteger)indoorFloorId
{
    [self setIndoorMap:_indoorMapId withIndoorMapFloorId:indoorFloorId];
}

- (void)setIndoorMap:(NSString * _Nonnull)indoorMapId
withIndoorMapFloorId:(NSInteger)indoorMapFloorId
{
    _indoorMapId = indoorMapId;
    _indoorFloorId = indoorMapFloorId;
    m_pBlueSphereApi->SetIndoorMap([_indoorMapId UTF8String], static_cast<int>(_indoorFloorId));
}

- (void)setEnabled:(bool)enabled
{
    _enabled = enabled;
    m_pBlueSphereApi->SetEnabled(_enabled);
}

- (void)setAccuracyRingEnabled:(bool)accuracyRingEnabled
{
    _accuracyRingEnabled = accuracyRingEnabled;
    m_pBlueSphereApi->SetAccuracyRingEnabled(_accuracyRingEnabled);
}

-(void)setAccuracyInMeters:(float)accuracyInMeters
{
    _accuracyInMeters = accuracyInMeters;
    m_pBlueSphereApi->SetCurrentLocationAccuracy(accuracyInMeters);
}

- (void)setCoordinate:(CLLocationCoordinate2D)coordinate
            heading:(CLLocationDirection) heading
{
    [self setCoordinate:coordinate];
    [self setHeading:heading];
}

- (void)setShowOrientation:(bool)orientationVisible
{
    _showOrientation = orientationVisible;
    m_pBlueSphereApi->ShowOrientation(_showOrientation);
}


@end
