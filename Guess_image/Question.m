//
//  Question.m
//  Guess_image
//
//  Created by apple on 6/19/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import "Question.h"

@implementation Question
-(instancetype)initWithDict:(NSDictionary *)dict
{
    if(self = [super init]){
        self.icon = dict[@"icon"];
        self.title = dict[@"title"];
        self.answer = dict[@"answer"];
        self.options = dict[@"options"];
        
    }
    return self;
}


+(instancetype)questionWithDict:(NSDictionary *)dict
{
    return [[self alloc]initWithDict:dict];
    
    
    
}
@end
