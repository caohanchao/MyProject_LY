//
//  CallHelpBottomView.m
//  ProjectTemplate
//
//  Created by 李凯华 on 17/2/27.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "CallHelpBottomView.h"
#import "UserAllModel.h"
#import "XMLocationManager.h"

@interface CallHelpBottomView ()

//收到支援

@property (strong, nonatomic) UIView *reseveBgView;
@property (strong, nonatomic) UILabel *reseveTextlabel;
@property (strong, nonatomic) UILabel *reseveTimeLabel;
@property (strong, nonatomic) UILabel *reseveNameLabel;
@property (strong, nonatomic) UILabel *reseveAddressLabel;
@property (strong, nonatomic) UILabel *reseveLineLabel;
@property (strong, nonatomic) UIImageView *reseveIconImageView;
@property (strong, nonatomic) NSArray *reseveImageArr;
@property (strong, nonatomic) NSArray *reseveTitleArr;
@property (strong, nonatomic) NSMutableArray *userHelpArr;
@property (strong, nonatomic) UIScrollView *userHelpAsCtView;

@property (strong, nonatomic) NSDictionary *dict;


@end

@implementation CallHelpBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = zWhiteColor;
        [self initView];
    }
    return self;
}
- (void)initView {
    [self initTopView];
}

- (void)initTopView {
    
    [self addSubview:self.reseveBgView];
    [self.reseveBgView addSubview:self.reseveIconImageView];
    [self.reseveBgView addSubview:self.reseveNameLabel];
    [self.reseveBgView addSubview:self.reseveTextlabel];
    [self.reseveBgView addSubview:self.reseveTimeLabel];
    [self.reseveBgView addSubview:self.reseveAddressLabel];
    [self.reseveBgView addSubview:self.reseveLineLabel];
    
    [self createThreeImageViewAndTitleAndButton];
}

- (void)createThreeImageViewAndTitleAndButton
{
    for (int i = 0; i<3; i++) {
        UIImageView * bottomImageView = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth()/6-10+screenWidth()/3*i,110, 20, 20)];
        bottomImageView.image = [UIImage imageNamed:self.reseveImageArr[i]];
        [self.reseveBgView addSubview:bottomImageView];
        
        UILabel * bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth()/3*i, self.reseveBgView.height-20, screenWidth()/3, 15)];
        bottomLabel.text = self.reseveTitleArr[i];
        bottomLabel.textAlignment = NSTextAlignmentCenter;
        bottomLabel.font = [UIFont systemFontOfSize:12.0];
        bottomLabel.textColor = zBlueColor;
        if (i==2) {
            bottomLabel.textColor = ZEBRedColor;
        }
        [self.reseveBgView addSubview:bottomLabel];
        
        UIButton * bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        bottomBtn.frame = CGRectMake(screenWidth()/3*i, 110, screenWidth()/3, 50);
        bottomBtn.backgroundColor = zClearColor;
        bottomBtn.tag = i+60000;
        bottomBtn.enabled = YES;
        [bottomBtn addTarget:self action:@selector(bottomThreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.reseveBgView addSubview:bottomBtn];
    }
}

#pragma mark  -------收到救援信息的控件
//收到救援信息
- (UIView *)reseveBgView
{
    if (!_reseveBgView) {
        _reseveBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0 , screenWidth(), 160)];
        _reseveBgView.backgroundColor = zWhiteColor;
        _reseveBgView.hidden = YES;
    }
    return _reseveBgView;
}
- (UILabel*)reseveTextlabel
{
    if (!_reseveTextlabel) {
        _reseveTextlabel = [[UILabel alloc]initWithFrame:CGRectMake(74, 30, screenWidth()-84-12, 30)];
        _reseveTextlabel.text = @"在发起呼叫增援！";
        _reseveTextlabel.textColor = zGrayColor;
        _reseveTextlabel.font = [UIFont systemFontOfSize:12.0];
        _reseveTextlabel.textAlignment = NSTextAlignmentLeft;
        _reseveTextlabel.numberOfLines = 0;
    }
    return _reseveTextlabel;
}

- (UIImageView*)reseveIconImageView
{
    if (!_reseveIconImageView) {
        _reseveIconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 10, 50, 50)];
        _reseveIconImageView.layer.masksToBounds = YES;
        _reseveIconImageView.layer.cornerRadius = 6;
    }
    return _reseveIconImageView;
}
- (UILabel*)reseveNameLabel
{
    if (!_reseveNameLabel) {
        _reseveNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(74, 10, 60, 20)];
        _reseveNameLabel.textColor  = zBlackColor;
        _reseveNameLabel.textAlignment = NSTextAlignmentLeft;
        _reseveNameLabel.font = [UIFont systemFontOfSize:16.0];
    }
    return _reseveNameLabel;
}

- (UILabel*)reseveTimeLabel
{
    if (!_reseveTimeLabel) {
        CGFloat width = [LZXHelper textWidthFromTextString:@" 2017 - 01 - 13 16:12:00 " height:15 fontSize:12.0];
        
        _reseveTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth()-width-12, 15, width, 15)];
        _reseveTimeLabel.textColor = zGrayColor;
        _reseveTimeLabel.font = [UIFont systemFontOfSize:12.0];
        _reseveTimeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _reseveTimeLabel;
}

