//
//  WorkDesRightTableViewTopCell.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/14.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "WorkDesRightTableViewTopCell.h"

@interface WorkDesRightTableViewTopCell () {

    
}
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *posLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *posiLabel;//位置

@end

@implementation WorkDesRightTableViewTopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier widthModel:(WorkAllTempModel *)model {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.model = model;
        self.frame = CGRectMake(0, 0, kScreenWidth-100, 0);
        [self createUI];
    }
    return self;
}
- (void)createUI {

    
    UserAllModel *model = [[[DBManager sharedManager] personnelInformationSQ] selectDepartmentmemberlistById:_model.alarm];
    
    self.headerImageView = [[UIImageView alloc] init];
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.headerImageView imageGetCacheForAlarm:model.RE_alarmNum forUrl:model.RE_headpic];
    
    
    self.nameLabel = [LZXHelper getLabelFont:ZEBFont(16) textColor:[UIColor blackColor]];
    self.nameLabel.text = model.RE_name;
    
    UnitListModel *uModel = [self getTypeForUser];
    self.posLabel = [LZXHelper getLabelFont:ZEBFont(14) textColor:[UIColor grayColor]];
    self.posLabel.text = uModel.DE_name;
    
    self.timeLabel = [LZXHelper getLabelFont:ZEBFont(13) textColor:[UIColor lightGrayColor]];
    self.timeLabel.text = [self.model.create_time timeChaneForWorkList];
    
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = [UIColor lightGrayColor];
    
    
    UIImageView *posiImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"location_work"]];
    
    self.posiLabel = [LZXHelper getLabelFont:ZEBFont(14) textColor:[UIColor grayColor]];
    self.posiLabel.text = self.model.position;
    self.posiLabel.numberOfLines = 2;
    
    [self addSubview:self.headerImageView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.posLabel];
    [self addSubview:self.timeLabel];
    [self addSubview:line];
    [self addSubview:posiImageView];
    [self addSubview:self.posiLabel];
    
    CGFloat leftMrgin = 5;
    
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.left.equalTo(self.mas_left).offset(leftMrgin);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImageView.mas_top);
        make.left.equalTo(self.headerImageView.mas_right).offset(10);
        make.height.equalTo(@25);
        make.width.mas_lessThanOrEqualTo(80);
    }];
    [self.posLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom);
        make.left.equalTo(self.nameLabel.mas_left);
        make.height.equalTo(@20);
        make.width.mas_lessThanOrEqualTo(150);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-leftMrgin);
        make.width.mas_lessThanOrEqualTo(80);
        make.top.equalTo(self.nameLabel.mas_top);
        make.height.equalTo(@25);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerImageView.mas_bottom).offset(10);
        make.left.equalTo(self.mas_left);
        make.width.equalTo(self.mas_width);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@0.5);
    }];
    [posiImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(leftMrgin);
        make.top.equalTo(line.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
       
    }];
    [self.posiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(posiImageView.mas_right).offset(5);
        make.width.mas_lessThanOrEqualTo(width(self.frame)-70);
        make.top.equalTo(posiImageView.mas_top);
    }];
    
    
}
- (UnitListModel *)getTypeForUser {
    
    UserAllModel *uModel = [[[DBManager sharedManager] personnelInformationSQ] selectDepartmentmemberlistById:_model.alarm];
    UnitListModel *ulModel = [[[DBManager sharedManager] DepartmentlistSQ] selectDepartmentlistById:uModel.RE_department];
    return ulModel;
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
