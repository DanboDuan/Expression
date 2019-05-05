//
//  BenchmarkViewController.m
//  Demo
//
//  Created by bob on 2019/4/30.
//  Copyright © 2019 bob. All rights reserved.
//

#import "BenchmarkViewController.h"
#import "FeedModel.h"
#import "BenchmarkUtils.h"
#import "SectionModel.h"

#import <Expression/NSArray+Expression.h>

static NSString * const CellReuseIdentifier = @"UITableViewCell_ri";

@interface BenchmarkViewController ()

@property (nonatomic, strong) NSArray<SectionModel *> *feedList;

@end

@implementation BenchmarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:(UIBarButtonSystemItemRefresh) target:self action:@selector(updateBenckmark)];
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(updateBenckmark) forControlEvents:(UIControlEventValueChanged)];
    [self.refreshControl beginRefreshing];
    [self updateBenckmark];
}

- (void)updateBenckmark {
    self.feedList = [BenchmarkUtils loadBenchmarkPageFeedList];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.feedList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.feedList objectAtIndex:section].sectionList.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.feedList objectAtIndex:section].title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellReuseIdentifier];
    }
    SectionModel *section = [self.feedList objectAtIndex:indexPath.section];
    FeedModel *model = [section.sectionList objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%zd: %@",(NSInteger)(indexPath.row + 1),model.title];
    cell.detailTextLabel.text = model.subTitle;
    cell.detailTextLabel.textColor = model.subTitleColor;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

@end
