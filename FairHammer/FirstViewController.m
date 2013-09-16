//
//  ViewController.m
//  FairHammer
//
//  Created by barry on 08/07/2013.
//  Copyright (c) 2013 barry. All rights reserved.
//

#import "FirstViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import "Gauge.h"
#import "ScoreDisplayViewController.h"
#import "Session.h"
#import "UIEffectDesignerView.h"
#import <AVFoundation/AVFoundation.h>

typedef void(^RunTimer)(void);

@interface FirstViewController ()
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
    int threshold;
    
   AVAudioPlayer *audioPlayer;
    
    UIButton  *togglebutton;
    BOOL   toggleIsON;
    
    int midiinhale;
    int midiexhale;
    int currentdirection;
    int inorout;

}
@end

@implementation FirstViewController
-(void)setResitance:(int)pvalue
{
    switch (pvalue) {
        case 0:
            [gaugeView setMass:1];
            break;
            
        case 1:
            [gaugeView setMass:3];
            
            break;
        case 2:
            [gaugeView setMass:6];
            
            break;
            
        case 3:
            [gaugeView setMass:10];
            
            break;
            
        default:
            break;

    }
}
-(void)setThreshold:(int)pvalue
{
    switch (pvalue) {
        case 0:
            threshold=10;
            break;
            
        case 1:
            threshold=30;

            break;
        case 2:
            threshold=70;

            break;
            
        case 3:
            threshold=100;
            
            break;
            
        default:
            break;
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    bg=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MainBackground"]];
    [self.view insertSubview:bg atIndex:0];
    self.tabBarItem.image = [UIImage imageNamed:@"Menu-Main"];
    self.title = @"Main";
    midiinhale=61;
    midiexhale=73;
    threshold=10;
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
    highScoreViewController.view.frame=CGRectMake(self.view.bounds.size.width-215, 15, 200, 200);
    [highScoreViewController setup];
    [self.view addSubview:highScoreViewController.view];
    
      
    gaugeView=[[Gauge alloc]initWithFrame:CGRectMake(370, 365, 40, GUAGE_HEIGHT)];
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
    [logoviewcontroller.view setFrame:CGRectMake(gaugeView.frame.origin.x-90,20,174,174)];
    
    [self.view addSubview:logoviewcontroller.view];
    
    
    togglebutton=[UIButton buttonWithType:UIButtonTypeCustom];
    togglebutton.frame=CGRectMake(110, self.view.frame.size.height-120, 108, 58);
    [togglebutton addTarget:self action:@selector(toggleDirection:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:togglebutton];
    
    [togglebutton setBackgroundImage:[UIImage imageNamed:@"BreathDirection_NORMAL.png"] forState:UIControlStateNormal];
    toggleIsON=NO;

    
}
- (IBAction)toggleDirection:(id)sender
{
    
    switch (midiController.toggleIsON) {
        case 0:
            midiController.toggleIsON=YES;
          //  midiController.currentdirection=midiinhale;
            [togglebutton setBackgroundImage:[UIImage imageNamed:@"BreathDirection_REVERSE.png"] forState:UIControlStateNormal];
            break;
        case 1:
            midiController.toggleIsON=NO;

            [togglebutton setBackgroundImage:[UIImage imageNamed:@"BreathDirection_NORMAL.png"] forState:UIControlStateNormal];
          //  midiController.currentdirection=midiexhale;

            
            break;
            
        default:
            break;
    }
    
    
    
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
    
    if (vel<threshold) {
        return;
    }
    if (vel==127) {
        return;
    }
    float scale=50.0f;
    float value=vel*scale;
    [gaugeView setForce:(value)];
    NSDate  *date=[NSDate date];
    
    if (vel>[currentSession.sessionStrength floatValue]) {
        currentSession.sessionStrength=[NSNumber numberWithFloat:vel];
       // [gaugeView setArrowPos:0];
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
-(void)endCurrentSessionTest
{
   /** if (sessionRunning) {
        sessionRunning=NO;
    }
    currentSession=[[Session alloc]init];
    currentSession.sessionDate=midiController.date;
    currentSession.username=[[NSUserDefaults standardUserDefaults]valueForKey:@"currentusername"];
    currentSession.sessionDuration=[NSNumber numberWithInt:1];
    currentSession.sessionStrength=[NSNumber numberWithInt:1];
    [loginViewController updateUserStats:currentSession];
    
    
    
    [highScoreViewController updateWithCurrentSession:currentSession];**/
    
}
-(void)endCurrentSession
{
    if (sessionRunning) {
        sessionRunning=NO;
    }
       // dispatch_async(dispatch_get_main_queue(), ^{
          //  scoreViewController.durationValueLabel.text=@"";
           // scoreViewController.strengthValueLabel.text=@"";
        
       // });

    [loginViewController updateUserStats:currentSession];
   
    
    [highScoreViewController updateWithCurrentSession:currentSession];

}

#pragma mark -
#pragma mark - Animation

-(void)maxDistanceReached
{
    [self endCurrentSession];
    [midiController pause];
    if (particleEffect) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [particleEffect removeFromSuperview];
            particleEffect=nil;
        });
    }
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
   // [loginViewController updateUserStats:currentSession];
    
   //
    [highScoreViewController updateWithCurrentSession:currentSession];
}

-(void)killSparks
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [particleEffect removeFromSuperview];
        particleEffect=nil;
    });
    [midiController resume];
    [self midiNoteStopped:midiController];
    [effecttimer invalidate];
    effecttimer=nil;
    
   
    [gaugeView start];
    //[bellImageView stopAnimating];
    [logoviewcontroller stopAnimating];

}
-(void) playSound {
    
  NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"bell" ofType:@"mp3"];
    
    
    NSData *fileData = [NSData dataWithContentsOfFile:soundPath];
    
    NSError *error = nil;
    
    audioPlayer = [[AVAudioPlayer alloc] initWithData:fileData
                                                    error:&error];
    [audioPlayer prepareToPlay];
    [audioPlayer play];

    //[soundPath release];
   // NSLog(@"soundpath retain count: %d", [soundPath retainCount]);
}

-(void)setRate:(float)value
{
   // self.animationrate=value;
}

-(void)sendValue:(int)note onoff:(int)onoff
{
   /** const UInt8 noteOn[]  = { 0x90, note, 127 };
    // const UInt8 noteOff[] = { 0x80, note, 0   };
    [_delegate sendLogToOutput:@"got this 127"];
    [self sendBytes:noteOn size:sizeof(noteOn)];
    [NSThread sleepForTimeInterval:0.1];**/
    // [self sendBytes:noteOff size:sizeof(noteOff)];
    [midiController sendValue:note onoff:onoff];
    
    
}
@end
