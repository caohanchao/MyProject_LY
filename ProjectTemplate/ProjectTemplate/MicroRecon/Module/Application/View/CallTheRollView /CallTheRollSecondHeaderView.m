//
//  CallTheRollSecondHeaderView.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/2/14.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "CallTheRollSecondHeaderView.h"
#import "UIButton+EnlargeEdge.h"

@interface CallTheRollSecondHeaderView ()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *havereportedBtn;
@property (nonatomic, strong) UIButton *notreportedBtn;
@property (nonatomic, strong) UIButton *dateBtn;
@end

@implementation CallTheRollSecondHeaderView


+ (instancetype)headerViewWithTableView:(UITableView *)tableView block:(changeStateBlock)block dateBlock:(selectDateBlock)dateBlock {
    
    static NSString *ID = @"header2";
    CallTheRollSecondHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        header = [[CallTheRollSecondHeaderView alloc] initWithReuseIdentifier:ID block:block dateBlock:dateBlock];
    }
    return header;
}

/**
 *  在这个初始化方法中,HeaderView的frame\bounds没有值
 */
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier  block:(changeStateBlock)block dateBlock:(selectDateBlock)dateBlock {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.block = block;
        self.dateBlock = dateBlock;
        [self initView];
    }
    return self;
}
- (void)initView {

    self.topView = [[UIView alloc] init];
    self.topView.backgroundColor = zGroupTableViewBackgroundColor;
    
    self.havereportedBtn = [CHCUI createButtonWithtarg:self sel:@selector(havereportedBtn:) titColor:RGB(51, 51, 51) font:ZEBFont(12) image:nil backGroundImage:nil title:@"已报道"];
    [self.havereportedBtn setTitleColor:zNavColor forState:UIControlStateSelected];
    self.havereportedBtn.selected = YES;
    
    self.notreportedBtn = [CHCUI createButtonWithtarg:self sel:@selector(notreportedBtn:) titColor:RGB(51, 51, 51) font:ZEBFont(12) image:nil backGroundImage:nil title:@"未报道"];
    [self.notreportedBtn setTitleColor:zNavColor forState:UIControlStateSelected];
    
    
    self.dateBtn = [CHCUI createButtonWithtarg:self sel:@selector(dateBtn:) titColor:zClearColor font:ZEBFont(10) image:nil backGroundImage:@"icon_date" title:@""];
    self.dateBtn.hidden = YES;
    [self.dateBtn setEnlargeEdge:10];
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = LineColor;
    
    
    [self.contentView addSubview:line];
    [self.contentView addSubview:self.topView];
    [self.contentView addSubview:self.havereportedBtn];
    [self.contentView addSubview:self.notreportedBtn];
    [self.contentView addSubview:self.dateBtn];
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@16);
    }];
    [self.havereportedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left);
        make.size.mas_equalTo(CGSizeMake(80, 35));
        
    }];
    [self.notreportedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.equalTo(self.havereportedBtn.mas_right);
        make.size.mas_equalTo(CGSizeMake(80, 35));
    }];
    [self.dateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.notreportedBtn.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-13);
        make.size.mas_equalTo(CGSizeMake(18, 17));
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@0.5);
    }];

}
- (void)havereportedBtn:(UIButton *)btn {
    self.havereportedBtn.selected = YES;
    self.notreportedBtn.selected = NO;
    self.block(0);
}

- (void)notreportedBtn:(UIButton *)btn {
    self.havereportedBtn.selected = NO;
    self.notreportedBtn.selected = YES;
    self.block(1);
}
- (void)dateBtn:(UIButton *)btn {
    self.dateBlock(self);
}
- (void)setNotreported:(BOOL)notreported {
    _notreported = notreported;
    if (_notreported) {
        self.havereportedBtn.selected = NO;
        self.notreportedBtn.selected = YES;
        
    }else {
        self.havereportedBtn.selected = YES;
        self.notreportedBtn.selected = NO;
        
    }
    
}
- (void)setNotreportedCount:(NSInteger)notreportedCount {
    _notreportedCount = notreportedCount;
    [self.notreportedBtn setTitle:[NSString stringWithFormat:@"未报道（%ld）",_notreportedCount] forState:UIControlStateNormal];
}
- (void)setHavereportedCount:(NSInteger)havereportedCount {
    _havereportedCount = havereportedCount;
    [self.havereportedBtn setTitle:[NSString stringWithFormat:@"已报道（%ld）",_havereportedCount] forState:UIControlStateNormal];
}
- (void)setShowDateBtn:(BOOL)showDateBtn {
    _showDateBtn = showDateBtn;
    
    if (_showDateBtn) {
        self.dateBtn.hidden = NO;
    }else {
        self.dateBtn.hidden = YES;
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
