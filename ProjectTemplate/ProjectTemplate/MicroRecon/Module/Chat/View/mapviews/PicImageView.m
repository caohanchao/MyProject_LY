//
//  PicImageView.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/11/1.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "PicImageView.h"
#import "UIButton+EnlargeEdge.h"

@interface PicImageView ()

@property (nonatomic, strong) UIButton *delBtn;
@property (nonatomic, strong) UIImageView *bgView;
@end

@implementation PicImageView

- (instancetype)initWithFrame:(CGRect)frame pic:(NSString *)pic {
    self = [super initWithFrame:frame];
    if (self) {
        self.picUrl = pic;
        [self createUI];
    }
    return self;
}
- (void)createUI {
    
    self.bgView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:self.bgView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick)];
    [self addGestureRecognizer:tap];
    
    [self.bgView sd_setImageWithURL:[NSURL URLWithString:self.picUrl] placeholderImage:[LZXHelper buttonImageFromColor:[UIColor groupTableViewBackgroundColor]]];
    self.bgView.clipsToBounds = YES;
    self.bgView.contentMode = UIViewContentModeScaleAspectFill;

    
    //    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(deleteMine:)];
    //    longPress.numberOfTouchesRequired = 1;
    //    longPress.minimumPressDuration = 1.f;
    //    [self addGestureRecognizer:longPress];
    
    self.delBtn = [CHCUI createButtonWithtarg:self sel:@selector(deleteMine) titColor:zClearColor font:ZEBFont(10) image:@"mark_delete" backGroundImage:@"" title:@""];
    [self.delBtn setEnlargeEdge:5];
    [self addSubview:self.delBtn];
    
    [self.delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(14, 14));
        make.left.equalTo(self.bgView.mas_right).offset(-7);
        make.top.equalTo(self.bgView.mas_top).offset(-7);
    }];
}
- (void)setDelhidden:(BOOL)delhidden {
    _delhidden = delhidden;
    if (_delhidden) {
        self.delBtn.hidden = YES;
    }
}
- (void)imageClick {
    if (_delegate && [_delegate respondsToSelector:@selector(picImageView:index:)]) {
        [_delegate picImageView:self index:self.index];
    }
}
//- (void)deleteMine:(UILongPressGestureRecognizer *)longPressGes {
//    if (longPressGes.state == UIGestureRecognizerStateBegan) {
//        if (_delegate && [_delegate respondsToSelector:@selector(picImageView:deleteImageIndex:)]) {
//            [_delegate picImageView:self deleteImageIndex:self.index];
//        }
//    }
//}
- (void)deleteMine {
    
    if (_delegate && [_delegate respondsToSelector:@selector(picImageView:deleteImageIndex:)]) {
        [_delegate picImageView:self deleteImageIndex:self.index];
    }
    
}
//重写该方法后可以让超出父视图范围的子视图响应事件
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        for (UIView *subView in self.subviews) {
            CGPoint tp = [subView convertPoint:point fromView:self];
            if (CGRectContainsPoint(subView.bounds, tp)) {
                view = subView;
            }
        }
    }
    
    return view;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
