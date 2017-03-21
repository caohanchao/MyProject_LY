//
//  CallTheRollFirstHeaderView.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/2/14.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "CallTheRollFirstHeaderView.h"
#import "UIImageView+CornerRadius.h"
#import "CallTheRollDeatilModel.h"

@interface CallTheRollFirstHeaderView ()

@property (nonatomic, strong) UIImageView *headpic;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@end

@implementation CallTheRollFirstHeaderView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"header1";
    CallTheRollFirstHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        header = [[CallTheRollFirstHeaderView alloc] initWithReuseIdentifier:ID];
    }
    return header;
}

/**
 *  在这个初始化方法中,HeaderView的frame\bounds没有值
 */
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        [self initView];
    }
    return self;
}

- (void)initView {

//    self.headpic = [[UIImageView alloc] initWithCornerRadiusAdvance:35/2 rectCornerType:UIRectCornerAllCorners];
    self.headpic = [[UIImageView alloc] initWithCornerRadiusAdvance:6 rectCornerType:UIRectCornerAllCorners];
    self.headpic.image = [LZXHelper buttonImageFromColor:zGroupTableViewBackgroundColor];
    
    self.nameLabel = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentLeft font:ZEBFont(13) textColor:RGB(51, 51, 51) text:@""];
    
    self.stateLabel = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentRight font:ZEBFont(10) textColor:RGB(238, 68, 68) text:@""];
    
    self.timeLabel = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentLeft font:ZEBFont(10) textColor:RGB(153, 153, 153) text:@""];
    
    self.contentLabel = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentLeft font:ZEBFont(14) textColor:RGB(51, 51, 51) text:@""];
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = LineColor;
    
    
    [self.contentView addSubview:line];
    [self.contentView addSubview:self.headpic];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.stateLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.contentLabel];
    
    
    [self.headpic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headpic.mas_right).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(11);
        make.height.equalTo(@13);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-12);
        make.centerY.equalTo(self.headpic.mas_centerY);
        make.height.equalTo(@15);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headpic.mas_right).offset(10);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(12);
        make.height.equalTo(@10);
        make.width.mas_lessThanOrEqualTo(200);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.top.equalTo(self.headpic.mas_bottom).offset(10);
        make.height.equalTo(@50);
        make.right.equalTo(self.contentView.mas_right).offset(-12);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@0.5);
    }];

}
- (void)setDeatilModel:(CallTheRollDeatilModel *)deatilModel {
    _deatilModel = deatilModel;
    [self reloadCell];
}
- (void)reloadCell {
    [self.headpic sd_setImageWithURL:[NSURL URLWithString:self.deatilModel.publish_head_pic] placeholderImage:[LZXHelper buttonImageFromColor:zGroupTableViewBackgroundColor]];
    self.nameLabel.text = self.deatilModel.publish_name;
    self.timeLabel.text = self.deatilModel.create_time;
    self.contentLabel.text = self.deatilModel.title;
    
    if ([self.deatilModel.sign_state isEqualToString:@"0"]) { // 点名的状态(0,1,2,3:点名中,待点名,已完成,已关闭)
        self.stateLabel.text = @"点名中";
    }else if ([self.deatilModel.sign_state isEqualToString:@"1"]) {
        self.stateLabel.text = @"待点名";
    }else if ([self.deatilModel.sign_state isEqualToString:@"2"]) {
        self.stateLabel.text = @"已完成";
    }else if ([self.deatilModel.sign_state isEqualToString:@"3"]) {
        self.stateLabel.text = @"已关闭";
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
