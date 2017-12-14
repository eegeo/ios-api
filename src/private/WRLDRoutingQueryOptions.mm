
#import "WRLDRoutingQueryOptions.h"
#import "WRLDRoutingQueryWaypoint.h"
#import "WRLDRoutingQueryWaypoint+Private.h"

@interface WRLDRoutingQueryOptions ()

@end

@implementation WRLDRoutingQueryOptions
{
    NSMutableArray* m_waypoints;
}

- (instancetype)init {
    self = [super init];
    if (self)
    {
        m_waypoints = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addWaypoint:(CLLocationCoordinate2D)latLng
{
    WRLDRoutingQueryWaypoint* routingQueryWaypoint = [[WRLDRoutingQueryWaypoint alloc] initWithLatLng:latLng
                                                                                            isIndoors:false
                                                                                        indoorFloorId:0];
    [m_waypoints addObject:routingQueryWaypoint];
}

- (void)addIndoorWaypoint:(CLLocationCoordinate2D)latLng forIndoorFloor:(int)indoorFloorId
{
    WRLDRoutingQueryWaypoint* routingQueryWaypoint = [[WRLDRoutingQueryWaypoint alloc] initWithLatLng:latLng
                                                                                            isIndoors:true
                                                                                        indoorFloorId:indoorFloorId];
    [m_waypoints addObject:routingQueryWaypoint];
}

- (NSMutableArray*)getWaypoints
{
    return m_waypoints;
}

@end

