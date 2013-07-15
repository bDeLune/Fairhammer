//
//  LoginViewViewController.m
//  FairHammer
//
//  Created by barry on 09/07/2013.
//  Copyright (c) 2013 barry. All rights reserved.
//

#import "LoginViewViewController.h"
#import "Toast+UIView.h"
#import "UserStatsViewController.h"
@interface LoginViewViewController ()
{
    SignUpViewController  *signupViewController;
    UserStatsViewController *userStatsViewController;
    
    NSDictionary  *currentUserData;
}
@end

@implementation LoginViewViewController

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
    userStatsViewController=[[UserStatsViewController alloc]init];

    self.navigationItem.title=@"Login";
    
    
}

-(IBAction)loginButtonPressed:(id)sender
{
    if (!signupViewController) {
        signupViewController=[[SignUpViewController alloc]init];
        signupViewController.delegate=self;
        [self.navigationController pushViewController:signupViewController animated:YES];
    }else
    {
       // NSArray  *vcs=self.navigationController.viewControllers;
        [self.navigationController pushViewController:signupViewController animated:YES];
    }

}
-(IBAction)statsButtonPressed:(id)sender
{
    if (currentUserData)
    {
     
        [self showUserStats];
    }else
    {
        [self.view makeToast:@"You need to be logged in to do that"];
    }
}

-(void)showUserStats
{
    if (!userStatsViewController) {
        userStatsViewController=[[UserStatsViewController alloc]init];
        [self.navigationController pushViewController:userStatsViewController animated:YES];
    }else
    {
        [self.navigationController pushViewController:userStatsViewController animated:YES];
    }
}
#pragma mark -
#pragma mark - Signup Delegate

-(void)userCreated:(NSDictionary*)dict
{
    currentUserData=dict;
     self.navigationItem.title=[currentUserData valueForKey:@"username"];
    [[NSUserDefaults standardUserDefaults]setObject:[currentUserData valueForKey:@"username"] forKey:@"currentusername"];
    [_delegate loginSuccess];
}
-(void)userSignedIn:(NSDictionary*)dict
{
    currentUserData=dict;
    self.navigationItem.title=[currentUserData valueForKey:@"username"];
    [[NSUserDefaults standardUserDefaults]setObject:[currentUserData valueForKey:@"username"] forKey:@"currentusername"];

    [_delegate loginSuccess];



}

-(void)updateUserStats:(Session*)asession
{
   // NSString  *username=[[NSUserDefaults standardUserDefaults]valueForKey:@"currentusername"];
   // NSMutableDictionary  *dict=[[NSUserDefaults standardUserDefaults]objectForKey:username];
    
    
    //NSData *data = [[NSKeyedArchiver archivedDataWithRootObject:asession]mutableCopy];
    ////[dict setObject:data forKey:@"lastsession"];
   // [[NSUserDefaults standardUserDefaults]synchronize];
    
    [userStatsViewController updateUserStats:asession];
}
@end