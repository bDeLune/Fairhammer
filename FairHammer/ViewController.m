//
//  ViewController.m
//  FairHammer
//
//  Created by barry on 08/07/2013.
//  Copyright (c) 2013 barry. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import "Gauge.h"
#import "ScoreDisplayViewController.h"
#import "Session.h"
#import "UIEffectDesignerView.h"
typedef void(^RunTimer)(void);

@interface ViewController ()
{
    UINavigationController   *navcontroller;
    LoginViewViewController   *loginViewController;
    HighScoreViewController   *highScoreViewController;
    Gauge    *gaugeView;
    MidiController  *midiController;
    ScoreDisplayViewController  *scoreViewController;
    NSTimer  *timer;
    BOOL  sessionRunning;
    Session  *currentSession;
    
    UIEffectDesignerView  *particleEffect;
    
    NSTimer  *effecttimer;
    UIImageView  *bellImageView;
    UIImageView  *bg;
    UIImageView  *peakholdImageView;
    
    LogoViewController  *logoviewcontroller;
}

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    bg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MainBackground.png"]];
    [self.view insertSubview:bg atIndex:0];
      // drawDuration = 3.0;
	// Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateLogNotification:) name:SEND_MSG_TO_LOG_NOTIFY object:nil];
    [self setupLogin];
       
}

-(void)updateLogNotification:(NSNotification*)notification
{

}

#pragma mark -
#pragma mark - Login
-(void)loginSuccess
{
    [gaugeView start];
}

-(void)setupLogin
{

    loginViewController=[[LoginViewViewController alloc]init];
    loginViewController.delegate=self;
    navcontroller=[[UINavigationController alloc]initWithRootViewController:loginViewController];
    navcontroller.view.frame = CGRectMake(30, 35, 210, 200);  // Move and resize the UINavigator Controller
    [self.view addSubview:navcontroller.view];
    
    highScoreViewController=[[HighScoreViewController alloc]init];
    highScoreViewController.view.frame=CGRectMake(self.view.bounds.size.width-200, 10, 200, 200);
    [highScoreViewController setup];
    [self.view addSubview:highScoreViewController.view];
    
  /**  gaugeView=[[Gauge alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2-(GAUGE_WIDTH/2),
                                                     self.view.bounds.size.height-GUAGE_HEIGHT,
                                                     GAUGE_WIDTH,
                                                     GUAGE_HEIGHT)];**/
    
    gaugeView=[[Gauge alloc]initWithFrame:CGRectMake(353, 300, 40, GUAGE_HEIGHT)];
    gaugeView.gaugedelegate=self;
    
    scoreViewController=[[ScoreDisplayViewController alloc]init];
    scoreViewController.view.frame=CGRectMake(self.view.bounds.size.width-200,
                                              self.view.bounds.size.height-400,
                                              200,
                                              300);
    
    [self.view addSubview:scoreViewController.view];
    [self.view addSubview:gaugeView];
    midiController=[[MidiController alloc]init];
    midiController.delegate=self;
    [midiController setup];
    
    NSArray *imageNames = @[@"bell_1.png", @"bell_2.png", @"bell_3.png", @"bell_2.png",@"bell_1.png"];
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i < imageNames.count; i++) {
        [images addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
    }
    
    // Normal Animation
   bellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(gaugeView.frame.origin.x, gaugeView.frame.origin.y-50, 100, 100)];
    bellImageView.animationImages = images;
    bellImageView.animationDuration = 0.7;
    
    [self.view addSubview:bellImageView];
    peakholdImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"PeakHoldArrow.png"]];
    CGRect peakframe=peakholdImageView.frame;
    peakframe.origin.x=-100;
    peakframe.origin.y=GUAGE_HEIGHT-40;
    [peakholdImageView setFrame:peakframe];
    [gaugeView addSubview:peakholdImageView];
    gaugeView.arrow=peakholdImageView;
   // [bellImageView startAnimating];
    
    
    logoviewcontroller=[[LogoViewController alloc]init];
    [logoviewcontroller.view setFrame:CGRectMake(gaugeView.frame.origin.x-50,20,174,174)];
    
    [self.view addSubview:logoviewcontroller.view];
    
}

#pragma mark -
#pragma mark - Test Methods

