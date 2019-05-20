#import "ScoreDisplayViewController.h"

@interface ScoreDisplayViewController ()
{
    float maxStrength;
}

@end

@implementation ScoreDisplayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    maxStrength=130;
    _strenthProgress.progress=0;
    self.view.backgroundColor=[UIColor clearColor];
}

-(void)setDuration:(float)pDuration
{
}

-(void)setStrength:(float)pStrength
{
    if (pStrength>maxStrength) {
        pStrength=maxStrength;
    }
    float pct=pStrength/maxStrength;
    _strenthProgress.progress=pct;
    [_strengthValueLabel setText:[NSString stringWithFormat:@"%0.0f",pStrength]];
}
@end
