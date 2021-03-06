//
//  SignUpViewController.m
//  FairHammer
//
//  Created by barry on 09/07/2013.
//  Copyright (c) 2013 barry. All rights reserved.
//

#import "SignUpViewController.h"
#import "Toast+UIView.h"
@interface SignUpViewController ()

@end

@implementation SignUpViewController

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
-(IBAction)doLogin:(id)sender
{
    NSLog(@"Do Login");
    
    BOOL  validFields=[self validFields];
    
    if (!validFields) {
        [self.view makeToast:@"Username too Short"];
        
        return;
        
    }
    
    [self loginUser];
    
    

}
-(IBAction)doSignup:(id)sender
{
    BOOL  validFields=[self validFields];
    
    if (!validFields) {
        [self.view makeToast:@"Username too Short"];
        
        return;
        
    }
    
    [self makeUser];
}

-(BOOL)validFields
{
    BOOL  result=YES;
    
    if ([self.usernameTextField.text length]<1) {
        result=NO;
    }
    
   /// if ([self.passwordTextField.text length]<1) {
  //      result=NO;
   /// }
    
    
    return result;

}

-(void)makeUser
{
    NSString  *username=self.usernameTextField.text;
    NSString  *password=self.passwordTextField.text;
    
    NSDictionary  *dict=[[NSUserDefaults standardUserDefaults]objectForKey:@"users"];
    NSMutableDictionary  *mDict=[dict mutableCopy];
    NSDictionary  *dictionarycheck=[mDict valueForKey:username];
    
    if (dictionarycheck) {
        [self.view makeToast:@"That Username is already in use"];
        
        return;
    }
    
    NSMutableDictionary  *dictionary=[[NSMutableDictionary alloc]init];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate  *date=[NSDate date];
    [dateFormat setDateFormat:@"d MMM y H:m:s"];
    NSString *dateString = [dateFormat stringFromDate:date];
    [dictionary setValue:password forKey:@"password"];
    [dictionary setValue:username forKey:@"username"];
    [dictionary setValue:[NSNumber numberWithFloat:0.0] forKey:@"bestduration"];
    [dictionary setValue:[NSNumber numberWithFloat:0.0] forKey:@"beststrength"];
    
    [dictionary setValue:dateString forKey:@"lastlogin"];
    NSMutableDictionary  *allscores=[[NSMutableDictionary alloc]init];
    [dictionary setValue:allscores forKey:@"allscores"];

   
    [mDict setValue:dictionary forKey:username];
    [[NSUserDefaults standardUserDefaults]setValue:mDict forKey:@"users"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [_delegate userCreated:dictionary];
}
//
-(void)loginUser
{
    NSString  *username=self.usernameTextField.text;
    NSString  *password=self.passwordTextField.text;
    
    
    NSDictionary  *dict=[[NSUserDefaults standardUserDefaults]objectForKey:@"users"];
    NSMutableDictionary  *mDict=[dict mutableCopy];

    
    NSDictionary  *dictionarycheck=[mDict valueForKey:username];
    
    if (!dictionarycheck) {
        [self.view makeToast:@"That User Doesnt Exist"];
        
        return;
    }
    
   // NSString  *dictpassword=[dictionarycheck valueForKey:@"password"];
   // if (![dictpassword isEqualToString:password]) {
  ///      [self.view makeToast:@"Incorrect Password"];
  ///      return;
//
  ///  }
    
    NSMutableDictionary   *addDateDictionary=[dict mutableCopy];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate  *date=[NSDate date];
    [dateFormat setDateFormat:@"d MMM y H:m:s"];
    NSString *dateString = [dateFormat stringFromDate:date];
    
    NSLog(@"date: %@", dateString);
    
    [addDateDictionary setValue:dateString forKey:@"lastlogin"];
    
    
    [mDict setValue:addDateDictionary forKey:username];
    [self.navigationController popToRootViewControllerAnimated:YES];

    [_delegate userSignedIn:dictionarycheck];
}


@end