-(IBAction)touchAccelerateUp:(id)sender
{
    [gaugeView blowingEnded];
    [self endCurrentSession];
    [timer invalidate];
}
-(IBAction)touchAccelerateDown:(id)sender
{
    [self beginNewSession];

    [gaugeView blowingBegan];
    timer=[NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(simulateBlow) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}
-(void)simulateBlow
{
    float  vel=[_inputtext.text floatValue];
    if (vel==127) {
        return;
    }
    float scale=10.0f;
    float value=vel*scale;
    [gaugeView setForce:(value)];
    NSDate  *date=[NSDate date];
    
    if (vel>[currentSession.sessionStrength floatValue]) {
        currentSession.sessionStrength=[NSNumber numberWithFloat:vel];
    }
    
    double  duration=[date timeIntervalSinceDate:midiController.date];
    currentSession.sessionDuration=[NSNumber numberWithDouble:duration];
    NSString  *durationtext=[NSString stringWithFormat:@"%0.1f",duration];
    dispatch_async(dispatch_get_main_queue(), ^{
        scoreViewController.durationValueLabel.text=durationtext;
        [scoreViewController setStrength:vel];
        
    });
}
#pragma mark -
#pragma mark - Midi Delegate

-(void)midiNoteBegan:(MidiController*)midi
{
    
    if (gaugeView.animationRunning) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_debugTextField setText:@"\nMidi Began"];
            
        });
        [self beginNewSession];
        [gaugeView blowingBegan];
    }
    

}
-(void)midiNoteStopped:(MidiController*)midi
{

    if (gaugeView.animationRunning) {
        [self sendLogToOutput:@"\nMidi Stop"];
        [gaugeView blowingEnded];
        [self endCurrentSession];

    }
    
}
-(void)midiNoteContinuing:(MidiController*)midi
{

    float  vel=midiController.velocity;
    if (vel==127) {
        return;
    }
    float scale=50.0f;
    float value=vel*scale;
    [gaugeView setForce:(value)];
    NSDate  *date=[NSDate date];
    
    if (vel>[currentSession.sessionStrength floatValue]) {
        currentSession.sessionStrength=[NSNumber numberWithFloat:vel];
    }
    
    double  duration=[date timeIntervalSinceDate:midiController.date];
    currentSession.sessionDuration=[NSNumber numberWithDouble:duration];
    NSString  *durationtext=[NSString stringWithFormat:@"%0.0f",duration];
    dispatch_async(dispatch_get_main_queue(), ^{
        scoreViewController.durationValueLabel.text=durationtext;
        [scoreViewController setStrength:vel];
       // [self sendLogToOutput:@"conti"];
    });

}
-(void)sendLogToOutput:(NSString*)log
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSString  *string=[NSString stringWithFormat:@"\n %@",log];
        _debugTextField.text =[_debugTextField.text stringByAppendingString:string];

    });
    

}

#pragma mark -
#pragma mark - Session Controls
-(void)beginNewSession
{
    if (!sessionRunning) {
        sessionRunning=YES;
        currentSession=[[Session alloc]init];
        currentSession.sessionDate=midiController.date;
        currentSession.username=[[NSUserDefaults standardUserDefaults]valueForKey:@"currentusername"];
    }

}

-(void)endCurrentSession
{
    if (sessionRunning) {
        sessionRunning=NO;
    }
    
    [loginViewController updateUserStats:currentSession];
   
    
    [highScoreViewController updateWithCurrentSession:currentSession];

}

#pragma mark -
#pragma mark - Animation

-(void)maxDistanceReached
{
    [midiController pause];
    particleEffect = [UIEffectDesignerView effectWithFile:@"sparks.ped"];
    CGRect frame=particleEffect.frame;
    frame.origin.x=(self.view.bounds.size.width/2)-50;
    frame.origin.y=gaugeView.frame.origin.y-40;
    particleEffect.frame=frame;
    [self.view addSubview:particleEffect];
    effecttimer=[NSTimer timerWithTimeInterval:8 target:self selector:@selector(killSparks) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:effecttimer forMode:NSDefaultRunLoopMode];
    [self playSound];
//[bellImageView startAnimating];
    [logoviewcontroller startAnimating];
}

-(void)killSparks
{
    [midiController resume];
    [self midiNoteStopped:midiController];
    [effecttimer invalidate];
    effecttimer=nil;
    [particleEffect removeFromSuperview];
    particleEffect=nil;
    [gaugeView start];
    //[bellImageView stopAnimating];
    [logoviewcontroller stopAnimating];

}
-(void) playSound {
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"bell" ofType:@"mp3"];
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &soundID);
    AudioServicesPlaySystemSound (soundID);
    //[soundPath release];
   // NSLog(@"soundpath retain count: %d", [soundPath retainCount]);
}
@end
