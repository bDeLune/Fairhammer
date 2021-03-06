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
#import "Draggable.h"
//#import "BTLEManager.h"
#import "BTLEManager.h"
typedef void(^RunTimer)(void);

@interface FirstViewController ()<BTLEManagerDelegate>
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
    Draggable  *peakholdImageView;
    
    LogoViewController  *logoviewcontroller;
    int threshold;
    
    AVAudioPlayer *audioPlayer;
    
    float rangeReduction;
    double rangeReductionAsDouble;
    
    float currHighestStrength;
    double currHighestDuration;
    
    UIButton  *togglebutton;
    BOOL   toggleIsON;
    
    int midiinhale;
    int midiexhale;
    int currentdirection;
    int inorout;
    bool currentlyExhaling;
    bool currentlyInhaling;
    
    BOOL allowResetHighScore;
}

@property(nonatomic,strong)IBOutlet UIImageView  *btOnOfImageView;
@property(nonatomic,strong)BTLEManager  *btleManager;
@property(nonatomic,strong)    NSDate  *date;
@end

@implementation FirstViewController
-(void)setBTTreshold:(float)value
{
    [self.btleManager setTreshold:value];
}

-(void)setBTBoost:(float)value
{
    [self.btleManager setRangeReduction:value];
    rangeReduction = value;
    rangeReductionAsDouble = (double)value;
}

-(void)btleManagerConnected:(BTLEManager *)manager
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.btOnOfImageView setImage:[UIImage imageNamed:@"Bluetooth-CONNECTED"]];
        currentlyExhaling = false;
        currentlyInhaling = false;
    });
}

-(void)btleManagerDisconnected:(BTLEManager *)manager

{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.btOnOfImageView setImage:[UIImage imageNamed:@"Bluetooth-DISCONNECTED"]];
    });
}

-(void)setResitance:(int)pvalue
{
    NSLog(@"Setting setResitance to %d", pvalue);
    
    switch (pvalue) {
        case 0:
            [gaugeView setMass:1];
            break;
            
        case 1:
            [gaugeView setMass:1.8];
            
            break;
        case 2:
            [gaugeView setMass:2.4];
            
            break;
            
        case 3:
            [gaugeView setMass:3.4];
            
            break;
            
        default:
            break;
    }
}

