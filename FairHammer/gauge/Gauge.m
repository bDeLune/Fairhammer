//
//  Gauge.m
//  FairHammer
//
//  Created by barry on 09/07/2013.
//  Copyright (c) 2013 barry. All rights reserved.
//

#import "Gauge.h"
#import <QuartzCore/QuartzCore.h>

@interface Gauge ()
{
    float velocity;
    float distance;
    float time;
    float acceleration;// force/ mass
    BOOL  isaccelerating;
    float force;
    float mass;
    
    CADisplayLink *displayLink;
    
    NSDate *start;
    
    UIView  *animationObject;
    
    float h;
    float hm;
    float last_hm;
    float anim;
    float anim_delay;
    float weight;
    float bestDistance;
    bool setToInhale;
    bool currentlyExhaling;
    
    bool userBreathingCorrectly;
}

@end
@implementation Gauge


-(void)setMass:(float)value
{
    mass=value;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setDefaults];
        
        displayLink = [CADisplayLink displayLinkWithTarget:self
                                                  selector:@selector(animate)];
        
        start=[NSDate date];
        animationObject=[[UIView alloc]initWithFrame:self.bounds];
        [animationObject setBackgroundColor:[UIColor blueColor]];
        animationObject.layer.cornerRadius=16;
        [self addSubview:animationObject];
        
        isaccelerating=false;
        self.backgroundColor=[UIColor clearColor];
        self.layer.cornerRadius=16;
        
        mass=1;
        force=15;
       /** if (!animationRunning)
        {
            [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
            animationRunning = YES;
        }**/

    }
    return self;
}
-(void)setDefaults
{
    velocity=0.0;
    distance=0.1;
    time=0.1;
    acceleration=0.1;
   // mass=1;
//force=15;
    
    h=0;
    hm=0;
    anim_delay=0;
    bestDistance=0;
    isaccelerating=NO;

}
-(void)setBestDistanceWithY:(float)yValue
{
    bestDistance= yValue;
    
    NSLog(@"new dist == %f",bestDistance);
}

-(void)setBreathToggleAsExhale:(bool)value isExhaling: (bool)value2;{

    currentlyExhaling = value2;
    setToInhale = value;
   // NSLog(@"GAUGE: setToInhale == 0 / currentlyExhaling == 1");
    //NSLog(@"GAUGE: set - %d currentlyExhaling - %d", value2, value);
    
    if ((currentlyExhaling == 1 && setToInhale == 0) || (currentlyExhaling == 0 && setToInhale == 1)){
       // NSLog(@"CORRECT");
        userBreathingCorrectly = true;
      //   isaccelerating=YES;
    }else{
        userBreathingCorrectly = false;
         isaccelerating=NO;
    }
    
}


-(void)setForce:(float)pforce
{
    //NSLog(@"distancE %f - GUAGE_HEIGHT %d", distance, GUAGE_HEIGHT);
   // if (userBreathingCorrectly == true || distance > 525){
    force=(pforce/mass);
  //  hm++;
   // }
    
    ///NSLog(@"SET FORCE %f", pforce);
    
}
-(void)blowingBegan
{
   // NSLog(@"BLOW BEGAN isaccelerating %hhd", isaccelerating);
    isaccelerating=YES;
}
-(void)blowingEnded
{
   /// NSLog(@"BLOW ENDED isaccelerating %hhd", isaccelerating);

    isaccelerating=NO;

}
-(void)animate
{
   // [self setForce:_midiSource.velocity*100];
    
    ///NSLog(@"ANIMATING 1");

  //  if (userBreathingCorrectly == false){
   //    [self fallQuickly];
   //     return;
    
   // }
    
    if (isaccelerating) {
       // force+=500;
        
    }else
    {
        force-=force*0.03;
        acceleration-=acceleration*0.03;
        
//NSLog(@"Deccelerating %f ", acceleration);
        
    }
    

    if (force<1) {
        force=1;
    }
    
    acceleration= acceleration +( force/mass);    
    velocity = distance / time;
    
    time = distance / velocity;
    
    distance= ceilf((0.5)* (acceleration * powf(time, 2)));
    
    
      if (distance<GUAGE_HEIGHT) {
        CGRect frame=animationObject.frame;
        frame.origin.y=self.bounds.size.height-distance;
        frame.size.height=distance;
          
          if (distance>bestDistance) {
              
                CGRect frame2=_arrow.frame;
               frame2.origin.y=frame.origin.y-40;
              CGRect originInSuperview = [self convertRect:frame2 toView:self.superview];
              originInSuperview.origin.x=250;

               [_arrow setFrame:originInSuperview];
              bestDistance=distance;

          }
      
          
        //  if (userBreathingCorrectly == false){
          // [self fallQuickly];
        //      return;
        ///  }else{
              
              [animationObject setFrame:frame];
          
         // }
          
    }else
    {
        distance=GUAGE_HEIGHT;
        [self stop];
        [self fallQuickly];
        NSLog(@"MEANT TO FALL QUICKLY");
        [_gaugedelegate maxDistanceReached];

    }
    
    [self setNeedsDisplay];
    
    //1/2*a*t2
}
-(void)setArrowPos:(float)pforce
{
    force=(pforce/mass);
    
    
    NSLog(@"SETTING PFORCE %f", pforce);
    
   // acceleration= acceleration +( force/mass);
   // velocity = distance / time;
    
   // time = distance / velocity;
   // distance= ceilf((0.5)* (acceleration * powf(time, 2)));
    CGRect frame=animationObject.frame;
    frame.origin.y=self.bounds.size.height-distance;
    CGRect frame2=_arrow.frame;
    frame2.origin.y=frame.origin.y-40;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        CGRect originInSuperview = [self convertRect:frame2 toView:self.superview];
        originInSuperview.origin.x=250;
        [_arrow setFrame:originInSuperview];
       // [_arrow setFrame:frame2];

    });
    
}
-(void)stop
{
    if (_animationRunning) {
        [displayLink invalidate];
        _animationRunning=NO;
    }
}

-(void)start
{
  //  [self stop];
    
    NSLog(@"STARTING ANIMATION");
    
    [self setDefaults];
    if (!_animationRunning)
    {
        displayLink = [CADisplayLink displayLinkWithTarget:self
                                                  selector:@selector(animate)];
        [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        _animationRunning = YES;
    }
}
-(void)fallQuickly
{
    NSLog(@"FALLING QUICKLY!");
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         CGRect frame=animationObject.frame;
                         frame.origin.y=self.bounds.size.height-GUAGE_HEIGHT;
                         frame.size.height=distance;

                         
                         CGRect frame2=_arrow.frame;
                         frame2.origin.y=900;
                         frame2.origin.x=250;
                         
                         [_arrow setFrame:frame2];
                     }
                     completion:^(BOOL finished){
                         
                         [self stop];

                     }];}
@end
