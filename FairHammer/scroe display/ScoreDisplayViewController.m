//
//  ScoreDisplayViewController.m
//  FairHammer
//
//  Created by barry on 11/07/2013.
//  Copyright (c) 2013 barry. All rights reserved.
//

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
    [super viewDidLoad];
    maxStrength=30;
    _strenthProgress.progress=0;
    // Do any additional setup after loading the view from its nib.
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
    
        [_strengthValueLabel setText:[NSString stringWithFormat:@"%0.0f",pStrength]];
    

}
@end