- (UILabel*)reseveAddressLabel
{
    if (!_reseveAddressLabel) {
        _reseveAddressLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 75, screenWidth()-24, 20)];
        _reseveAddressLabel.textColor = zBlackColor;
        _reseveAddressLabel.text = @"呼叫增援距离我 0 米";
        _reseveAddressLabel.font = [UIFont systemFontOfSize:14.0];
        _reseveAddressLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _reseveAddressLabel;
}

- (UILabel*)reseveLineLabel
{
    if (!_reseveLineLabel) {
        _reseveLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, screenWidth(), 0.5)];
        _reseveLineLabel.backgroundColor = LineColor;
    }
    return _reseveLineLabel;
}

- (NSArray*)reseveImageArr
{
    if (!_reseveImageArr) {
        _reseveImageArr = [NSArray arrayWithObjects:@"callhelpphonr",@"callcancel",@"callHelpdh", nil];
    }
    return _reseveImageArr;
}

- (NSArray*)reseveTitleArr
{
    if (!_reseveTitleArr) {
        _reseveTitleArr = [NSArray arrayWithObjects:@"电话",@"忽略",@"支援", nil];
    }
    return _reseveTitleArr;
}

- (UIScrollView*)userHelpAsCtView
{
    if (!_userHelpAsCtView) {
        _userHelpAsCtView = [[UIScrollView alloc]initWithFrame:CGRectMake(100, 40, screenWidth()-100-12, 100)];
        _userHelpAsCtView.showsVerticalScrollIndicator = NO;
        _userHelpAsCtView.showsHorizontalScrollIndicator = NO;
        _userHelpAsCtView.pagingEnabled = NO;
    }
    return _userHelpAsCtView;
}

- (void)showWith:(NSDictionary *)dict {
    
    CGRect rect = self.frame;
    rect.size.height = HEIGHT;
    rect.origin.y = screenHeight()-160;
    self.reseveBgView.hidden = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = rect;
    }];
    
    UserAllModel * model = [[[DBManager sharedManager]personnelInformationSQ]selectDepartmentmemberlistById:dict[@"content"][@"SID"]];
    
    self.reseveTimeLabel.text = dict[@"content"][@"TIME"];
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    if ([model.RE_alarmNum isEqualToString:alarm]) {
        UserInfoModel * model = [[[DBManager sharedManager]userDetailSQ]selectUserDetail];
        self.reseveNameLabel.text = model.name;
    }else {
       self.reseveNameLabel.text = model.RE_name;
    }
    
//    if ([model.RE_name isEqualToString:@"文件助手"]||[model.RE_name isEqualToString:@"文件小助手"]) {
//        UserInfoModel * model = [[[DBManager sharedManager]userDetailSQ]selectUserDetail];
//        self.reseveNameLabel.text = model.name;
//    }
//    else
//    {
//        self.reseveNameLabel.text = model.RE_name;
//    }
    
    [self.reseveIconImageView imageGetCacheForAlarm:model.RE_alarmNum forUrl:@"ph_s"];
    
    self.reseveAddressLabel.text = [NSString stringWithFormat:@"呼叫增援距离我 %.2f 米",[self getDistanceWith:dict]];
    
    [[XMLocationManager shareManager] reverseGeocodeWithCoordinate2D:(CLLocationCoordinate2D){[dict[@"content"][@"GPS"][@"W"] doubleValue],[dict[@"content"][@"GPS"][@"H"] doubleValue]} success:^(NSArray *pois) {
        if (pois && pois.count > 0) {
            CLPlacemark *position = pois[0];
            NSString * address = [position.addressDictionary[@"FormattedAddressLines"] firstObject];
            
           WeakSelf
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"在%@发起呼叫增援！",address]];
             [AttributedStr addAttribute:NSForegroundColorAttributeName value:zBlueColor range:NSMakeRange(1, address.length)];
            [AttributedStr addAttribute:NSForegroundColorAttributeName value:ZEBRedColor range:NSMakeRange(address.length+1, 7)];
           // weakSelf.reseveTextlabel.text = [NSString stringWithFormat:@"在%@发起呼叫增援！",address];
            weakSelf.reseveTextlabel.attributedText = AttributedStr;
        }
    } failure:^{
        
    }];
    
}
- (void)dissmiss {
    
    CGRect rect = self.frame;
    rect.size.height = 0;
    rect.origin.y = screenHeight();
    self.reseveBgView.hidden = YES;
    self.reseveAddressLabel.text = @"";
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = rect;
    }];
}
//下方三个按钮点击
- (void)bottomThreeBtnClick:(UIButton*)btn
{
    if (self.block) {
        self.block((int)btn.tag - 60000);
    }
}
//获取两个距离
- (CLLocationDistance)getDistanceWith:(NSDictionary*)dict
{
    
    //1.将两个经纬度点转成投影点
    MAMapPoint point1 = MAMapPointForCoordinate(CLLocationCoordinate2DMake(self.latitude ,self.longitude));
    MAMapPoint point2 = MAMapPointForCoordinate(CLLocationCoordinate2DMake([dict[@"content"][@"GPS"][@"W"] doubleValue],[dict[@"content"][@"GPS"][@"H"] doubleValue]));
    //2.计算距离
    CLLocationDistance kilometers = MAMetersBetweenMapPoints(point1,point2);
    
    return kilometers;
}

@end
