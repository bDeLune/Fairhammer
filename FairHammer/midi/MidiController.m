//
//  MidiController.m
//  FairHammer
//
//  Created by barry on 09/07/2013.
//  Copyright (c) 2013 barry. All rights reserved.
//

#import "MidiController.h"
#import <CoreMIDI/CoreMIDI.h>
#import <AudioToolbox/AudioToolbox.h>
static void	MyMIDIReadProc(const MIDIPacketList *pktlist, void *refCon, void *connRefCon);
void MyMIDINotifyProc (const MIDINotification  *message, void *refCon);
@interface MidiController ()
{
    int inorout;
    
    
    
    MIDIPortRef inPort ;
    MIDIPortRef outPort ;
    
    MIDIClientRef client;
    BOOL  ispaused;
}

@end
@implementation MidiController

-(void)setup
{

    _midiinhale=61;
    _midiexhale=73;
    _velocity=0;
    //_zerocount=0;
    _midiIsOn=false;
    [self setupMIDI];
    
    

}
-(void)pause
{
    ispaused=YES;
}
-(void)resume
{
    ispaused=NO;
}
#pragma mark - midi
-(void) setupMIDI {
    [_delegate sendLogToOutput:@"Midi setup"];

    client = NULL;
	MIDIClientCreate(CFSTR("Midi Client"), MyMIDINotifyProc,(__bridge void*) self, &client);
	
    inPort = NULL;
    outPort = NULL;
    
	MIDIInputPortCreate(client, CFSTR("Input port"), MyMIDIReadProc,(__bridge void*)  self, &inPort);
	MIDIOutputPortCreate(client, (CFStringRef)@"Output Port", &outPort);
	unsigned long sourceCount = MIDIGetNumberOfSources();
	for (int i = 0; i < sourceCount; ++i) {
		MIDIEndpointRef src = MIDIGetSource(i);
		CFStringRef endpointName = NULL;
		OSStatus nameErr = MIDIObjectGetStringProperty(src, kMIDIPropertyName, &endpointName);
		if (noErr == nameErr) {
		}
		MIDIPortConnectSource(inPort, src, NULL);
	}
	
}

-(void)reset
{

}

-(void)midiNoteBegan:(int)direction vel:(int)pvelocity

{
    if (ispaused) {
        return;
    }
    inorout=direction;
    
    if (_toggleIsON==YES) {
        if (inorout==_midiinhale) {
            inorout=_midiexhale;
        }else if(inorout==_midiexhale)
        {
            inorout=_midiinhale;;
            
        }
    }
    _velocity=pvelocity;

    _date=[NSDate date];
    [_delegate midiNoteBegan:self];
    
}



-(void)continueMidiNote:(int)pvelocity
{
    
    if (ispaused) {
        return;
    }
    self.velocity=pvelocity;
    [_delegate midiNoteContinuing:self];
    
    
    
}
-(void)stopMidiNote
{
    
    if (ispaused) {
        return;
    }
    _midiIsOn=NO;

   // self.velocity=0.1;
    [_delegate midiNoteStopped:self];


}

#pragma mark MIDI Output
- (IBAction) sendMidiData
{
    [self performSelectorInBackground:@selector(sendMidiDataInBackground) withObject:nil];
}
-(void)sendValue:(int)note onoff:(int)onoff
{
    const UInt8 noteOn[]  = { 0x90, note, 127 };
    // const UInt8 noteOff[] = { 0x80, note, 0   };
    [_delegate sendLogToOutput:@"got this 127"];
    [self sendBytes:noteOn size:sizeof(noteOn)];
    [NSThread sleepForTimeInterval:0.1];
    // [self sendBytes:noteOff size:sizeof(noteOff)];
    
    
}


- (void) sendPacketList:(const MIDIPacketList *)packetList
{
    for (ItemCount index = 0; index < MIDIGetNumberOfDestinations(); ++index)
    {
        MIDIEndpointRef outputEndpoint = MIDIGetDestination(index);
        if (outputEndpoint)
        {
            // Send it
            MIDISend(outPort, outputEndpoint, packetList);
            // NSLogError(s, @"Sending MIDI");
        }
    }
}

- (void) sendBytes:(const UInt8*)data size:(UInt32)size
{
    // NSLog(@"%s(%u bytes to core MIDI)", __func__, unsigned(size));
    assert(size < 65536);
    Byte packetBuffer[size+100];
    MIDIPacketList *packetList = (MIDIPacketList*)packetBuffer;
    MIDIPacket     *packet     = MIDIPacketListInit(packetList);
    
    packet = MIDIPacketListAdd(packetList, sizeof(packetBuffer), packet, 0, size, data);
    
    [self sendPacketList:packetList];
}

static void	MyMIDIReadProc(const MIDIPacketList *pktlist, void *refCon, void *connRefCon)
{
	
	MidiController *vc = (__bridge MidiController*) refCon;
    
	
	MIDIPacket *packet = (MIDIPacket *)pktlist->packet;
	int midiCommand = packet->data[0] >> 4;
    int note = packet->data[1] & 0x7F;
    int veolocity = packet->data[2] & 0x7F;

    if (midiCommand == 0x09) {
        vc.midiIsOn=YES;
        

        [vc midiNoteBegan:note vel:veolocity];
    }
    
    if (midiCommand==11) {
        
        if (note==2) {
            
            if (veolocity==0) {
              //  [vc stopMidiNote];

            }else
            {
                [vc continueMidiNote:veolocity];

            }


       
         
                        
        }else
        {
            //ended
            

            [vc stopMidiNote];
           
            
        }
    }
    
   // [vc.delegate sendLogToOutput:[NSString stringWithFormat:
                               //   @"Command =%d ,Note=%d, Velocity=%d",midiCommand, note, veolocity]];

	
}
void MyMIDINotifyProc (const MIDINotification  *message, void *refCon) {
	/**ViewController *vc = (__bridge ViewController*) refCon;
     [vc appendToTextView:[NSString stringWithFormat:
     @"MIDI Notify, messageId=%ld,", message->messageID]];**/
	
}
@end
