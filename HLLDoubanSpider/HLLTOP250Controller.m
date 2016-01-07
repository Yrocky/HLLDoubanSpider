//
//  HLLTOP250Controller.m
//  HLLDoubanSpider
//
//  Created by admin on 16/1/7.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLLTOP250Controller.h"
#import <Ono/Ono.h>
#import "HLLRequestManager.h"
#import "HLLHTMLParseManager.h"
#import "HLLMovieCell.h"
#import <MJRefresh/MJRefresh.h>

@implementation NSString (Size)

+ (CGSize)sizeOfString:(NSString *)text withWidth:(float)width font:(UIFont *)font
{
    NSInteger ch;
    CGSize size = CGSizeMake(width, MAXFLOAT);
    
    if ([text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSDictionary *tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
        size = [text boundingRectWithSize:size
                                  options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                               attributes:tdic
                                  context:nil].size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        size = [text sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
#pragma clang diagnostic pop
    }
    ch = size.height;
    
    return size;
}
@end
@interface HLLTOP250Controller ()

@property (nonatomic ,strong) NSMutableArray * movies;

@property (nonatomic ,strong) NSMutableArray * cellHeights;
@end

@implementation HLLTOP250Controller

#pragma mark - lazy
- (NSMutableArray *)movies{

    if (!_movies) {
        _movies = [NSMutableArray array];
    }
    return _movies;
}

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    [self reloadTOP250MovieData];
    
    //
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(reloadTOP250MovieData)];
    self.tableView.mj_footer = footer;
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.movies.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    HLLMovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"movie" forIndexPath:indexPath];
    
    [cell configureCellWithTOP250Movie:self.movies[indexPath.row]];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - server
- (void) reloadTOP250MovieData{
    
    NSUInteger pageNumber = self.movies.count / 25 + 1;
    NSLog(@"%lu",(unsigned long)pageNumber);
    if (pageNumber > 10) {
        
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    [[HLLRequestManager shareRequestManager] request_doubanTOP250MovieWithPageNumber:pageNumber result:^(id data, NSError *error) {
        
        HLLHTMLParseManager * parseManager = [HLLHTMLParseManager shareParseManager];
        NSLog(@"++++++TOP250++++++");
        [parseManager parseasTOP250MovieWithHTMLData:data andError:error result:^(NSArray *movies, NSError *parseError) {

            [_movies addObjectsFromArray:movies];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        }];
    }];
    
}

@end
