//
//  WifiPwdViewController.m
//  ConfigWifiTool
//
//  Created by 吴志和 on 16/10/30.
//  Copyright © 2016年 吴志和. All rights reserved.
//

#import "WifiPwdViewController.h"
#import "WifiManager.h"

@interface WifiPwdViewController ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray<NSString *> *names;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL inSearch;

@end

@implementation WifiPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"wifi密码(点击复制密码)";
    
    CGRect searBarRect = CGRectMake(0, 0, self.view.bounds.size.width, 40);
    _searchBar = [[UISearchBar alloc] initWithFrame:searBarRect];
    _searchBar.showsCancelButton = YES;
    _searchBar.delegate = self;
    _searchBar.placeholder = @"输入wifi名进行搜索";
    [self.view addSubview:_searchBar];
    
    CGRect tableViewRect = CGRectMake(0, CGRectGetHeight(searBarRect), self.view.bounds.size.width, self.view.bounds.size.height - CGRectGetHeight(searBarRect) - 49 - 64);
    
    self.tableView = [[UITableView alloc] initWithFrame:tableViewRect style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.inSearch = YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    self.inSearch = NO;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar endEditing:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.names = [[WifiManager manager].wifis.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2];
    }];
    if (self.inSearch && self.searchBar.text.length > 0) {
        NSMutableArray *arr = @[].mutableCopy;
        for (NSString *name in self.names) {
            if ([name.lowercaseString containsString:self.searchBar.text.lowercaseString]) {
                [arr addObject:name];
            }
        }
        self.names = arr;
    }
    return self.names.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"WifiCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    NSString *name = [NSString stringWithFormat:@"%@", self.names[indexPath.row]];
    WiFiModel *model = [WifiManager manager].wifis[self.names[indexPath.row]];
    cell.textLabel.text = name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"密码:%@", model.pwd];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WiFiModel *model = [WifiManager manager].wifis[self.names[indexPath.row]];
    [UIPasteboard generalPasteboard].string = model.pwd;
}

@end
