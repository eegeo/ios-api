#import "WRLDRouteStep.h"
#import "WRLDRouteStep+Private.h"

@interface WRLDRouteStep ()

@end

@implementation WRLDRouteStep
{
    CLLocationCoordinate2D* m_path;
    int m_pathCount;
    WRLDRouteDirections* m_directions;
    WRLDRouteTransportationMode m_mode;
    BOOL m_isIndoors;
    NSString* m_indoorId;
    int m_indoorFloorId;
    NSTimeInterval m_duration;
    double m_distance;
}

- (instancetype)initWithPath:(CLLocationCoordinate2D*)path
                   pathCount:(int)pathCount
                  directions:(WRLDRouteDirections*)directions
                        mode:(WRLDRouteTransportationMode)mode
                   isIndoors:(BOOL)isIndoors
                    indoorId:(NSString*)indoorId
               indoorFloorId:(int)indoorFloorId
                    duration:(NSTimeInterval)duration
                    distance:(double)distance
{
    if (self = [super init])
    {
        m_path = path;
        m_pathCount = pathCount;
        m_directions = directions;
        m_mode = mode;
        m_isIndoors = isIndoors;
        m_indoorId = indoorId;
        m_indoorFloorId = indoorFloorId;
        m_duration = duration;
        m_distance = distance;
    }

    return self;
}

- (CLLocationCoordinate2D*) path
{
    return m_path;
}

- (int) pathCount
{
    return m_pathCount;
}

- (WRLDRouteDirections*) directions
{
    return m_directions;
}

- (WRLDRouteTransportationMode) mode
{
    return m_mode;
}

- (BOOL) isIndoors
{
    return m_isIndoors;
}

- (NSString*) indoorId
{
    return m_indoorId;
}

- (int) indoorFloorId
{
    return m_indoorFloorId;
}

- (NSTimeInterval) duration
{
    return m_duration;
}

- (double) distance
{
    return m_distance;
}

@end
