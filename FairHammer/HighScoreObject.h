//
//  HighScoreObject.h
//  FairHammer
//
//  Created by barry on 11/07/2013.
//  Copyright (c) 2013 barry. All rights reserved.
//

#import <Foundation/Foundation.h>
//
@interface HighScoreObject : NSObject<NSCoding>
@property(nonatomic,strong)NSNumber  *strength;
@property(nonatomic,strong)NSNumber  *duration;
@property(nonatomic,strong)NSString  *username;
@end
