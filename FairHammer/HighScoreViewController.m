//
//  HighScoreViewController.m
//  FairHammer
//
//  Created by barry on 09/07/2013.
//  Copyright (c) 2013 barry. All rights reserved.
//

#import "HighScoreViewController.h"
#import "HighScoreObject.h"

@interface HighScoreViewController ()

@end

@implementation HighScoreViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor clearColor];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateNewHighScore:) name:NEW_HIGH_SCORE_NOTIFICATION object:nil];
    }
    return self;
}
-(void)updateNewHighScore:(NSNotification*)notification
{
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:@"highscore"];
    HighScoreObject *object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    NSLog(@"High Score object %@", object);

    dispatch_async(dispatch_get_main_queue(), ^{
      //  self.strengthValueLabel.text=[NSString stringWithFormat:@"%0.0f",[object.strength floatValue]];
     //   self.durationValueLabel.text=[NSString stringWithFormat:@"%0.0f",[object.duration floatValue]]; //added
    });
}

-(void)updateWithCurrentSession:(Session *)session
{
    NSLog(@"UPDATE WITH CURRENT SESSIONS - START");
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:@"highscore"];
    HighScoreObject *object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    //ADDED
    NSLog(@"object %@", object);
    NSLog(@"object.strength %@", object.strength);
    NSLog(@"object.duration %@", object.duration);
    //self.strengthValueLabel.text=[NSString stringWithFormat:@"%0.0f",[object.strength floatValue]];
    //self.durationValueLabel.text=[NSString stringWithFormat:@"%0.0f",[object.duration floatValue]];
    
    if (!object) {
        [self setHighScore:session];
    }else
    {
        if ([self compareSessionToHighScore:session highscore:object]) {
            
            [[NSNotificationCenter defaultCenter]postNotificationName:NEW_HIGH_SCORE_NOTIFICATION object:nil userInfo:nil];
        }
    }
 //
}
-(BOOL)compareSessionToHighScore:(Session*)session highscore:(HighScoreObject*)highscore
{
    
  //   NSLog(@"COMPARE SESSION TO HIGH SCORE- START");
    BOOL  newhighscore=NO;
    if ([session.sessionStrength floatValue]>[highscore.strength floatValue]) {
        
        highscore.strength=session.sessionStrength;
        newhighscore=YES;
    }
    
    if ([session.sessionDuration floatValue]>[highscore.duration floatValue]) {
        highscore.duration=session.sessionDuration;
        newhighscore=YES;

    }
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:highscore];
    [[NSUserDefaults standardUserDefaults]setObject:data forKey:@"highscore"];
    [[NSUserDefaults standardUserDefaults]synchronize];

    return newhighscore;
}
-(void)setHighScore:(Session*)session
{
    HighScoreObject  *object=[[HighScoreObject alloc]init];
    object.duration=session.sessionDuration;
    object.strength=session.sessionStrength;
    object.username=session.username;
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
    [[NSUserDefaults standardUserDefaults]setObject:data forKey:@"highscore"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:NEW_HIGH_SCORE_NOTIFICATION object:nil userInfo:nil];

}
-(void)setup
{
    NSData *data=[[NSUserDefaults standardUserDefaults]objectForKey:@"highscore"];
    
    if (!data)
    {
        return;
    }
    HighScoreObject *object = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    dispatch_async(dispatch_get_main_queue(), ^{
       // self.strengthValueLabel.text=[NSString stringWithFormat:@"%0.0f",[object.strength floatValue]];
       // self.durationValueLabel.text=[NSString stringWithFormat:@"%0.0f",[object.duration floatValue]]
    });
}

-(void)setStrengthLabel: (NSString*) val{
    NSLog(@"strength is %@", val);
    self.strengthValueLabel.text= val;
}

-(void)setDurationLabel: (NSString*)val{
    NSLog(@"duration is %@", val);
    self.durationValueLabel.text = val;
}

-(IBAction)reset:(id)sender
{
    HighScoreObject  *object=[[HighScoreObject alloc]init];
    object.duration=0;
    object.strength=0;
    object.username=@"";
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
    [[NSUserDefaults standardUserDefaults]setObject:data forKey:@"highscore"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[NSNotificationCenter defaultCenter]postNotificationName:NEW_HIGH_SCORE_NOTIFICATION object:nil userInfo:nil];
    
    //ADDED
    self.strengthValueLabel.text=[NSString stringWithFormat:@"0"];
    self.durationValueLabel.text=[NSString stringWithFormat:@"0"];
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"resetNotification"
     object:self];
    
    
}
@end
