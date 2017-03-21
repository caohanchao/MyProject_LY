//
//  VehicleDetectionSearchViewController.m
//  ProjectTemplate
//
//  Created by caohanchao on 2016/12/1.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//  车辆侦查-搜索

#define CHCTextColor [UIColor whiteColor]
#define CHCBGColor [UIColor whiteColor]
#define Font(font) [UIFont systemFontOfSize:font]
#define btnFont() [UIFont systemFontOfSize:12]

static NSString * VD_Search_StartTime  = @"起始时间:";
static NSString * VD_Search_EndTime = @"结束时间:";

#import "VehicleDetectionSearchViewController.h"
#import "ZEBPickerView.h"
#import "VehicleDetectionViewController.h"
#import "GetInfoCarRequest.h"
#import "VdBaseResultModel.h"
#import "VdResultModel.h"
#import <MAMapKit/MAMapKit.h>
#import "VehicleDetectionMapManager.h"
#import "ZEBUtils.h"
#import "ZEBSearchTextField.h"
#import "ProvinceListAlertView.h"
#import "VehicleDetectionListViewController.h"

@interface VehicleDetectionSearchViewController ()<ZEBPickViewDelegate,UITextFieldDelegate>

{
    NSString *_searchStartTime;
    NSString *_searchEndTime;
    NSString *_searchResult;
    NSDateFormatter* _formatter;
}

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,strong)UIView *topView;

@property(nonatomic,strong)UIView *bottomView;

@property(nonatomic,strong)UIView *chooseView; // 选项view

@property(nonatomic,strong)UIButton *oneDayBtn;

@property(nonatomic,strong)UIButton *threeDayBtn;

@property(nonatomic,strong)UIButton *oneWeekBtn;

@property (nonatomic, strong) UIButton *provinceBtn;

@property(nonatomic,strong)ZEBSearchTextField *searchTextfield;

@property(nonatomic,strong)ZEBSearchTextField *searchBar;

@property(nonatomic,strong)UIButton *startTime;

@property(nonatomic,strong)UIButton *endTime;

@property(nonatomic,strong)UIButton *searchBtn;

@property(nonatomic,strong)UILabel *startTimeLabel;

@property(nonatomic,strong)UILabel *endTimeLabel;

@property(nonatomic,strong) ZEBPickerView *cuiPickerView;

@property (nonatomic, weak) MAMapView *mapView;

@property (nonatomic, weak) UIImageView *TrafficMonitoringImage;
@property (nonatomic, weak) UIImageView *PathAnalysisImage;

@property (nonatomic, strong) ProvinceListAlertView *provinceListAlertView;

@end




@implementation VehicleDetectionSearchViewController


