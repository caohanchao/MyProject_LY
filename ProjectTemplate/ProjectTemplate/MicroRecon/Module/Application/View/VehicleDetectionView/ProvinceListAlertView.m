//
//  ProvinceListAlertView.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/3/13.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "ProvinceListAlertView.h"
#import "ProvinceListCollectionViewCell.h"
#import "ProvinceListModel.h"


@interface ProvinceListAlertView ()<UICollectionViewDelegate, UICollectionViewDataSource> {
    CGPoint _arrowStartPoint;
 
}

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIControl *overlayView;

@property (nonatomic, weak) ProvinceListModel *tempModel;

@end

@implementation ProvinceListAlertView

- (instancetype)init {
    self = [super init];
    if (self) {
        
        [self initall];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initall];
    }
    return self;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)initall {
    self.backgroundColor = zClearColor;
    self.frame = CGRectMake(0, 0, kScreenWidth-24, HEIGHT_H);
    self.direction = TriangleDirection_Up;
    self.borderWidth = 0.5;
    self.borderColor = CHCHexColor(@"eeeeee");
    self.cornerRadius = 5;
    self.color = CHCHexColor(@"f5f5f5");
    self.triangleXY = 20;
    [self addSubview:self.collectionView];
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:[self getDataSource]];
    
    //加入覆盖背景
    self.overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.overlayView.backgroundColor = [UIColor colorWithColor:CHCHexColor(@"000000") alpha:0.5];
    
    [self.overlayView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
}

- (NSMutableArray *)getDataSource {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"province_abbr_list" ofType:@"plist"];
    NSMutableArray *plist = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    NSMutableArray *dataArr = [NSMutableArray array];
    for (NSString *name in plist) {
        ProvinceListModel *model = [[ProvinceListModel alloc] init];
        model.name = name;
        if ([name isEqualToString:@"鄂"]) {
            model.select = YES;
            self.tempModel = model;
            
        }else {
            model.select = NO;
        }
        [dataArr addObject:model];
    }
    return dataArr;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        //此处必须要有创见一个UICollectionViewFlowLayout的对象
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        //同一行相邻两个cell的最小间距
        layout.minimumInteritemSpacing = 5;
        //最小两行之间的间距
        layout.minimumLineSpacing = 5;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, width(self.frame)-16, HEIGHT_H-36) collectionViewLayout:layout];
        _collectionView.backgroundColor = zClearColor;
        _collectionView.delegate=self;
        _collectionView.dataSource=self;
        [_collectionView registerClass:[ProvinceListCollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCell"];
    }
    return _collectionView;
}
//一共有多少个组

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

//每一组有多少个cell
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dataArray.count;
    
}

//每一个cell是什么
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ProvinceListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    cell.model = self.dataArray[indexPath.item];
    
    WeakSelf
    cell.block = ^(ProvinceListCollectionViewCell *cell, NSInteger item){
        weakSelf.tempModel.select = NO;
        
        ProvinceListModel *model = weakSelf.dataArray[indexPath.item];
        weakSelf.tempModel = model;
        model.select = YES;
        
        [weakSelf.collectionView reloadData];
        
        [weakSelf dismiss];
    };
    return cell;
    
}
//每一个分组的上左下右间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(2.5, 2.5, 2.5, 2.5);
    
}
//定义每一个cell的大小

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(34, 34);
    
}


- (void)showInPoint:(CGPoint)point {
    [super showInPoint:point];
    _arrowStartPoint = point;
    
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    [keywindow addSubview:self.overlayView];
    [keywindow addSubview:self];
   
    
    self.alpha = 0.0;
    self.collectionView.alpha = 0.0;
    
    CGRect toFrame1 = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), kScreenWidth-24, HEIGHT_H);
    CGRect toFrame2 = CGRectMake(6, 32, kScreenWidth-24-16, HEIGHT_H-36);
    
    self.frame = (CGRect){CGRectGetMinX(self.frame) +_arrowStartPoint.x, CGRectGetMinY(self.frame), 0, 0};
    self.collectionView.frame = CGRectMake(6, 32, 0, 0);
    
    [UIView animateWithDuration:0.2
                     animations:^(void) {
                         
                         self.alpha = 1.0f;
                         self.frame = toFrame1;
                         
                         self.collectionView.alpha = 1.0;
                         self.collectionView.frame = toFrame2;
                         
                     } completion:^(BOOL completed) {
                         
                     }];
    
}

- (void)dismiss {
   
    self.block(self,self.tempModel.name);
    CGRect frame1 = (CGRect){ CGRectGetMinX(self.frame) +_arrowStartPoint.x, CGRectGetMinY(self.frame),0,0};
    CGRect frame2 = CGRectMake(6, 32, 0, 0);
    [UIView animateWithDuration:0.2
                     animations:^(void) {
                         
                         self.alpha = 0.0;
                         self.frame = frame1;
                         self.collectionView.alpha = 0.0;
                         self.collectionView.frame = frame2;
                         
                     } completion:^(BOOL finished) {
                         
                         [self removeFromSuperview];
                         [self.overlayView removeFromSuperview];
                         
                    }];

    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
