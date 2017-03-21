//
//  CallTheRollHomeTableViewCell.m
//  ProjectTemplate
//
//  Created by caohanchao on 2017/2/14.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#define ListGaryColor [UIColor colorWithRed:0.60 green:0.60 blue:0.60 alpha:1.00]

#import "CallTheRollHomeTableViewCell.h"
#import "RollCountDownProgress.h"
#import "UIButton+EnlargeEdge.h"
@interface CallTheRollHomeTableViewCell ()

@property (nonatomic,strong)UILabel *title;
@property (nonatomic,strong)UILabel *beginTime;
@property (nonatomic,strong)UILabel *peason;
@property (nonatomic,strong)UILabel *numbers;
@property (nonatomic,strong)RollCountDownProgress *countDownIcon;
@property (nonatomic,strong)UILabel *week;
@property (nonatomic,strong)UISwitch *repeat;
@property (nonatomic,strong)UIButton *report;
@property (nonatomic,strong)UILabel *line;


@property (nonatomic,assign)NSInteger  isReceiveOrCreateMode;

@property (nonatomic,copy)CallTheRollHomeCallBack callback;

@property (nonatomic,strong)CallTheRollListDetailModel *model;

@property (nonatomic,assign)CallTheRallType type;

@end

@implementation CallTheRollHomeTableViewCell

- (UILabel *)title {
    if (!_title) {
        _title = [CHCUI createLabelWithbackGroundColor:zWhiteColor textAlignment:0 font:ZEBFont(14) textColor:zBlackColor text:@"外出办案"];
    }
    return _title;
}
- (UILabel *)beginTime {
    if (!_beginTime) {
        _beginTime = [CHCUI createLabelWithbackGroundColor:zWhiteColor textAlignment:0 font:ZEBFont(10) textColor:ListGaryColor text:@"开始时间:   12:00"];
    }
    return _beginTime;
}
- (UILabel *)peason {
    if (!_peason) {
        _peason = [CHCUI createLabelWithbackGroundColor:zWhiteColor textAlignment:0 font:ZEBFont(13) textColor:zBlackColor text:@"杨华"];
    }
    return _peason;
}
- (UILabel *)numbers {
    if (!_numbers) {
        _numbers = [CHCUI createLabelWithbackGroundColor:zWhiteColor textAlignment:0 font:ZEBFont(13) textColor:ListGaryColor text:@"12/13人"];
    }
    return _numbers;
}

- (UILabel *)week {
    if (!_week) {
        _week = [CHCUI createLabelWithbackGroundColor:zWhiteColor textAlignment:0 font:ZEBFont(13) textColor:zBlueColor text:@"周一,周五"];
    }
    return _week;
}

- (UISwitch *)repeat {
    if (!_repeat) {
        _repeat = [[UISwitch alloc] init];
        _repeat.onTintColor = zBlueColor;
        [_repeat addTarget:self action:@selector(repeatSwitch:) forControlEvents:UIControlEventValueChanged];
        
    }
    return _repeat;
}

- (RollCountDownProgress *)countDownIcon {
    if (!_countDownIcon) {
        _countDownIcon = [[RollCountDownProgress alloc] initWithFrame:CGRectMake(12, 22, 30, 30)];
        _countDownIcon.backgroundColor = [UIColor whiteColor];
        
    }
    return _countDownIcon;
}

- (UIButton *)report {
    if (!_report ) {
        _report = [CHCUI createButtonWithtarg:self sel:@selector(reportClick) titColor:ListGaryColor font:ZEBFont(13) image:@"" backGroundImage:@"" title:@"报道"];
        [_report setEnlargeEdgeWithTop:10 right:10 bottom:10 left:20];
        _report.layer.borderWidth = 0.5;
        _report.layer.borderColor = ListGaryColor.CGColor;
        _report.userInteractionEnabled = NO;
    }
    return _report;
}

- (UILabel *)line {
    if (!_line) {
        _line = [UILabel new];
        _line.backgroundColor = LineColor;
    }
    return _line;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)configWithModel:(CallTheRollListDetailModel *)model withCallRollType:(CallTheRallType)type withReceiveOrCreateMode:(NSInteger)mode withCallBack:(CallTheRollHomeCallBack)callback {
    self.model = model;
    self.type = type;
    self.isReceiveOrCreateMode = mode;
    _title.text = _model.title;
    _beginTime.text = _model.start_time;
    _peason.text = _model.publish_name;
    _numbers.text = [NSString stringWithFormat:@"%@/%@人",_model.reportNum,_model.userAllNum];
    _week.text = [self getselectWeek];
    
    self.countDownIcon.count = _model.countdown;
    self.countDownIcon.callTheRolling = _model.sign_state;
    
    [self changeReportState];
    
    [self.countDownIcon setNeedsDisplay];
    
    //点名类型   点名中 ,待点名  ,已完成 ,已关闭
    if ([_model.sign_state isEqualToString:@"0"]) {
        if([_model.keeptime isEqualToString:@"0"]){
            self.countDownIcon.keepTime = @"30";
        }else {
            self.countDownIcon.keepTime = [NSString stringWithFormat:@"%ld",[_model.keeptime integerValue] * 60];
        }
        
    }
    _callback = callback;
    
}

