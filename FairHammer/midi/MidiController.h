//
//  MidiController.h
//  FairHammer
//
//  Created by barry on 09/07/2013.
//  Copyright (c) 2013 barry. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MidiController;

@protocol MidiControllerProtocol <NSObject>

-(void)midiNoteBegan:(MidiController*)midi;
-(void)midiNoteStopped:(MidiController*)midi;
-(void)midiNoteContinuing:(MidiController*)midi;
-(void)sendLogToOutput:(NSString*)log;
@end

@interface MidiController : NSObject
{

   

}


@property(nonatomic,strong) UITextView  *outputtext;
@property  dispatch_source_t  aTimer;

@property int midiinhale;
@property int midiexhale;
@property float velocity;
@property int currentdirection;
@property BOOL midiIsOn;
@property BOOL toggleIsON;
@property (nonatomic,strong)NSDate  *date;
-(void)pause;
-(void)resume;



@property(nonatomic,unsafe_unretained)id<MidiControllerProtocol>delegate;

-(void)continueMidiNote:(int)pvelocity;
-(void)stopMidiNote;
-(void)midiNoteBegan:(int)direction vel:(int)pvelocity;
-(void)setup;
-(void)sendValue:(int)note onoff:(int)onoff;
@end
