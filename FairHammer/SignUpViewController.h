//
//  SignUpViewController.h
//  FairHammer
//
//  Created by barry on 09/07/2013.
//  Copyright (c) 2013 barry. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SignupViewControllerProtocol <NSObject>

-(void)userCreated:(NSDictionary*)dict;
-(void)userSignedIn:(NSDictionary*)dict;

@end

@interface SignUpViewController : UIViewController
@property(nonatomic,strong)IBOutlet  UIButton  *loginButton;
@property(nonatomic,strong)IBOutlet  UIButton   *signupButton;
@property(nonatomic,strong)IBOutlet  UITextField  *usernameTextField;
@property(nonatomic,strong)IBOutlet   UITextField  *passwordTextField;
@property(nonatomic,unsafe_unretained)id<SignupViewControllerProtocol>delegate;
@property(nonatomic,strong)NSString *currentUserName;
-(IBAction)doLogin:(id)sender;
-(IBAction)doSignup:(id)sender;
@end
