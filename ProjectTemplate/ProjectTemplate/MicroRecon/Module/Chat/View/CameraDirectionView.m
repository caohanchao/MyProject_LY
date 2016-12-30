//
//  CameraDirectionView.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/26.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "CameraDirectionView.h"
#import "UIButton+Layout.h"
#import "ChatBusiness.h"

#define MHeight 185

@interface CameraDirectionView ()

@property (nonatomic, strong) UIControl *overlayView;
@end

@implementation CameraDirectionView

- (instancetype)initWithFrame:(CGRect)frame cameraDirationBlock:(CameraDireationClickBlock)block {
    self = [super initWithFrame:frame];
    if (self) {
        self.block = block;
        self.overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.overlayView.backgroundColor = [UIColor blackColor];
        self.overlayView.alpha = 0.0;
        [self.overlayView addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        self.backgroundColor = RGB(234, 233, 233);
        self.alpha = 0.95;
        [self createUI];
    }
    return self;
}
- (void)createUI {

    UILabel *topLabel = [CHCUI createLabelWithbackGroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter font:ZEBFont(13) textColor:[UIColor blackColor] text:@"请选择摄像头方向"];
    topLabel.frame = CGRectMake(25, 5, kScreen_Width-50, 25);
    [self addSubview:topLabel];
    
    NSArray *dircationArr = @[@"camera_direction_1",@"camera_direction_2",@"camera_direction_3",@"camera_direction_4",@"camera_direction_5",@"camera_direction_6",@"camera_direction_7",@"camera_direction_8",@"camera_direction_9"];
    
    CGFloat btnW = 50;
    CGFloat leftM = (kScreen_Width - btnW*3)/2;
    CGFloat topM = maxY(topLabel)+5;
    
    NSInteger count = dircationArr.count;
    for (int i = 0; i < count; i++) {
        NSString *imageStr = dircationArr[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(leftM+btnW*(i%3), topM+btnW*(i/3), btnW, btnW);
        [btn setBackgroundImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
        if (i == 4) {
            btn.userInteractionEnabled = NO;
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 20, 20)];
            imageView.center = CGPointMake(width(btn.frame)/2, height(btn.frame)/2-5);
            imageView.image = [UIImage imageNamed:@"camera_yi"];
            [btn addSubview:imageView];
            
            UILabel *label = [CHCUI createLabelWithbackGroundColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter font:ZEBFont(10) textColor:[UIColor blackColor] text:@"移动拍摄"];
            label.frame = CGRectMake(0, maxY(imageView)+2.5, width(btn.frame), 20);
            [btn addSubview:label];
        }else {
            [btn addTarget:self action:@selector(chooseDircation:) forControlEvents:UIControlEventTouchUpInside];
        }
        btn.tag = 1000+i;
        [self addSubview:btn];
    }

}
- (void)chooseDircation:(UIButton *)btn {
    NSInteger index = btn.tag - 1000;
    self.block(self,[ChatBusiness getStandardDircation:index]);
}
- (void)showIn:(UIView *)view {
    
    [view addSubview:self.overlayView];
    [view addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        self.overlayView.alpha = 0.3;
        self.frame = CGRectMake(0, kScreenHeight-MHeight, kScreenWidth, MHeight);
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