-(void)setThreshold:(int)pvalue
{
    NSLog(@"Setting inner threshold to %d", pvalue);
    
    switch (pvalue) {
        case 0:
            threshold=10;
            break;
            
        case 1:
            //threshold=20; //changed values by request 1/2/2017 - b
            //threshold 15
            threshold=11;
            break;
        case 2:
            //threshold=30;
            //threshold=30;
            threshold=16;
            break;
            
        case 3:
            threshold=20;
            NSLog(@"Setting inner threshold to 50");
            break;
            
        default:
            break;
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    currHighestStrength = 0;
    currHighestDuration = 0; //ADDED
    rangeReductionAsDouble = 1.0;
    rangeReduction = 1;
    
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
    
    self.btleManager =[BTLEManager new];
    self.btleManager.delegate=self;
    [self.btleManager startWithDeviceName:@"GroovTube" andPollInterval:0.1];
    [self.btleManager setTreshold:60];
    [self.btOnOfImageView setImage:[UIImage imageNamed:@"Bluetooth-DISCONNECTED"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(resetNotification:)
                                                 name:@"resetNotification"
                                               object:nil];

}

- (void) resetNotification:(NSNotification *) notification
{
    // [notification name] should always be @"TestNotification"
    // unless you use this method for observation of other notifications
    // as well.
    
     currHighestStrength = 0;
     currHighestDuration = 0;
    
    if ([[notification name] isEqualToString:@"resetNotification"])
        NSLog (@"Successfully received the resetNotification!");
}

-(void)btleManagerBreathBegan:(BTLEManager*)manager{
    self.date=[NSDate date];
    
  //  NSLog(@"MIDINOTEBGAN currentlyexhaling == %d", currentlyExhaling);
  //  NSLog(@"MIDINOTEBGAN currentlyInhaling == %d", currentlyInhaling);
    
  //  if ((currentlyExhaling == true && midiController.toggleIsON )|| (currentlyInhaling == true && midiController.toggleIsON == false)){
    
        [self midiNoteBegan:nil];
    
    if (allowResetHighScore == YES){
        allowResetHighScore = NO;
        currHighestStrength = 0;
        currHighestDuration = 0; //ADDED
        [highScoreViewController updateWithCurrentSession:currentSession];
        
       // float reset = 0.0f;
        
        scoreViewController.durationValueLabel.text= @"0";
        ///[scoreViewController setStrength: reset];
    }
}


-(void)btleManagerBreathStopped:(BTLEManager*)manager{
    [gaugeView blowingEnded];
    [self midiNoteStopped:nil];
}

-(void)btleManager:(BTLEManager*)manager inhaleWithValue:(float)percentOfmax
{
    currentlyExhaling = false;
    currentlyInhaling = true;
    
     [gaugeView setBreathToggleAsExhale:currentlyExhaling isExhaling: midiController.toggleIsON];
    
    if (midiController.toggleIsON==NO) {
        return;
    }
    
    float  vel=127.0*percentOfmax;;
    float withoutRangeReduction = percentOfmax/rangeReductionAsDouble;
    float withoutRangeReductionScaled = withoutRangeReduction*127;
    
    if (vel<threshold) {
        return;
    }
   // if (vel==127) {
    //    return;
    //}
    
    [gaugeView blowingBegan];
    
    float scale=50.0f;
    float value=vel*scale;
    [gaugeView setForce:(value)];
    NSDate  *date=[NSDate date];
    
    if (vel>[currentSession.sessionStrength intValue]) {
        currentSession.sessionStrength=[NSNumber numberWithInt:vel];
        // [gaugeView setArrowPos:0];
    }
    
    double  duration=[date timeIntervalSinceDate:self.date];
    currentSession.sessionDuration=[NSNumber numberWithDouble:duration];
    NSString  *durationtext=[NSString stringWithFormat:@"%0.0f",duration];
    dispatch_async(dispatch_get_main_queue(), ^{
        scoreViewController.durationValueLabel.text=durationtext;
        [scoreViewController setStrength:withoutRangeReductionScaled];
        [self updateHighScore: withoutRangeReductionScaled withDuration: duration];
        // [self sendLogToOutput:@"conti"];
    });
}

-(void)btleManager:(BTLEManager*)manager exhaleWithValue:(float)percentOfmax{
    
    currentlyExhaling = true;
    currentlyInhaling = false;
    
    //-(void)setBreathToggleAsExhale:(bool)value isExhaling: (bool)value2;
    [gaugeView setBreathToggleAsExhale:currentlyExhaling isExhaling: midiController.toggleIsON];
    
    if (midiController.toggleIsON) {
        return;
    }
    
    float vel=127.0*percentOfmax;;
    float withoutRangeReduction = percentOfmax/rangeReductionAsDouble;
    float withoutRangeReductionScaled = withoutRangeReduction*127;
    
    //NSLog(@"withoutRangeReduction %f", withoutRangeReduction);
    ///NSLog(@"withoutRangeReductionScaled %f", withoutRangeReductionScaled);
    
    if (vel<threshold) {
        return;
    }
    
    //if (vel==127) {
    //    return;
    //}
    
    [gaugeView blowingBegan];
    ///NSLog(@"VEL IS %f", vel);
    
    float scale=50.0f;
    float value=vel*scale;
    [gaugeView setForce:(value)];
    NSDate  *date=[NSDate date];
    
    if (vel>[currentSession.sessionStrength intValue]) {
        currentSession.sessionStrength=[NSNumber numberWithInt:vel];
        // [gaugeView setArrowPos:0];
    }
    
    double  duration=[date timeIntervalSinceDate:self.date];
    currentSession.sessionDuration=[NSNumber numberWithDouble:duration];
    NSString  *durationtext=[NSString stringWithFormat:@"%0.0f",duration];
    dispatch_async(dispatch_get_main_queue(), ^{
        scoreViewController.durationValueLabel.text=durationtext;
        [scoreViewController setStrength:withoutRangeReductionScaled];
        [self updateHighScore: withoutRangeReductionScaled withDuration: duration];
    });
}

-(void)updateHighScore: (float)strength withDuration: (double)duration{
    
    //NSLog(@"HS strength %f / HIGH: %f", strength, currHighestStrength);
   /// NSLog(@"HS duration %f / HIGH: %f", duration, currHighestDuration);
    
    int strengthRounded = (int)roundf(strength);
    int durationRounded = (int)roundf(duration);
    
    if (strengthRounded > currHighestStrength){
        currHighestStrength = strengthRounded;
        [highScoreViewController setStrengthLabel: [NSString stringWithFormat:@"%d", strengthRounded]];
    }
    
    if (durationRounded > currHighestDuration){
        currHighestDuration = durationRounded;
        //NSString* myDuration = [NSString stringWithFormat:@"%f", duration];
        //NSString* truncatedString = [myDuration substringToIndex: MIN(1, [myDuration length])];
        [highScoreViewController setDurationLabel: [NSString stringWithFormat:@"%d", durationRounded]];
    }
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
    // midiController=[[MidiController alloc]init];
    //  midiController.delegate=self;
    //  [midiController setup];
    
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
    peakholdImageView=[[Draggable alloc]initWithImage:[UIImage imageNamed:@"PeakHoldArrow.png"]];
    CGRect peakframe=peakholdImageView.frame;
    // peakframe.origin.x=-100;
    peakframe.origin.y=900;
    peakframe.origin.x=251;
    
    [peakholdImageView setFrame:peakframe];
    peakholdImageView.delegate=self;
    // [gaugeView addSubview:peakholdImageView];
    //  self.view.userInteractionEnabled=NO;
    [self.view addSubview:peakholdImageView];
    gaugeView.arrow=peakholdImageView;
    // [gaugeView addSubview:peakholdImageView];
    // gaugeView.arrow.userInteractionEnabled=YES;
    // [bellImageView startAnimating];
    
    logoviewcontroller=[[LogoViewController alloc]init];
    [logoviewcontroller.view setFrame:CGRectMake(gaugeView.frame.origin.x-90,20,174,174)];
    
    [self.view addSubview:logoviewcontroller.view];
    
    
    togglebutton=[UIButton buttonWithType:UIButtonTypeCustom];
    togglebutton.frame=CGRectMake(110, self.view.frame.size.height-120, 108, 58);
    [togglebutton addTarget:self action:@selector(toggleDirection:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:togglebutton];
    
    [togglebutton setBackgroundImage:[UIImage imageNamed:@"BreathDirection_EXHALE.png"] forState:UIControlStateNormal];
    toggleIsON=NO;
    
    [[NSUserDefaults standardUserDefaults]setObject:@"exhale" forKey:@"direction"];
  
    
    currentlyExhaling = false;
     [gaugeView setBreathToggleAsExhale:currentlyExhaling isExhaling: midiController.toggleIsON];
    
    
}
-(void)draggable:(Draggable *)didDrag
{
    
    //900-330
    CGRect  frame=didDrag.frame;
    
    [gaugeView setBestDistanceWithY:900-frame.origin.y];
    
    // CGRect  newframe=[self.view convertRect:frame toView:gaugeView];
    
}
- (IBAction)toggleDirection:(id)sender
{
    if (!midiController) {
        midiController=[MidiController new];
    }
    switch (midiController.toggleIsON) {
        case 0:
            midiController.toggleIsON=YES;
            //  midiController.currentdirection=midiinhale;
            [togglebutton setBackgroundImage:[UIImage imageNamed:@"BreathDirection_INHALE.png"] forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults]setObject:@"inhale" forKey:@"direction"];
           // currentlyExhaling = false;
            break;
        case 1:
            midiController.toggleIsON=NO;
            
            [togglebutton setBackgroundImage:[UIImage imageNamed:@"BreathDirection_EXHALE.png"] forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults]setObject:@"exhale" forKey:@"direction"];
            //currentlyExhaling = true;
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
    NSLog(@"Simulating blow");
    
    
    float  vel=[_inputtext.text floatValue];
    if (vel==127) {
        return;
    }
    float scale=10.0f;
    float value=vel*scale;
    [gaugeView setForce:(value)];
    NSDate  *date=[NSDate date];
    
    if (vel>[currentSession.sessionStrength intValue]) {
        currentSession.sessionStrength=[NSNumber numberWithInt:vel];
    }
    
    double  duration=[date timeIntervalSinceDate:self.date];
    currentSession.sessionDuration=[NSNumber numberWithDouble:duration];
    NSString  *durationtext=[NSString stringWithFormat:@"%0.1f",duration];
    dispatch_async(dispatch_get_main_queue(), ^{
        scoreViewController.durationValueLabel.text=durationtext;
        [scoreViewController setStrength:vel/rangeReduction];   //added
        
    });
    
    
}
#pragma mark -
#pragma mark - Midi Delegate

-(void)midiNoteBegan:(MidiController*)midi
{
    //if (currentlyExhaling == true && midiController.toggleIsON || currentlyInhaling == true && midiController.toggleIsON == false){
    NSLog(@"MIDINOTEBEGAN");
    
  //  if ((currentlyExhaling == true && midiController.toggleIsON) || (currentlyInhaling == true && midiController.toggleIsON == false)){
        
        if (gaugeView.animationRunning) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_debugTextField setText:@"\nMidi Began"];
            
            });
            [self beginNewSession];
            [gaugeView blowingBegan];
        }
        
  //  }else{
    
    //    NSLog(@"DISALLOWED as blowing in wrong mode");
   // }

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
    NSLog(@"midiNoteContinuing currentlyExhaling %d", currentlyExhaling);
    NSLog(@"midiNoteContinuing currentlyInhaling %d", currentlyInhaling);
    
     if ((currentlyExhaling == true && midiController.toggleIsON) || (currentlyInhaling == true && midiController.toggleIsON == false)){
    
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
    
    if (vel>[currentSession.sessionStrength intValue]) {
        currentSession.sessionStrength=[NSNumber numberWithInt:vel];
        // [gaugeView setArrowPos:0];
    }
    
    double  duration=[date timeIntervalSinceDate:self.date];
    currentSession.sessionDuration=[NSNumber numberWithDouble:duration];
    NSString  *durationtext=[NSString stringWithFormat:@"%0.0f",duration];
    dispatch_async(dispatch_get_main_queue(), ^{
        scoreViewController.durationValueLabel.text=durationtext;
        [scoreViewController setStrength:vel/rangeReduction];
        // [self sendLogToOutput:@"conti"];
    });
         
     }else{
         NSLog(@"Disallowing");
     }
    
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
        self.date=[NSDate date];
        currentSession.sessionDate=self.date;
        currentSession.username=[[NSUserDefaults standardUserDefaults]valueForKey:@"currentusername"];
    }
    
}
-(void)endCurrentSessionTest
{
    
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
   // [highScoreViewController updateWithCurrentSession:currentSession];    //added removed this line
    

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
    effecttimer=[NSTimer timerWithTimeInterval:4 target:self selector:@selector(killSparks) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:effecttimer forMode:NSDefaultRunLoopMode];
    [self playSound];
    //[bellImageView startAnimating];
    [logoviewcontroller startAnimating];
    // [loginViewController updateUserStats:currentSession];
    
    //
    [highScoreViewController updateWithCurrentSession:currentSession];
    
    allowResetHighScore = YES;

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
    
    NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"bell" ofType:@"wav"];
    
    
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
