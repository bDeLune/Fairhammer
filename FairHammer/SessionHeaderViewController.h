//
//  SessionHeaderViewController.h
//  FairHammer
//
//  Created by barry on 12/09/2013.
//  Copyright (c) 2013 barry. All rights reserved.
//

#import "FirstViewController.h"

@interface SessionHeaderViewController : FirstViewController
@property(nonatomic,strong)IBOutlet UILabel  *sessionDateLasel;
@property(nonatomic,strong)IBOutlet UIButton *addNoteButton;
@property(nonatomic,strong)NSDictionary  *userData;
-(IBAction)addNote:(id)sender;
@end
