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
@end

@interface HLLMovieCell (TOP250)
- (void) configureCellWithTOP250Movie:(HLLMovie *)movie;
@end

@interface HLLMovieCell (WeekMovie)
- (void)configureCellWithWeekMovie:(HLLRankMovie *)movie;
@end

@interface HLLMovieCell (NewMovie)
- (void)configureCellWithNewMovie:(HLLMovie *)movie;
@end