//
//  SessionNoteViewController.h
//  FairHammer
//
//  Created by barry on 12/09/2013.
//  Copyright (c) 2013 barry. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SESSION_NOTE_ADDED_NOTIFY  @"session_note_added"
@interface SessionNoteViewController : UIViewController<UITextViewDelegate>
@property(nonatomic,weak)IBOutlet  UITextView  *textView;
@property(nonatomic,weak)IBOutlet  UIButton    *doneButton;
@property(nonatomic,weak)NSDictionary  *userdata;
@property(nonatomic,strong)NSString  *date;

-(IBAction)doneButtonHit:(id)sender;

@end
