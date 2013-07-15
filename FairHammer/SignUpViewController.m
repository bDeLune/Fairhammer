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
        [self.view makeToast:@"Username OR Password Too Short"];
        
        return;
        
    }
    
    [self loginUser];
    
    

}
-(IBAction)doSignup:(id)sender
{
    BOOL  validFields=[self validFields];
    
    if (!validFields) {
        [self.view makeToast:@"Username OR Password Too Short"];
        
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
    
    if ([self.passwordTextField.text length]<1) {
        result=NO;
    }
    
    
    return result;

}

-(void)makeUser
{
    NSString  *username=self.usernameTextField.text;
    NSString  *password=self.passwordTextField.text;
    
    NSDictionary  *dictionarycheck=[[NSUserDefaults standardUserDefaults]valueForKey:username];
    
    if (dictionarycheck) {
        [self.view makeToast:@"That Username is already in use"];
        
        return;
    }
    
    NSMutableDictionary  *dictionary=[[NSMutableDictionary alloc]init];
    [dictionary setValue:password forKey:@"password"];
    [dictionary setValue:username forKey:@"username"];
    [dictionary setValue:[NSNumber numberWithFloat:0.0] forKey:@"bestduration"];
    [dictionary setValue:[NSNumber numberWithFloat:0.0] forKey:@"beststrength"];

    [[NSUserDefaults standardUserDefaults]setValue:dictionary forKey:username];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [_delegate userCreated:dictionary];
}
//
-(void)loginUser
{
    NSString  *username=self.usernameTextField.text;
    NSString  *password=self.passwordTextField.text;
    NSDictionary  *dictionarycheck=[[NSUserDefaults standardUserDefaults]valueForKey:username];
    
    if (!dictionarycheck) {
        [self.view makeToast:@"That User Doesnt Exist"];
        
        return;
    }
    
    NSString  *dictpassword=[dictionarycheck valueForKey:@"password"];
    if (![dictpassword isEqualToString:password]) {
        [self.view makeToast:@"Incorrect Password"];
        return;

    }
    [self.navigationController popToRootViewControllerAnimated:YES];

    [_delegate userSignedIn:dictionarycheck];
}


@end
