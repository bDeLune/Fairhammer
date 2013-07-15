//
//  ViewController.h
//  FairHammer
//
//  Created by barry on 08/07/2013.
//  Copyright (c) 2013 barry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "LoginViewViewController.h"
#import "HighScoreViewController.h"
#import  "MidiController.h"
#import "Gauge.h"
#define SEND_MSG_TO_LOG_NOTIFY  @"com.rocudo.logmessage"

//VELOCITY

// velocity = distance / time
//time = distance / velocity
//distance = velocity x time

//FORCE

//Mass  * acceleration


//VELOCITY
//velocity = accceleration by time

//Distance
//s(t) = 1/2*a*t2  

@interface ViewController : UIViewController<LoginViewControllerDelegate,MidiControllerProtocol,GaugeProtocol>
@property(nonatomic,strong)IBOutlet UIButton   *accelerateButton;
@property(nonatomic,strong)IBOutlet UITextView  *debugTextField;
@property(nonatomic,strong)IBOutlet UITextField  *inputtext;
@property  dispatch_source_t  aTimer;

-(IBAction)touchAccelerateUp:(id)sender;
-(IBAction)touchAccelerateDown:(id)sender;
@end