- (ProvinceListAlertView *)provinceListAlertView {
    if (!_provinceListAlertView) {
        _provinceListAlertView = [[ProvinceListAlertView alloc] init];
        _provinceListAlertView.backgroundColor = zClearColor;
        _provinceListAlertView.frame = CGRectMake(0, 0, kScreenWidth-24, HEIGHT_H);
        _provinceListAlertView.direction = TriangleDirection_Up;
        _provinceListAlertView.borderWidth = 0.5;
        _provinceListAlertView.borderColor = CHCHexColor(@"eeeeee");
        _provinceListAlertView.cornerRadius = 5;
        _provinceListAlertView.color = CHCHexColor(@"f5f5f5");
        _provinceListAlertView.triangleXY = 20;
        WeakSelf
        _provinceListAlertView.block = ^(ProvinceListAlertView *view, NSString *province){
            ZEBLog(@"------%@",province);
    
            [weakSelf.provinceBtn setTitle:province forState:UIControlStateNormal];
        };
    }
    return _provinceListAlertView;
}
- (ZEBPickerView *)cuiPickerView {
    if (!_cuiPickerView) {
        _cuiPickerView = [ZEBPickerView new];
        _cuiPickerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200);
        _cuiPickerView.delegate = self;
        _cuiPickerView.backgroundColor = [UIColor whiteColor];
    }
    return _cuiPickerView;
}
- (UIView *)chooseView {
    if (!_chooseView) {
        _chooseView = [[UIView alloc] init];
        _chooseView.backgroundColor = zWhiteColor;
    }
    return _chooseView;
}
- (UIView *)topView {
    if (!_topView) {
        _topView = [UIView new];
        _topView.backgroundColor = CHCBGColor;
    }
    return _topView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView =[UIView new];
        _bottomView.backgroundColor = CHCBGColor;
    }
    return _bottomView;
}
- (UIButton *)provinceBtn {
    if (!_provinceBtn) {
        _provinceBtn = [CHCUI createButtonWithtarg:self sel:@selector(chooseProvince:) titColor:zBlackColor font:ZEBFont(14) image:nil backGroundImage:nil title:@"鄂"];
        _provinceBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 2.5, 0);
    }
    return _provinceBtn;
}
- (ZEBSearchTextField *)searchBar {
    if (!_searchBar) {
        _searchBar = [ZEBSearchTextField new];
        
//        path.lineWidth = 5.0;
        _searchBar.backgroundColor = [UIColor whiteColor];
        _searchBar.layer.borderWidth = 1;
        _searchBar.returnKeyType = UIReturnKeySearch;
        _searchBar.layer.borderColor = [UIColor colorWithRed:0.86 green:0.86 blue:0.86 alpha:1.00].CGColor;
        _searchBar.layer.cornerRadius = 5;
        _searchBar.layer.masksToBounds = YES;
        _searchBar.delegate = self;
        _searchBar.textColor = CHCHexColor(@"333333");
       // _searchBar.text = @"鄂A";
        _searchBar.font = [UIFont systemFontOfSize:14];
        
        //左
        UIView *blankView = [[UIView alloc] initWithFrame:CGRectMake(0,0,12.0, _searchBar.frame.size.height)];
        _searchBar.leftView = blankView;
        _searchBar.leftViewMode =UITextFieldViewModeAlways;
        _searchBar.enablesReturnKeyAutomatically = YES; //这里设置为无文字就灰色不可点
        
        //右
//        UIView *searchview = [UIView new];
//        searchview.frame =CGRectMake(0, 0, 35, 20);
//        
//        UIImageView *imgv=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"VD_search"]];
//        imgv.frame = CGRectMake(0, 0, 20, 20);
//        imgv.userInteractionEnabled = YES;
//        [searchview addSubview:imgv];
//        _searchBar.rightView = searchview;
//        _searchBar.rightViewMode = UITextFieldViewModeAlways;
//        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(searchBtnClick)];
//        [imgv addGestureRecognizer:tap];

    }
    return  _searchBar;
}

- (UIButton *)oneDayBtn {
    if (!_oneDayBtn) {
        _oneDayBtn = [CHCUI createButtonWithtarg:self sel:@selector(oneDayBtnClick) titColor:CHCTextColor font:Font(13) image:@"VD_seachTime" backGroundImage:nil title:@"一天以内"];
        _oneDayBtn.layer.masksToBounds = YES;
        _oneDayBtn.layer.cornerRadius = 5;
        
        _oneDayBtn.backgroundColor = CHCHexColor(@"f8b551");
        
        [_oneDayBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 60)];
//        [_oneDayBtn setTitleEdgeInsets:UIEdgeInsetsMake(10, 5, 10, 55)];
    }
    return _oneDayBtn;
}


- (UIButton *)threeDayBtn {
    if (!_threeDayBtn) {
        _threeDayBtn = [CHCUI createButtonWithtarg:self sel:@selector(threeDayBtnClick) titColor:CHCTextColor font:Font(13) image:@"VD_seachTime" backGroundImage:nil title:@"三天以内"];
        _threeDayBtn.layer.masksToBounds = YES;
        _threeDayBtn.layer.cornerRadius = 5;
        _threeDayBtn.backgroundColor = CHCHexColor(@"f8b551");

        [_threeDayBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 60)];
    }
    return _threeDayBtn;
}

