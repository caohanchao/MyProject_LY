//
//  MapBtnBtnsView.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/11.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "MapBtnBtnsView.h"


#define cornerRadius 8

@implementation MapBtnBtnsView


- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSMutableArray *)dataArray title:(NSString *)title type:(NSString *)type selectArray:(NSMutableArray *)selectArray clickBlock:(BtnClickBlock)block {

    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = zClearColor;
        self.userInteractionEnabled = YES;
        self.dataArray = dataArray;
        self.title = title;
        self.type = type;
        self.block = block;
        self.selectArray = selectArray;
        [self createUI];
    }
    return self;
}
- (void)createUI {
    
    CGFloat leftMargin = 10;
    CGFloat topMargin = 15;
    CGFloat titleHeight = 10;
    CGFloat btnCenterMarginX = 14;
    CGFloat btnWidth = (width(self.frame)-leftMargin*2-btnCenterMarginX*3)/4;
    CGFloat btnCenterMarginY = 15;
    CGFloat btnTitleHeight = 10;
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width(self.frame), titleHeight)];
//    
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:titleLabel.bounds byRoundingCorners:UIRectCornerTopLeft |  UIRectCornerTopRight cornerRadii:CGSizeMake(8, 8)];
//    
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
//    //设置大小
//    maskLayer.frame = titleLabel.bounds;
//    //设置图形样子
//    maskLayer.path = maskPath.CGPath;
//    titleLabel.layer.mask = maskLayer;
//    
//    titleLabel.text = [NSString stringWithFormat:@" %@",self.title];
//    titleLabel.backgroundColor = RGB(235, 234, 235);
//    titleLabel.textColor = [UIColor blackColor];
//    titleLabel.font = ZEBFont(18);
//    [self addSubview:titleLabel];
//    
    NSInteger count = self.dataArray.count;
    
    for (int i = 0; i < count; i++) {
        NSDictionary *dic = self.dataArray[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(leftMargin + (btnWidth + btnCenterMarginX)*(i%4), topMargin + (btnTitleHeight + btnWidth + btnCenterMarginY)*(i/4), btnWidth, btnWidth);
        btn.type = dic[@"type"];
        if ([btn.type isEqualToString:@"01"] || [btn.type isEqualToString:@"02"] || [btn.type isEqualToString:@"03"]) {
            btn.userInteractionEnabled = NO;
        }
        btn.format = dic[@"format"];
        btn.my_type = self.type;
        btn.tag = 1000+i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(minX(btn), maxY(btn)+ 5, width(btn.frame), btnTitleHeight)];
        titleLabel.text = dic[@"title"];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.tag = 10000+i;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = ZEBFont(10);
        [btn setBackgroundImage:[UIImage imageNamed:dic[@"iconName"]] forState:UIControlStateNormal];
        
        if ([self.type isEqualToString:@"0"]) {
            titleLabel.textColor = zWhiteColor;
            //不设置也会有高亮，给的高亮图片没汉字，好郁闷，所以去掉不设置
            //[btn setBackgroundImage:[UIImage imageNamed:dic[@"iconNameSelect"]] forState:UIControlStateHighlighted];
            
        }else if ([self.type isEqualToString:@"1"]) {
            titleLabel.textColor = zWhiteColor;
            [btn setBackgroundImage:[UIImage imageNamed:dic[@"iconNameSelect"]] forState:UIControlStateSelected];
            
            if (i == count-1) {
              //  titleLabel.textColor = [UIColor colorWithRed:0.77 green:0.77 blue:0.77 alpha:1.00];
                btn.userInteractionEnabled = NO;
            }else {
                if (i < count-1) {
                    btn.selected = [self.selectArray[i] boolValue];
                }
                if (btn.selected) {
                    titleLabel.textColor = CHCHexColor(@"12b7f5");
                }else {
                    titleLabel.textColor = CHCHexColor(@"ffffff");
                }
            }
        }
        
    [self addSubview:btn];
    [self addSubview:titleLabel];
       
    }
}
- (void)btnClick:(UIButton *)btn {
    NSInteger btnTag = btn.tag - 1000;
    NSInteger labelTag = btnTag + 10000;
    UILabel *label = [self viewWithTag:labelTag];
    
    if ([self.type isEqualToString:@"0"]) {
        
    }else if ([self.type isEqualToString:@"1"]) {
         btn.selected = !btn.selected;
        if (btn.selected) {
            label.textColor = CHCHexColor(@"12b7f5");
        }else {
            label.textColor = CHCHexColor(@"ffffff");
        }
    }
    
    self.block(btn);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(8, 8)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    //设置大小
    maskLayer.frame = self.bounds;
    //设置图形样子
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
    
}


@end
