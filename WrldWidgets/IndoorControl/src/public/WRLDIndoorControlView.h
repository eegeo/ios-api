#import <UIKit/UIKit.h>
@import Wrld;

@interface WRLDIndoorControlView : UIView <WRLDIndoorMapDelegate>

@property (nonatomic) IBOutlet WRLDMapView *mapView;

- (instancetype)initWithFrame:(CGRect)frame;

- (void) didEnterIndoorMap;
- (void) didExitIndoorMap;

@end
