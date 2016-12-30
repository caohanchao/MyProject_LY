//
//  DraftsCell.m
//  ProjectTemplate
//
//  Created by caohanchao on 16/10/27.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#define Diameter 45
#define TitleBG [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1.00]
#define white_backgroundColor [UIColor whiteColor]
#define font_blackColor [UIColor blackColor]
#define font_grayColor [UIColor grayColor]
#define font(font) [UIFont systemFontOfSize:font]

#define CellHeight 100
#define LeftMargin 12.5
#define TopMargin 12.5

#import "DraftsCell.h"
#import "UIButton+EnlargeEdge.h"
#import "NSString+Time.h"
#import "ChatBusiness.h"

@interface DraftsCell ()

@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UIImageView *iconImg;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *tasktitle;
@property(nonatomic,strong)UILabel *desLabel;
@property(nonatomic,strong)UILabel *locationLabel;
@property(nonatomic,strong)UIImageView *locationImg;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UIImageView *bgView;

@property(nonatomic,strong)UIButton *uploadBtn;
@end

@implementation DraftsCell

- (void)configureWithCell:(id)model {
//    if (type == markType) {
//        
//    }
//    else if (type == TrajectoryType) {
//        
//    }
    if ([model isKindOfClass:[WorkAllTempModel class]]) {
        self.model = model;
        self.type = markType;
    }
    if ([model isKindOfClass:[GetPathModel class]]) {
        self.pModel = model;
        self.type = TrajectoryType;
    }
}

-(void)setModel:(WorkAllTempModel *)model
{
    _model = model;
    _tempModel = _model;
//    [_iconImg imageGetCacheForAlarm:_model.alarm forUrl:_model.headpic];
    _iconImg.image = [ChatBusiness getIcon:_model.mode type:_model.type];
    _name.text = _model.title;
    _desLabel.text = _model.content;
    _timeLabel.text = [_model.create_time timeChage];
    _locationLabel.text = _model.position;
    _locationImg.image = [UIImage imageNamed:@"drafts_location"];
}

-(void)setPModel:(GetPathModel *)pModel {
    _pModel = pModel;
    _tempModel = _pModel;
    _desLabel.text = _pModel.describetion;
    if ([_pModel.type isEqualToString:@"0"]) {
        _locationLabel.text = @"走线";
    } else if ([_pModel.type isEqualToString:@"1"]) {
        _locationLabel.text = @"走访";
    } else if ([_pModel.type isEqualToString:@"2"]) {
        _locationLabel.text = @"追踪";
    }
    _iconImg.image = [UIImage imageNamed:@"drafts_path"];
    _name.text = _pModel.route_title;
    _timeLabel.text = [_pModel.createTime timeChage];
    _locationImg.image = [UIImage imageNamed:@"drafts_workmode"];
    
}

-(UIImageView *)locationImg
{
    if (!_locationImg) {
        _locationImg = [CHCUI createImageWithbackGroundImageV:@"drafts_location"];

    }
    return _locationImg;
}

-(UILabel *)locationLabel
{
    if (!_locationLabel) {
        _locationLabel =[CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:0 font:font(10) textColor:font_grayColor text:@""];
    }
    return _locationLabel;
}

-(UIButton *)uploadBtn
{
    if (!_uploadBtn) {
        _uploadBtn = [CHCUI createButtonWithtarg:self sel:@selector(uploadClick) titColor:nil font:nil image:@"update_carema" backGroundImage:nil title:nil];
        [_uploadBtn setEnlargeEdgeWithTop:20 right:20 bottom:20 left:20];
//        _uploadBtn.hidden = YES;
    }
    return _uploadBtn;
}
-(UIImageView *)bgView
{
    if (!_bgView) {
        _bgView = [CHCUI createImageWithbackGroundImageV:@""];
        _bgView.backgroundColor = white_backgroundColor;
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 5 ;

    }
    return _bgView;
}
-(UIImageView *)iconImg
{
    if (!_iconImg) {
        _iconImg = [CHCUI createImageWithbackGroundImageV:@""];
//        _iconImg.layer.masksToBounds = YES;
//        _iconImg.layer.cornerRadius = Diameter/2;
        _iconImg.backgroundColor =white_backgroundColor;
    }
    return _iconImg;
}
//-(UILabel *)nameLabel
//{
//    if (!_nameLabel) {
//        _nameLabel = [CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:0 font:font(13) textColor:font_grayColor text:@""];
//    }
//    return _nameLabel;
//}
//-(UILabel *)tasktitle
//{
//    if (!_tasktitle) {
//        _tasktitle = [CHCUI createLabelWithbackGroundColor:[UIColor clearColor] textAlignment:0 font:font(15) textColor:font_blackColor text:@"线上测试"];
//    }
//    return _tasktitle;
//}

-(UILabel *)name
{
    if (!_name) {
        _name = [CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:0 font:font(14) textColor:font_blackColor text:@""];
        
    }
    return _name;
}

-(UILabel *)desLabel
{
    if (!_desLabel) {
        _desLabel =[CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:0 font:font(12) textColor:font_grayColor text:@""];
    }
    return _desLabel;
}

