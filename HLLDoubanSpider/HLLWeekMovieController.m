//
//  HLLWeekMovieController.m
//  HLLDoubanSpider
//
//  Created by admin on 16/1/7.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLLWeekMovieController.h"

#import "HLLRequestManager.h"
#import "HLLHTMLParseManager.h"
#import "HLLMovieCell.h"
#import <MJRefresh/MJRefresh.h>

@interface HLLWeekMovieController ()

@property (nonatomic ,strong) HLLRequestManager * requestManager;

@property (nonatomic ,strong) NSMutableArray * weekMovies;

@end

@implementation HLLWeekMovieController

- (NSMutableArray *)weekMovies{
    
    if (!_weekMovies) {
        _weekMovies = [NSMutableArray array];
    }
    return _weekMovies;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _requestManager = [[HLLRequestManager alloc] init];

    //
    [self reloadWeekMovieData];
    
    self.tableView.rowHeight = 44.0f;
    self.tableView.sectionHeaderHeight = 0.1f;
    
    //
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadWeekMovieData)];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.weekMovies.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"weekMovie" forIndexPath:indexPath];
    
    return cell;
}

- (void ) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

    HLLMovieCell * movieCell = (HLLMovieCell *)cell;
    
    [movieCell configureCellWithWeekMovie:self.weekMovies[indexPath.row]];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-  (void) reloadWeekMovieData{
    
    [_requestManager request_doubanWeekMovieWithResult:^(id data, NSError *error) {
        NSLog(@"++++++New Movie++++++");
        HLLHTMLParseManager * parserManager = [HLLHTMLParseManager shareParseManager];
        [parserManager parseasWeekMovieWithHTMLData:data andError:error result:^(NSString *dateRangeContext, NSArray *weekMovies, NSError *parseError) {
            
            if (self.weekMovies.count) {
                [self.weekMovies removeAllObjects];
            }
            [self.weekMovies addObjectsFromArray:weekMovies];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }];
    }];
}
@end
