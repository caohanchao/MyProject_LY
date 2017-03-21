//
//  PhysicsViewController.m
//  ProjectTemplate
//
//  Created by caohanchao on 2016/12/20.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#define white_backgroundColor [UIColor whiteColor]
#define font_blackColor [UIColor blackColor]
#define font_grayColor [UIColor grayColor]

#define font() [UIFont systemFontOfSize:14]

#define CellHeight 44.5
#define LeftMargin 12
#define UploadViewH 44.5
#define TextFildPLText @"请输入描述内容..."

#import "PhysicsViewController.h"
#import "ZMLPlaceholderTextView.h"
#import "WorkListsViewController.h"
#import "PhysicsRequest.h"
#import "WorkModeViewController.h"
#import "MAPointAnnotation+Property.h"
#import "XMLocationManager.h"
#import "NSString+Tools.h"
#import "UIViewController+BackButtonHandler.h"
#import "GetPathLocationModel.h"

@interface PhysicsViewController ()<UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    NSString *_createTime;
    NSString *_content;
    NSString *_titleName;
    NSString *_taskName;
    NSString *_workid;
    NSString *_startTime;
    NSString *_endTime;
    NSString *_startLatitue;
    NSString *_startLongtitue;
    NSString *_endLatitue;
    NSString *_endLongtitue;
    NSString *_startPosition;
    NSString *_endPosition;
    NSString *_pointJSON;
}

@property (nonatomic, strong) UIActivityIndicatorView *starLocationActivityIndicatorView; // 起点位置
@property (nonatomic, strong) UIActivityIndicatorView *endLocationActivityIndicatorView; // 终点位置
@property (nonatomic, strong) GetPathModel *model;
@property (nonatomic, strong) UIScrollView *scroller;

//@property (nonatomic, strong) UIActivityIndicatorView *locationIndicatorView;
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)UIView *centralView;


@property(nonatomic,strong)UITextField *titleField;
@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,strong)UILabel *taskLabel;

@property(nonatomic,strong)UILabel *peasonName;
@property(nonatomic,strong)UILabel *peasonPost;
@property(nonatomic,strong)UIImageView *peasonImg;

@property(nonatomic,strong)UILabel *workModeLabel;

@property(nonatomic,strong)UILabel *startTimeLabel;
@property(nonatomic,strong)UILabel *endTimeLabel;

@property(nonatomic,strong)UILabel *startLocation;
@property(nonatomic,strong)UILabel *endLocation;

@property(nonatomic,strong)ZMLPlaceholderTextView *descriptionView;

@property(nonatomic,strong)UIView *uploadView;
@property(nonatomic,strong)UISwitch *uploadSwitch;

@property(nonatomic,strong)UserInfoModel *userInfoModel;

@property (nonatomic,assign)WorkModeType workMode;

@property (nonatomic,strong)NSDateFormatter *formatter;

@property (nonatomic,strong)CLGeocoder *geocoder1;

@property (nonatomic,strong)CLGeocoder *geocoder2;

@property (nonatomic, strong) UIBarButtonItem *rightItem;

@end

@implementation PhysicsViewController