- (UIButton *)oneWeekBtn {
    if (!_oneWeekBtn) {
        _oneWeekBtn = [CHCUI createButtonWithtarg:self sel:@selector(oneWeekBtnClick) titColor:CHCTextColor font:Font(13) image:@"VD_seachTime" backGroundImage:nil title:@"一周以内"];
        _oneWeekBtn.layer.masksToBounds = YES;
        _oneWeekBtn.layer.cornerRadius = 5;
        _oneWeekBtn.backgroundColor = CHCHexColor(@"f8b551");

        [_oneWeekBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 60)];
    }
    return  _oneWeekBtn;
}

- (UIButton *)searchBtn {
    if (!_searchBtn) {
        _searchBtn = [CHCUI createButtonWithtarg:self sel:@selector(searchBtnClick) titColor:CHCTextColor font:Font(18) image:nil backGroundImage:nil title:@"搜 索"];
        _searchBtn.layer.masksToBounds = YES;
        _searchBtn.layer.cornerRadius = 5;
        _searchBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _searchBtn.backgroundColor = CHCHexColor(@"12b7f5");
//        _searchBtn.backgroundColor = zBlueColor;
    }
    return _searchBtn;
}

- (ZEBSearchTextField *)searchTextfield {
    if (!_searchTextfield) {
        _searchTextfield = [ZEBSearchTextField new];
        _searchTextfield.textColor = CHCHexColor(@"333333");
        _searchTextfield.font = Font(12);
        
    }
    return _searchTextfield;
}

- (UIButton *)startTime {
    if (!_startTime) {
        _startTime = [UIButton buttonWithType:UIButtonTypeCustom];
        [_startTime addTarget:self action:@selector(startTimeClick) forControlEvents:UIControlEventTouchUpInside];
        _startTime.backgroundColor = [UIColor clearColor];
    }
    return _startTime;
}

- (UIButton *)endTime {
    if (!_endTime) {
        _endTime = [UIButton buttonWithType:UIButtonTypeCustom];
        [_endTime addTarget:self action:@selector(endTimeClick) forControlEvents:UIControlEventTouchUpInside];
        _endTime.backgroundColor = [UIColor clearColor];
    }
    return _endTime;
}

- (UILabel *)startTimeLabel {
    if(!_startTimeLabel) {
        _startTimeLabel = [CHCUI createLabelWithbackGroundColor:[UIColor whiteColor] textAlignment:0 font:Font(14) textColor:[UIColor blackColor] text:VD_Search_StartTime];
    }
    return _startTimeLabel;
}

- (UILabel *)endTimeLabel {
    if (!_endTimeLabel ) {
        _endTimeLabel = [CHCUI createLabelWithbackGroundColor:[UIColor whiteColor] textAlignment:0 font:Font(14) textColor:[UIColor blackColor] text:VD_Search_EndTime];
    }
    return _endTimeLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.analysisType = TrafficMonitoring;
    [self initUI];
    
    [self initFormater];
    
    [self oneDayBtnClick];
    self.mapView  = [VehicleDetectionMapManager shareMAMapView];
    // Do any additional setup after loading the view.
}

#pragma mark - INITUI

- (void)initUI {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = zGroupTableViewBackgroundColor;
    self.title = @"车辆查询";
    [self.view addSubview:self.topView];
    [self.view addSubview:self.bottomView];
    [self.view addSubview:self.chooseView];
    [self addSubViewOfTopView];
    [self addSubViewOfBottomView];
    [self addSearchBtn];
    [self addchooseView];
    [self.view addSubview:self.cuiPickerView];
    
}

