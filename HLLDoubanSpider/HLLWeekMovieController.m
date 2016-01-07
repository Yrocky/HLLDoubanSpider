//
//  HLLWeekMovieController.m
//  HLLDoubanSpider
//
//  Created by admin on 16/1/7.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLLWeekMovieController.h"

#import <Ono/Ono.h>
#import "HLLRequestManager.h"
#import "HLLHTMLParseManager.h"
#import "HLLMovieCell.h"
#import <MJRefresh/MJRefresh.h>


@interface HLLWeekMovieController ()
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
    
    //
    [self reloadWeekMovieData];
    
    //
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadWeekMovieData)];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.weekMovies.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HLLMovieCell *cell ;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"weekMovie" forIndexPath:indexPath];
    [cell configureCellWithWeekMovie:self.weekMovies[indexPath.row]];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.1f;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44.0f;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-  (void) reloadWeekMovieData{
    
    [[HLLRequestManager shareRequestManager] request_doubanWeekMovieWithResult:^(id data, NSError *error) {
        
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
