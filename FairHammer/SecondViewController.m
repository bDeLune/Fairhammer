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
-(IBAction)changeBTTreshold:(id)sender
{
    [self.settinngsDelegate setBTTreshold:btThresholdSlider.value];
    
    [btTresholdLabel setText:[NSString stringWithFormat:@"%f",btThresholdSlider.value]];

}
-(IBAction)changeBTBoostValue:(id)sender
{
    [self.settinngsDelegate setBTBoost:btBoostSlider.value];
    [btrangeBoost setText:[NSString stringWithFormat:@"%f",btBoostSlider.value]];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Settings";
        self.tabBarItem.image = [UIImage imageNamed:@"Menu-Settings"];
        
        arrayA=[NSMutableArray arrayWithObjects:@"Small",@"Normal",@"Big",@"Very Big", nil];
        arrayB=[NSMutableArray arrayWithObjects:@"Low",@"Normal",@"High",@"Very High", nil];
        arrayC=[NSMutableArray arrayWithObjects:@"10",@"50",@"100",@"200", nil];
        filterArray=[NSMutableArray arrayWithObjects:@"Bulge",@"Swirl",@"Blur", nil];
        arrayResistance=@[@"Low",@"Medium",@"High"];
        arrayThreshold=@[@"Low",@"Medium",@"High",@"Very High"];

    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title=@"Settings";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

#pragma mark -
#pragma mark Picker View Methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
	return 1;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *tView = (UILabel*)view;
    if (!tView)
    {
        tView = [[UILabel alloc] init];
        [tView setTextColor:[UIColor whiteColor]];
        [tView setFont:[UIFont fontWithName:@"font-name-here" size:15]];
        [tView setTextAlignment:NSTextAlignmentCenter];
    }
    // Fill the label text here
    return tView;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
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

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

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
        NSLog(@"SelectedfilterPicker : %@. Index of selected color: %i", [filterArray objectAtIndex:row], row);
    }
    
    if (thePickerView==pickerViewA) {
        NSLog(@"SelectedA : %@. Index of selected color: %i", [arrayA objectAtIndex:row], row);
        [self valueASend:row];
    }
    if (thePickerView==pickerViewB) {
        NSLog(@"SelectedB : %@. Index of selected color: %i", [arrayB objectAtIndex:row], row);
        [self valueBSend:row];
    }
    
    if (thePickerView==pickerResistance) {
        NSLog(@"SelectedpickerResistance : %@. Index of selected color: %i", [arrayResistance objectAtIndex:row], row);
        [self.settinngsDelegate setResitance:row];
    }
    
    if (thePickerView==pickerThreshold) {
        NSLog(@"Selected : %@. Index of selected color: %i", [arrayThreshold objectAtIndex:row], row);
        NSString *difficulty= [arrayThreshold objectAtIndex:row];
        [[NSUserDefaults standardUserDefaults]setObject:difficulty forKey:@"difficulty"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self.settinngsDelegate setThreshold:row];
        [self.settinngsDelegate setResitance:row];
    }
}

-(IBAction)changeRate:(id)sender
{

}

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

@end
