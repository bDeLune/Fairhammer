//
//  UserStatsViewController.h
//  FairHammer
//
//  Created by barry on 12/07/2013.
//  Copyright (c) 2013 barry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Session.h"



@interface UserStatsViewController : UIViewController
@property(nonatomic,strong)IBOutlet UILabel  *usernameLabel;
@property(nonatomic,strong)IBOutlet UILabel  *durationLabel;
@property(nonatomic,strong)IBOutlet UILabel  *strengthLabel;
-(void)setUserStats:(Session*)session;
-(void)updateUserStats:(Session*)session;
@end
