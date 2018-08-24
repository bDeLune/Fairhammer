//
//  SecondViewController.h
//  GroovTube
//
//  Created by Culann Mac Cabe on 21/02/2013.
//  Copyright (c) 2013 Culann Mac Cabe. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "FirstViewController.h"

@interface SecondViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>
{
    IBOutlet UIPickerView *pickerViewA;
    IBOutlet UIPickerView *pickerViewB;
    IBOutlet UIPickerView *pickerViewC;
    IBOutlet UIPickerView *filterPicker;
    IBOutlet UISlider *rateSlider;
    
	NSMutableArray *arrayA;
    NSMutableArray *arrayB;
    NSMutableArray *arrayC;
    NSMutableArray *filterArray;
    
    id<SETTINGS_DELEGATE> __unsafe_unretained settinngsDelegate;
    
    IBOutlet UIPickerView *pickerResistance;
    IBOutlet UIPickerView *pickerThreshold;
    NSArray *arrayResistance;
    NSArray *arrayThreshold;
    IBOutlet UILabel   *btTresholdLabel;
    IBOutlet UILabel   *btrangeBoost;
    IBOutlet UISlider  *btThresholdSlider;
    IBOutlet UISlider  *btBoostSlider;
}

@property (unsafe_unretained) id<SETTINGS_DELEGATE> settinngsDelegate;
-(IBAction)changeRate:(id)sender;

@end
