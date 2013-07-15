//
//  LogoViewController.h
//  FairHammer
//
//  Created by barry on 15/07/2013.
//  Copyright (c) 2013 barry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogoViewController : UIViewController
@property(nonatomic,strong)IBOutlet  UIImageView *full;
@property(nonatomic,strong)IBOutlet  UIImageView *top;
@property(nonatomic,strong)IBOutlet  UIImageView *middle;
@property(nonatomic,strong)IBOutlet  UIImageView *bottom;
-(void)startAnimating;
-(void)stopAnimating;
@end
