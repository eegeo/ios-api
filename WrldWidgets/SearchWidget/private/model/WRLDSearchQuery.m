#import <Foundation/Foundation.h>
#import "WRLDSearchQuery.h"
#import "WRLDSearchQuery+Private.h"
#import "WRLDSearchRequest.h"
#import "WRLDSearchRequest+Private.h"
#import "WRLDSearchProviderHandle.h"
#import "WRLDSuggestionProviderHandle.h"
#import "WRLDSearchProvider.h"
#import "WRLDSuggestionProvider.h"
#import "WRLDSearchModelQueryDelegate.h"

@implementation WRLDSearchQuery
{
    WRLDFulfillerResultsDictionary* m_fulfillerResultsDictionary;
    NSMutableArray<WRLDSearchRequest *>* m_requests;
    WRLDSearchModelQueryDelegate* m_queryDelegate;
}

-(instancetype) initWithQueryString:(NSString*) queryString queryDelegate:(WRLDSearchModelQueryDelegate *) queryDelegate
{
    self = [super init];
    if(self)
    {
        _queryString = queryString;
        m_requests =[[NSMutableArray<WRLDSearchRequest *> alloc ]  init];
        m_queryDelegate = queryDelegate;
        m_fulfillerResultsDictionary = [[WRLDFulfillerResultsDictionary alloc] init];
    }
    return self;
}

-(void) cancel
{
    _progress = Cancelled;
    _hasCompleted = YES;
    _hasSucceeded = NO;
}

-(BOOL) isFinished
{
    return (self.progress == Cancelled || self.progress == Completed);
}

-(void) didComplete:(BOOL) success
{
    _progress = Completed;
    _hasCompleted = YES;
    _hasSucceeded = success;
    
    if(m_queryDelegate)
    {
        [m_queryDelegate didComplete:self];
    }
}

-(WRLDSearchResultsCollection *) getResultsForFulfiller:(id<WRLDQueryFulfillerHandle>) fulfillerHandle
{
    return nil;
}

-(void) completeWithNoProviders
{
    [self didComplete :YES];
}

-(void) dispatchRequestsToSearchProviders:(WRLDSearchProviderCollection *) providerHandles
{
    [m_queryDelegate willSearchFor: self];
    if([providerHandles count] == 0)
    {
        [self completeWithNoProviders];
        return;
    }
    for(WRLDSearchProviderHandle* handle in providerHandles)
    {
        WRLDSearchRequest *searchRequest = [self createRequestForFulfiller: handle];
        [m_requests addObject:searchRequest];
        [handle.provider searchFor: searchRequest];
    }
}

-(void) dispatchRequestsToSuggestionProviders:(WRLDSuggestionProviderCollection *) providerHandles
{
    [m_queryDelegate willSearchFor: self];
    if([providerHandles count] == 0)
    {
        [self completeWithNoProviders];
        return;
    }
    
    for(WRLDSuggestionProviderHandle* handle in providerHandles)
    {
        WRLDSearchRequest *searchRequest = [self createRequestForFulfiller: handle];
        [m_requests addObject:searchRequest];
        [handle.provider getSuggestions: searchRequest];
    }
}

-(WRLDSearchRequest *) createRequestForFulfiller: (id<WRLDQueryFulfillerHandle>) handle
{
    return [[WRLDSearchRequest alloc] initWithFulfillerHandle: handle
                                                                                        forQuery:self];
}

-(void) addResults: (WRLDSearchResultsCollection *) results fromFulfiller:(id<WRLDQueryFulfillerHandle>) fulfillerHandle withSuccess:(BOOL) success
{
    NSNumber *key = [[NSNumber alloc] initWithInt:fulfillerHandle.identifier];
    //TODO Find import spell for EEGEO_ASSERT
    //EEGEO_ASSERT([m_fulfillerResultsDictionary objectForKey:key] == nil, @"Cannot add multiple result sets from the same provider to a combined query");
    
    [m_fulfillerResultsDictionary setObject: results forKey: key];
    [self checkForCompletion];
}

- (void) checkForCompletion
{
    for(WRLDSearchRequest * request in m_requests)
    {
        if(!request.hasCompleted)
        {
            return;
        }
    }
    [self didComplete:YES];
}

- (WRLDSearchResultsCollection *) getResultsFromFulfiller:(id<WRLDQueryFulfillerHandle>)fulfillerHandle
{
    NSNumber *key = [[NSNumber alloc] initWithInt:fulfillerHandle.identifier];
    return [m_fulfillerResultsDictionary objectForKey:key];
}

@end
