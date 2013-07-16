//
//  AppDelegate.m
//  FairHammer
//
//  Created by barry on 08/07/2013.
//  Copyright (c) 2013 barry. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "SecondViewController.h"
#import "AllUsersViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
     NSDictionary  *dict=[[NSUserDefaults standardUserDefaults]valueForKey:@"users"];
    
    if (!dict) {
        NSDictionary  *dictionary=[[NSDictionary alloc]init];
        [[NSUserDefaults standardUserDefaults]setObject:dictionary forKey:@"users"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
   // self.window.rootViewController = self.viewController;
    self.viewController2=[[SecondViewController alloc] initWithNibName:@"SecondViewController_iPad" bundle:nil];
    [self.viewController2 setSettinngsDelegate:self.viewController];

    self.allusersViewController=[[AllUsersViewController alloc]initWithNibName:@"AllUsersViewController" bundle:nil];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[_viewController, _viewController2,_allusersViewController];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
