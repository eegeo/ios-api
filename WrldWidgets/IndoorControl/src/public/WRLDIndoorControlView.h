#import <UIKit/UIKit.h>
@import Wrld;

@interface WRLDIndoorControlView : UIView

@property (weak, nonatomic) IBOutlet WRLDMapView *mapView;

- (instancetype)initWithFrame:(CGRect)frame;

- (void) didEnterIndoorMap;
- (void) didExitIndoorMap;

@end
