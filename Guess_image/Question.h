//
//  Question.h
//  Guess_image
//
//  Created by apple on 6/19/15.
//  Copyright (c) 2015 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject
@property(nonatomic,copy)NSString *answer;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *icon;
@property(nonatomic,strong)NSArray *options;


-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)questionWithDict:(NSDictionary *)dict;


@end