- (void)addchooseView {
    
    
    UILabel *line1 = [[UILabel alloc] init];
    line1.backgroundColor = LineColor;
    
    UILabel *TrafficMonitoringLabel = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentLeft font:ZEBFont(14) textColor:zBlackColor text:@"通行监控"];
    TrafficMonitoringLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapTrafficMonitoring = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseTrafficMonitoring)];
    [TrafficMonitoringLabel addGestureRecognizer:tapTrafficMonitoring];
    
    UIImageView *TrafficMonitoringImage = [CHCUI createImageWithbackGroundImageV:@"gougou"];
    TrafficMonitoringImage.alpha = 1.0;
    self.TrafficMonitoringImage = TrafficMonitoringImage;
    
    UILabel *line2 = [[UILabel alloc] init];
    line2.backgroundColor = LineColor;
    
    UILabel *PathAnalysisLabel = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentLeft font:ZEBFont(14) textColor:zBlackColor text:@"轨迹分析"];
    PathAnalysisLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapPathAnalysisLabel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choosePathAnalysisLabel)];
    [PathAnalysisLabel addGestureRecognizer:tapPathAnalysisLabel];
    
    UIImageView *PathAnalysisImage = [CHCUI createImageWithbackGroundImageV:@"gougou"];
    PathAnalysisImage.alpha = 0.0;
    self.PathAnalysisImage = PathAnalysisImage;
    
    
    UILabel *line3 = [[UILabel alloc] init];
    line3.backgroundColor = LineColor;
    
    
    [self.chooseView addSubview:line1];
    [self.chooseView addSubview:line2];
    [self.chooseView addSubview:line3];
    
    [self.chooseView addSubview:TrafficMonitoringLabel];
    [self.chooseView addSubview:TrafficMonitoringImage];
    
    [self.chooseView addSubview:PathAnalysisLabel];
    [self.chooseView addSubview:PathAnalysisImage];

    
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.chooseView);
        make.height.equalTo(@0.5);
    }];
    
    [TrafficMonitoringLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.chooseView.mas_left).offset(12);
        make.top.equalTo(line1.mas_bottom);
        make.right.equalTo(self.chooseView.mas_right);
        make.height.equalTo(@45);
    }];
    
    [TrafficMonitoringImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(TrafficMonitoringLabel.mas_centerY);
        make.right.equalTo(self.chooseView.mas_right).offset(-12);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.chooseView.mas_left).offset(12);
        make.centerY.equalTo(self.chooseView.mas_centerY);
        make.right.equalTo(self.chooseView);
        make.height.equalTo(@0.5);
    }];
    
    [PathAnalysisLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.chooseView.mas_left).offset(12);
        make.top.equalTo(line2.mas_bottom);
        make.right.equalTo(self.chooseView.mas_right);
        make.height.equalTo(@45);
    }];
    
    [PathAnalysisImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(PathAnalysisLabel.mas_centerY);
        make.right.equalTo(self.chooseView.mas_right).offset(-12);
        make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.chooseView);
        make.height.equalTo(@0.5);
    }];
    
}
- (void)addSearchBtn {
    
    [self.view addSubview:self.searchBtn];
    [self.searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(12);
        make.right.equalTo(self.view.mas_right).offset(-12);
        make.height.offset(40);
        make.top.equalTo(self.chooseView.mas_bottom).offset(30);
    }];
}

- (void)initFormater {
    
    _formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"yyyy-MM-dd HH:mm"];

}

- (void)addSubViewOfTopView {
    
    
    [self.topView addSubview:self.searchBar];
    [self.searchBar addSubview:self.provinceBtn];
//    [self.topView addSubview:self.oneDayBtn];
//    [self.topView addSubview:self.threeDayBtn];
//    [self.topView addSubview:self.oneWeekBtn];
    
    
    NSInteger top_L_R_Constraints = 20;
    CGFloat btnWidth = 92;
    CGFloat btnSpace = ([UIScreen mainScreen].bounds.size.width - (btnWidth*3)- top_L_R_Constraints*2)/2;
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.offset(100);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
//        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.height.offset(90);
    }];
    
    [self.chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView.mas_bottom).offset(16);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@91.5);
    }];
    
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_top).offset(30);
        make.left.equalTo(self.topView.mas_left).offset(12);
        make.right.equalTo(self.topView.mas_right).offset(-12);
        make.height.equalTo(@38);
       
    }];
    
    [self.provinceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.searchBar);
        make.bottom.equalTo(self.searchBar).offset(1);
        make.width.mas_equalTo(self.searchBar.mas_height);
    }];
    
