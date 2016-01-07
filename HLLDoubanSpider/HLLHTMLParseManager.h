//
//  HLLHTMLParseManager.h
//  HLLCodingNetFramework
//
//  Created by admin on 16/1/7.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLLMovie.h"

@interface HLLHTMLParseManager : NSObject

+ (instancetype) shareParseManager;

// TOP250
- (void)parseasTOP250MovieWithHTMLData:(NSData *)data andError:(NSError *)error result:(void (^)(NSArray * movies, NSError *error))result;

// 豆瓣新片榜
- (void) parseNewMovieWithHTMLData:(NSData *)data andError:(NSError *)error result:(void (^)(NSArray * movies ,NSError * parseError))result;

// 本周口碑榜
- (void) parseasWeekMovieWithHTMLData:(NSData *)data andError:(NSError *)error result:(void (^)(NSString * dateRangeContext ,NSArray * movies ,NSError * parseError))result;

@end
