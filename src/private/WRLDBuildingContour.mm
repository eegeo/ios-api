#import "WRLDBuildingContour.h"
#import "WRLDBuildingContour+Private.h"

@interface WRLDBuildingContour ()

@end

@implementation WRLDBuildingContour
{
    std::vector<CLLocationCoordinate2D> m_points;
}

- (instancetype) initWithBottomAltitude:(CLLocationDistance)bottomAltitude
                           topAltitude:(CLLocationDistance)topAltitude
                                points:(std::vector<CLLocationCoordinate2D>)points
{
    if (self = [super init])
    {
        m_points = points;

        _bottomAltitude = bottomAltitude;
        _topAltitude = topAltitude;
        _pointCount = (NSUInteger) m_points.size();
    }

    return self;
}

- (void)getPoints:(CLLocationCoordinate2D *)coordinates
{
    for (NSUInteger i=0; i<_pointCount; i++)
    {
        coordinates[i] = m_points[i];
    }
}

@end
