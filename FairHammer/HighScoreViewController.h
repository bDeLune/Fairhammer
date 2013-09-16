//
//  HighScoreViewController.h
//  FairHammer
//
//  Created by barry on 09/07/2013.
//  Copyright (c) 2013 barry. All rights reserved.
//
/**
 update worked?
 */
#import <UIKit/UIKit.h>
#import "Session.h"
#define NEW_HIGH_SCORE_NOTIFICATION  @"com.rocudo.newHighscore"

@interface HighScoreViewController : UIViewController
@property(nonatomic,strong)IBOutlet  UILabel  *durationValueLabel;
@property(nonatomic,strong)IBOutlet UILabel  *strengthValueLabel;
@property(nonatomic,strong)IBOutlet  UIButton  *resetButton;
-(IBAction)reset:(id)sender;
-(void)updateWithCurrentSession:(Session*)session;
-(void)setup;
@end
