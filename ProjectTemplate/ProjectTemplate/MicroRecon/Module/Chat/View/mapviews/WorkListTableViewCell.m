//
//  WorkListTableViewCell.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/13.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "WorkListTableViewCell.h"
#import "ChatBusiness.h"

#define leftMrgin 50


@interface WorkListTableViewCell () {
    
    
    
}

@property (nonatomic, strong) UIImageView *timeLeftImageView;
@property (nonatomic, strong) UILabel *timeRightLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *pushMemberLabel;
@end

@implementation WorkListTableViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, kScreenWidth, 0);
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    UILabel *lineLabel = [[UILabel alloc] init];
    lineLabel.layer.backgroundColor = [UIColor lightGrayColor].CGColor;
    
    
    self.timeLeftImageView = [[UIImageView alloc] init];
    
    
    
    self.timeRightLabel = [[UILabel alloc] init];
    self.timeRightLabel.textColor = [UIColor blueColor];
    self.timeRightLabel.font = ZEBFont(10);
    
    
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.textColor = [UIColor grayColor];
    self.contentLabel.font = ZEBFont(14);
    
    
    
    self.pushMemberLabel = [[UILabel alloc] init];
    self.pushMemberLabel.textColor = [UIColor lightGrayColor];
    self.pushMemberLabel.font = ZEBFont(12);
   
    
    [self addSubview:lineLabel];
    [self addSubview:self.timeLeftImageView];
    [self addSubview:self.timeRightLabel];
    [self addSubview:self.contentLabel];
    [self addSubview:self.pushMemberLabel];
    
    [lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left).offset(leftMrgin);
        make.width.mas_equalTo(0.5);
        make.height.equalTo(self.mas_height);
    }];
    [self.timeLeftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(lineLabel.mas_centerX);
        make.centerY.equalTo(lineLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    [self.timeRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineLabel.mas_right).offset(3);
        make.bottom.equalTo(self.timeLeftImageView.mas_top);
        make.height.equalTo(@15);
        make.width.equalTo(@35);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeRightLabel.mas_right).offset(5);
        make.top.equalTo(self.timeRightLabel.mas_top).offset(3);
        make.height.equalTo(@30);
        make.width.mas_lessThanOrEqualTo(150);
    }];
    [self.pushMemberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentLabel.mas_left);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(1);
        make.height.equalTo(@25);
        make.width.mas_lessThanOrEqualTo(150);
    }];
}
- (void)setModel:(WorkAllTempModel *)model {
    _model = model;
    [self reloadCell];
}
- (void)reloadCell {
    self.timeLeftImageView.image = [ChatBusiness getIcon:_model.mode direction:_model.direction type:_model.type];
    self.timeRightLabel.text = [_model.create_time timeChangeHHmm];
    self.contentLabel.text = _model.title;
    
    UserAllModel *model = [[[DBManager sharedManager] personnelInformationSQ] selectDepartmentmemberlistById:_model.alarm];
    
    self.pushMemberLabel.text = [NSString stringWithFormat:@"发布者：%@",model.RE_name];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
