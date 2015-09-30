//
//  Gauge.h
//  FairHammer
//
//  Created by barry on 09/07/2013.
//  Copyright (c) 2013 barry. All rights reserved.
//

#import <UIKit/UIKit.h>
#define GAUGE_WIDTH  100
#import "Draggable.h"
#define GUAGE_HEIGHT 575
@protocol GaugeProtocol <NSObject>
-(void)maxDistanceReached;

@end

@interface Gauge : UIView

@property(nonatomic,unsafe_unretained)id<GaugeProtocol>gaugedelegate;
@property BOOL animationRunning;
@property(nonatomic,weak)Draggable  *arrow;

-(void)start;
-(void)stop;
-(void)setForce:(float)pforce;
-(void)blowingBegan;
-(void)blowingEnded;
-(void)setArrowPos:(float)pforce;
-(void)setMass:(float)value;
-(void)setBestDistanceWithY:(float)yValue;
@end
