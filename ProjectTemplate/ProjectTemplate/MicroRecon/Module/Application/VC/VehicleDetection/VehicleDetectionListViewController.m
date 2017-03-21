//
//  VehicleDetectionListViewController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/3/14.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "VehicleDetectionListViewController.h"
#import "VehicleDetectionListView.h"
#import "VdResultModel.h"
#import "VehicleDetectionDesViewController.h"

@interface VehicleDetectionListViewController ()<VehicleDetectionListViewDelegate>

@property (nonatomic, strong) VehicleDetectionListView *vdListView;
@property (nonatomic, strong) NSMutableArray *carDataSource;

@end

@implementation VehicleDetectionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initall];
}
- (void)setCarDataSources:(NSArray *)carDataSource {
    
    _carDataSource = carDataSource;
    self.title = [[_carDataSource firstObject] hphm];
    self.vdListView.dataArray = [_carDataSource mutableCopy];
    [self soureArray:_carDataSource changeindex:YES];
}

- (void)setkkbh:(NSString *)kkbh withAllarr:(NSMutableArray *)arr {
    
    
    self.carDataSource = [NSMutableArray array];
    for (VdResultModel *model in arr) {
        if ([model.kkbh isEqualToString:kkbh]) {
            [self.carDataSource addObject:model];
        }
    }
    self.title = [[_carDataSource firstObject] hphm];
    self.vdListView.dataArray = [_carDataSource mutableCopy];
    [self soureArray:_carDataSource changeindex:NO];
    
}
#pragma mark -
#pragma mark 格式化数据

- (void)soureArray:(NSMutableArray *)array changeindex:(BOOL)changeindex {
    
    //将数据按照时间排序
    NSArray *results = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        VdResultModel *model1 = obj1;
        VdResultModel *model2 = obj2;
        NSComparisonResult result = [model1.jgsj compare:model2.jgsj];
        return result == NSOrderedAscending;
    }];
    
    NSString *time1;
    NSInteger i = 0;
    NSInteger count = results.count;
    for (VdResultModel *model in results) {
        NSString *time2 = [model.jgsj componentsSeparatedByString:@" "][0];
        if (changeindex) {
          model.kkindex =  (count - i);
        }
        if (![time1 isEqualToString:time2]) {
            [self.vdListView.titleArray addObject:time2];
            time1 = time2;
        }
        i++;
    }
    
    for (int i = 0; i < self.vdListView.titleArray.count; i++) {
        NSMutableArray *array = [NSMutableArray array];
        for (int j = 0; j < results.count; j++) {
            VdResultModel *model = results[j];
            NSString *time2 = [model.jgsj componentsSeparatedByString:@" "][0];
            if ([time2 isEqualToString:self.vdListView.titleArray[i]]) {
                
                [array addObject:model];
                
            }
            if (j == self.vdListView.titleArray.count-1) {
                [self.vdListView.dateDic setObject:array forKey:self.vdListView.titleArray[i]];
            }
        }
    }
    
    [self.vdListView reloadData];
    
}
- (void)initall {
    [self.view addSubview:self.vdListView];
}

- (VehicleDetectionListView *)vdListView {
    if (!_vdListView) {
        _vdListView = [[VehicleDetectionListView alloc] initWithFrame:CGRectMake(0, TopBarHeight, kScreenWidth, kScreenHeight-TopBarHeight)];
        _vdListView.delegate = self;
    }
    return _vdListView;
}
- (void)vehicleDetectionListView:(VehicleDetectionListView *)view vdResultModel:(VdResultModel *)mode {
    VehicleDetectionDesViewController *desController = [[VehicleDetectionDesViewController alloc] init];
    desController.model = mode;
    [self.navigationController pushViewController:desController animated:YES];
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
