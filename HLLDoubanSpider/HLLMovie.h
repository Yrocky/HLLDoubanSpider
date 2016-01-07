//
//  HLLMovie.h
//  HLLCodingNetFramework
//
//  Created by admin on 16/1/7.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger , MovieRankStatus) {
    
    UP      = 0,
    DOWN    = 1
};
@interface HLLMovie : NSObject

@property (nonatomic ,assign) int rank;
@property (nonatomic ,copy) NSString * img;
@property (nonatomic ,copy) NSString * name;
@property (nonatomic ,copy) NSString * movieDesc;
@property (nonatomic ,assign) float score;
@property (nonatomic ,copy) NSString * commit;
@property (nonatomic ,copy) NSString * quote;

@end

@interface HLLRankMovie : HLLMovie
@property (nonatomic ,assign) int rankStep;
@property (nonatomic ,assign) MovieRankStatus rankStatus;
@end