- (BOOL)navigationShouldPopOnBackButton {
    
    if (self.fromWhere == DraftsPage && ![self isChange]) {
        return YES;
    }
    NSString *message = @"您是否将未上传的轨迹存入草稿箱";
    if (self.fromWhere == DraftsPage) {
        message = @"您是否需要更新未上传的轨迹到草稿箱";
        [self initGetPathModelWithCUID:self.gModel.cuid];
    }else if (self.fromWhere == EndPhysicsPage) {
        [self initGetPathModel];
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
   
        if (self.fromWhere == DraftsPage) {
            [self writeToDBForUpdata];
            self.block(self);
        }else if (self.fromWhere == EndPhysicsPage) {
            [self removeMapPath];
            [self writeToDB];
        }
       
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (self.fromWhere == DraftsPage) {
            [self.navigationController popViewControllerAnimated:YES];
        }else if (self.fromWhere == EndPhysicsPage) {
            [self removeMapPath];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
    
    [alertController addAction:action2];
    [alertController addAction:action1];
    
    [self presentViewController:alertController animated:YES completion:nil];
    return YES;
}
/*
 
 禁止当前页面左侧滑动返回
 
 */

-(void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    [super viewWillDisappear:animated];
    
}

- (void)reloadUI {
    
    
    self.timeLabel.text = [self.gModel.createTime timeChage];
    self.titleField.text = self.gModel.route_title;
    if ([self.gModel.type isEqualToString:@"0"]) {
        self.workModeLabel.text = @"走线";
    } else if ([self.gModel.type isEqualToString:@"1"]) {
        self.workModeLabel.text = @"走访";
    } else if ([self.gModel.type isEqualToString:@"2"]) {
        self.workModeLabel.text = @"追踪";
    }
    self.workMode = (WorkModeType)[self.gModel.type integerValue];
    _workid = self.gModel.task_id;
    self.descriptionView.text = self.gModel.describetion;
}
- (void)setPointInfo:(NSMutableArray *)pointInfo {
    _pointInfo = pointInfo;
    id startpoint = [_pointInfo firstObject];
    if ([startpoint isKindOfClass:[MAPointAnnotation class]]) {
        MAPointAnnotation *startPoint = (MAPointAnnotation *)startpoint;
        _startPosition = startPoint.posi;
        _startTime = startPoint.time;
        _startLongtitue = [NSString stringWithFormat:@"%.10lf",startPoint.coordinate.longitude];
        _startLatitue = [NSString stringWithFormat:@"%.10lf",startPoint.coordinate.latitude];
    }else if ([startpoint isKindOfClass:[NSDictionary class]]) {
        NSDictionary *startPoint = (NSDictionary *)startpoint;
        _startTime = [startPoint objectForKey:@"time"];
        _startLongtitue = [startPoint objectForKey:@"longitude"];
        _startLatitue = [startPoint objectForKey:@"latitude"];

    }
    
    
    id endpoint = [_pointInfo lastObject];
    if ([endpoint isKindOfClass:[MAPointAnnotation class]]) {
        MAPointAnnotation *endPoint = (MAPointAnnotation *)endpoint;
        _endPosition = endPoint.posi;
        _endTime = endPoint.time;
        _endLongtitue = [NSString stringWithFormat:@"%.10lf",endPoint.coordinate.longitude];
        _endLatitue = [NSString stringWithFormat:@"%.10lf",endPoint.coordinate.latitude];
    }else if ([endpoint isKindOfClass:[NSDictionary class]]) {
        NSDictionary *endPoint = (NSDictionary *)endpoint;
        _endTime = [endPoint objectForKey:@"time"];
        _endLongtitue = [endPoint objectForKey:@"longitude"];
        _endLatitue = [endPoint objectForKey:@"latitude"];
        
    }
}

-(UserInfoModel *)userInfoModel
{
    if (!_userInfoModel) {
        _userInfoModel = [[[DBManager sharedManager] userDetailSQ] selectUserDetail];
    }
    return _userInfoModel;
}

- (NSDateFormatter *)formatter {
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        [_formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    }
    return _formatter;
}

- (UIActivityIndicatorView *)starLocationActivityIndicatorView {
    if (!_starLocationActivityIndicatorView) {
        _starLocationActivityIndicatorView = [[UIActivityIndicatorView alloc] init];
        _starLocationActivityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    }
    return _starLocationActivityIndicatorView;
}
- (UIActivityIndicatorView *)endLocationActivityIndicatorView {
    if (!_endLocationActivityIndicatorView) {
        _endLocationActivityIndicatorView = [[UIActivityIndicatorView alloc] init];
        _endLocationActivityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        
    }
    return _endLocationActivityIndicatorView;
}
-(UISwitch *)uploadSwitch
{
    if (!_uploadSwitch) {
        _uploadSwitch =[[UISwitch alloc]init];
        _uploadSwitch.onTintColor = zBlueColor;
        _uploadSwitch.enabled = YES;
        _uploadSwitch.userInteractionEnabled = YES;
        _uploadSwitch.on = [self.userInfoModel.autoUploadSet boolValue];
//        _uploadSwitch.on = [self.userInfoModel.autoUploadSet boolValue];
        [_uploadSwitch addTarget:self action:@selector(uploadSwitchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _uploadSwitch;
}

- (UIView *)uploadView {
    if (!_uploadView) {
        _uploadView = [[UIView alloc] init];
        _uploadView.backgroundColor = white_backgroundColor;
    }
    return _uploadView;
}

- (UILabel *)startTimeLabel {
    if (!_startTimeLabel) {
        _startTimeLabel = [CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:0 font:font() textColor:font_blackColor text:@"2016-11-13 13:20"];
    }
    return _startTimeLabel;
}

- (UILabel *)endTimeLabel {
    if (!_endTimeLabel) {
        _endTimeLabel = [CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:0 font:font() textColor:font_blackColor text:@"2016-11-13 15:20"];
    }
    return _endTimeLabel;
}

- (UILabel *)startLocation {
    if (!_startLocation) {
        _startLocation = [CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:0 font:font() textColor:font_blackColor text:@""];
        _startLocation.userInteractionEnabled = NO;
        _startLocation.text = _startPosition;
        
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadStartLocation)];
        [_startLocation addGestureRecognizer:ges];
        
    }
    return _startLocation;
}

- (UILabel *)endLocation {
    if (!_endLocation) {
        _endLocation =[CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:0 font:font() textColor:font_blackColor text:@""];
        _endLocation.userInteractionEnabled = NO;
        _endLocation.text = _endPosition;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reloadEndLocation)];
        [_endLocation addGestureRecognizer:ges];
    }
    return _endLocation;
}

- (UIScrollView *)scroller {
    if (!_scroller) {
        _scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _scroller.delegate = self;
        _scroller.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _scroller;
}


-(UIView *)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = white_backgroundColor;
    }
    return _topView;
    
}
-(UIView *)centralView
{
    if (!_centralView) {
        _centralView = [[UIView alloc]init];
        _centralView.backgroundColor = white_backgroundColor;
    }
    return _centralView;
}

-(UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = white_backgroundColor;
    }
    return _bottomView;
    
}

-(UITextField *)titleField
{
    if (!_titleField) {
        _titleField =[[UITextField alloc] init];
        _titleField.delegate = self;
        _titleField.placeholder = @"请添加标题";
        [_titleField setValue:CHCHexColor(@"a6a6a6") forKeyPath:@"placeholderLabel.textColor"];
        _titleField.textColor = CHCHexColor(@"000000");
        _titleField.font = font();
    }
    return _titleField;
    
}

-(UILabel *)timeLabel
{
    if (!_timeLabel) {
        if (self.fromWhere == DraftsPage) {
//            _createTime = _model.create_time;
        }else {
            _createTime = [self requestTime];
        }
        
        _timeLabel =[CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:2 font:[UIFont systemFontOfSize:9] textColor:font_grayColor text:[_createTime timeChage]];
    }
    return _timeLabel;
}

-(UILabel *)taskLabel
{
    if (!_taskLabel) {
        _taskLabel =[CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:0 font:font() textColor:CHCHexColor(@"000000") text:self.workInfo[@"workName"]];
        _taskLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taskBtnClick)];
        [_taskLabel addGestureRecognizer:tap];
    }
    return _taskLabel;
}


-(UILabel *)workModeLabel
{
    if (!_workModeLabel) {
        _workModeLabel = [CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:0 font:font() textColor:CHCHexColor(@"000000") text:@"走线"];
        _workModeLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectWorkModeAction)];
        [_workModeLabel addGestureRecognizer:tap];
    }
    return _workModeLabel;
}

