//
//  BTLEManager.h
//  GrooveTubeMelodySmart
//
//  Created by barry on 19/08/2015.
//  Copyright (c) 2015 rocudo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MAX_INHALE 1000
#define MAX_EXHALE 3000

typedef enum BT_LE_State:NSUInteger

{
    BTLEState_Beginnging,
    BTLEState_Began,
    BTLEState_Stopping,
    BTLEState_Stopped

}BT_LE_State;
@class BTLEManager;

@protocol BTLEManagerDelegate <NSObject>

-(void)btleManagerBreathBegan:(BTLEManager*)manager;
-(void)btleManagerBreathStopped:(BTLEManager*)manager;

-(void)btleManagerConnected:(BTLEManager*)manager;
-(void)btleManagerDisconnected:(BTLEManager*)manager;

-(void)btleManager:(BTLEManager*)manager inhaleWithValue:(float)percentOfmax;
-(void)btleManager:(BTLEManager*)manager exhaleWithValue:(float)percentOfmax;


@end

@interface BTLEManager : NSObject
-(void)startWithDeviceName:(NSString*)deviceName andPollInterval:(float)interval;
-(void)stop;
-(void)requestData;
@property(nonatomic,unsafe_unretained)id<BTLEManagerDelegate>delegate;
@property BT_LE_State  btleState;
@end
