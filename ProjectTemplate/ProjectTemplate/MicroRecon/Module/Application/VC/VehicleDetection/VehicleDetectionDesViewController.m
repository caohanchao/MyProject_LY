//
//  VehicleDetectionDesViewController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/5.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "VehicleDetectionDesViewController.h"
#import "VdDesTableViewHeaderFooterView.h"
#import "VdDesHaveImageCell.h"
#import "VdDesNotHaveImageCell.h"
#import "HZImagesGroupView.h"
#import "HZPhotoItemModel.h"
#import "GetInfoCarRequest.h"
#import "VdLineDesNotHaveImageCell.h"

@interface VehicleDetectionDesViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *imageDataSource;
@property (nonatomic, strong) NSArray *titleDataSource;

@property (nonatomic, strong) NSArray *desDataSource;
@property (nonatomic, strong) NSArray *carImageDataSouce;
@end

@implementation VehicleDetectionDesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.title = @"鄂A NQ898";
    [self requestData];
    [self initall];
}

- (NSArray *)carImageDataSouce {
    if (!_carImageDataSouce) {
        _carImageDataSouce = [NSArray array];
    }
    return _carImageDataSouce;
}

- (NSArray *)desDataSource {
    if (!_desDataSource) {
        _desDataSource = [NSArray array];
    }
    return _desDataSource;
}

- (void)requestData {
    
    self.title = self.model.hphm;
    self.desDataSource = [GetInfoCarRequest configurationCellWithModel:self.model];
    if (![[LZXHelper isNullToString:self.model.gctx] isEqualToString:@""]) {
       self.carImageDataSouce = @[self.model.gctx];
    }

}

- (void)initall {
    [self initView];
}
- (NSArray *)imageDataSource {
    if (!_imageDataSource) {
        _imageDataSource = @[@"vd_kkNum",@"vd_chdNum",@"vd_chepai",@"vd_cheshen",@"vd_type",@"vd_carzht"];
    }
    return _imageDataSource;
}
- (NSArray *)titleDataSource {
    if (!_titleDataSource) {
        _titleDataSource = @[@"卡口名称",@"车道编号",@"车牌颜色",@"车身颜色",@"车辆类型",@"行驶状态"];
    }
    return _titleDataSource;
}
- (void)initView {
    [self.view addSubview:self.tableView];
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = CHCHexColor(@"f5f5f5");
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 6;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *indextifier = @"indextifier";
    if (indexPath.section == 0) {
        
        if (indexPath.row == self.imageDataSource.count-1) {
            VdLineDesNotHaveImageCell *cell = [tableView dequeueReusableCellWithIdentifier:indextifier];
            if (cell == nil) {
                cell = [[VdLineDesNotHaveImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indextifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.imageStr = self.imageDataSource[indexPath.row];
            cell.desStr = [NSString stringWithFormat:@"%@：%@",self.titleDataSource[indexPath.row],self.desDataSource[indexPath.row]];
            return cell;
        }
        VdDesNotHaveImageCell *cell = [tableView dequeueReusableCellWithIdentifier:indextifier];
        if (cell == nil) {
            cell = [[VdDesNotHaveImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indextifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
       
        cell.imageStr = self.imageDataSource[indexPath.row];
        cell.desStr = [NSString stringWithFormat:@"%@：%@",self.titleDataSource[indexPath.row],self.desDataSource[indexPath.row]];
        return cell;
    }else if (indexPath.section == 1) {
        VdDesHaveImageCell *cell = [tableView dequeueReusableCellWithIdentifier:indextifier];
        if (cell == nil) {
            cell = [[VdDesHaveImageCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:indextifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        NSArray *imageArray = @[@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1480921744&di=0be90680868101986ce33a5ea956c1e4&src=http://a.hiphotos.baidu.com/image/pic/item/730e0cf3d7ca7bcb42c304eaba096b63f724a8bf.jpg",@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1480921744&di=0be90680868101986ce33a5ea956c1e4&src=http://a.hiphotos.baidu.com/image/pic/item/730e0cf3d7ca7bcb42c304eaba096b63f724a8bf.jpg",@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1480921744&di=0be90680868101986ce33a5ea956c1e4&src=http://a.hiphotos.baidu.com/image/pic/item/730e0cf3d7ca7bcb42c304eaba096b63f724a8bf.jpg"];
        if (self.carImageDataSouce.count != 0) {
            HZImagesGroupView *imagesGroupView = [[HZImagesGroupView alloc] init];
            imagesGroupView.longPress = NO;
            NSMutableArray *temp = [NSMutableArray array];
            [self.carImageDataSouce enumerateObjectsUsingBlock:^(NSString *src, NSUInteger idx, BOOL *stop) {
                HZPhotoItemModel *item = [[HZPhotoItemModel alloc] init];
                item.thumbnail_pic = src;
                [temp addObject:item];
            }];
            cell.imageArray = [self.carImageDataSouce copy];
            imagesGroupView.photoItemArray = [temp copy];
            [cell.imageScrollView addSubview:imagesGroupView];
        }
        return cell;
 
    }
    return [UITableViewCell new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 45;
    }
    return 150;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 57;
    }
    return 16;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        VdDesTableViewHeaderFooterView *headerView = [VdDesTableViewHeaderFooterView headerViewWithTableView:tableView];
        [headerView setTimeText:self.model.jgsj];
        return headerView;
    }
   
    return [[UIView alloc] init];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
