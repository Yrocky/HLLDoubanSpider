//
//  HLLRequestManager.m
//  HLLCodingNetFramework
//
//  Created by admin on 16/1/6.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLLRequestManager.h"
#import "AFNetworking.h"

@interface HLLRequestManager ()

@property (nonatomic ,strong) AFHTTPSessionManager * sessionManager;

@end

@implementation HLLRequestManager

- (id) init{
    
    self = [super init];
    if (self) {
        
        _sessionManager = [[AFHTTPSessionManager alloc] init];
        
        // response
        self.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html",@"application/xhtml+xml",@"application/xml",@"image/webp", nil];
        
        // 设置请求的头信息
        [self.sessionManager.requestSerializer setValue:randomUserAgent() forHTTPHeaderField:@"User-Agent"];
        [self.sessionManager.requestSerializer setValue:@"movie.douban.com" forHTTPHeaderField:@"Host"];
        
        // SSL
        self.sessionManager.securityPolicy.allowInvalidCertificates = NO;
    }
    return self;
}

NSString * randomUserAgent(){
    
    NSArray * userAgents = @[@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36",
                             @"Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/35.0.1916.114 Safari/537.36",
                             @"Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:36.0) Gecko/20100101 Firefox/36.0",
                             @"Mozilla/5.0 (Windows NT 6.2; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/27.0.1453.94 Safari/537.36",
                             @"Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10_6_6; en-US) AppleWebKit/533.20.25 (KHTML, like Gecko) Version/5.0.4 Safari/533.20.27"];
    return userAgents[arc4random() % userAgents.count];
}

#pragma mark - Request -

- (void) request_doubanTOP250MovieWithPageNumber:(NSUInteger)pageNumber result:(requestResult)result{

    NSDictionary * params;
    if (pageNumber > 1) {
        NSString * start = [NSString stringWithFormat:@"%lu",25 * (pageNumber - 1)];
        params = @{@"start":start,
                   @"filter":@""};
    }
    NSString * top250URL = [NSString stringWithFormat:@"%@/%@",DOUBAN_BASE_URL,@"top250"];
    [self.sessionManager GET:top250URL parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    
    [self.sessionManager GET:chart parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
    
    [self.sessionManager GET:chart parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
