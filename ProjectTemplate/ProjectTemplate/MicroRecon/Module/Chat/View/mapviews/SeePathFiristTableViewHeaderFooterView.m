//
//  SeePathFiristTableViewHeaderFooterView.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/22.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "SeePathFiristTableViewHeaderFooterView.h"
#import "UIImageView+CornerRadius.h"
#import "NSString+Property.h"

@interface SeePathFiristTableViewHeaderFooterView ()

@property (nonatomic, strong) UIImageView *headPic;
@property (nonatomic, strong) UILabel *poLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *imageBtn;


@end

@implementation SeePathFiristTableViewHeaderFooterView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"headerFirist";
    SeePathFiristTableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        header = [[SeePathFiristTableViewHeaderFooterView alloc] initWithReuseIdentifier:ID];
        
    }
    return header;
    
}

/**
 *  在这个初始化方法中,MJHeaderView的frame\bounds没有值
 */
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        UIView *view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = [UIColor whiteColor];
        self.backgroundView = view;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
        singleRecognizer.numberOfTapsRequired = 1; //点击的次数 =1:单击
        [singleRecognizer setNumberOfTouchesRequired:1];//1个手指操作
        [self addGestureRecognizer:singleRecognizer];//添加一个手势监测；
        [self createView];
    }
    return self;
}
- (void)createView {
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = zGroupTableViewBackgroundColor;
    
    self.headPic  = [[UIImageView alloc] initWithCornerRadiusAdvance:6 rectCornerType:UIRectCornerAllCorners];
    
    self.poLabel = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentCenter font:ZEBFont(8) textColor:zWhiteColor text:@""];
    self.poLabel.layer.masksToBounds = YES;
    self.poLabel.layer.cornerRadius = 3;
    self.poLabel.textAlignment = NSTextAlignmentCenter;
    
    self.nameLabel  = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentLeft font:ZEBFont(13) textColor:CHCHexColor(@"000000") text:@""];
    
    self.imageBtn = [[UIImageView alloc] init];
    self.imageBtn.image = [UIImage imageNamed:@"zhankai"];
    
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = LineColor;
    
    UILabel *line1 = [[UILabel alloc] init];
    line1.backgroundColor = LineColor;
    
    [self.contentView addSubview:topView];
    [self.contentView addSubview:self.headPic];
  //  [self.contentView addSubview:self.poLabel];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.imageBtn];
    [self.contentView addSubview:line1];
    [self.contentView addSubview:line];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(16);
    }];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.headPic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(7);
        make.left.equalTo(self.mas_left).offset(12);
        make.size.mas_equalTo(CGSizeMake(36, 36));
    }];
//    [self.poLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.headPic.mas_centerY);
//        make.left.equalTo(self.headPic.mas_right).offset(12);
//        make.height.equalTo(@15);
//        make.width.mas_lessThanOrEqualTo(100);
//    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headPic.mas_centerY);
        make.left.equalTo(self.headPic.mas_right).offset(12);
        make.height.equalTo(@15);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    [self.imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headPic.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-20);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
}
- (void)setAlarm:(NSString *)alarm {
    _alarm = alarm;
    [self reloadCell];
}
- (void)reloadCell {
    
    UserAllModel *uModel = [[[DBManager sharedManager] personnelInformationSQ] selectDepartmentmemberlistById:self.alarm];
    [self.headPic imageGetCacheForAlarm:self.alarm forUrl:uModel.RE_headpic];
    
    UnitListModel *ulModel = [[[DBManager sharedManager] DepartmentlistSQ] selectDepartmentlistById:uModel.RE_department];
    NSString *DE_type = ulModel.DE_type;
    NSString *DE_name = [LZXHelper isNullToString:uModel.RE_post];
    
    if ([[LZXHelper isNullToString:DE_type] isEqualToString:@""]) {
        self.poLabel.layer.backgroundColor = [UIColor colorWithHexString:@"#96b0fb"].CGColor;
        
        self.poLabel.text = [NSString stringWithFormat:@" 武汉市公安局 "];
        
        
    }else {
        if ([DE_type isEqualToString:@"0"]) {//0警察公务组织紫，1技术支持绿
            self.poLabel.layer.backgroundColor = [UIColor colorWithHexString:@"#96b0fb"].CGColor;
            self.poLabel.text = [NSString stringWithFormat:@" %@ ",DE_name];
            
        }else if ([DE_type isEqualToString:@"1"]) {
            self.poLabel.layer.backgroundColor = [UIColor colorWithHexString:@"#6cd9a3"].CGColor;
            self.poLabel.text = [NSString stringWithFormat:@" %@ ",DE_name];
            
        }
        
    }
    self.nameLabel.text = uModel.RE_name;
    if ([_alarm.open boolValue]) {
        
        self.imageBtn.image = [UIImage imageNamed:@"zhankai"];
        
    }else {
        
        self.imageBtn.image = [UIImage imageNamed:@"shouqi"];
        
    }
    
}
#pragma mark 展开收缩section中cell 手势监听
-(void)SingleTap:(UITapGestureRecognizer*)recognizer {
    
    if (_deleagte && [_deleagte respondsToSelector:@selector(seePathFiristTableViewHeaderFooterView:index:)]) {
        [_deleagte seePathFiristTableViewHeaderFooterView:self index:self.idnex];
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