//    [self.oneDayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.searchBar.mas_bottom).offset(20);
//        make.left.equalTo(self.topView.mas_left).offset(top_L_R_Constraints);
////        make.height.equalTo(@35);
//        make.bottom.equalTo(self.topView.mas_bottom).offset(-20);
////        make.width.offset(btnWidth);
//    }];
//    [self.threeDayBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.oneDayBtn.mas_top);
//        make.left.equalTo(self.oneDayBtn.mas_right).offset(10);
//        make.height.equalTo(self.oneDayBtn.mas_height);
//        make.width.equalTo(self.oneDayBtn.mas_width);
////        make.width.equalTo(self.oneDayBtn.mas_width);
//    }];
//    [self.oneWeekBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.oneDayBtn.mas_top);
//        make.left.equalTo(self.threeDayBtn.mas_right).offset(10);
//        make.height.equalTo(self.oneDayBtn.mas_height);
//        make.width.equalTo(self.oneDayBtn.mas_width);
//        make.right.equalTo(self.topView.mas_right).offset(-top_L_R_Constraints);
//    }];
}

- (void)addSubViewOfBottomView {
    
    
    CGFloat bottom_L_R_Constraints = 12;
    CGFloat bottom_T_B_Constraints = 13;
    CGFloat bottom_height = 19;
    
    UIImageView *startImg = [CHCUI createImageWithbackGroundImageV:@"VD_start"];
    
    UIImageView *endImg =[CHCUI createImageWithbackGroundImageV:@"VD_end"];
    
    UIImageView *startTimerightImg = [CHCUI createImageWithbackGroundImageV:@"VD_itemright"];
    
    UIImageView *endTimerightImg = [CHCUI createImageWithbackGroundImageV:@"VD_itemright"];
    
    UILabel *line1 = [UILabel new];
    line1.backgroundColor = LineColor;
    
    UILabel *line2 = [UILabel new];
    line2.backgroundColor = LineColor;
    
    [self.bottomView addSubview:startImg];
    [self.bottomView addSubview:endImg];
    
    [self.bottomView addSubview:self.startTimeLabel];
    [self.bottomView addSubview:self.endTimeLabel];
    
    [self.bottomView addSubview:startTimerightImg];
    [self.bottomView addSubview:endTimerightImg];
    
    [self.bottomView addSubview:self.startTime];
    [self.bottomView addSubview:self.endTime];
    
   // [self.bottomView addSubview:line1];
    [self.bottomView addSubview:line2];
    
    
    
    [startImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.bottomView.mas_top).offset(bottom_T_B_Constraints);
        make.left.equalTo(self.bottomView.mas_left).offset(bottom_L_R_Constraints);
        make.width.and.height.offset(bottom_height);
//        make.bottom.equalTo(self.startTime.mas_bottom).offset(-bottom_T_B_Constraints);
    }];
    
    [startTimerightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(startImg.mas_centerY).offset(0);
        make.right.equalTo(self.bottomView.mas_right).offset(-bottom_L_R_Constraints);
        make.height.width.offset(12);
    }];
    
    [self.startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(startImg.mas_right).offset(bottom_L_R_Constraints);
        make.centerY.equalTo(startImg.mas_centerY).offset(0);
        make.height.offset(bottom_height);
        make.right.equalTo(startTimerightImg.mas_left).offset(-bottom_L_R_Constraints);
    }];
    
    [self.startTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView.mas_top);
        make.left.equalTo(self.bottomView.mas_left);
        make.right.equalTo(self.bottomView.mas_right);
        make.height.offset(bottom_height + bottom_T_B_Constraints*2);
    }];
    
    [endImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.startTime.mas_bottom).offset(bottom_T_B_Constraints);
        make.left.equalTo(self.bottomView.mas_left).offset(bottom_L_R_Constraints);
        make.width.and.height.offset(bottom_height);
    }];
    
    [endTimerightImg mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerY.equalTo(endImg.mas_centerY).offset(0);
        make.right.equalTo(self.bottomView.mas_right).offset(-bottom_L_R_Constraints);
        make.width.height.offset(12);
    }];
    
    [self.endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(endImg.mas_right).offset(bottom_L_R_Constraints);
        make.centerY.equalTo(endImg.mas_centerY).offset(0);
        make.height.offset(bottom_height);
        make.right.equalTo(endTimerightImg.mas_left).offset(-bottom_L_R_Constraints);
    }];
    
    [self.endTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.startTime.mas_bottom);
        make.left.equalTo(self.bottomView.mas_left);
        make.right.equalTo(self.bottomView.mas_right);
        make.height.offset(bottom_height+bottom_T_B_Constraints*2);
    }];
    
    
    
