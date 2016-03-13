//
//  DownloadDataTool.m
//  IQQ
//
//  Created by Miaolegemi on 15/12/12.
//  Copyright © 2015年 9527. All rights reserved.
//

#import "DownloadDataTool.h"

@implementation DownloadDataTool

-(BOOL)isNetWork
{
    return YES;
}

-(void)downloadWithUrl:(NSString *)strUrl
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:strUrl];
    NSURLSessionTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [self.myDelegate sendData:data];
    }];
    [dataTask resume];
}

@end
