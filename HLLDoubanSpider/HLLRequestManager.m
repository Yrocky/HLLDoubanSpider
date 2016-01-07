//
//  HLLRequestManager.m
//  HLLCodingNetFramework
//
//  Created by admin on 16/1/6.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLLRequestManager.h"
#import "HLLNetClient.h"

@implementation HLLRequestManager

static HLLRequestManager *_instance;

+ (id)allocWithZone:(NSZone *)zone{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)shareRequestManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}
- (void) request_doubanTOP250MovieWithPageNumber:(NSUInteger)pageNumber result:(requestResult)result{

    NSDictionary * params;
    if (pageNumber > 1) {
        NSString * start = [NSString stringWithFormat:@"%lu",25 * (pageNumber - 1)];
        params = @{@"start":start,
                   @"filter":@""};
    }
    NSString * top250URL = [NSString stringWithFormat:@"%@/%@",DOUBAN_BASE_URL,@"top250"];
    [[HLLNetClient shareClient] GET:top250URL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (result) {
            result(responseObject,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (result) {
            result(nil,error);
        }
    }];
}

- (void) request_doubanWeekMovieWithResult:(requestResult)result{

    NSString * chart = [NSString stringWithFormat:@"%@/%@",DOUBAN_BASE_URL,@"chart"];
    
    [[HLLNetClient shareClient] GET:chart parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (result) {
            result(responseObject,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (result) {
            result(nil,error);
        }
    }];
}

- (void) request_doubanNewMovieWithResult:(requestResult)result{
    NSString * chart = [NSString stringWithFormat:@"%@/%@",DOUBAN_BASE_URL,@"chart"];
    
    [[HLLNetClient shareClient] GET:chart parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (result) {
            result(responseObject,nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (result) {
            result(nil,error);
        }
    }];
}

@end
