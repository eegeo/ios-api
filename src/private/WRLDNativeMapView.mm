#import "WRLDNativeMapView.h"
#import "WRLDMapView+Private.h"

#include "EegeoMapApi.h"
#include "EegeoMarkersApi.h"
#include "EegeoIndoorsApi.h"
#include "EegeoApiHostModule.h"
#include "EegeoPoiApi.h"
#include "EegeoRoutingApi.h"
#include "iOSApiRunner.h"



WRLDNativeMapView::WRLDNativeMapView(WRLDMapView* mapView, Eegeo::ApiHost::iOS::iOSApiRunner& apiRunner)
: m_mapView(mapView)
, m_apiRunner(apiRunner)
, m_cameraHandler(this, &WRLDNativeMapView::OnCameraChange)
, m_initialStreamingCompleteHandler(this, &WRLDNativeMapView::OnInitialStreamingComplete)
, m_markerTappedHandler(this, &WRLDNativeMapView::OnMarkerTapped)
, m_positionersProjectionChangedHandler(this, &WRLDNativeMapView::OnPositionerProjectionChanged)
, m_enteredIndoorMapHandler(this, &WRLDNativeMapView::OnEnteredIndoorMap)
, m_exitedIndoorMapHandler(this, &WRLDNativeMapView::OnExitedIndoorMap)
, m_poiSearchCompletedHandler(this, &WRLDNativeMapView::OnPoiSearchCompleted)
, m_routingQueryCompletedHandler(this, &WRLDNativeMapView::OnRoutingQueryCompleted)
{
    Eegeo::Api::EegeoMapApi& mapApi = GetMapApi();
    
    mapApi.GetCameraApi().RegisterEventCallback(m_cameraHandler);
    mapApi.RegisterInitialStreamingCompleteCallback(m_initialStreamingCompleteHandler);
    mapApi.GetMarkersApi().RegisterMarkerPickedCallback(m_markerTappedHandler);
    mapApi.GetPositionerApi().RegisterProjectionChangedCallback(m_positionersProjectionChangedHandler);
    mapApi.GetIndoorsApi().RegisterIndoorMapEnteredCallback(m_enteredIndoorMapHandler);
    mapApi.GetIndoorsApi().RegisterIndoorMapExitedCallback(m_exitedIndoorMapHandler);
    mapApi.GetPoiApi().RegisterSearchCompletedCallback(m_poiSearchCompletedHandler);
    mapApi.GetRoutingApi().RegisterQueryCompletedCallback(m_routingQueryCompletedHandler);
}

WRLDNativeMapView::~WRLDNativeMapView()
{
    Eegeo::Api::EegeoMapApi& mapApi = GetMapApi();
    
    mapApi.GetRoutingApi().UnregisterQueryCompletedCallback(m_routingQueryCompletedHandler);
    mapApi.GetPoiApi().UnregisterSearchCompletedCallback(m_poiSearchCompletedHandler);
    mapApi.GetIndoorsApi().UnregisterIndoorMapExitedCallback(m_exitedIndoorMapHandler);
    mapApi.GetIndoorsApi().UnregisterIndoorMapEnteredCallback(m_enteredIndoorMapHandler);
    mapApi.GetPositionerApi().UnregisterProjectionChangedCallback(m_positionersProjectionChangedHandler);
    mapApi.GetMarkersApi().UnregisterMarkerPickedCallback(m_markerTappedHandler);
    mapApi.UnregisterInitialStreamingCompleteCallback(m_initialStreamingCompleteHandler);
    mapApi.GetCameraApi().UnregisterEventCallback(m_cameraHandler);
}

void WRLDNativeMapView::OnCameraChange(const Eegeo::Api::CameraEventType& type)
{
    switch (type)
    {
        case Eegeo::Api::CameraEventType::MoveStart:
        {
            [m_mapView notifyMapViewRegionWillChange];
            break;
        }
        
        case Eegeo::Api::CameraEventType::Move:
        {
            [m_mapView notifyMapViewRegionIsChanging];
            break;
        }
        
        case Eegeo::Api::CameraEventType::MoveEnd:
        {
            [m_mapView notifyMapViewRegionDidChange];
            break;
        }
        
        default:
            break;
    }
}

void WRLDNativeMapView::OnInitialStreamingComplete()
{
    [m_mapView notifyInitialStreamingCompleted];
}

void WRLDNativeMapView::OnMarkerTapped(const Eegeo::Markers::IMarker& marker)
{
    [m_mapView notifyMarkerTapped:marker.GetId()];
}

void WRLDNativeMapView::OnPositionerProjectionChanged()
{
    [m_mapView notifyPositionerProjectionChanged];
}

void WRLDNativeMapView::OnEnteredIndoorMap()
{
    [m_mapView notifyEnteredIndoorMap];
}

void WRLDNativeMapView::OnExitedIndoorMap()
{
    [m_mapView notifyExitedIndoorMap];
}

void WRLDNativeMapView::OnPoiSearchCompleted(const Eegeo::PoiSearch::PoiSearchResults& poiSearchResults)
{
    [m_mapView notifyPoiSearchCompleted:poiSearchResults];
}

void WRLDNativeMapView::OnRoutingQueryCompleted(const Eegeo::Routes::Webservice::RoutingQueryResponse& routingQueryResponse)
{
    [m_mapView notifyRoutingQueryCompleted:routingQueryResponse];
}

Eegeo::Api::EegeoMapApi& WRLDNativeMapView::GetMapApi()
{
    return m_apiRunner.GetEegeoApiHostModule()->GetEegeoMapApi();
}

