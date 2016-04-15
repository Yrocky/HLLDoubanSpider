//
//  HLLTOP250Controller.m
//  HLLDoubanSpider
//
//  Created by admin on 16/1/7.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLLTOP250Controller.h"

#import "HLLRequestManager.h"
#import "HLLHTMLParseManager.h"
#import "HLLMovieCell.h"
#import <MJRefresh/MJRefresh.h>

@interface HLLTOP250Controller ()<UISearchResultsUpdating,UISearchBarDelegate>

@property (nonatomic ,strong) HLLRequestManager * requestManager;

@property (nonatomic ,copy) NSMutableArray * movies;
@property (readwrite, copy) NSArray *moviesResults;
@property (nonatomic, readwrite) NSMutableArray *tempMovies;

@property (nonatomic ,strong) NSArray * scopeButtonTitles;
@property (nonatomic ,strong) NSArray * filterContextArray;
@property (nonatomic ,strong) UISearchController * searchController;
@end

@implementation HLLTOP250Controller

#pragma mark - lazy
- (NSMutableArray *)movies{

    if (!_movies) {
        _movies = [NSMutableArray array];
    }
    return _movies;
}

- (NSMutableArray *)tempMovies{

    if (!_tempMovies) {
        _tempMovies = [NSMutableArray array];
    }
    return _tempMovies;
}
#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _requestManager = [[HLLRequestManager alloc] init];
    
    //
    [self reloadTOP250MovieData];
    
    //
    MJRefreshBackStateFooter *footer = [MJRefreshBackStateFooter footerWithRefreshingTarget:self refreshingAction:@selector(reloadTOP250MovieData)];
    self.tableView.mj_footer = footer;
    
    //
    self.tableView.rowHeight = UITableViewAutomaticDimension;// 根据auto layout进行高度的计算
    self.tableView.estimatedRowHeight = 163.0f;// 这个可以使用任意值，预估高度
    
    //
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    
    _scopeButtonTitles = @[@"演员",@"排名",@"评分",@"影名"];
    _filterContextArray = @[@"movieDesc",@"rank",@"score",@"name"];
    [self.searchController.searchBar sizeToFit];
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.scopeButtonTitles = _scopeButtonTitles;
    self.searchController.searchBar.selectedScopeButtonIndex = 0;
    self.searchController.searchBar.tintColor = [UIColor colorWithRed:0/255.0 green:109.0/255.0 blue:95.0/255.0 alpha:1];

    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    self.definesPresentationContext = YES;

}
#pragma mark - function
- (void) hll_filterMovieWithFilterString:(NSString *)filterString andScopeSelectedIndex:(NSUInteger)index{
 
    if (!filterString || filterString.length <= 0) {
        self.movies = self.tempMovies;
        self.moviesResults = [self.movies copy];
    }else{
        NSPredicate * filterPredicate = [NSPredicate predicateWithFormat:@"%K contains %@",self.filterContextArray[index],filterString];

        self.movies = [[self.moviesResults filteredArrayUsingPredicate:filterPredicate] mutableCopy];
    }
    [self.tableView reloadData];
}
#pragma mark -
#pragma mark UISearchBarDelegate
- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar{

    [self hll_filterMovieWithFilterString:nil andScopeSelectedIndex:searchBar.selectedScopeButtonIndex];
}

#pragma mark UISearchResultsUpdating
// Called when the search bar's text or scope has changed or when the search bar becomes first responder.
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{

    if (!searchController.active) {
        return;
    }
    [self hll_filterMovieWithFilterString:searchController.searchBar.text andScopeSelectedIndex:searchController.searchBar.selectedScopeButtonIndex];
}
#pragma mark - UITableViewDataSource & UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    if (self.movies.count == 0 && indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"PlaceholderCell" forIndexPath:indexPath];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"movie" forIndexPath:indexPath];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{

    HLLMovieCell * movieCell = (HLLMovieCell *)cell;
    
    [movieCell configureCellWithTOP250Movie:self.movies[indexPath.row]];
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - server
- (void) reloadTOP250MovieData{

    MJRefreshBackStateFooter * footer = (MJRefreshBackStateFooter *)self.tableView.mj_footer;
//    footer.stateLabel.hidden = self.searchController.active;
    
//    footer.hidden = self.searchController.active;
    
    if (self.searchController.active) {
//        footer.state = MJRefreshStateRefreshing;
        return;
    }
    NSUInteger pageNumber = self.movies.count / 25 + 1;
    NSLog(@"%lu",(unsigned long)pageNumber);
    if (pageNumber > 10) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    [_requestManager request_doubanTOP250MovieWithPageNumber:pageNumber result:^(id data, NSError *error) {
        
        HLLHTMLParseManager * parseManager = [HLLHTMLParseManager shareParseManager];
        NSLog(@"++++++TOP250++++++");
        [parseManager parseasTOP250MovieWithHTMLData:data andError:error result:^(NSArray *movies, NSError *parseError) {

            [self.movies addObjectsFromArray:movies];
            [self.tempMovies addObjectsFromArray: movies];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        }];
    }];
    
}

@end
