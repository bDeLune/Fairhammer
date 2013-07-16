//
//  SecondViewController.m
//  GroovTube
//
//  Created by Culann Mac Cabe on 21/02/2013.
//  Copyright (c) 2013 Culann Mac Cabe. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()
{
    UIImageView   *bgimage;
}
@end

@implementation SecondViewController
@synthesize settinngsDelegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Settings";
        self.tabBarItem.image = [UIImage imageNamed:@"Menu-Settings"];
        
        arrayA=[NSMutableArray arrayWithObjects:@"Small",@"Normal",@"Big", nil];
       arrayB=[NSMutableArray arrayWithObjects:@"Low",@"Normal",@"High",@"Very High", nil];

        arrayC=[NSMutableArray arrayWithObjects:@"10",@"50",@"100",@"200", nil];
        
        filterArray=[NSMutableArray arrayWithObjects:@"Bulge",@"Swirl",@"Blur", nil];
        
        arrayResistance=@[@"Low",@"Medium",@"High"];
        arrayThreshold=@[@"Low",@"Medium",@"High"];

      //  bgimage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"SettingsScreenBackground"]];
       // [self.view insertSubview:bgimage atIndex:0];

    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title=@"Settings";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -
#pragma mark Picker View Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
	
    
    int amount;
    
    if (thePickerView==pickerViewA) {
        amount=[arrayA count];
    }
    if (thePickerView==pickerViewB) {
        amount=[arrayB count];

    }
    if (thePickerView==pickerViewC) {
        amount=[arrayC count];

    }
    if (thePickerView==filterPicker) {
        amount=[filterArray count];
        
    }
    
    if (thePickerView==pickerResistance) {
        amount=[arrayResistance count];
        
    }
    
    if (thePickerView==pickerThreshold) {
        amount=[arrayThreshold count];
        
    }
	return amount;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	
    
    NSString *thetitle;
    
    if (thePickerView==pickerViewA) {
       thetitle=[arrayA objectAtIndex:row];
    }
    if (thePickerView==pickerViewB) {
        thetitle=[arrayB objectAtIndex:row];
        
    }
    if (thePickerView==pickerViewC) {
        thetitle=[arrayC objectAtIndex:row];
        
    }
    if (thePickerView==filterPicker) {
        thetitle=[filterArray objectAtIndex:row];
        
    }
    
    if (thePickerView==pickerResistance) {
        thetitle=[arrayResistance objectAtIndex:row];
        
    }
    
    if (thePickerView==pickerThreshold) {
        thetitle=[arrayThreshold objectAtIndex:row];
        
    }
	return thetitle;
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	
    
    
    if (thePickerView==pickerViewA) {
        NSLog(@"Selected : %@. Index of selected color: %i", [arrayA objectAtIndex:row], row);
        
        [self valueASend:row];
    }
    if (thePickerView==pickerViewB) {
        NSLog(@"Selected : %@. Index of selected color: %i", [arrayB objectAtIndex:row], row);
        [self valueBSend:row];

        
    }
    if (thePickerView==pickerViewC) {
        NSLog(@"Selected : %@. Index of selected color: %i", [arrayC objectAtIndex:row], row);
        [self valueCSend:row];

        
    }
    
    if (thePickerView==filterPicker) {
        NSLog(@"Selected : %@. Index of selected color: %i", [filterArray objectAtIndex:row], row);
        //[self.settinngsDelegate setFilter:row];
        
        
    }
    
    if (thePickerView==pickerViewA) {
        NSLog(@"Selected : %@. Index of selected color: %i", [arrayA objectAtIndex:row], row);
        
        [self valueASend:row];
    }
    if (thePickerView==pickerViewB) {
        NSLog(@"Selected : %@. Index of selected color: %i", [arrayB objectAtIndex:row], row);
        [self valueBSend:row];
        
        
    }
    if (thePickerView==pickerResistance) {
        NSLog(@"Selected : %@. Index of selected color: %i", [arrayResistance objectAtIndex:row], row);
        [self.settinngsDelegate setResitance:row];
        
        
    }
    
    if (thePickerView==pickerThreshold) {
        NSLog(@"Selected : %@. Index of selected color: %i", [arrayThreshold objectAtIndex:row], row);
        [self.settinngsDelegate setThreshold:row];
        
        
    }


}

