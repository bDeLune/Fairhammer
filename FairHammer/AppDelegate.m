//
//  AppDelegate.m
//  FairHammer
//
//  Created by barry on 08/07/2013.
//  Copyright (c) 2013 barry. All rights reserved.
//

#import "AppDelegate.h"

#import "FirstViewController.h"
#import "SecondViewController.h"
#import "AllUsersViewController.h"
#import  "TestFlight.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
     NSDictionary  *dict=[[NSUserDefaults standardUserDefaults]valueForKey:@"users"];
    
    if (!dict) {
        NSDictionary  *dictionary=[[NSDictionary alloc]init];
        [[NSUserDefaults standardUserDefaults]setObject:dictionary forKey:@"users"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
     [TestFlight takeOff:@"89b9cbf6-013d-4a6a-b675-bb29590b1abc"];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
   // self.window.rootViewController = self.viewController;
    self.viewController2=[[SecondViewController alloc] initWithNibName:@"SecondViewController_iPad" bundle:nil];
    [self.viewController2 setSettinngsDelegate:self.viewController];

    self.allusersViewController=[[AllUsersViewController alloc]initWithNibName:@"AllUsersViewController" bundle:nil];
    UINavigationController  *navCOntroller=[[UINavigationController alloc]initWithRootViewController:_allusersViewController];
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[_viewController, _viewController2,navCOntroller];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    return YES;
}


@end