//-(UILabel *)postLabel
//{
//    if (!_postLabel) {
//        _postLabel = [CHCUI createLabelWithbackGroundColor:nil textAlignment:0 font:font(10) textColor:[UIColor whiteColor] text:@""];
//        
//        _postLabel.layer.masksToBounds = YES;
//        _postLabel.layer.cornerRadius = 3;
//    }
//    return _postLabel;
//}
-(UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel =[CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:2 font:font(12) textColor:font_grayColor text:@""];
    }
    return _timeLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initUI];
    }
    return self;
}

-(void)initUI
{
    
    self.backgroundColor =[UIColor clearColor];
    [self.contentView addSubview:self.bgView];
//    [self.contentView addSubview:self.tasktitle];
    [self.contentView addSubview:self.iconImg];
    
//    self.name = [CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:0 font:font(12) textColor:font_grayColor text:@"发布人"];
    [self.contentView addSubview:self.name];
    
//    [self.contentView addSubview:self.postLabel];
//    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.desLabel];
    [self.contentView addSubview:self.uploadBtn];
    
    UILabel *line =[UILabel new];
    line.backgroundColor = LineColor;
    [self.contentView addSubview:line];
    
    [self.contentView addSubview:self.locationImg];
    [self.contentView addSubview:self.locationLabel];
    
//    UserInfoModel *model = [[[DBManager sharedManager] userDetailSQ] selectUserDetail];
//    UserAllModel *userModel = [[[DBManager sharedManager] personnelInformationSQ] selectDepartmentmemberlistById:model.alarm];
//    UnitListModel *uModel = [[[DBManager sharedManager] DepartmentlistSQ] selectDepartmentlistById:userModel.RE_department];
//    NSString *DE_type = uModel.DE_type;
//    NSString *DE_name = [LZXHelper isNullToString:uModel.DE_name];
//    
//    CGFloat width =_postLabel.frame.size.width;
//    
//    if ([DE_name isEqualToString:@""]) {
//        self.postLabel.layer.backgroundColor = [UIColor colorWithHexString:@"#96b0fb"].CGColor;
//        self.postLabel.text = [NSString stringWithFormat:@" 武汉市公安局 "];
//    }else {
//        if ([DE_type isEqualToString:@"0"]) {//0警察公务组织紫，1技术支持绿
//            self.postLabel.layer.backgroundColor = [UIColor colorWithHexString:@"#96b0fb"].CGColor;
//            self.postLabel.text = [NSString stringWithFormat:@" %@ ",userModel.RE_post];
//        }else if ([DE_type isEqualToString:@"1"]) {
//            self.postLabel.layer.backgroundColor = [UIColor colorWithHexString:@"#6cd9a3"].CGColor;
//            self.postLabel.text = [NSString stringWithFormat:@" %@ ",userModel.RE_post];
//        }
//    }
//    
//    width = [LZXHelper textWidthFromTextString:_postLabel.text height:20 fontSize:10];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(LeftMargin);
        make.right.equalTo(self.contentView.mas_right).offset(-LeftMargin);
        make.height.offset(CellHeight);
        make.top.equalTo(self.contentView.mas_top).offset(0);
    }];
    
    [self.iconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_top).offset(TopMargin);
        make.left.equalTo(self.bgView.mas_left).offset(LeftMargin);
        make.width.and.height.offset(Diameter);
    }];
    
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImg.mas_right).offset(LeftMargin);
        make.top.equalTo(self.iconImg.mas_top).offset(5);
        make.width.greaterThanOrEqualTo(@150);
        make.height.offset(15);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView.mas_right).offset(-12);
        make.top.equalTo(self.iconImg.mas_top).offset(0);
        make.width.equalTo(@100);
        make.height.offset(10);
        
    }];
    
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.name.mas_left).offset(0);
        make.top.equalTo(self.name.mas_bottom).offset(8);
        make.height.equalTo(@13);
        make.right.equalTo(self.bgView.mas_right).offset(-45);
    }];
    
//    [self.postLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.name.mas_centerY).with.offset(0);
//        make.left.equalTo(self.name.mas_right).with.offset(LeftMargin);
//        make.width.offset(width);
//        make.height.equalTo(self.name.mas_height).offset(0);
//    }];
//    
//    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.postLabel.mas_right).offset(5);
//        make.centerY.equalTo(self.postLabel.mas_centerY).offset(0);
//        make.width.greaterThanOrEqualTo(@100);
//        make.height.equalTo(self.postLabel.mas_height).offset(0);
//    }];
    
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImg.mas_left).offset(0);
        make.top.equalTo(self.iconImg.mas_bottom).offset(TopMargin);
        make.right.equalTo(self.bgView.mas_right).offset(-LeftMargin);
        make.height.equalTo(@1);
    }];
    
    [self.locationImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImg.mas_left).offset(0);
        make.top.equalTo(line.mas_bottom).offset(7);
        make.width.offset(11);
        make.height.offset(15);
    }];
    
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.locationImg.mas_centerY).offset(0);
        make.left.equalTo(self.locationImg.mas_right).offset(10);
        make.right.equalTo(self.bgView.mas_right).offset(-LeftMargin);
        make.height.equalTo(@14);
        
    }];
    
    [self.uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.desLabel.mas_centerY).offset(0);
        make.right.equalTo(self.bgView.mas_right).offset(-LeftMargin);
        make.width.offset(12);
        make.height.offset(14);
    }];
    
    
    
}

-(void)uploadClick
{
    self.draftsUploadClick(self.tempModel,self.type);
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
