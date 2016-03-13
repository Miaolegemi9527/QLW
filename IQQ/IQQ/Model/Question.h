//
//  Question.h
//  IQQ
//
//  Created by Miaolegemi on 15/12/12.
//  Copyright © 2015年 9527. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject

@property(nonatomic,strong) NSString *title;
@property(nonatomic,assign) NSInteger difficulty;
@property(nonatomic,strong) NSString *analysis;
@property(nonatomic,strong) NSArray *answers;

-(instancetype)initWithTitle:(NSString *)title difficulty:(NSInteger)difficulty analysis:(NSString *)analysis answers:(NSArray *)answers;
+(instancetype)questionWithTitle:(NSString *)title difficulty:(NSInteger)difficulty analysis:(NSString *)analysis answers:(NSArray *)answers;

@end
