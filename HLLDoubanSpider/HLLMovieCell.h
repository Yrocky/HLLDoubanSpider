//
//  HLLMovieCell.h
//  HLLDoubanSpider
//
//  Created by admin on 16/1/7.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLLMovie.h"

@interface HLLMovieCell : UITableViewCell

- (void) configureCellWithTOP250Movie:(HLLMovie *)movie;
- (void)configureCellWithWeekMovie:(HLLRankMovie *)movie;
- (void)configureCellWithNewMovie:(HLLMovie *)movie;
@end
