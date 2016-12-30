//
//  ShakeBottomView.m
//  摇一摇
//
//  Created by apple on 16-12-12.
//  Copyright (c) 2016年 zeb-apple. All rights reserved.
//

#import "ShakeBottomView.h"
#import "UIButton+Layout.h"

#define kWidth [UIScreen mainScreen].bounds.size.width

@interface ShakeBottomView ()


@property (nonatomic, copy) CameraBlock cBlock;// 摄像头
@property (nonatomic, copy) PolicingBlock pBlock;// 监控室
@property (nonatomic, copy) BaseStationBlock bSBlock;// 基站
@property (nonatomic, weak) UIButton *tempBtn;
@end

@implementation ShakeBottomView

- (instancetype)initWithFrame:(CGRect)frame cBlock:(CameraBlock)cBlock pBlock:(PolicingBlock)pBlock bSBlock:(BaseStationBlock)bSBlock {
    self = [super initWithFrame:frame];
    if (self) {

        self.cBlock = cBlock;
        self.pBlock = pBlock;
        self.bSBlock = bSBlock;
        [self initView];
        
    }
    return self;
}
- (void)initView {

    NSArray *titleArr = @[@"摄像头",@"监控室",@"基站"];
    NSArray *imageNoArr = @[@"Camera_no",@"Policing_no",@"BaseStation_no"];
    NSArray *imageSelArr = @[@"Camera_se",@"Policing_se",@"BaseStation_se"];
    
    NSInteger count = titleArr.count;
    
    
    CGFloat btnW = 100;
    CGFloat btnH = 60;
    CGFloat margin = 75-35;
    CGFloat marginC = (kScreenWidth - 2*margin - 3*btnW)/2;
    
    for (int i = 0; i < count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(margin + (btnW + marginC)*i, 0, btnW, btnH);
        [button setImage:[UIImage imageNamed:imageNoArr[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:imageSelArr[i]] forState:UIControlStateSelected];
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        [button setTitleColor:CHCHexColor(@"808080") forState:UIControlStateNormal];
        [button setTitleColor:CHCHexColor(@"12b7f5") forState:UIControlStateSelected];
        button.tag = 1000000+i;
        button.titleLabel.font = [UIFont systemFontOfSize:10];
        [button addTarget:self action:@selector(change:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            [button setSelected:YES];
            self.tempBtn = button;
        }
        [button layoutButtonForTitle:titleArr[i] titleFont:[UIFont systemFontOfSize:10] image:[UIImage imageNamed:imageNoArr[i]] gapBetween:8 layType:2];
    
        [self addSubview:button];
    }
    
}
- (void)change:(UIButton *)btn {
    NSInteger index = btn.tag - 1000000;
    
    if (self.tempBtn) {
        [self.tempBtn setSelected:NO];
    }
    [btn setSelected:YES];
    self.tempBtn = btn;
    if (index == 0) {
        self.cBlock(self);
    }else if (index == 1) {
        self.pBlock(self);
    }else if (index == 2) {
        self.bSBlock(self);
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
