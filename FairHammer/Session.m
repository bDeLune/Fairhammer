//
//  Session.m
//  FairHammer
//
//  Created by barry on 11/07/2013.
//  Copyright (c) 2013 barry. All rights reserved.
//

#import "Session.h"

@implementation Session

-(id)init
{
    self=[super init];
    
    if (self) {
        _sessionDate=[NSDate date];
        _sessionStrength=[NSNumber numberWithFloat:0.0];
        _sessionDuration=[NSNumber numberWithFloat:0.0];
    }
    
    return self;
}

-(void)updateStrength:(float)pvalue
{
    if (pvalue>[_sessionStrength floatValue]) {
        _sessionStrength=[NSNumber numberWithFloat:pvalue];
    }
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_sessionDate forKey:@"sessionDate"];
    [encoder encodeObject:_sessionDuration forKey:@"sessionDuration"];
    [encoder encodeObject:_sessionStrength forKey:@"sessionStrength"];
    [encoder encodeObject:_username forKey:@"username"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self.sessionDate = [decoder decodeObjectForKey:@"sessionDate"];
    self.sessionStrength = [decoder decodeObjectForKey:@"sessionStrength"];
    self.username = [decoder decodeObjectForKey:@"username"];
    self.sessionDuration = [decoder decodeObjectForKey:@"sessionDuration"];
    return self;
}

@end
