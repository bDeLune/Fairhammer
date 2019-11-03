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
    
    NSLog(@"INITING NOTE WITH NIB NAME");

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
    
    NSLog(@"NOTES ABOUT TO APPEAR");
    
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
    NSLog(@"VIEWFORHEADERINSECTION ABOUT TO FINISH");
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
    
    NSLog(@"HERE1");
    
    NSMutableDictionary  *mdict=[_userdata mutableCopy];
    NSMutableDictionary  *scoredict=[[mdict objectForKey:@"allscores"]mutableCopy];
    NSMutableDictionary  *sessiondict=[[scoredict objectForKey:_date]mutableCopy];
    
    NSLog(@"HERE2");
    
        [sessiondict setObject:note forKey:@"note"];
        [scoredict setObject:sessiondict forKey:_date];
        [mdict setValue:scoredict forKey:@"allscores"];
   
     NSLog(@"HERE3");
        
        NSDictionary  *dict=[[NSUserDefaults standardUserDefaults]objectForKey:@"users"];
        NSMutableDictionary  *mdictAllUsers=[dict mutableCopy];
    
    NSLog(@"mdict %@", mdict); ///MDICT IS ALLSCORES
    NSLog(@"mdictAllUsers %@", mdictAllUsers);
     NSLog(@"[mdict valueForKey:@] %@", [mdict valueForKey:@"username"]);
    
    [mdictAllUsers setObject:mdict forKey:[mdict valueForKey:@"username"]];
    [[NSUserDefaults standardUserDefaults]setObject:mdictAllUsers forKey:@"users"];
    [[NSUserDefaults standardUserDefaults]synchronize];

     NSLog(@"HERE4");

       [self dismissViewControllerAnimated:YES completion:^{
           [[NSNotificationCenter  defaultCenter]postNotification:[NSNotification notificationWithName:SESSION_NOTE_ADDED_NOTIFY object:nil]];
    }];
}

@end
