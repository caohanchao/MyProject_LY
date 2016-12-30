//
//  MapBottomView.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/25.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "MapBottomView.h"
#import "UIButton+EnlargeEdge.h"

@interface MapBottomView () {
    NSArray *_photoArr;
    NSArray *_titleArr;
}


@property (nonatomic, strong) UIControl *overlayView;
@property (nonatomic, assign) CGFloat MHeight;
@end

@implementation MapBottomView


- (instancetype)initWithFrame:(CGRect)frame markType:(MARKTYPE)type block:(ChooseBlock)block {

    self = [super initWithFrame:frame];
    if (self) {
        self.block = block;
        self.type = type;
        self.backgroundColor = [UIColor whiteColor];
        self.overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.overlayView.backgroundColor = [UIColor blackColor];
        self.overlayView.alpha = 0.0;
        [self.overlayView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        
        [self createUI];
    }
    return self;
}
- (void)setType:(MARKTYPE)type {
    _type = type;
    
    if (_type == CAMERAMARK) {//摄像头标记
        self.MHeight = 80;
        _photoArr = @[@"mark_gong_square_1",@"mark_gong_circle_1",@"mark_fei_square_1",@"mark_fei_circle_1",@"mark_yi_square_1"];
        _titleArr = @[@"公安枪机",@"公安球机",@"非公安机",@"非公球机",@"移动拍摄"];
    }else if (_type == VISITMARK) {//走访标记
        self.MHeight = 80;
        _photoArr = @[@"mark_goodw_1",@"mark_footw_1",@"mark_carw_1",@"mark_manw_1",@"mark_suspectw_1",@"mark_bannerw_1"];
        _titleArr = @[@"嫌疑物",@"案发地",@"嫌疑车",@"嫌疑人",@"受伤者",@"集合点"];
    }
}
- (void)createUI {

    NSInteger count = _photoArr.count;
    
   
    CGFloat leftM = 20;
    CGFloat topM = 10;
    CGFloat btnW = 26;//(kScreenWidth - 2*leftM - (count-1)*centerM)/count;
    CGFloat centerM = (kScreenWidth - btnW*count-2*leftM)/(count-1);//35;
    
    for (int i = 0; i < count; i++) {
        NSString *photo = _photoArr[i];
        NSString *title = _titleArr[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(leftM+(btnW+centerM)*(i%count), topM, btnW, btnW);
        [btn setBackgroundImage:[UIImage imageNamed:photo] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1000+i;
        [btn setEnlargeEdge:10];
        [self addSubview:btn];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, btnW+20, 20)];
        label.center = CGPointMake(midX(btn), maxY(btn)+20);
        label.text = title;
        label.font = ZEBFont(10);
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }
}
- (void)choose:(UIButton *)btn {

    NSInteger index = btn.tag-1000;
    self.block(self.type,index);
}
- (void)showIn:(UIView *)view {
    
    [view addSubview:self.overlayView];
    [view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.overlayView.alpha = 0.3;
        self.frame = CGRectMake(0, kScreenHeight-self.MHeight, kScreenWidth, self.MHeight);
    }];
}
- (void)dismiss {
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.overlayView.alpha = 0;
        self.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 0);
    } completion:^(BOOL finished) {
        [self.overlayView removeFromSuperview];
        [self removeFromSuperview];
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
