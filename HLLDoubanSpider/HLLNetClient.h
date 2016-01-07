//
//  HLLNetClient.h
//  HLLCodingNetFramework
//
//  Created by admin on 16/1/6.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSUInteger , NetworkMethodType) {

    GET     = 0,
    POST    = 1,
    PUT     = 2,
    DELETE  = 3
};
typedef void(^ResultBlock)(id data,NSError * error);

@interface HLLNetClient : AFHTTPSessionManager

+ (instancetype) shareClient;
@end
