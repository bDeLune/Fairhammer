//
//  LoginViewViewController.h
//  FairHammer
//
//  Created by barry on 09/07/2013.
//  Copyright (c) 2013 barry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignUpViewController.h"
#import "Session.h"
@protocol LoginViewControllerDelegate <NSObject>

-(void)loginSuccess;
@end

@interface LoginViewViewController : UIViewController<SignupViewControllerProtocol>
@property(nonatomic,strong)IBOutlet UIButton  *loginButton;
@property(nonatomic,strong)IBOutlet UIButton  *statsButton;
@property(nonatomic,strong)id<LoginViewControllerDelegate>delegate;

-(IBAction)loginButtonPressed:(id)sender;
-(IBAction)statsButtonPressed:(id)sender;
-(void)updateUserStats:(Session*)asession;
@end
