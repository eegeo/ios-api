#pragma once

#import "WRLDMapView.h"

#include "Types.h"
#include "EegeoApiHostDeclarations.h"
#include "EegeoApi.h"
#include "ICallback.h"
#include "IMarker.h"
#include "EegeoCameraApi.h"
#include "EegeoPositionerApi.h"
#include "EegeoPoiApi.h"

class WRLDNativeMapView : private Eegeo::NonCopyable
{
public:
    WRLDNativeMapView(WRLDMapView* mapView, Eegeo::ApiHost::iOS::iOSApiRunner& apiRunner);
    
    virtual ~WRLDNativeMapView();
    
private:
    
    void OnCameraChange(const Eegeo::Api::CameraEventType& type);
    void OnInitialStreamingComplete();
    void OnMarkerTapped(const Eegeo::Markers::IMarker& marker);
    void OnPositionerProjectionChanged();
    void OnEnteredIndoorMap();
    void OnExitedIndoorMap();
    void OnPoiSearchCompleted(const Eegeo::PoiSearch::PoiSearchResults& poiSearchResults);
    void OnRoutingQueryCompleted(const Eegeo::Routes::Webservice::RoutingQueryResponse& routingQueryResponse);
    
    Eegeo::Api::EegeoMapApi& GetMapApi();
    
    __weak WRLDMapView* m_mapView;
    Eegeo::ApiHost::iOS::iOSApiRunner& m_apiRunner;
    
    
    Eegeo::Helpers::TCallback1<WRLDNativeMapView, const Eegeo::Api::CameraEventType> m_cameraHandler;
    
    Eegeo::Helpers::TCallback0<WRLDNativeMapView> m_initialStreamingCompleteHandler;
    
    Eegeo::Helpers::TCallback1<WRLDNativeMapView, const Eegeo::Markers::IMarker> m_markerTappedHandler;

    Eegeo::Helpers::TCallback0<WRLDNativeMapView> m_positionersProjectionChangedHandler;
    
    Eegeo::Helpers::TCallback0<WRLDNativeMapView> m_enteredIndoorMapHandler;
    
    Eegeo::Helpers::TCallback0<WRLDNativeMapView> m_exitedIndoorMapHandler;
    
    Eegeo::Helpers::TCallback1<WRLDNativeMapView, const Eegeo::PoiSearch::PoiSearchResults> m_poiSearchCompletedHandler;

    Eegeo::Helpers::TCallback1<WRLDNativeMapView, const Eegeo::Routes::Webservice::RoutingQueryResponse> m_routingQueryCompletedHandler;
};


