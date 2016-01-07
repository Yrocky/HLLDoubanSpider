//
//  HLLRequestManager.h
//  HLLCodingNetFramework
//
//  Created by admin on 16/1/6.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DOUBAN_BASE_URL @"http://movie.douban.com"


typedef void(^requestResult)(id data,NSError * error);

@interface HLLRequestManager : NSObject

+ (instancetype) shareRequestManager;
/**
 *  模拟登陆的接口调用
 *
 *  @param name        登陆
 *  @param password    密码
 *  @param             以后这里将会使用登陆模型来传递
 *  @param result      网络请求结果
 */
- (void) request_loginWithUserName:(NSString *)name
                       andPassword:(NSString *)password
                            result:(requestResult)result;

- (void) request_doubanTOP250MovieWithPageNumber:(NSUInteger)pageNumber result:(requestResult)result;

- (void) request_doubanWeekMovieWithResult:(requestResult)result;

- (void) request_doubanNewMovieWithResult:(requestResult)result;
@end
