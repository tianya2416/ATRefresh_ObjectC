//
//  ATTableController.m
//  ATRefresh_ObjectC
//
//  Created by wangws1990 on 2020/5/12.
//  Copyright © 2020 wangws1990. All rights reserved.
//

#import "ATTableController.h"
#import "ATTableViewCell.h"
@interface ATTableController ()
@property (assign, nonatomic) ATRefreshOption option;
@property (strong, nonatomic) NSMutableArray *listData;
@end

@implementation ATTableController
+ (instancetype)vcWithOption:(ATRefreshOption )option{
    ATTableController *vc = [[[self class] alloc] init];
    vc.option = option;
    return  vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.listData= @[].mutableCopy;
    [self showNavTitle:@"玄幻"];
    [self setupRefresh:self.tableView option:self.option];
}
- (void)refreshData:(NSInteger)page{
    NSInteger count = 20;
    NSString *url = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/headline/T1348647853363/%@-%@.html",@((page - 1)*count),@(count)];
    [ATTool getData:url params:@{} success:^(id  _Nonnull object) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//动画看的更清楚
            if (page == 1) {
                [self.listData removeAllObjects];
            }
            NSArray *datas = [NSArray modelArrayWithClass:ATModel.class json:object];
            if (datas.count > 0) {
                [self.listData addObjectsFromArray:datas];
            }
            [self.tableView reloadData];
            [self endRefresh:datas.count > 0];
        });
    } failure:^(NSError * _Nonnull error) {
        [self endRefreshFailure];
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listData.count;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  UITableViewAutomaticDimension;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ATTableViewCell *cell = [ATTableViewCell cellForTableView:tableView indexPath:indexPath];
    cell.model = self.listData[indexPath.row];
    return cell;
}

@end