-(UIImageView *)peasonImg
{
    if (!_peasonImg) {
        _peasonImg = [[UIImageView alloc]init];
        _peasonImg.layer.cornerRadius = 6;
        _peasonImg.layer.masksToBounds = YES;
        
    }
    return _peasonImg;
}

-(UILabel *)peasonPost
{
    if (!_peasonPost) {
        _peasonPost = [CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:1 font:[UIFont systemFontOfSize:10] textColor:white_backgroundColor text:@"警员"];
        _peasonPost.layer.masksToBounds = YES;
        _peasonPost.layer.cornerRadius = 5;
    }
    return _peasonPost;
}
-(ZMLPlaceholderTextView *)descriptionView
{
    if (!_descriptionView) {
        _descriptionView = [[ZMLPlaceholderTextView alloc]init];
        _descriptionView.tintColor = zBlueColor;
        _descriptionView.font = ZEBFont(14);
        _descriptionView.textColor = CHCHexColor(@"a6a6a6");
        _descriptionView.placeholder = TextFildPLText;
        _descriptionView.delegate = self;
        _descriptionView.scrollEnabled = YES;
    }
    return _descriptionView;
}
-(UILabel *)peasonName
{
    if (!_peasonName) {
        _peasonName = [CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:0 font:[UIFont systemFontOfSize:14] textColor:CHCHexColor(@"808080") text:self.userInfoModel.name];
    }
    return _peasonName;
}


-(NSString *)requestTime{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *time = [formatter stringFromDate:[NSDate date]];
    return time;
}

- (void)createTopView {
    
    UserAllModel *userModel = [[[DBManager sharedManager] personnelInformationSQ] selectDepartmentmemberlistById:self.userInfoModel.alarm];
    UnitListModel *uModel = [[[DBManager sharedManager] DepartmentlistSQ] selectDepartmentlistById:userModel.RE_department];
    [self.peasonImg imageGetCacheForAlarm:self.userInfoModel.alarm forUrl:self.userInfoModel.headpic];
    NSString *DE_type = uModel.DE_type;
    NSString *DE_name = [LZXHelper isNullToString:self.userInfoModel.post];
    //    NSString *str =  [NSString stringWithFormat:@" %@ ",DE_name];
    CGFloat width =self.peasonPost.frame.size.width;
    
    if ([DE_name isEqualToString:@""]) {
        
        self.peasonPost.backgroundColor = [UIColor colorWithHexString:@"#96b0fb"];
        self.peasonPost.text = [NSString stringWithFormat:@" 武汉市公安局 "];
    }else {
        if ([DE_type isEqualToString:@"0"]) {//0警察公务组织紫，1技术支持绿
            self.peasonPost.backgroundColor = [UIColor colorWithHexString:@"#96b0fb"];
            self.peasonPost.text = [NSString stringWithFormat:@" %@ ",self.userInfoModel.post];
        }else if ([DE_type isEqualToString:@"1"]) {
            self.peasonPost.backgroundColor = [UIColor colorWithHexString:@"#6cd9a3"];
            self.peasonPost.text = [NSString stringWithFormat:@" %@ ",self.userInfoModel.post];
        }
    }
    width = [LZXHelper textWidthFromTextString:self.peasonPost.text height:20 fontSize:10];
    
    
    UILabel *title =[CHCUI createLabelWithbackGroundColor: white_backgroundColor textAlignment:0 font:font() textColor:font_blackColor text:@"标题"];
    UILabel *task = [CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:0 font:font()  textColor:font_blackColor text:@"所属任务"];
    UILabel *peason = [CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:0 font:font() textColor:font_blackColor text:@"记录人"];
    UILabel *workMode = [CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:0 font:font() textColor:font_blackColor text:@"工作模式"];
    
    UIImageView *taskImg = [CHCUI createImageWithbackGroundImageV:@"rightarrow"];
    
    UIImageView *workModeImg =[CHCUI createImageWithbackGroundImageV:@"rightarrow"];
    
    UILabel *line1 = [UILabel new];
    line1.backgroundColor = LineColor;
    
    UILabel *line2 =[UILabel new];
    line2.backgroundColor = LineColor;
    
    UILabel *line3 =[UILabel new];
    line3.backgroundColor = LineColor;
    
//    UILabel *line4 =[UILabel new];
//    line4.backgroundColor = LineColor;
    
    
    [self.topView addSubview:title];
    [self.topView addSubview:task];
    [self.topView addSubview:peason];
    [self.topView addSubview:workMode];
    
    [self.topView addSubview:self.titleField];
    [self.topView addSubview:self.timeLabel];
    [self.topView addSubview:line1];
    
    
    [self.topView addSubview:self.taskLabel];
    [self.topView addSubview:taskImg];
    [self.topView addSubview:line2];
//    [self.topView addSubview:self.taskBtn];
   
    
    [self.topView addSubview:self.peasonImg];
 //   [self.topView addSubview:self.peasonPost];
    [self.topView addSubview:self.peasonName];
    
    [self.topView addSubview:line3];
    
    [self.topView addSubview:workMode];
    [self.topView addSubview:self.workModeLabel];
    [self.topView addSubview:workModeImg];
    
    
    
    
//    CGFloat topConstraint = 0.5;
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_top).with.offset(0);
        make.height.offset(CellHeight);
        make.left.equalTo(self.topView.mas_left).with.offset(LeftMargin);
        make.width.offset(86);
    }];
    [task mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).with.offset(0);
        make.height.offset(CellHeight);
        make.left.equalTo(self.topView.mas_left).with.offset(LeftMargin);
        make.width.offset(86);
    }];
    [peason mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(task.mas_bottom).with.offset(0);
        make.height.offset(CellHeight);
        make.left.equalTo(self.topView.mas_left).with.offset(LeftMargin);
        make.width.offset(86);
    }];
    [workMode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(peason.mas_bottom).with.offset(0);
        make.left.equalTo(self.topView.mas_left).with.offset(LeftMargin);
        make.width.offset(86);
        make.height.offset(CellHeight);
    }];

    [self.titleField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(title.mas_right).with.offset(0);
        make.top.equalTo(title.mas_top).with.offset(0);
        make.right.equalTo(self.topView.mas_right).with.offset(-80);
        make.height.offset(CellHeight-0.5);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleField.mas_right).offset(0);
        make.right.equalTo(self.topView.mas_right).offset(-12);
        make.centerY.equalTo(self.titleField.mas_centerY).offset(0);
        make.height.offset(CellHeight-0.5);
    }];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleField.mas_left).with.offset(0);
        make.right.equalTo(self.topView.mas_right).with.offset(0);
        make.top.equalTo(self.titleField.mas_bottom).with.offset(0);
        make.height.offset(0.5);
    }];
    
    
    [self.taskLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(task.mas_top).with.offset(0);
        make.left.equalTo(task.mas_right).with.offset(0);
        make.height.offset(CellHeight-0.5);
        make.right.equalTo(taskImg.mas_left).with.offset(-12);
        
    }];
    [taskImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topView.mas_right).with.offset(0);
        make.centerY.equalTo(task.mas_centerY).with.offset(0);
        make.height.offset(30);
        make.width.offset(30);
    }];

