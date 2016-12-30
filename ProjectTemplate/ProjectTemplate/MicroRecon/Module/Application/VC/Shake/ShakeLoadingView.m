//
//  ShakeLoadingView.m
//  摇一摇
//
//  Created by apple on 16-12-12.
//  Copyright (c) 2016年 zeb-apple. All rights reserved.
//

#import "ShakeLoadingView.h"


@interface ShakeLoadingView ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UILabel *searchLabel;

@end

@implementation ShakeLoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}
- (void)initView {

    
    self.searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/2-50, 0, 150, CGRectGetHeight(self.frame))];
   // self.searchLabel.text = @"正在搜索附近摄像头...";
    self.searchLabel.textColor = [UIColor whiteColor];
    self.searchLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.searchLabel];
    
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.searchLabel.frame)-32, 0, 20, 20)];
    [self.activityIndicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
   
    [self.activityIndicatorView startAnimating];
    [self addSubview:self.activityIndicatorView];
    
}
- (void)setSearchText:(NSString *)searchText {
    _searchText = searchText;
    self.searchLabel.text = _searchText;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
