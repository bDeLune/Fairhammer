//
//  UserStatsViewController.m
//  FairHammer
//
//  Created by barry on 12/07/2013.
//  Copyright (c) 2013 barry. All rights reserved.
//

#import "UserStatsViewController.h"
#import "ViewController.h"
@interface UserStatsViewController ()

@end

@implementation UserStatsViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self writeStatsToLabels];
    

}
-(void)writeStatsToLabels
{
    dispatch_async(dispatch_get_main_queue(), ^{
    
        NSString  *username=[[NSUserDefaults standardUserDefaults]valueForKey:@"currentusername"];
        NSMutableDictionary  *dict=[[NSUserDefaults standardUserDefaults]objectForKey:username];
        
        NSNumber  *usersBestDuration=[dict valueForKey:@"bestduration"];
        NSNumber  *usersBestStrength=[dict valueForKey:@"beststrength"];
        self.usernameLabel.text=username;
        self.durationLabel.text=[NSString stringWithFormat:@"%0.1f",[usersBestDuration floatValue]];
        self.strengthLabel.text=[NSString stringWithFormat:@"%0.1f",[usersBestStrength floatValue]];
        

    });
  
}
-(void)setUserStats:(Session*)session
{
}
-(void)updateUserStats:(Session*)session
{
    //NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:@"lastsession"];
   // Session *object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
   // dispatch_async(dispatch_get_main_queue(), ^{
        NSString  *username=[[NSUserDefaults standardUserDefaults]valueForKey:@"currentusername"];
        NSMutableDictionary  *dict=[[NSUserDefaults standardUserDefaults]objectForKey:username];
       NSMutableDictionary *mutableDict = [dict mutableCopy];
        NSNumber  *usersBestDuration=[dict valueForKey:@"bestduration"];
        NSNumber  *usersBestStrength=[dict valueForKey:@"beststrength"];
        
        if (!session) {
            return ;
        }
        if (!session.sessionDuration) {
            return;
        }
        
        if ([session.sessionDuration floatValue]>[usersBestDuration floatValue]) {
            [mutableDict setObject:session.sessionDuration forKey:@"bestduration"];
        }
        if ([session.sessionStrength floatValue]>[usersBestStrength floatValue]) {
            [mutableDict setObject:session.sessionStrength forKey:@"beststrength"];
            
        }
        
        [[NSUserDefaults standardUserDefaults]setValue:mutableDict forKey:username];
        [[NSUserDefaults standardUserDefaults]synchronize];

  //  });
   
    
    [self writeStatsToLabels];
}
@end