//    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.taskLabel.mas_left).with.offset(0);
//        make.right.equalTo(self.topView.mas_right).with.offset(0);
//        make.top.equalTo(self.taskLabel.mas_bottom).with.offset(0);
//        make.height.offset(0.5);
//    }];
    
    [self.peasonImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(peason.mas_centerY).with.offset(0);
        make.left.equalTo(peason.mas_right).with.offset(0);
        make.height.width.offset(30);
        
    }];
//    [self.peasonPost mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(peason.mas_centerY).with.offset(0);
//        make.left.equalTo(self.peasonImg.mas_right).with.offset(10);
//        make.width.offset(width);
//        make.height.offset(20);
//    }];
    [self.peasonName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(peason.mas_top).with.offset(0);
        make.left.equalTo(self.peasonImg.mas_right).with.offset(10);
        make.width.mas_greaterThanOrEqualTo(100);
        make.height.offset(CellHeight-0.5);
    }];
    
//    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.workModeLabel.mas_left).with.offset(0);
//        make.right.equalTo(self.topView.mas_right).with.offset(0);
//        make.top.equalTo(self.peasonName.mas_bottom).with.offset(0);
//        make.height.offset(0.5);
//    }];
    
    [workModeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topView.mas_right).with.offset(0);
        make.centerY.equalTo(workMode.mas_centerY).with.offset(0);
        make.height.offset(30);
        make.width.offset(30);
    }];
    [self.workModeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(workMode.mas_right).with.offset(0);
        make.centerY.equalTo(workMode.mas_centerY).with.offset(0);
        make.right.equalTo(workModeImg.mas_left).with.offset(-12);
        make.height.offset(CellHeight);
    }];
    
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.taskLabel.mas_left).with.offset(0);
        make.right.equalTo(self.topView.mas_right).with.offset(0);
        make.top.equalTo(self.taskLabel.mas_bottom).with.offset(-0.5);
        make.height.offset(0.5);
    }];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.workModeLabel.mas_left).with.offset(0);
        make.right.equalTo(self.topView.mas_right).with.offset(0);
        make.top.equalTo(peason.mas_bottom).with.offset(-0.5);
        make.height.offset(0.5);
    }];
}

- (void)createCenterView {
    
    UILabel *startTime = [CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:0 font:font() textColor:font_blackColor text:@"起点时间"];
    UILabel *endTime = [CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:0 font:font() textColor:font_blackColor text:@"终点时间"];
    UILabel *startLoc = [CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:0 font:font() textColor:font_blackColor text:@"起点位置"];
    UILabel *endLoc = [CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:0 font:font() textColor:font_blackColor text:@"终点位置"];
    UILabel *line1 = [UILabel new];
    line1.backgroundColor = LineColor;
    UILabel *line2 =[UILabel new];
    line2.backgroundColor = LineColor;
    UILabel *line3 =[UILabel new];
    line3.backgroundColor = LineColor;
    [self.centralView addSubview:startTime];
    [self.centralView addSubview:endTime];
    [self.centralView addSubview:startLoc];
    [self.centralView addSubview:endLoc];
    [self.centralView addSubview:self.startTimeLabel];
    [self.centralView addSubview:line1];
    [self.centralView addSubview:self.endTimeLabel];
    [self.centralView addSubview:line2];
    [self.centralView addSubview:self.startLocation];
    [self.centralView addSubview:line3];
    [self.centralView addSubview:self.endLocation];
    [self.startLocation addSubview:self.starLocationActivityIndicatorView];
    [self.endLocation addSubview:self.endLocationActivityIndicatorView];
    
    
    [startTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.centralView.mas_top).with.offset(0);
        make.height.offset(CellHeight);
        make.left.equalTo(self.centralView.mas_left).with.offset(LeftMargin);
        make.width.offset(86);
    }];
    [endTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(startTime.mas_bottom).with.offset(0);
        make.height.offset(CellHeight);
        make.left.equalTo(self.centralView.mas_left).with.offset(LeftMargin);
        make.width.offset(86);
    }];
    [startLoc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(endTime.mas_bottom).with.offset(0);
        make.height.offset(CellHeight);
        make.left.equalTo(self.centralView.mas_left).with.offset(LeftMargin);
        make.width.offset(86);
    }];
    [endLoc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(startLoc.mas_bottom).with.offset(0);
        make.height.offset(CellHeight);
        make.left.equalTo(self.centralView.mas_left).with.offset(LeftMargin);
        make.width.offset(86);
    }];

    [self.startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(startTime.mas_right).with.offset(0);
        make.top.equalTo(startTime.mas_top).with.offset(0);
        make.right.equalTo(self.centralView.mas_right).offset(-12);
        make.height.offset(CellHeight-0.5);
    }];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startTimeLabel.mas_left).with.offset(0);
        make.right.equalTo(self.centralView.mas_right).with.offset(0);
        make.top.equalTo(self.startTimeLabel.mas_bottom).with.offset(0);
        make.height.offset(0.5);
    }];
    
    [self.endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(endTime.mas_right).with.offset(0);
        make.top.equalTo(line1.mas_bottom).with.offset(0);
        make.right.equalTo(self.centralView.mas_right).offset(-12);
        make.height.offset(CellHeight-0.5);
    }];
    
