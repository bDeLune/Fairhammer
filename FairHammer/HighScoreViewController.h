//

#import <UIKit/UIKit.h>
#import "Session.h"
#define NEW_HIGH_SCORE_NOTIFICATION  @"com.rocudo.newHighscore"

@interface HighScoreViewController : UIViewController
@property(nonatomic,strong)IBOutlet  UILabel  *durationValueLabel;
@property(nonatomic,strong)IBOutlet  UILabel  *strengthValueLabel;
@property(nonatomic,strong)IBOutlet  UIButton  *resetButton;
-(IBAction)reset:(id)sender;
-(void)updateWithCurrentSession:(Session*)session;
-(void)setup;
-(void)setStrengthLabel:(NSString*)val;
-(void)setDurationLabel:(NSString*)val;
@end
