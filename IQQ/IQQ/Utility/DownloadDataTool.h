//
//  DownloadDataTool.h
//  IQQ
//
//  Created by Miaolegemi on 15/12/12.
//  Copyright © 2015年 9527. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol sendDataDelegate <NSObject>

-(void)sendData:(NSData *)data;

@end

@interface DownloadDataTool : NSObject

-(void)downloadWithUrl:(NSString *)strUrl;
@property(nonatomic,weak)id<sendDataDelegate>myDelegate;

@end
