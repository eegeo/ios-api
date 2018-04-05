#pragma once

#import <UIKit/UIKit.h>

@class WRLDSearchQuery;
@protocol WRLDSearchRequestFulfillerHandle;
@class WRLDSearchResultSelectedObserver;
@class WRLDSearchWidgetResultSetViewModel;
@class WRLDSearchResultTableViewCell;

typedef void (^SearchResultsSourceEvent) (void);

@interface WRLDSearchWidgetResultsTableDataSource : NSObject<UITableViewDataSource>

- (instancetype) initWithDefaultCellIdentifier: (NSString *) defaultCellIdentifier;

@property (nonatomic, readonly) WRLDSearchResultSelectedObserver * selectionObserver;
@property (nonatomic, readonly) NSString* defaultCellIdentifier;
@property (nonatomic, readonly) NSString* moreResultsCellIdentifier;
@property (nonatomic, readonly) BOOL isAwaitingData;
@property (nonatomic, readonly) NSInteger providerCount;
@property (nonatomic, readonly) NSInteger * visibleResults;

- (void) updateResultsFrom: (WRLDSearchQuery *) query;
- (void) clearResults;
- (NSString*) getDisplayedQueryText;

- (void) selected : (NSIndexPath *) index;
- (void) expandSection: (NSInteger) expandedSectionPosition;
- (void) collapseAllSections;
- (void) populateCell: (WRLDSearchResultTableViewCell *)cell withDataFor:(NSIndexPath *)indexPath;

- (NSString *) getIdentifierForCellAtPosition:(NSIndexPath *) index;
- (WRLDSearchWidgetResultSetViewModel *) getViewModelForProviderAt: (NSInteger) section;

- (void) displayResultsFrom: (id<WRLDSearchRequestFulfillerHandle>) provider
     maxToShowWhenCollapsed: (NSInteger) maxToShowWhenCollapsed
      maxToShowWhenExpanded: (NSInteger) maxToShowWhenExpanded;

- (void) stopDisplayingResultsFrom: (id<WRLDSearchRequestFulfillerHandle>) provider;

- (void) addResultsSectionExpandedEvent: (SearchResultsSourceEvent)event;
- (void) removeResultsSectionExpandedEvent: (SearchResultsSourceEvent)event;
- (void) addResultsSectionsCollapsedEvent: (SearchResultsSourceEvent)event;
- (void) removeResultsSectionsCollapsedEvent: (SearchResultsSourceEvent)event;

- (NSInteger) getTotalResultCount;
@end


