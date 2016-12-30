//
//  WorkListsCollectionViewCell.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/13.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "WorkListsCollectionViewCell.h"
#import "UIImageView+CornerRadius.h"
#import "NSDate+Extensions.h"


@interface WorkListsCollectionViewCell () {

    UILabel *_topLabel;
    UILabel *_titleLabel;
    UILabel *_desLabel;
    UILabel *_lineLabel;
    UIImageView *_headpicImageView;
    UILabel *_posLabel;
    UILabel *_nameLabel;
    UILabel *_timeLabel;
}



@end

@implementation WorkListsCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:@"worklist_bg"];
        _imageView = imageView;
        imageView.frame = self.contentView.bounds;
        [self.contentView addSubview:imageView];
        [self createUI];
    }
    return self;
}
- (void)createUI {

    _topLabel = [[UILabel alloc] init];
    _topLabel.font = ZEBFont(11);
    _topLabel.textColor = [UIColor whiteColor];
    _topLabel.textAlignment = NSTextAlignmentCenter;
   
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = ZEBFont(12);
    _titleLabel.textColor = [UIColor blackColor];
   
    
    _desLabel = [[UILabel alloc] init];
    _desLabel.font = ZEBFont(11);
    _desLabel.textColor = CHCHexColor(@"808080");
    _desLabel.numberOfLines = 3;
 
    
    _lineLabel = [[UILabel alloc] init];
    _lineLabel.backgroundColor = [UIColor lightGrayColor];
    _lineLabel.alpha = 0.6;
    
    _headpicImageView = [[UIImageView alloc] initWithCornerRadiusAdvance:27/2 rectCornerType:UIRectCornerAllCorners];
    
    _posLabel = [[UILabel alloc] init];
    _posLabel.textColor = [UIColor whiteColor];
    _posLabel.layer.masksToBounds = YES;
    _posLabel.layer.cornerRadius = 5;
    _posLabel.font = ZEBFont(8);
    
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.textColor = CHCHexColor(@"808080");
    _nameLabel.font = ZEBFont(11);
   
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = CHCHexColor(@"808080");
    _timeLabel.font = ZEBFont(8);
    _timeLabel.textAlignment = NSTextAlignmentRight;
    
    [self.contentView addSubview:_topLabel];
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_desLabel];
    [self.contentView addSubview:_lineLabel];
    [self.contentView addSubview:_headpicImageView];
    [self.contentView addSubview:_posLabel];
    [self.contentView addSubview:_nameLabel];
    [self.contentView addSubview:_timeLabel];
    
    CGFloat leftMargin = 12;
    CGFloat w = CGRectGetWidth(self.frame)-2*leftMargin;
    [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_right).offset(-35);
        make.top.equalTo(self.mas_top);
        make.size.mas_equalTo(CGSizeMake(35 , 20));
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(20);
        make.left.equalTo(self.mas_left).offset(leftMargin);
        make.width.mas_lessThanOrEqualTo(w);
        make.height.equalTo(@25);
        
    }];
    [_desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLabel.mas_bottom).offset(9);
        make.left.equalTo(_titleLabel.mas_left);
        make.width.mas_lessThanOrEqualTo(w);
        make.height.mas_lessThanOrEqualTo(80);
    }];
    [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(120);
        make.left.equalTo(_desLabel.mas_left);
        make.right.equalTo(self.mas_right).offset(-leftMargin);
        make.height.equalTo(@0.5);
    }];
    [_headpicImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_lineLabel.mas_bottom).offset(10);
        make.left.equalTo(_lineLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(27, 27));
    }];
    [_posLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_headpicImageView.mas_centerY);
        make.left.equalTo(_headpicImageView.mas_right).offset(8);
        make.height.equalTo(@13);
        make.width.mas_lessThanOrEqualTo(30);
    }];
    CGFloat tn = 32;
    if (ZEBiPhone5_OR_5c_OR_5s) {
        tn = 30;
    }
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_headpicImageView.mas_centerY);
        make.left.equalTo(_posLabel.mas_right).offset(4);
        make.height.equalTo(@15);
        make.width.mas_lessThanOrEqualTo(tn);
    }];
    CGFloat tw = 50;
    if (ZEBiPhone5_OR_5c_OR_5s) {
        tw = 35;
    }
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_headpicImageView.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-9);
        make.height.equalTo(@15);
        make.width.mas_lessThanOrEqualTo(tw);
    }];
    
}
- (void)setModel:(SuspectlistModel *)model {
    _model = model;
    [self reloadCell];
}
- (void)reloadCell {
    
    _topLabel.text = @"侦查";
    
    _titleLabel.text = _model.suspectname;
    _desLabel.text = _model.suspectdec;
    [_headpicImageView imageGetCacheForAlarm:_model.createuser forUrl:_model.headpic];
    _nameLabel.text = _model.username;
    UserAllModel *uaModel = [[[DBManager sharedManager] personnelInformationSQ] selectDepartmentmemberlistById:_model.createuser];
    UnitListModel *uModel = [self getTypeForUser];
    
    if ([uModel.DE_type isEqualToString:@""]) {
        _posLabel.backgroundColor = [UIColor colorWithHexString:@"#96b0fb"];
        _posLabel.text = [NSString stringWithFormat:@" %@ ",uaModel.RE_post];
    }else {
        if ([uModel.DE_type isEqualToString:@"0"]) {//0警察公务组织紫，1技术支持绿
            _posLabel.backgroundColor = [UIColor colorWithHexString:@"#96b0fb"];
            _posLabel.text = [NSString stringWithFormat:@" %@ ",uaModel.RE_post];
        }else if ([uModel.DE_type isEqualToString:@"1"]) {
            _posLabel.backgroundColor = [UIColor colorWithHexString:@"#6cd9a3"];
            _posLabel.text = [NSString stringWithFormat:@" %@ ",uaModel.RE_post];
        }
        
    }
    
    _timeLabel.text = [_model.create_time timeChaneForWorkList];
    
}
- (UnitListModel *)getTypeForUser {

    UserAllModel *uModel = [[[DBManager sharedManager] personnelInformationSQ] selectDepartmentmemberlistById:_model.createuser];
    UnitListModel *ulModel = [[[DBManager sharedManager] DepartmentlistSQ] selectDepartmentlistById:uModel.RE_department];
    return ulModel;
}

@end
