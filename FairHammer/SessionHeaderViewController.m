//
//  SessionHeaderViewController.m
//  FairHammer
//
//  Created by barry on 12/09/2013.
//  Copyright (c) 2013 barry. All rights reserved.
//

#import "SessionHeaderViewController.h"

@interface SessionHeaderViewController ()

@end

@implementation SessionHeaderViewController

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
    // Do any additional setup after loading the view from its nib.
     [self.addNoteButton setBackgroundImage:nil forState:UIControlStateNormal];
    [self.addNoteButton setTitle:@"Note" forState:UIControlStateNormal];
    [UIButton buttonWithType:UIButtonTypeSystem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)addNote:(id)sender
{

}
@end
