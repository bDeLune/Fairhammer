//
//  AppDelegate.h
//  FairHammer
//
//  Created by barry on 08/07/2013.
//  Copyright (c) 2013 barry. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FirstViewController;
@class SecondViewController;
@class AllUsersViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) FirstViewController *viewController;
@property (strong,nonatomic) SecondViewController*viewController2;
@property (strong,nonatomic) AllUsersViewController*allusersViewController;
@property (strong, nonatomic) UITabBarController *tabBarController;

@end
