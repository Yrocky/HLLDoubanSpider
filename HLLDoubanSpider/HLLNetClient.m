//
//  HLLNetClient.m
//  HLLCodingNetFramework
//
//  Created by admin on 16/1/6.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLLNetClient.h"

@implementation HLLNetClient

static HLLNetClient *_instance;

+ (id)allocWithZone:(NSZone *)zone{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)shareClient{
    
    NSURL * baseUrl = [NSURL URLWithString:@"http://movie.douban.com"];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] initWithBaseURL:baseUrl];
    });
    return _instance;
}

- (id) initWithBaseURL:(NSURL *)url{

    self = [super initWithBaseURL:url];
    if (self) {
        
        // response
        self.responseSerializer = [AFHTTPResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html",@"application/xhtml+xml",@"application/xml",@"image/webp", nil];
        
        // 设置请求的头信息
        [self.requestSerializer setValue:randomUserAgent() forHTTPHeaderField:@"User-Agent"];
        [self.requestSerializer setValue:@"movie.douban.com" forHTTPHeaderField:@"Host"];
        
        // SSL
        self.securityPolicy.allowInvalidCertificates = NO;
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
@end
