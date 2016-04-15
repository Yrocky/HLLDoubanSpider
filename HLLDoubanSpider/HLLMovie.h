//
//  HLLMovie.h
//  HLLCodingNetFramework
//
//  Created by admin on 16/1/7.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger , MovieRankStatus) {
    
    UP      = 0,// 排名上升
    DOWN    = 1,// 排名下降
    NONE    = 2 // 排名没变
};
@interface HLLMovie : NSObject

@property (nonatomic ,copy) NSString * rank;
@property (nonatomic ,copy) NSString * img;
@property (nonatomic ,copy) NSString * name;
@property (nonatomic ,copy) NSString * movieDesc;
@property (nonatomic ,copy) NSString * score;
@property (nonatomic ,copy) NSString * commit;
@property (nonatomic ,copy) NSString * quote;

@property (nonatomic ,strong) UIImage * image;
@end

@interface HLLRankMovie : HLLMovie
@property (nonatomic ,assign) int rankStep;
@property (nonatomic ,assign) MovieRankStatus rankStatus;
@end