- (void)setType:(CallTheRallType)type {
    _type = type;
}

- (void)setIsReceiveOrCreateMode:(NSInteger)isReceiveOrCreateMode {
    _isReceiveOrCreateMode = isReceiveOrCreateMode;
    
    [self isShowView];
    
}

- (void)changeReportState {
    
    if ([_model.sign_state isEqualToString:@"0"]) {
        if ([self.model.self_state isEqualToString:@"0"]) {
            _report.layer.borderColor = zBlueColor.CGColor;
            [_report setTitleColor:zBlueColor];
            _report.userInteractionEnabled = YES;
        }
        else {
            _report.layer.borderColor = ListGaryColor.CGColor;
            [_report setTitleColor:ListGaryColor];
            _report.userInteractionEnabled = NO;
        }
    }
    else {
        _report.layer.borderColor = ListGaryColor.CGColor;
        [_report setTitleColor:ListGaryColor];
        _report.userInteractionEnabled = NO;
    }
    
}

- (void)isShowView {
    //接收
    if (_isReceiveOrCreateMode == 1) {
        _report.hidden = NO;
        _repeat.hidden = YES;
    }
    //创建
    else {
        _report.hidden = YES;
        // isrepeat : 1 不重复  isrepeat : 0 重复
        if ([_model.isrepeat isEqualToString:@"1"]) {
            _repeat.hidden = YES;
        }else{
            _repeat.hidden = NO;
            _repeat.on = [_model.active_state boolValue];
        }
    }
}

- (void)reportClick {
    self.callback(self.report,NO,self.model.rallcallid);
}

- (void)repeatSwitch:(UISwitch *)repeat {
    self.callback(self.repeat,repeat.on,self.model.rallcallid);
}
- (void)createUI {
    
    [self.contentView addSubview:self.countDownIcon];
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.week];
    [self.contentView addSubview:self.beginTime];
    [self.contentView addSubview:self.peason];
    [self.contentView addSubview:self.numbers];
    
//    [self.countDownIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView.mas_left).offset(12);
//        make.height.width.offset(30);
//        make.top.equalTo(self.contentView.mas_top).offset(22);
//    }];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(55);
        make.width.offset(100);
        make.height.offset(14);
    }];
    [self.week mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.contentView.mas_centerX).offset(0);
        make.right.equalTo(self.contentView.mas_right).offset(-12);
        make.height.offset(13);
    }];
    
    [self.beginTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom).offset(10);
        make.left.equalTo(self.title.mas_left);
        make.width.equalTo(@200);
        make.height.offset(10);
    }];
    [self.peason mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.beginTime.mas_bottom).offset(10);
        make.left.equalTo(self.beginTime.mas_left);
        make.width.offset(100);
        make.height.offset(14);
    }];
    
    [self.numbers mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.peason.mas_right).offset(100);
        make.centerY.mas_equalTo(self.peason);
        make.height.offset(13);
        make.width.offset(80);
    }];
    [self.contentView addSubview:self.report];
    [self.report mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-14);
        make.width.mas_equalTo(45);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(22);
    }];
    
    [self.contentView addSubview:self.repeat];
    [self.repeat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-14);
//        make.width.mas_equalTo(45);
        make.top.equalTo(self.contentView.mas_top).offset(25);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-25);
//        make.centerY.equalTo(self.contentView.mas_centerY);
//        make.height.mas_equalTo(22);
    }];
    
    
//    [self.contentView addSubview:self.line];
//    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.peason.mas_left).offset(0);
//        make.right.equalTo(self.)
//    }];
    
}

#pragma mark -
#pragma mark 返回选中周几的字符串
- (NSString *)getselectWeek {
    NSArray *array = @[@"周日",@"周一",@"周二",@"周三",@"周四",@"周五",@"周六"];
    NSString *weekstr = self.model.week;
//    NSMutableString *string = [[NSString alloc] init];
    NSMutableArray *repertWeek = [NSMutableArray array];
    if ([self.model.isrepeat isEqualToString:@"0"]) {
        for (int i = 0; i < weekstr.length; i++) {
            BOOL isrepert = [[NSString stringWithFormat:@"%c",[weekstr characterAtIndex:i]] boolValue];
            if (isrepert) {
                [repertWeek addObject:array[i]];
            }
        }
    }
    return [repertWeek componentsJoinedByString:@", "];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