//    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.endTimeLabel.mas_left).with.offset(0);
//        make.right.equalTo(self.centralView.mas_right).with.offset(0);
//        make.top.equalTo(self.endTimeLabel.mas_bottom).with.offset(0);
//        make.height.offset(0.5);
//    }];
    
    [self.startLocation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(CellHeight-0.5);
        make.left.equalTo(startLoc.mas_right).with.offset(0);
        make.top.equalTo(line2.mas_bottom).with.offset(0);
        make.right.equalTo(self.centralView.mas_right).offset(-12);
    }];
    [self.starLocationActivityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.startLocation.mas_centerY);
        make.left.equalTo(self.startLocation.mas_left).offset(5);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
//    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.startLocation.mas_left).with.offset(0);
//        make.right.equalTo(self.centralView.mas_right).with.offset(0);
//        make.top.equalTo(self.startLocation.mas_bottom).with.offset(0);
//        make.height.offset(0.5);
//    }];
    
    [self.endLocation mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(CellHeight-0.5);
        make.left.equalTo(endLoc.mas_right).with.offset(0);
        make.top.equalTo(line3.mas_bottom).with.offset(0);
        make.right.equalTo(self.centralView.mas_right).offset(-12);
    }];
    [self.endLocationActivityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.endLocation.mas_centerY);
        make.left.equalTo(self.endLocation.mas_left).offset(5);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.endTimeLabel.mas_left).with.offset(0);
        make.right.equalTo(self.centralView.mas_right).with.offset(0);
        make.top.equalTo(self.endTimeLabel.mas_bottom).with.offset(-0.5);
        make.height.offset(0.5);
    }];

    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.startLocation.mas_left).with.offset(0);
        make.right.equalTo(self.centralView.mas_right).with.offset(0);
        make.top.equalTo(self.startLocation.mas_bottom).with.offset(-0.5);
        make.height.offset(0.5);
    }];
    
}

- (void)createBottomView {
    UIImageView *uploadImg =[CHCUI createImageWithbackGroundImageV:@"update_carema"];
    
    UILabel *uploadLabel =[CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:0 font:font() textColor:font_blackColor text:@"直接上传"];
    UILabel *line = [UILabel new];
    line.backgroundColor = LineColor;
    [self.bottomView addSubview:self.descriptionView];
    
    
    
    if (self.fromWhere == EndPhysicsPage) {
        
        [self.bottomView addSubview:self.uploadView];
        [self.bottomView addSubview:uploadImg];
        [self.bottomView addSubview:uploadLabel];
        [self.bottomView addSubview:line];
        [self.bottomView addSubview:self.uploadSwitch];
        
        [self.descriptionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bottomView.mas_top).offset(5);
            make.left.equalTo(self.bottomView.mas_left).offset(5);
            make.right.equalTo(self.bottomView.mas_right).offset(-5);
            make.bottom.equalTo(self.bottomView.mas_bottom).offset(-45);
        }];
        
        
        [self.uploadView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.descriptionView.mas_bottom);
            make.right.equalTo(self.bottomView.mas_right).offset(0);
            make.left.equalTo(self.bottomView.mas_left).offset(0);
            make.height.offset(UploadViewH);
            
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.descriptionView.mas_bottom).offset(0);
            make.height.equalTo(@0.6);
            make.left.equalTo(self.bottomView.mas_left).offset(0);
            make.right.equalTo(self.bottomView.mas_right).offset(0);
        }];
        
        [uploadImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.uploadView.mas_left).with.offset(LeftMargin);
            make.top.equalTo(self.uploadView.mas_top).with.offset(12);
            make.width.offset(20.5);
            make.height.offset(20.5);
        }];
        
        [uploadLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(uploadImg.mas_right).with.offset(LeftMargin);
            make.centerY.equalTo(uploadImg.mas_centerY).with.offset(0);
            make.width.offset(100);
            make.height.offset(UploadViewH-10);
        }];
        
        [self.uploadSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.uploadView.mas_right).with.offset(-15);
            make.centerY.equalTo(uploadLabel.mas_centerY).with.offset(0);
            make.height.offset(30);
            make.width.offset(60);
        }];
    }else if (self.fromWhere == DraftsPage){
        [self.descriptionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bottomView.mas_top).offset(5);
            make.left.equalTo(self.bottomView.mas_left).offset(5);
            make.right.equalTo(self.bottomView.mas_right).offset(-5);
            make.bottom.equalTo(self.bottomView.mas_bottom).offset(-5);
        }];
    }
    
}

- (void)initAllView {
    
    
    
    [self.view addSubview:self.scroller];
    [self.scroller addSubview:self.topView];
    [self.scroller addSubview:self.centralView];
    [self.scroller addSubview:self.bottomView];
    CGFloat height;
    if (self.fromWhere == EndPhysicsPage) {
        height = 120;
    } else {
        height = 120-45;
    }
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scroller.mas_top).with.offset(16);
        make.left.equalTo(self.scroller.mas_left);
        make.width.mas_equalTo(kScreenWidth);
        make.height.offset(CellHeight*4);
    }];
    [self.centralView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).with.offset(16);
        make.left.equalTo(self.scroller.mas_left);
        make.width.mas_equalTo(kScreenWidth);
        make.height.offset(CellHeight*4);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.centralView.mas_bottom).with.offset(16);
        make.left.equalTo(self.scroller.mas_left);
        make.width.mas_equalTo(kScreenWidth);
        make.height.offset(height);
    }];
    
    
    [self createTopView];
    
    [self createCenterView];
    
    [self createBottomView];
    
    [self adjustUI];
}