//    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.startTime.mas_top);
//        make.left.equalTo(self.startTime.mas_left);
//        make.right.equalTo(self.startTime.mas_right);
//        make.height.equalTo(@0.5);
//    }];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.endTime.mas_top);
        make.left.equalTo(self.endTimeLabel.mas_left);
        make.right.equalTo(self.endTime.mas_right);
        make.height.equalTo(@0.5);
    }];
    
    
    
}
#pragma mark - CLICK
//一天以内
- (void)oneDayBtnClick {

    _searchEndTime = [_formatter stringFromDate:[NSDate date]];
    NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:[NSDate date]];
    _searchStartTime = [_formatter stringFromDate:lastDay];

    self.startTimeLabel.text = [NSString stringWithFormat:@"%@ %@",VD_Search_StartTime,_searchStartTime];
    self.endTimeLabel.text = [NSString stringWithFormat:@"%@ %@",VD_Search_EndTime,_searchEndTime];
    
    [_oneDayBtn setBackgroundColor:CHCHexColor(@"f39800")];
    [_threeDayBtn setBackgroundColor:CHCHexColor(@"f8b551")];
    [_oneWeekBtn setBackgroundColor:CHCHexColor(@"f8b551")];
    
}
//三天以内
- (void)threeDayBtnClick {
    [self.searchBar resignFirstResponder];

    _searchEndTime = [_formatter stringFromDate:[NSDate date]];
    NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60*3 sinceDate:[NSDate date]];
    _searchStartTime = [_formatter stringFromDate:lastDay];
        

    self.startTimeLabel.text = [NSString stringWithFormat:@"%@ %@",VD_Search_StartTime,_searchStartTime];
    self.endTimeLabel.text = [NSString stringWithFormat:@"%@ %@",VD_Search_EndTime,_searchEndTime];
    
    [_oneDayBtn setBackgroundColor:CHCHexColor(@"f8b551")];
    [_threeDayBtn setBackgroundColor:CHCHexColor(@"f39800")];
    [_oneWeekBtn setBackgroundColor:CHCHexColor(@"f8b551")];
    
}
//一周以内
- (void)oneWeekBtnClick {
    [self.searchBar resignFirstResponder];

    _searchEndTime = [_formatter stringFromDate:[NSDate date]];
    NSDate *lastDay = [NSDate dateWithTimeInterval:-24*60*60*7 sinceDate:[NSDate date]];
    _searchStartTime = [_formatter stringFromDate:lastDay];
        

    self.startTimeLabel.text = [NSString stringWithFormat:@"%@ %@",VD_Search_StartTime,_searchStartTime];
    self.endTimeLabel.text = [NSString stringWithFormat:@"%@ %@",VD_Search_EndTime,_searchEndTime];
    
    [_oneDayBtn setBackgroundColor:CHCHexColor(@"f8b551")];
    [_threeDayBtn setBackgroundColor:CHCHexColor(@"f8b551")];
    [_oneWeekBtn setBackgroundColor:CHCHexColor(@"f39800")];
    
}
//搜索
- (void)searchBtnClick {
    [self.searchBar resignFirstResponder];
    
    _searchResult = [self.provinceBtn currentTitle];
    _searchResult = [NSString stringWithFormat:@"%@%@",_searchResult,[LZXHelper isNullToString:self.searchBar.text]];

    //搜索结果为空
    if ([[LZXHelper isNullToString:_searchResult]isEqualToString:@""]) {
        [CHCUI presentAlertToCancelWithMessage:@"请输入车牌号码" WithObject:self.navigationController];
        return;
    }

    if (![[LZXHelper isNullToString:_searchStartTime]isEqualToString:@""] && ![[LZXHelper isNullToString:_searchEndTime]isEqualToString:@""] && ![[LZXHelper isNullToString:_searchResult]isEqualToString:@""]) {
        _searchResult = [GetInfoCarRequest removeSpaceAndNewline:_searchResult];
        if ([ZEBUtils validateCarNo:_searchResult]) {
            if ([GetInfoCarRequest compareDate:_searchStartTime withDate:_searchEndTime] == 0) {
                [CHCUI presentAlertToCancelWithMessage:@"开始时间与结束时间不能相同" WithObject:self.navigationController];
            } else if ([GetInfoCarRequest compareDate:_searchStartTime withDate:_searchEndTime] == -1){
                [CHCUI presentAlertToCancelWithMessage:@"开始时间不能大于结束时间" WithObject:self.navigationController];
                
            }else if ([GetInfoCarRequest compareDate:_searchStartTime withDate:_searchEndTime] == 1){
                [self.cuiPickerView hiddenPickerView];
                [self search];
            }
        } else {
            [CHCUI presentAlertToCancelWithMessage:@"请输入正确的车牌号码" WithObject:self.navigationController];
        }
    }
}

