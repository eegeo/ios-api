#import "WRLDSearchWidgetView.h"
#import "WRLDMapView.h"
#import "WRLDSearchProvider.h"
#import "WRLDSearchQuery.h"
#import "SearchProviders.h"
#import "WRLDSearchResultTableViewController.h"
#import "WRLDSearchSuggestionsViewController.h"
#import "WRLDSearchResultSet.h"


@interface WRLDSearchWidgetView()

@property (strong, nonatomic) IBOutlet UIView *wrldSearchWidgetRootView;
@property (weak, nonatomic) IBOutlet UIButton *wrldSearchWidgetMenuButton;
@property (unsafe_unretained, nonatomic) IBOutlet UISearchBar *wrldSearchWidgetSearchBar;
@property (weak, nonatomic) IBOutlet UIView *wrldSearchWidgetResultsTableViewContainer;
@property (weak, nonatomic) IBOutlet UITableView *wrldSearchWidgetResultsTableView;
@property (weak, nonatomic) IBOutlet UITableView *wrldSearchWidgetSuggestionsTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *resultsHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *suggestionsHeightConstraint;
@end

@implementation WRLDSearchWidgetView
{
    SearchProviders* m_searchProviders;
    WRLDSearchResultTableViewController* m_searchResultsTableViewController;
    WRLDSearchSuggestionsViewController* m_searchSuggestionsTableViewController;
    bool m_byPassSuggestions;
    NSString* m_suggestionsText;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self customInit];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        [self customInit];
    }
    
    return self;
}

-(void)customInit
{
    m_searchProviders = [[SearchProviders alloc] init];
    m_byPassSuggestions = false;
    m_suggestionsText = @"";
    
    NSBundle* widgetsBundle = [NSBundle bundleForClass:[WRLDSearchWidgetView class]];
    
    [widgetsBundle.self loadNibNamed:@"WRLDSearchWidgetView" owner:self options:nil];
    
    [self addSubview:self.wrldSearchWidgetRootView];
    self.wrldSearchWidgetRootView.frame = self.bounds;
    
    m_searchResultsTableViewController = [[WRLDSearchResultTableViewController alloc] init:
                                          self.wrldSearchWidgetResultsTableViewContainer :
                                          self.wrldSearchWidgetResultsTableView :
                                          m_searchProviders];
    
    [m_searchResultsTableViewController setHeightConstraint: self.resultsHeightConstraint];
    
    m_searchSuggestionsTableViewController = [[WRLDSearchSuggestionsViewController alloc] init :
                                              self.wrldSearchWidgetSuggestionsTableView :
                                              m_searchProviders :
                                               ^(NSString* queryText) {
                                                   [self searchForSuggestion: queryText];
                                               }];
    
    [m_searchSuggestionsTableViewController setHeightConstraint: self.suggestionsHeightConstraint];
    
    // assigns cancel button image in searchbar
//    UIImage *imgClear = [UIImage imageNamed:@"icon1_pin@3x.png" inBundle: widgetsBundle compatibleWithTraitCollection:nil];
//    [_wrldSearchWidgetSearchBar setImage:imgClear forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
}

-(void) addSearchProvider:(id<WRLDSearchProvider>)searchProvider
{
    [m_searchProviders addSearchProvider: searchProvider];
}

-(void)searchBar:(UISearchBar *)_searchBar textDidChange:(NSString *)searchText
{
    NSString *trimmedString = [searchText stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceCharacterSet]];
    
    if([trimmedString isEqualToString:m_suggestionsText]){
        return;
    }
    
    m_suggestionsText = trimmedString;
    
    if(!m_byPassSuggestions)
    {
        [m_searchResultsTableViewController fadeOut];
        
        if([searchText length] > 0)
        {
            WRLDSearchQuery * newQuery = [[WRLDSearchQuery alloc] initWithQueryString: trimmedString : m_searchProviders];
            [m_searchSuggestionsTableViewController setCurrentQuery:newQuery];
            [m_searchProviders doSuggestions: newQuery];
        }
        else{
            [m_searchSuggestionsTableViewController fadeOut];
        }
    }
}

-(void) searchForSuggestion: (NSString *) text{
    m_byPassSuggestions = true;
    [self.wrldSearchWidgetSearchBar setText:text];
    m_byPassSuggestions = false;
    [self runSearch: text];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self runSearch:[searchBar text]];
}

-(void) runSearch:(NSString *) queryString
{
    m_suggestionsText = queryString;
    [m_searchSuggestionsTableViewController fadeOut];
    WRLDSearchQuery * newQuery = [[WRLDSearchQuery alloc] initWithQueryString: queryString : m_searchProviders];
    
    [m_searchResultsTableViewController setCurrentQuery:newQuery];
    [m_searchProviders doSearch: newQuery];
}

-(void) registerCellForResultsTable: (NSString *) cellIdentifier : (UINib *) nib
{
    [self.wrldSearchWidgetResultsTableView registerNib:nib forCellReuseIdentifier: cellIdentifier];
}

@end

