// Copyright eeGeo Ltd (2012-2017), All Rights Reserved

#import <Foundation/Foundation.h>


#import "WRLDPoiSearchResult.h"
#import "WRLDPoiSearchResponse.h"
#import "POIServiceSuggestionProvider.h"
#import "POIServiceSuggestionProvider+Private.h"



#import "SuggestionProvider.h"
#import "SearchResultSet.h"
#import "OnResultsRecievedCallback.h"

@implementation POIServiceSuggestionProvider
{
    WRLDPoiService* m_poiService;
    WRLDMapView* m_mapView;
    
    OnResultsRecievedCallback* m_resultsReceivedCallback;
    SearchResultViewFactory* m_searchResultViewFactory;
}

- (instancetype)initWithMapViewAndPoiService:(WRLDMapView*)mapView poiService: (WRLDPoiService*)poiService
{
    if (self = [super init])
    {
        m_mapView = mapView;
        m_poiService = poiService;
        
        m_mapView.delegate = self;
    }
    
    return self;
}

-(void)mapView:(WRLDMapView *)mapView poiSearchDidComplete:(int)poiSearchId poiSearchResponse:(WRLDPoiSearchResponse *)poiSearchResponse
{
    // Unpack search results, fill structures up
    SearchResultSet* searchResultSet;

    for(WRLDPoiSearchResult *poiSearchResult in [poiSearchResponse results])
    {
        SearchResult* searchResult = [[SearchResult alloc] init];
        
        // Set title
        [searchResult setTitle: [poiSearchResult title]];
        
        // todo - Set other properties
        
        // Add to result set
        [searchResultSet addResult: searchResult];
    }
    
    // Invoke callback
    if(m_resultsReceivedCallback != nil)
    {
        [m_resultsReceivedCallback onResultsRecieved: [searchResultSet getAllResults]];
    }
}

-(void)getSuggestions: (NSString*) query
{
    [self getSearchResults: query];
}

- (SearchResultViewFactory*)getSuggestionViewFactory
{
    return [self getResultViewFactory];
}

- (void)addOnSuggestionsRecievedCallback:(OnResultsRecievedCallback *)resultsReceivedCallback
{
    [self addOnResultsRecievedCallback: resultsReceivedCallback];
}

- (void)setSuggestionViewFactory:(SearchResultViewFactory *)searchResultFactory
{
    [self setResultViewFactory: searchResultFactory];
}

- (void)getSearchResults:(NSString *)query
{
    WRLDAutocompleteOptions* autocompleteOptions = [[WRLDAutocompleteOptions alloc] init];
    [autocompleteOptions setQuery: query];
    [autocompleteOptions setCenter:  [m_mapView centerCoordinate]];
    [m_poiService searchAutocomplete: autocompleteOptions];
}

- (void)addOnResultsRecievedCallback:(OnResultsRecievedCallback*)resultsReceivedCallback
{
    m_resultsReceivedCallback = resultsReceivedCallback;
}

- (SearchResultViewFactory *)getResultViewFactory
{
    return m_searchResultViewFactory;
}


- (void)setResultViewFactory:(SearchResultViewFactory *)viewFactory
{
    m_searchResultViewFactory = viewFactory;
}


@synthesize title;

@end

