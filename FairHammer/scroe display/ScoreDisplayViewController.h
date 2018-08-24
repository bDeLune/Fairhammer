
#import <UIKit/UIKit.h>

@interface ScoreDisplayViewController : UIViewController
@property(nonatomic,strong)IBOutlet  UILabel * durationValueLabel;
@property(nonatomic,strong)IBOutlet  UILabel * strengthValueLabel;
@property(nonatomic,strong)IBOutlet  UIProgressView *durationProgress;
@property(nonatomic,strong)IBOutlet  UIProgressView *strenthProgress;

-(void)setDuration:(float)pDuration;
-(void)setStrength:(float)pStrength;

@end
