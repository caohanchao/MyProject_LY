//
//  ShakeNoResultView.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/12.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "ShakeNoResultView.h"

@interface ShakeNoResultView ()

@property (nonatomic, strong) UILabel *label;
@end

@implementation ShakeNoResultView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}
- (void)initView {
    _label = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentCenter font:ZEBFont(14) textColor:zWhiteColor text:@""];
    _label.frame = CGRectMake(0, 0, width(self.frame), height(self.frame));
    [self addSubview:_label];
}
- (void)setText:(NSString *)text {
    
    _label.text = text;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
