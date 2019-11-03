//
//  UserStatsViewController.m
//  FairHammer
//
//  Created by barry on 12/07/2013.
//  Copyright (c) 2013 barry. All rights reserved.
//

#import "UserStatsViewController.h"
#import "FirstViewController.h"
#import "SessionNoteViewController.h"
@interface UserStatsViewController ()

@end

@implementation UserStatsViewController


-(void)viewWillAppear:(BOOL)animated
{
    [self writeStatsToLabels];
    

}
-(void)writeStatsToLabels
{
    dispatch_async(dispatch_get_main_queue(), ^{
    
        
   //     NSLog(@"USER STATS ABOUT TO APPEAR");
        
        NSString  *username=[[NSUserDefaults standardUserDefaults]valueForKey:@"currentusername"];
        
        NSDictionary  *userdict=[[NSUserDefaults standardUserDefaults]objectForKey:@"users"];
        NSMutableDictionary  *mDict=[userdict mutableCopy];
        
        NSMutableDictionary  *dict=[mDict objectForKey:username];
        
        NSNumber  *usersBestDuration=[dict valueForKey:@"bestduration"];
        NSNumber  *usersBestStrength=[dict valueForKey:@"beststrength"];
        self.usernameLabel.text=username;
        
     //   NSLog(@"WRITING TO LABEL DURATION %@",usersBestDuration);
    //     NSLog(@"WRITING TO LABEL sTRENGTH %@",usersBestStrength);
     ////
        self.durationLabel.text=[NSString stringWithFormat:@"%0.1f",[usersBestDuration floatValue]];
        self.strengthLabel.text=[NSString stringWithFormat:@"%0.1f",[usersBestStrength floatValue]];
        
       // self.durationLabel.text=[NSString stringWithFormat:@"%@", usersBestDuration];
        //self.strengthLabel.text=[NSString stringWithFormat:@"%@", usersBestStrength];
        
    //     NSLog(@"USER STATS ABOUT TO APPEAR");
        
    //    NSLog(@"DURATION %@",self.durationLabel.text);
    //    NSLog(@"sTRENGTH %@", self.strengthLabel.text);

    });
  
}
-(void)setUserStats:(Session*)session
{
}
-(void)updateUserStats:(Session*)session
{
   // NSLog(@"UPDATE USER STATS - START");
    
    NSDictionary  *userdict=[[NSUserDefaults standardUserDefaults]objectForKey:@"users"];
    NSMutableDictionary  *mDict=[userdict mutableCopy];
    

    NSString  *username=[[NSUserDefaults standardUserDefaults]valueForKey:@"currentusername"];
    NSMutableDictionary  *dict=[mDict objectForKey:username];
    NSMutableDictionary *mutableDict = [dict mutableCopy];
    NSNumber  *usersBestDuration=[dict valueForKey:@"bestduration"];
    NSNumber  *usersBestStrength=[dict valueForKey:@"beststrength"];
    
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate  *date=[NSDate date];
        [dateFormat setDateFormat:@"d MMM y H:m:s"];
    NSString *attemptDateString = [dateFormat stringFromDate:date];
    
    NSDictionary  *allScoresDict=[dict valueForKey:@"allscores"];
    NSMutableDictionary  *allScoresMutatable=[allScoresDict mutableCopy];
    
    NSString  *difficulty=[[NSUserDefaults standardUserDefaults]valueForKey:@"difficulty"];
    
    NSString  *direction=[[NSUserDefaults standardUserDefaults]objectForKey:@"direction"];
    NSMutableDictionary   *durationAndStrenghtDict=[NSMutableDictionary  dictionaryWithObjectsAndKeys:
                                             usersBestDuration,@"bestduration",
                                             usersBestStrength,@"beststrength",session.sessionDuration,@"duration",session.sessionStrength,@"strength", nil];
    [durationAndStrenghtDict setObject:difficulty forKey:@"difficulty"];
    [durationAndStrenghtDict setObject:direction forKey:@"direction"];
    
    
    [allScoresMutatable  setValue:durationAndStrenghtDict forKey:attemptDateString];
    [mutableDict setObject:allScoresMutatable forKey:@"allscores"];
    
    
  //  NSLog(@"BEST DURATION %@", session.sessionDuration);
  //  NSLog(@"BEST STRENGTH %@", session.sessionStrength);
    
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
    
       [mDict setValue:mutableDict forKey:username];
        
        [[NSUserDefaults standardUserDefaults]setValue:mDict forKey:@"users"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    
    
    //    [[NSNotificationCenter  defaultCenter]postNotification:[NSNotification notificationWithName:SESSION_NOTE_ADDED_NOTIFY object:nil]];
        //ADDED - THIS LINE WAS REMOVED TO PREVENT THE TABLEVIEW FROM DISAPPEARING
  //  });
   
    
    [self writeStatsToLabels];
}
@end
