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

- (void) request_doubanTOP250MovieWithPageNumber:(NSUInteger)pageNumber result:(requestResult)result;

- (void) request_doubanWeekMovieWithResult:(requestResult)result;

- (void) request_doubanNewMovieWithResult:(requestResult)result;
@end
