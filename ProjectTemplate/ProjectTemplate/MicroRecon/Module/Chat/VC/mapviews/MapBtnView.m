//
//  MapBtnView.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/10.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "MapBtnView.h"
#import "UIButton+Property.h"
#import "CameraMarkViewController.h"

@interface MapBtnView ()

@property (nonatomic, strong) NSMutableArray *dataArray;


@end

@implementation MapBtnView

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self getButtons];
        [self createBtn];
    }
    return self;
}
- (NSMutableArray *)dataArray {

    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (void)getButtons {

    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"ChatMap" ofType:@"plist"];
    NSArray *plistArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
    
    [self.dataArray addObjectsFromArray:plistArray];

}
- (void)createBtn {
    
    CGFloat margin = 5;
    CGFloat wdth = 40;
    NSArray *arr = @[@"",@"",@"记录",@"标记",@"摄像头",@"轨迹"];
    for (int i = 0;i < self.dataArray.count; i++) {
        
        NSDictionary *dic = self.dataArray[i];
        NSString *iconName = dic[@"iconName"];
        NSMutableArray *btns = dic[@"buttons"];
        NSString *type = dic[@"type"];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, wdth, wdth);
        btn.center = CGPointMake(width(self.frame)/2, margin + wdth/2 + (wdth + margin)*i);
        [btn setBackgroundImage:[UIImage imageNamed:iconName] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        btn.type = type;
//        if ([type isEqualToString:@"2"]) {
//            btn.userInteractionEnabled = NO;
//        }
        if (i >= 2) {
            if (i == 2) {
                btn.center = CGPointMake(width(self.frame)/2, margin + wdth/2 + (wdth + margin)*2 + wdth*(i-2));
            }else if (i == 3){
                btn.center = CGPointMake(width(self.frame)/2, margin + wdth/2 + (wdth + margin)*2 + wdth*(i-2));
            }else {
                btn.center = CGPointMake(width(self.frame)/2, margin + wdth/2 + (wdth + margin)*2 + wdth*(i-2));
            }
            
//            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, wdth-15,wdth, 10)];
//            titleLabel.font = ZEBFont(10);
//            titleLabel.text = arr[i];
//            titleLabel.textColor = zWhiteColor;
//            titleLabel.textAlignment = NSTextAlignmentCenter;
          //  [btn addSubview:titleLabel];
        }
        btn.buttons = btns;
        
        [self addSubview:btn];
    }
}
- (void)click:(UIButton *)btn {

    switch ([btn.type integerValue]) {
        case 0:
            [self clickOne:btn];
            break;
        case 1:
            [self clickTwo:btn];
            break;
        case 2:
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowHudNotfication" object:@"该功能开发中"];
            [self clickThree:btn];
            break;
        case 3:
            [self clickFour:btn];
            break;
        case 4:
            [self clickFive:btn];
            break;
        case 5:
            [self clickSix:btn];
        default:
            break;
    }
    
}
- (void)clickOne:(UIButton *)btn {
    
    CGFloat by = btn.center.y;
    CGFloat bx = btn.center.x;
    CGFloat sy = minY(self);
    CGFloat sx = minX(self);
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"buttons"] = btn.buttons;
    parame[@"type"] = btn.type;
    parame[@"title"] = @"实用功能";
    parame[@"centerY"] = [NSString stringWithFormat:@"%f",by+sy];
    parame[@"centerX"] = [NSString stringWithFormat:@"%f",bx+sx];
    [[NSNotificationCenter defaultCenter] postNotificationName:MapShowBtnsNotification object:nil userInfo:parame];
}
- (void)clickTwo:(UIButton *)btn {
    
    CGFloat by = btn.center.y;
    CGFloat bx = btn.center.x;
    CGFloat sy = minY(self);
    CGFloat sx = minX(self);
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"buttons"] = btn.buttons;
    parame[@"type"] = btn.type;
    parame[@"title"] = @"图层筛选";
    parame[@"centerY"] = [NSString stringWithFormat:@"%f",by+sy];
    parame[@"centerX"] = [NSString stringWithFormat:@"%f",bx+sx];
    [[NSNotificationCenter defaultCenter] postNotificationName:MapShowBtnsNotification object:nil userInfo:parame];
   
}
-(void)clickThree:(UIButton *)btn
{

//    [DCURLRouter pushURLString:[NSString stringWithFormat:@"ly://cameraMarkViewController?markType=1"] animated:YES replace:NO];
    [LYRouter openURL:@"ly://addQuickRecordMark"];
}

-(void)clickFour:(UIButton *)btn
{
//    [DCURLRouter pushURLString:[NSString stringWithFormat:@"ly://cameraMarkViewController?markType=1"] animated:YES replace:NO];
    [LYRouter openURL:@"ly://addvisitMark"];
}

-(void)clickFive:(UIButton *)btn
{
//    [DCURLRouter pushURLString:[NSString stringWithFormat:@"ly://cameraMarkViewController?markType=0"] animated:YES replace:NO];
    [LYRouter openURL:@"ly://addcameraMark"];
}
-(void)clickSix:(UIButton *)btn
{
    //    [DCURLRouter pushURLString:[NSString stringWithFormat:@"ly://cameraMarkViewController?markType=0"] animated:YES replace:NO];
    [LYRouter openURL:@"ly://addPathMark"];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
