//
//  ATConnectionController.m
//  ATRefresh_ObjectC
//
//  Created by wangws1990 on 2020/5/12.
//  Copyright © 2020 wangws1990. All rights reserved.
//

#import "ATConnectionController.h"
#import "ATCollectionViewCell.h"
@interface ATConnectionController ()
@property (strong, nonatomic) NSMutableArray *listData;
@end

@implementation ATConnectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.listData= @[].mutableCopy;
    [self showNavTitle:@"玄幻"];
    [self setupRefresh:self.collectionView option:ATRefreshDefault];
}
- (void)refreshData:(NSInteger)page{
    NSInteger count = 20;
    NSString *url = [NSString stringWithFormat:@"http://c.m.163.com/nc/article/headline/T1348647853363/%@-%@.html",@((page - 1)*count),@(count)];
    [ATTool getData:url params:@{} success:^(id  _Nonnull object) {
        if (page == 1) {
            [self.listData removeAllObjects];
        }
        NSArray *datas = [NSArray modelArrayWithClass:ATModel.class json:object];
        if (datas.count > 0) {
            [self.listData addObjectsFromArray:datas];
        }
        [self.collectionView reloadData];
        [self endRefresh:datas.count > 0];
    } failure:^(NSError * _Nonnull error) {
        [self endRefreshFailure];
    }];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.listData.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (SCREEN_WIDTH - 3 *10 -1)/2;
    CGFloat height = width * 1.3 + 30;
    return CGSizeMake(width, height);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ATCollectionViewCell *cell = [ATCollectionViewCell cellForCollectionView:collectionView indexPath:indexPath];
    cell.model = self.listData[indexPath.row];
    return cell;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10,10,10,10);
}
@end