#pragma mark -Action
- (void)reloadEndLocation {
    
    if (self.fromWhere == EndPhysicsPage) {
        self.endLocation.text = @"";
        MAPointAnnotation *endPoint = [self.pointInfo lastObject];
        CLLocation *location2 = [[CLLocation alloc] initWithLatitude:endPoint.coordinate.latitude longitude:endPoint.coordinate.longitude];
        WeakSelf;
        [self.endLocationActivityIndicatorView startAnimating];
        [self.geocoder2 reverseGeocodeLocation:location2 completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            [self.endLocationActivityIndicatorView stopAnimating];
            if (placemarks && placemarks.count > 0) {
                CLPlacemark *position = placemarks[0];
                _endPosition = position.addressDictionary[@"FormattedAddressLines"][0];
                if(![[LZXHelper isNullToString:_endPosition] isEqualToString:@""]) {
                    weakSelf.endLocation.text = [_endPosition separatedBy:@"中国湖北省"];
                    weakSelf.endLocation.userInteractionEnabled = NO;
                }
            }
            if (error) {
                weakSelf.endLocation.text = @"地址名称获取失败";
                weakSelf.endLocation.userInteractionEnabled = YES;
            }
        }];
    }else if (self.fromWhere == DraftsPage) {
        self.endLocation.text = self.gModel.end_posi;
        self.endLocation.userInteractionEnabled = NO;
    }
}

- (void)reloadStartLocation {
    
    
    if (self.fromWhere == EndPhysicsPage) {
        
        self.startLocation.text = @"";
        MAPointAnnotation *endPoint = [self.pointInfo firstObject];
        CLLocation *location1 = [[CLLocation alloc] initWithLatitude:endPoint.coordinate.latitude longitude:endPoint.coordinate.longitude];
        WeakSelf;
        [self.starLocationActivityIndicatorView startAnimating];
        [self.geocoder1 reverseGeocodeLocation:location1 completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            [self.starLocationActivityIndicatorView stopAnimating];
            if (placemarks && placemarks.count > 0) {
                CLPlacemark *position = placemarks[0];
                _startPosition = position.addressDictionary[@"FormattedAddressLines"][0];
                if(![[LZXHelper isNullToString:_startPosition] isEqualToString:@""]) {
                    weakSelf.startLocation.text = [_startPosition separatedBy:@"中国湖北省"];
                    weakSelf.startLocation.userInteractionEnabled = NO;
                }
            }
            if (error) {
                weakSelf.startLocation.text = @"地址名称获取失败";
                weakSelf.startLocation.userInteractionEnabled = YES;
            }
        }];
    }else if (self.fromWhere == DraftsPage) {
        self.startLocation.text = self.gModel.start_posi;
        self.startLocation.userInteractionEnabled = NO;
    }
    
    
}

//选择任务
- (void)taskBtnClick {
    [self.titleField resignFirstResponder];
    WeakSelf;
    WorkListsViewController *workList = [[WorkListsViewController alloc] init];
    workList.gid = self.gid;
    workList.type = 1;
    workList.taskBlock = ^(NSMutableDictionary *param){
        _workid = param[@"taskId"];
        _taskName = param[@"taskName"];
        weakSelf.taskLabel.text = _taskName;
    };
    [self.navigationController pushViewController:workList animated:YES];
}
//选择工作模式
- (void)selectWorkModeAction {
    [self.titleField resignFirstResponder];
    WeakSelf;
    WorkModeViewController *wvc =[[WorkModeViewController alloc] init];
    wvc.WorkModeBlock = ^(WorkModeType workMode,NSString *workModeName) {
        weakSelf.workMode = workMode;
        weakSelf.workModeLabel.text = workModeName;
    };
    [self.navigationController pushViewController:wvc animated:YES];
}
//上传
- (void)uploadPhysicsAction {
    [self.titleField resignFirstResponder];
    if (self.fromWhere == DraftsPage) {
     //  [self initGetPathModelWithCUID:self.gModel.cuid];
       self.uploadSwitch.on = YES;
    }else if (self.fromWhere == EndPhysicsPage) {
      [self initGetPathModel];
    }

    
    if (!self.uploadSwitch.on) {
        [self writeToDB];
        [self removeMapPath];
    }else {
    
    if ([[LZXHelper isNullToString:_titleField.text] isEqualToString:@""]) {
        [self showHint:@"请输入标题"];
        return;
    }
    if ([[LZXHelper isNullToString:_taskLabel.text ]isEqualToString:@""]) {
        [self showHint:@"请选择任务"];
        return;
    }
    if ([[LZXHelper isNullToString:_workModeLabel.text] isEqualToString:@""]) {
        [self showHint:@"请选择工作模式"];
        return;
    }

    NSUserDefaults *user =[NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"alarm"]             = [user objectForKey:@"alarm"];
    param[@"gid"]               = self.gid;
    param[@"token"]             = [user objectForKey:@"token"];
    param[@"task_id"]           = _workid;
    param[@"end_posi"]          = self.endLocation.text;
    param[@"start_posi"]        = self.startLocation.text;
    param[@"route_title"]       = self.titleField.text;
    param[@"type"]              = [NSString stringWithFormat:@"%d",self.workMode];
    param[@"start_time"]        = _startTime;
    param[@"end_time"]          = _endTime;
    param[@"describetion"]      = self.descriptionView.text;
    param[@"end_latitude"]      = _endLatitue;
    param[@"end_longitude"]     = _endLongtitue;
    param[@"start_latitude"]    = _startLatitue;
    param[@"start_longitude"]   = _startLongtitue;
    param[@"location_list"]     = _pointJSON;

    [self showloadingName:@"正在上传轨迹"];
    [PhysicsRequest postUploadPhysicsWithParam:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:reponse
                                                             options:NSJSONReadingMutableContainers error:nil];
        ZEBLog(@"%@",dict);
        if ([dict[@"resultcode"] isEqualToString:@"0"]) {
            if (self.fromWhere == DraftsPage) {
                [[[DBManager sharedManager] trajectoryListSQ] deleteTrajectoryListByCuid:self.gModel.cuid];
                self.block(self);
                [self.navigationController popViewControllerAnimated:YES];
            }else if (self.fromWhere == EndPhysicsPage) {
                [self removeMapPath];
                [self.navigationController popViewControllerAnimated:YES];
            }
           
            [self hideHud];
            [self showHint:dict[@"resultmessage"]];
        } else {
            [self showHint:dict[@"resultmessage"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showHint:@"上传失败"];
    }];
    }
}
//上传开关
- (void)uploadSwitchAction:(UISwitch *)sw {
    [[[DBManager sharedManager] userDetailSQ] updateUserDetailAutoUploadSet:[NSString stringWithFormat:@"%d",sw.on]];
    if (sw.on) {
       self.rightItem.title = @"上传";
    }else {
        self.rightItem.title = @"保存";
    }
}



