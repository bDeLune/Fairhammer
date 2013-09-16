//
//  SessionNoteViewController.m
//  FairHammer
//
//  Created by barry on 12/09/2013.
//  Copyright (c) 2013 barry. All rights reserved.
//

#import "SessionNoteViewController.h"


@implementation SessionNoteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableDictionary  *mdict=[_userdata mutableCopy];
    NSLog(@"%@",[mdict allKeys]);
    NSMutableDictionary  *scoredict=[[mdict objectForKey:@"allscores"]mutableCopy];
    NSMutableDictionary  *sessiondict=[scoredict objectForKey:_date];
    NSString  *note=[sessiondict objectForKey:@"note"];
    if (note) {
        [_textView setText:note];

    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)doneButtonHit:(id)sender
{
    
    NSString   *note=_textView.text;
    
    if (!note) {
        note=@"";
    }
    NSMutableDictionary  *mdict=[_userdata mutableCopy];
    NSMutableDictionary  *scoredict=[[mdict objectForKey:@"allscores"]mutableCopy];
    NSMutableDictionary  *sessiondict=[[scoredict objectForKey:_date]mutableCopy];
    
        [sessiondict setObject:note forKey:@"note"];
        [scoredict setObject:sessiondict forKey:_date];
        [mdict setValue:scoredict forKey:@"allscores"];
        
        
        NSDictionary  *dict=[[NSUserDefaults standardUserDefaults]objectForKey:@"users"];
        NSMutableDictionary  *mdictAllUsers=[dict mutableCopy];
        [mdictAllUsers setObject:mdict forKey:[mdict valueForKey:@"username"]];
        [[NSUserDefaults standardUserDefaults]setObject:mdictAllUsers forKey:@"users"];
        [[NSUserDefaults standardUserDefaults]synchronize];




       [self dismissViewControllerAnimated:YES completion:^{
           [[NSNotificationCenter  defaultCenter]postNotification:[NSNotification notificationWithName:SESSION_NOTE_ADDED_NOTIFY object:nil]];
    }];
}

@end
