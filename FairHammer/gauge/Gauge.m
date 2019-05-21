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
    float mass;///
    float temp;
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
    }
    return self;
}
-(void)setDefaults
{
    velocity=0.0;
    distance=0.1;
    time=0.1;
    acceleration=0.1;
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
    if ((currentlyExhaling == 1 && setToInhale == 0) || (currentlyExhaling == 0 && setToInhale == 1)){
        userBreathingCorrectly = true;
    }else{
        userBreathingCorrectly = false;
         isaccelerating=NO;
    }
    
}

-(void)setForce:(float)pforce
{
    force=(pforce/mass);
}

-(void)blowingBegan
{
    isaccelerating=YES;
}

-(void)blowingEnded
{
    isaccelerating=NO;
}

-(void)animate
{
    if (isaccelerating) {
       // force+=500;
        
    }else
    {
        force-=force*0.03;
        acceleration-=acceleration*0.03;
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

        [animationObject setFrame:frame];
          
    }else{
        distance=GUAGE_HEIGHT;
        [self stop];
        [self fallQuickly];
        NSLog(@"MEANT TO FALL QUICKLY");
        [_gaugedelegate maxDistanceReached];
    }
    
    [self setNeedsDisplay];
}

-(void)setArrowPos:(float)pforce
{
    force=(pforce/mass);
    CGRect frame=animationObject.frame;
    frame.origin.y=self.bounds.size.height-distance;
    CGRect frame2=_arrow.frame;
    frame2.origin.y=frame.origin.y-40;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect originInSuperview = [self convertRect:frame2 toView:self.superview];
        originInSuperview.origin.x=250;
        [_arrow setFrame:originInSuperview];
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
    [self stop];}];
}
@end
