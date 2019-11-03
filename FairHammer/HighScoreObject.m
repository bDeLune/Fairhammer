//
//  HighScoreObject.m
//  FairHammer
//
//  Created by barry on 11/07/2013.
//  Copyright (c) 2013 barry. All rights reserved.
//

#import "HighScoreObject.h"
//
@implementation HighScoreObject


-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_duration forKey:@"duration"];
    [encoder encodeObject:_strength forKey:@"strength"];
    [encoder encodeObject:_username forKey:@"username"];

}

-(id)initWithCoder:(NSCoder *)decoder
{
    self.duration = [decoder decodeObjectForKey:@"duration"];
    self.strength = [decoder decodeObjectForKey:@"strength"];
    self.username = [decoder decodeObjectForKey:@"username"];

    return self;
}
@end