-(IBAction)changeRate:(id)sender

{
  //  UISlider  *slider=(UISlider*)sender;
    //[self.settinngsDelegate setRate:slider.value];

}

/**
 
 C1  12
 C2  24
 C3  36
 C4  48
 D1  14
 D2  26
 D3  38
 D4  50
 E1  16
 E2  28
 E3  40
 E4  52
 F1  17
 F2  29
 F3  41
 F4  53
 **/
-(void)valueASend:(NSInteger)index
{
    
    int note =0;
    switch (index) {
        case 0:
            note=12;
            break;
        case 1:
            note=14;

            break;
        case 2:
            note=16;

            break;
            
        default:
            break;
    }
    
    
    [settinngsDelegate sendValue:note onoff:0];
}
-(void)valueBSend:(NSInteger)index
{
    int note =0;
    switch (index) {
        case 0:
            note=24;
            break;
        case 1:
            note=26;
            
            break;
        case 2:
            note=28;
            
            break;
        case 3:
            note=29;
            
            break;
            
        default:
            break;
    }
    
    
    [settinngsDelegate sendValue:note onoff:0];
}
-(void)valueCSend:(NSInteger)index
{
    int note =0;
    switch (index) {
        case 0:
            note=36;
            break;
        case 1:
            note=38;
            
            break;
        case 2:
            note=40;
            
            break;
        case 3:
            note=41;
            
            break;
            
        default:
            break;
    }
    
    
    [settinngsDelegate sendValue:note onoff:0];
}



/**
 
 
 void HandleNote(BYTE Note)
 {
 BOOL ToggleLed = TRUE;
 
 if (NextNoteIsOutNote || NextNoteIsInNote) {
 if (NextNoteIsOutNote) {
 setNotes(Note);
 FLASH_SaveParameters();
 //FLASH_WriteUserBytes(,Note);
 } else {
 MIDI_InBreathNote = Note;
 }
 NextNoteIsOutNote = FALSE;
 NextNoteIsInNote = FALSE;
 return;
 }
 switch (Note)
 {
 case C1:
 //LED2_TOGGLE;
 BREATH_SetHysterisis(BREATH_DEAD_ZONE_SMALL);
 break;
 case D1:
 //LED2_TOGGLE;
 BREATH_SetHysterisis(BREATH_DEAD_ZONE_NORMAL);
 break;
 case E1:
 //LED2_TOGGLE;
 BREATH_SetHysterisis(BREATH_DEAD_ZONE_BIG);
 break;
 case C2:
 //LED2_TOGGLE;
 BREATH_SetSensitivity(BREATH_SENSITIVITY_LOW);
 break;
 case D2:
 //LED2_TOGGLE;
 BREATH_SetSensitivity(BREATH_SENSITIVITY_NORMAL);
 break;
 case E2:
 //LED2_TOGGLE;
 BREATH_SetSensitivity(BREATH_SENSITIVITY_HIGH);
 break;
 case F2:
 //LED2_TOGGLE;
 BREATH_SetSensitivity(BREATH_SENSITIVITY_VERY_HIGH);
 break;
 case C3:
 //LED2_TOGGLE;
 BREATH_SetAcceptanceTime(BREATH_ACCEPTANCE_10);
 break;
 case D3:
 //LED2_TOGGLE;
 BREATH_SetAcceptanceTime(BREATH_ACCEPTANCE_50);
 break;
 case E3:
 //LED2_TOGGLE;
 BREATH_SetAcceptanceTime(BREATH_ACCEPTANCE_100);
 break;
 case F3:
 //LED2_TOGGLE;
 BREATH_SetAcceptanceTime(BREATH_ACCEPTANCE_200);
 break;
 case C4:
 NextNoteIsOutNote = TRUE;
 //LED2_TOGGLE;
 break;
 //case D4:
 //NextNoteIsInNote = TRUE;
 //LED2_TOGGLE;
 //      break;
 case E4:
 //LED2_TOGGLE;
 break;
 default:
 ToggleLed = FALSE;
 break;
 }
 if (ToggleLed) {
 if ((Note != C4) && (Note != D4)) {FLASH_SaveParameters();}
 LED2_ON;
 }
 }
 **/

@end