//
//  LogoViewController.m
//  FairHammer
//
//  Created by barry on 15/07/2013.
//  Copyright (c) 2013 barry. All rights reserved.
//

#import "LogoViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface LogoViewController ()

@end

@implementation LogoViewController

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
    self.view.backgroundColor=[UIColor clearColor];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)startAnimating
{
    _full.alpha=0.0;

    
    [UIView animateWithDuration:0.8 delay:0.0 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse animations:^{
        //
        _top.alpha=0.0;
           } completion:NULL];
    
    [UIView animateWithDuration:0.8 delay:0.4 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse animations:^{
        //
        _middle.alpha=0.0;
    } completion:NULL];
    
    [UIView animateWithDuration:0.8 delay:0.8 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse animations:^{
        //
        _bottom.alpha=0.0;
    } completion:NULL];
}
-(void)stopAnimating
{
    [_top.layer removeAllAnimations];
    [_middle.layer removeAllAnimations];
    [_bottom.layer removeAllAnimations];

    _top.alpha=1.0;
    _middle.alpha=1.0;
    _bottom.alpha=1.0;
    _full.alpha=1.0;

}
@end
