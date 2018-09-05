
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
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"VIEWFORHEADERINSECTION ABOUT TO APPEAR");
    [super viewDidLoad];
    maxStrength=100;
    _strenthProgress.progress=0;
    self.view.backgroundColor=[UIColor clearColor];
    // Do any additional setup after loading the view from its nib.
    NSLog(@"VIEWFORHEADERINSECTION ABOUT TO FINISH");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

    NSLog(@"displaying strenght score %d", (int)pStrength);
    
    [_strengthValueLabel setText:[NSString stringWithFormat:@"%0.0d", (int)pStrength]];
}
@end
