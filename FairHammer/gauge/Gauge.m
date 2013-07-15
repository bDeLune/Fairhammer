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
    NSTimeInterval drawDuration;
    CFTimeInterval lastTime;
    CFTimeInterval starttime;
    
    CGFloat drawProgress;
    NSDate *start;
    
    UIView  *animationObject;
    
    float h;
    float hm;
    float last_hm;
    float anim;
    float anim_delay;
    float weight;
    

}

@end
@implementation Gauge

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
    velocity=0.1;
    distance=0.1;
    time=0.1;
    acceleration=0.1;
    mass=1;
    force=15;
    
    h=0;
    hm=0;
    anim_delay=0;
    weight=2.0;

}
-(void)setForce:(float)pforce
{
    force=(pforce/mass);
  //  hm++;
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
   // [self setForce:_midiSource.velocity*100];
      
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
          
          
          CGRect frame2=_arrow.frame;
          frame2.origin.y=frame.origin.y-40;
          [_arrow setFrame:frame2];
          
        [animationObject setFrame:frame];
    }else
    {
        distance=GUAGE_HEIGHT;
        [self stop];
        [self fallQuickly];

        [_gaugedelegate maxDistanceReached];

    }
    
    [self setNeedsDisplay];
    
    //1/2*a*t2
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
/**
 CGRect frame=animationObject.frame;
 frame.origin.y=self.bounds.size.height-distance;
 
 frame.size.height=distance;
 [animationObject setFrame:frame];
 */
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         CGRect frame=animationObject.frame;
                         frame.origin.y=self.bounds.size.height-1;
                         animationObject.frame=frame;
                         
                         CGRect frame2=_arrow.frame;
                         frame2.origin.y=self.bounds.size.height-1;
                         [_arrow setFrame:frame2];
                     }
                     completion:^(BOOL finished){
                         
                         
                     }];}
@end
