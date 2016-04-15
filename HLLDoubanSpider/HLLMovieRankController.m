//
//  HLLMovieRankController.m
//  HLLDoubanSpider
//
//  Created by admin on 16/1/7.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLLMovieRankController.h"

#import "HLLRequestManager.h"
#import "HLLHTMLParseManager.h"
#import "HLLMovieCell.h"
#import <MJRefresh/MJRefresh.h>

@interface HLLMovieRankController ()

@property (nonatomic ,strong) HLLRequestManager * requestManager;

@property (nonatomic ,strong) NSMutableArray * newMovies;
@end

@implementation HLLMovieRankController

#pragma mark - lazy
- (NSMutableArray *)newMovies{

    if (!_newMovies) {
        _newMovies = [NSMutableArray array];
    }
    return _newMovies;
}


#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _requestManager = [[HLLRequestManager alloc] init];

    //
    [self loadMovieData];
    
    self.tableView.rowHeight = 160.0f;
    
    //
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:nil];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadMovieData)];
}

#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.newMovies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"newMovie" forIndexPath:indexPath];

    return cell;
}


- (void ) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HLLMovieCell * movieCell = (HLLMovieCell *)cell;
    
    [movieCell configureCellWithNewMovie:self.newMovies[indexPath.row]];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - server

- (void) loadMovieData{

    [self reloadNewMovieData];
}
- (void)reloadNewMovieData {
    
    [_requestManager request_doubanNewMovieWithResult:^(id data, NSError *error) {
        
        HLLHTMLParseManager * parseManager = [HLLHTMLParseManager shareParseManager];
        NSLog(@"++++++New Movie++++++");
        [parseManager parseNewMovieWithHTMLData:data andError:error result:^(NSArray *newMovies, NSError *parseError) {
            
            if (self.newMovies.count) {
                [self.newMovies removeAllObjects];
            }
            [self.newMovies addObjectsFromArray:newMovies];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        }];
    }];
}
@end
