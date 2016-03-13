//
//  Question.m
//  IQQ
//
//  Created by Miaolegemi on 15/12/12.
//  Copyright © 2015年 9527. All rights reserved.
//

#import "Question.h"

@implementation Question

-(instancetype)initWithTitle:(NSString *)title difficulty:(NSInteger)difficulty analysis:(NSString *)analysis answers:(NSArray *)answers
{
    self = [super init];
    if (self) {
        self.title = title;
        self.difficulty = difficulty;
        self.analysis = analysis;
        self.answers = answers;
    }
    return self;
}

+(instancetype)questionWithTitle:(NSString *)title difficulty:(NSInteger)difficulty analysis:(NSString *)analysis answers:(NSArray *)answers
{
    Question *question = [[Question alloc] initWithTitle:title difficulty:difficulty analysis:analysis answers:answers];
    return question;
}

@end