#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    self.descriptionView.textColor = CHCHexColor(@"000000");
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    _content = textView.text;
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *string = [NSString stringWithFormat:@"%@%@", textView.text, text];
    if (string.length > CONTENT_MAXLENGTH){
        [self showloadingError:@"字数不能大于50!"];
        return NO;
    }
    if ([[[UITextInputMode currentInputMode]primaryLanguage] isEqualToString:@"emoji"])
    {
        [self showloadingError:@"输入格式有误!"];
        return NO;
    }
    if ([NSString containEmoji:text])
    {
        [self showloadingError:@"输入格式有误!"];
        return NO;
    }

    return YES;
}

- (void)adjustUI {

    if (self.editType == OnlyReadType) {
        self.taskLabel.userInteractionEnabled = NO;
        self.workModeLabel.userInteractionEnabled = NO;
        self.descriptionView.editable = NO;
    }
    if ([_content isEqualToString:@""] &&[self.descriptionView.text isEqualToString:TextFildPLText]) {
        self.descriptionView.textColor = CHCHexColor(@"a6a6a6");
        self.descriptionView.text =@"";
    }else {
        self.descriptionView.textColor = CHCHexColor(@"000000");
        self.descriptionView.text = _content;
    }
    NSDateFormatter *oldformatter = [[NSDateFormatter alloc] init];
    [oldformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date1 = [oldformatter dateFromString:_startTime];
    self.startTimeLabel.text = [self.formatter stringFromDate:date1];
    
    NSDate *date2 = [oldformatter dateFromString:_endTime];
    self.endTimeLabel.text = [self.formatter stringFromDate:date2];
    
//    MAPointAnnotation *startpoint = [self.pointInfo firstObject];
//    MAPointAnnotation *endpoint = [self.pointInfo lastObject];
    
    self.geocoder1 = [[CLGeocoder alloc] init];
    [self reloadStartLocation];
//    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:startpoint.coordinate.latitude longitude:startpoint.coordinate.longitude];
//    WeakSelf;
//    [self.geocoder1 reverseGeocodeLocation:location1 completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//        if (placemarks && placemarks.count > 0) {
//            CLPlacemark *position = placemarks[0];
//            _startPosition = position.addressDictionary[@"FormattedAddressLines"][0];
//            if(![[LZXHelper isNullToString:_startPosition] isEqualToString:@""]) {
//                weakSelf.startLocation.text = [_startPosition separatedBy:@"中国湖北省"];
//            }
//        }
//    }];


    self.geocoder2 = [[CLGeocoder alloc] init];
    [self reloadEndLocation];
//    CLLocation *location2 = [[CLLocation alloc] initWithLatitude:endpoint.coordinate.latitude longitude:endpoint.coordinate.longitude];
//    [self.geocoder2 reverseGeocodeLocation:location2 completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//        if (placemarks && placemarks.count > 0) {
//            CLPlacemark *position = placemarks[0];
//            _endPosition = position.addressDictionary[@"FormattedAddressLines"][0];
//            if(![[LZXHelper isNullToString:_endPosition] isEqualToString:@""]) {
//                weakSelf.endLocation.text = [_endPosition separatedBy:@"中国湖北省"];
//            }
//        }
//    }];
    
    _pointJSON = [LZXHelper toJSONString:[self selPointInfo]];
    
}

- (NSMutableArray *)selPointInfo{
    
    NSMutableArray *selPointArray = [NSMutableArray array];
    for (id tempPoint in self.pointInfo) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if ([tempPoint isKindOfClass:[MAPointAnnotation class]]) {
            MAPointAnnotation *point = (MAPointAnnotation *)tempPoint;
            dict[@"angle"] = @"0.0";
            dict[@"latitude"] = [NSString stringWithFormat:@"%.10f",point.coordinate.latitude];
            dict[@"longitude"] = [NSString stringWithFormat:@"%.10f",point.coordinate.longitude];
            dict[@"time"] = point.time;
            dict[@"type"] = point.type;
            [selPointArray addObject:dict];
        }else if ([tempPoint isKindOfClass:[NSDictionary class]]) {
            NSDictionary *point = (NSDictionary *)tempPoint;
            [selPointArray addObject:point];
        }
    }
    return selPointArray;
}

//- (NSString *)dictionaryToJson:(NSDictionary *)dic
//
//{
//    NSError *parseError = nil;
//    
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
//    
//    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    
//}