- (NSDate *)getCurrentTime {
    NSString *dateTime=[_formatter stringFromDate:[NSDate date]];
    NSDate *date = [_formatter dateFromString:dateTime];
    return date;
}



//选择开始时间
- (void)startTimeClick {
    [self.searchBar resignFirstResponder];
    if (![[LZXHelper isNullToString:_searchStartTime]isEqualToString:@""]) {
        self.cuiPickerView.curDate = [_formatter dateFromString:_searchStartTime];
    } else {
        self.cuiPickerView.curDate = [self getCurrentTime];
    }
    self.cuiPickerView.myResponder = self.startTime;
    
    [_cuiPickerView showInView:self.view];
    
//    [_oneDayBtn setBackgroundColor:CHCHexColor(@"f8b551")];
//    [_threeDayBtn setBackgroundColor:CHCHexColor(@"f8b551")];
//    [_oneWeekBtn setBackgroundColor:CHCHexColor(@"f8b551")];
    
}

//选择结束时间
- (void)endTimeClick {
    [self.searchBar resignFirstResponder];
    if (![[LZXHelper isNullToString:_searchEndTime]isEqualToString:@""]) {
        self.cuiPickerView.curDate = [_formatter dateFromString:_searchEndTime];
    }else {
        self.cuiPickerView.curDate = [self getCurrentTime];
    }
    self.cuiPickerView.myResponder = self.endTime;
    [_cuiPickerView showInView:self.view];
    
//    [_oneDayBtn setBackgroundColor:CHCHexColor(@"f8b551")];
//    [_threeDayBtn setBackgroundColor:CHCHexColor(@"f8b551")];
//    [_oneWeekBtn setBackgroundColor:CHCHexColor(@"f8b551")];
}
#pragma mark -
#pragma mark 选择城市
- (void)chooseProvince:(UIButton *)btn {
    
    [self.searchBar endEditing:YES];
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect = [btn convertRect: btn.bounds toView:window];
    [self.provinceListAlertView showInPoint:CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect))];
}
#pragma mark -
#pragma mark 选择通行监控
- (void)chooseTrafficMonitoring {
    self.analysisType = TrafficMonitoring;
    [UIView animateWithDuration:0.3 animations:^{
        self.TrafficMonitoringImage.alpha = 1.0;
        self.PathAnalysisImage.alpha = 0.0;
    }];
}
#pragma mark -
#pragma mark 选择轨迹分析
- (void)choosePathAnalysisLabel {
    self.analysisType = PathAnalysis;
    [UIView animateWithDuration:0.3 animations:^{
        self.TrafficMonitoringImage.alpha = 0.0;
        self.PathAnalysisImage.alpha = 1.0;
    }];
}
#pragma mark - search
- (void)search {

    NSMutableDictionary *info =[NSMutableDictionary dictionary];
    
    info[@"carNumber"] = _searchResult;
    info[@"toTime"] = _searchEndTime;
    info[@"formTime"] = _searchStartTime;
    
    [self showloadingName:@"正在搜索中..."];
    
    [GetInfoCarRequest getCarIntoWithDict:info success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
        
        
        self.dataArray = [NSMutableArray array];
        
        
        VdBaseResultModel *model = [VdBaseResultModel getInfoWithData:reponse];
        
        if ([model.resultcode isEqualToString:@"0"]) {
            self.dataArray = [model.results mutableCopy];
            
            if (self.dataArray.count  == 0) {
                [self showHint:@"没有搜索到结果"];
                return ;
            }
            if (self.analysisType == TrafficMonitoring) {
                VehicleDetectionListViewController *ve = [[VehicleDetectionListViewController alloc] init];
                ve.hidesBottomBarWhenPushed = YES;
                [ve setCarDataSources:self.dataArray];
                [self.navigationController pushViewController:ve animated:YES];
            }else if (self.analysisType == PathAnalysis) {
                VehicleDetectionViewController *ve = [[VehicleDetectionViewController alloc] init];
                ve.hidesBottomBarWhenPushed = YES;
                [ve setCarDataSource:self.dataArray];
                [self.navigationController pushViewController:ve animated:YES];
            }
            [self hideHud];
        }
        else {
            [self showHint:model.resultmessage];
        }
        
        
        
        

//        for ( VdResultModel *vModel in model.results) {
//            if (vModel.sbxx.count == 0) {
//                [self.dataArray removeObject:vModel];
//            }
//            else {
//                for (SBXXModel *sbModel in vModel.sbxx) {
//                    if ([[LZXHelper isNullToString:[sbModel.longitude stringValue]] isEqualToString:@""] || [[LZXHelper isNullToString:[sbModel.latitude stringValue]] isEqualToString:@""] || ([sbModel.longitude doubleValue] == 0.000000 && [sbModel.latitude doubleValue] == 0.000000)) {
//                        [self.dataArray removeObject:vModel];
//                    }
//                }
//            }
//        }

        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showHint:@"搜索失败"];
    }];

    
//    NSLog(@"R:%@,S:%@,E:%@",_searchResult,_searchStartTime,_searchEndTime);
}

#pragma mark - ZEBPickViewDelegate
- (void)didFinishPickView:(NSString *)date {
    if (self.cuiPickerView.myResponder == self.startTime) {
        self.startTimeLabel.text = [NSString stringWithFormat:@"%@ %@",VD_Search_StartTime,date];
        _searchStartTime = date;
    }else if (self.cuiPickerView.myResponder == self.endTime) {
        self.endTimeLabel.text = [NSString stringWithFormat:@"%@ %@",VD_Search_EndTime,date];
        _searchEndTime = date;
    }

}

#pragma mark - UITextFieldDelegate 
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    _searchResult = textField.text;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    _searchResult = self.searchBar.text;

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self searchBtnClick];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    
    if (!self.cuiPickerView) {
        return;
    }else {
        [self.cuiPickerView hiddenPickerView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