- (void)createNavBar {
    
    NSString *title;
    if (self.fromWhere == EndPhysicsPage) {
        if ([self.userInfoModel.autoUploadSet boolValue]) {
            title = @"上传";
        }else {
            title= @"保存";
        }
    } else if (self.fromWhere == DraftsPage) {
        title = @"上传";
    } else {
        return;
    }
    self.rightItem =[[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(uploadPhysicsAction)];
    [self.rightItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItems = [self.navigationItem rightItemsWithBarButtonItem:self.rightItem WithSpace:5];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = zGroupTableViewBackgroundColor;
    self.title = @"轨迹详情";
    self.workMode = RoutingWorkMode;
    [self createNavBar];
    
    [self initAllView];
    if (self.gModel) {
        [self reloadUI];
    }
    
    // Do any additional setup after loading the view.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.scroller) {
       [self.view endEditing:YES];
    }
//    [self.getAudioView dismiss];
    
}
#pragma mark -
#pragma mark  初始化轨迹model
- (void)initGetPathModel {
    

    if (!self.model) {
        self.model = [[GetPathModel alloc] init];
    }
    self.model.alarm = self.userInfoModel.alarm;
    self.model.end_latitude = _endLatitue;
    self.model.end_longitude = _endLongtitue;
    self.model.end_posi = self.endLocation.text;
    self.model.end_time = _endTime;
    self.model.gid = self.gid;
    self.model.head_pic = self.userInfoModel.headpic;
    self.model.name = self.userInfoModel.name;
    self.model.cuid = [LZXHelper createCUID];
    self.model.route_title = self.titleField.text;
    self.model.start_latitude = _startLatitue;
    self.model.start_longitude = _startLongtitue;
    self.model.start_time = _startTime;
    self.model.start_posi = self.startLocation.text;
    self.model.task_id = _workid;
    self.model.type = [NSString stringWithFormat:@"%d",self.workMode];
    self.model.location_list = [self selPointInfo];
    self.model.createTime = [self requestTime];
    self.model.describetion = self.descriptionView.text;
    
}
- (void)initGetPathModelWithCUID:(NSString *)cuid {
    
    
    if (!self.model) {
        self.model = [[GetPathModel alloc] init];
    }
    self.model.alarm = self.userInfoModel.alarm;
    self.model.end_latitude = _endLatitue;
    self.model.end_longitude = _endLongtitue;
    self.model.end_posi = self.endLocation.text;
    self.model.end_time = _endTime;
    self.model.gid = self.gid;
    self.model.head_pic = self.userInfoModel.headpic;
    self.model.name = self.userInfoModel.name;
    self.model.cuid = cuid;
    self.model.route_title = self.titleField.text;
    self.model.start_latitude = _startLatitue;
    self.model.start_longitude = _startLongtitue;
    self.model.start_time = _startTime;
    self.model.start_posi = self.startLocation.text;
    self.model.task_id = _workid;
    self.model.type = [NSString stringWithFormat:@"%d",self.workMode];
    self.model.location_list = [self selPointInfo];
    self.model.createTime = [self requestTime];
    self.model.describetion = self.descriptionView.text;
    
}

#pragma mark -
#pragma mark 保存草稿箱
- (void)writeToDB {
    if ([[[DBManager sharedManager] trajectoryListSQ] insertTrajectoryList:self.model]) {
        [self showHint:@"保存成功"];
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self showHint:@"保存失败"];
    }
}
#pragma mark -
#pragma mark 更新草稿箱
- (void)writeToDBForUpdata {
    if ([[[DBManager sharedManager] trajectoryListSQ] updataTrajectoryList:self.model]) {
        [self showHint:@"更新成功"];
        self.block(self);
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self showHint:@"更新失败"];
    }
}
#pragma mark -
#pragma mark 移除地图的杂物
- (void)removeMapPath {
    [LYRouter openURL:@"ly://MapViewControllerRemovePolyline"];
    [LYRouter openURL:@"ly://dissmissWarningView"];
}
//解决UIScrollView不滚的问题
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat H = 0;
    if ((height(self.topView.frame)+ height(self.centralView.frame)+height(self.bottomView.frame)) > kScreenHeight) {
        H = height(self.topView.frame)+ height(self.centralView.frame)+height(self.bottomView.frame)+16+64;
    }else {
        H = kScreenHeight;
    }
    self.scroller.contentSize = CGSizeMake(kScreenWidth,H);
    
}
//判断内容是否改变，若改变提示是否更新到草稿箱
- (BOOL)isChange {
    BOOL ret = NO;
    
    ZEBLog(@"-----%@-------%@------%d----%@",self.titleField.text,self.descriptionView.text,self.workMode,_workid);
    if (![[LZXHelper isNullToString:self.titleField.text] isEqualToString:[LZXHelper isNullToString:self.gModel.route_title]]) {
        ret = YES;
    }
    if (![[LZXHelper isNullToString:_workid] isEqualToString:[LZXHelper isNullToString:self.gModel.task_id]]) {
        ret = YES;
    }
    if (self.workMode != (WorkModeType)[self.gModel.type integerValue]) {
        ret = YES;
    }
    if (![[LZXHelper isNullToString:self.descriptionView.text] isEqualToString:[LZXHelper isNullToString:self.gModel.describetion]]) {
        ret = YES;
    }
   
    return ret;
}


#pragma mark -
#pragma mark textFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *string1 = [NSString stringWithFormat:@"%@%@", textField.text, string];
    if (string1.length > TITLE_MAXLENGTH){
        [self showloadingError:@"字数不能大于14!"];
        return NO;
    }
    if ([[[UITextInputMode currentInputMode]primaryLanguage] isEqualToString:@"emoji"])
    {
        [self showloadingError:@"输入格式有误!"];
        return NO;
    }
    if ([NSString containEmoji:string])
    {
        [self showloadingError:@"输入格式有误!"];
        return NO;
    }
    return YES;
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
