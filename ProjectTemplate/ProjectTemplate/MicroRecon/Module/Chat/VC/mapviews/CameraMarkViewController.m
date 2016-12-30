//
//  CameraMarkViewController.m
//  ProjectTemplate
//
//  Created by caohanchao on 16/10/25.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//


#define white_backgroundColor [UIColor whiteColor]
#define font_blackColor [UIColor blackColor]
#define font_grayColor [UIColor grayColor]

#define font() [UIFont systemFontOfSize:14]

#define CellHeight 44.5
#define LeftMargin 12
#define UploadViewH 44.5

#import <AMapSearchKit/AMapSearchKit.h>
#import "CameraMarkViewController.h"
#import "NSDate+Extensions.h"
#import "UIButton+EnlargeEdge.h"
#import "MarkLocationViewController.h"
#import "WorkListsViewController.h"

#import "UIViewController+BackButtonHandler.h"
#import "WorkAllTempModel.h"
#import "NSString+Time.h"

#import "AudioView.h"
#import "VideoView.h"
#import "GetAudioView.h"
#import "XMProgressHUD.h"
#import "Mp3Recorder.h"
#import "UploadModel.h"
#import "ZLPhotoActionSheet.h"
#import "VideoRecorderViewController.h"
#import "IDMPhotoBrowser.h"
#import "VideoViewController.h"
#import "XMNAVAudioPlayer.h"
#import "LZXHelper.h"
#import "PicImageView.h"
#import "ZLDefine.h"
#import "ZMLPlaceholderTextView.h"


//图片 语音 视频 适配
#define picleftM  12
#define piccenterM  12
#define picCenterY  20
#define audioLeftM  12
#define audioCenterM  12
#define btnW  (width(self.view.frame)-3*piccenterM-2*picleftM)/4
#define audioBtnW  (width(self.view.frame)-3*audioCenterM-2*audioLeftM)/4
#define audioBtnH  26

#define TextFildPLText @"请输入描述内容..."

static NSString *postName = @"武汉市公安局";

@interface CameraMarkViewController ()<UITextFieldDelegate,UITextViewDelegate,AMapSearchDelegate, AudioViewDelegate, VideoViewDelegate, Mp3RecorderDelegate,VideoRecorderViewControllerDelegate, UIScrollViewDelegate, XMNAVAudioPlayerDelegate, PicImageViewDelegate>
{
    NSString *_createTime;
    NSString *_content;
    NSString *_titleName;
    NSString *_taskName;
    NSString *_mode;
    NSString *_position;
    NSString *_pictureUrl;
    NSString *_audioUrl;
    NSString *_videoUrl;
    NSString *_workid;
    
    
    NSString *_longitude;
    NSString *_latitude;
    
//    NSString *

    AMapSearchAPI *_search;
    CLLocation *_currentLocation;
    
    NSInteger _imageTempCount;
    UIBarButtonItem *_rightBarButtonItem;
}

@property (nonatomic, strong) UIScrollView *scroller;
@property (nonatomic, strong) ZLPhotoActionSheet *actionSheet;
@property (strong, nonatomic) Mp3Recorder *MP3;
@property (nonatomic, strong) GetAudioView *getAudioView;

@property (nonatomic, strong) UIActivityIndicatorView *locationIndicatorView;
@property(nonatomic,strong)UIView *topView;
@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)UIView *centralView;

@property (nonatomic, strong) UIView *uploadView;
@property(nonatomic,strong)UITextField *titleField;
@property(nonatomic,strong)UILabel *taskLabel;
@property(nonatomic,strong)UIButton *taskBtn;

@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UILabel *peasonName;
@property(nonatomic,strong)UILabel *peasonPost;
@property(nonatomic,strong)UIImageView *peasonImg;
@property(nonatomic,strong)UILabel *location;
@property(nonatomic,strong)UIButton *locationBtn;

@property(nonatomic,strong)ZMLPlaceholderTextView *descriptionView;
@property(nonatomic,strong)UISwitch *uploadSwitch;
//存放url
@property (nonatomic, strong) NSMutableArray *audioUrlArray;
@property (nonatomic, strong) NSMutableArray *picUrlArray;
@property (nonatomic, strong) NSMutableArray *videoUrlArray;


@property(nonatomic,strong)WorkAllTempModel *wModel;
@property(nonatomic,strong)UserInfoModel *userInfoModel;

//存放展示控件
@property (nonatomic, strong) NSMutableArray *audioArray;
@property (nonatomic, strong) NSMutableArray *picArray;
@property (nonatomic, strong) NSMutableArray *videoArray;



@end

@implementation CameraMarkViewController


-(void)setMarkParam:(NSMutableDictionary *)markParam
{

    _longitude = markParam[@"longitude"];
    _latitude = markParam[@"latitude"];
    _gid = markParam[@"gid"];
    _direction = markParam[@"direction"];
    _workid = markParam[@"workid"];
    _markType = [markParam[@"mode"] integerValue];
    _type = markParam[@"type"];
    _taskName = markParam[@"workname"];
    if ([_taskName isEqualToString:@"全部"]) {
        _taskName = @"";
    }
    [self initSearch];
    [self reGeoAction];
}

- (void)setModel:(WorkAllTempModel *)model {
    _model = model;
   // ZEBLog(@"-----%@-----%@-------%@",_model,self.model.workId,self.wModel.create_time);
    SuspectlistModel *sModel = [[[DBManager sharedManager] suspectAlllistSQ] selectSuspectByWorkId:self.model.workId];
    
    _taskName = sModel.suspectname;
    _longitude = _model.longitude;
    _latitude = _model.latitude;
    _gid = _model.gid;
    _direction = _model.direction;
    _workid = _model.workId;
    _markType = [_model.mode integerValue];
    _type = _model.type;
    
}

#pragma mark - 懒加载

-(UserInfoModel *)userInfoModel
{
    if (!_userInfoModel) {
        _userInfoModel = [[[DBManager sharedManager] userDetailSQ] selectUserDetail];
    }
    return _userInfoModel;

}


-(WorkAllTempModel *)wModel
{
    if (!_wModel) {
        _wModel = [[WorkAllTempModel alloc] init];
    }
    return _wModel;

}


- (GetAudioView *)getAudioView {
    if (!_getAudioView) {
        _getAudioView = [[GetAudioView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 0) startBlock:^(GetAudioView *view) {//开始录音
            [self.descriptionView setEditable:NO];
            [XMProgressHUD show];
            [self.MP3 startRecord];
        } cancelBlock:^(GetAudioView *view) {//取消录音
            [self.descriptionView setEditable:YES];
            [XMProgressHUD dismissWithMessage:@"取消录音"];
            [self.MP3 cancelRecord];
        } confimBlock:^(GetAudioView *view) {//录音结束
            [self.descriptionView setEditable:YES];
            [self.MP3 stopRecord];
        } updateCancelBlock:^(GetAudioView *view) {//更新录音显示状态,手指向上滑动后提示松开取消录音
             [XMProgressHUD changeSubTitle:@"松开手指取消录音"];
        } updateContinueBlock:^(GetAudioView *view) {//更新录音状态,手指重新滑动到范围内,提示向上取消录音
            [XMProgressHUD changeSubTitle:@"向上滑动取消录音"];
        }];
    }
    return _getAudioView;
}
- (ZLPhotoActionSheet *)actionSheet {
    if (!_actionSheet) {
        _actionSheet = [[ZLPhotoActionSheet alloc] init];
        //设置照片最大选择数
        _actionSheet.maxSelectCount = 10;
        //设置照片最大预览数
        _actionSheet.maxPreviewCount = 500;
    }
    return _actionSheet;
}
- (UIScrollView *)scroller {
    if (!_scroller) {
        _scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-CellHeight)];
        _scroller.delegate = self;
        _scroller.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _scroller;
}
- (NSMutableArray *)audioArray {
    if (!_audioArray) {
        _audioArray = [NSMutableArray array];
    }
    return _audioArray;
}
- (NSMutableArray *)picArray {
    if (!_picArray) {
        _picArray = [NSMutableArray array];
    }
    return _picArray;
}
- (NSMutableArray *)videoArray {
    if (!_videoArray) {
        _videoArray = [NSMutableArray array];
    }
    return _videoArray;
}
- (NSMutableArray *)audioUrlArray {
    if (!_audioUrlArray) {
        _audioUrlArray = [NSMutableArray array];
    }
    return _audioUrlArray;
}
- (NSMutableArray *)picUrlArray {
    if (!_picUrlArray) {
        _picUrlArray = [NSMutableArray array];
    }
    return _picUrlArray;
}
- (NSMutableArray *)videoUrlArray {
    if (!_videoUrlArray) {
        _videoUrlArray = [NSMutableArray array];
    }
    return _videoUrlArray;
}
- (UIView *)uploadView {
    if (!_uploadView) {
        _uploadView = [[UIView alloc] init];
        _uploadView.backgroundColor = white_backgroundColor;
    }
    return _uploadView;
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
        if (self.fromWhere == DraftsController) {
          _createTime = _model.create_time;
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
        _taskLabel =[CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:0 font:font() textColor:CHCHexColor(@"808080") text:_taskName];
    }
    return _taskLabel;
}

-(UIButton *)taskBtn
{
    if (!_taskBtn) {
        _taskBtn = [CHCUI createButtonWithtarg:self sel:@selector(taskBtnClick) titColor:[UIColor grayColor] font:font() image:nil backGroundImage:nil title:nil];
        _taskBtn.backgroundColor =[UIColor clearColor];
    }
    return _taskBtn;
}

-(UIButton *)locationBtn
{
    if (!_locationBtn) {
        _locationBtn = [CHCUI createButtonWithtarg:self sel:@selector(locationBtnClick) titColor:nil font:font() image:nil backGroundImage:nil title:nil];
        
    }
    return _locationBtn;
}

-(UIImageView *)peasonImg
{
    if (!_peasonImg) {
        _peasonImg = [[UIImageView alloc]init];
        _peasonImg.layer.cornerRadius = 15;
        _peasonImg.layer.masksToBounds = YES;
        
    }
    return _peasonImg;
}

-(UILabel *)peasonPost
{
    if (!_peasonPost) {
        _peasonPost = [CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:1 font:[UIFont systemFontOfSize:10] textColor:white_backgroundColor text:@""];
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
        _peasonName = [CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:0 font:[UIFont systemFontOfSize:14] textColor:CHCHexColor(@"808080") text:@""];
    }
    return _peasonName;
}

-(UISwitch *)uploadSwitch
{
    if (!_uploadSwitch) {
        
//        UserInfoModel *model = [[[DBManager sharedManager] userDetailSQ] selectUserDetail];
        _uploadSwitch =[[UISwitch alloc]init];
        _uploadSwitch.onTintColor = zBlueColor;
        _uploadSwitch.enabled = YES;
        _uploadSwitch.userInteractionEnabled = YES;
        _uploadSwitch.on = [self.userInfoModel.autoUploadSet boolValue];
        [_uploadSwitch addTarget:self action:@selector(uploadSwitchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _uploadSwitch;
}
- (UIActivityIndicatorView *)locationIndicatorView {
    if (!_locationIndicatorView) {
        _locationIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_locationIndicatorView startAnimating];
    }
    return _locationIndicatorView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
     [XMNAVAudioPlayer sharePlayer].delegate = self;
    self.MP3 = [[Mp3Recorder alloc] initWithDelegate:self];
    [self createNavBar];
    [self createUI];
    // Do any additional setup after loading the view.
}


#pragma mark -
#pragma mark - init


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[XMNAVAudioPlayer sharePlayer] stopAudioPlayer];
    [XMNAVAudioPlayer sharePlayer].index = NSUIntegerMax;
    [XMNAVAudioPlayer sharePlayer].URLString = nil;
}

- (void)initSearch
{
    _search = [[AMapSearchAPI alloc]init];
    _search.delegate =self;
    
}

-(void)createNavBar
{
//    self.markType = [self.markParam[@"mode"] integerValue];
    if (self.fromWhere == DraftsController) {
        self.title = @"记录详情";
    }else {
    switch (self.markType) {
        case WalkMark:
            self.title =@"走访标记";
            break;
        case QuickRecord:
            self.title =@"快速记录";
            break;
        case CaremaMark:
            self.title =@"摄像头标记";
            break;

        default:
            break;
    }
    }
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(leftBtnClick)];
    self.userInfoModel = [[[DBManager sharedManager] userDetailSQ] selectUserDetail];
    
    NSString *rightTitle = @"保存";

    if (self.fromWhere == DraftsController) {
        rightTitle = @"上传";
    }else {
        if ([self.userInfoModel.autoUploadSet boolValue]) {
           rightTitle = @"上传";
        }
    }
    
    
    _rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:rightTitle style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction)];
    
    self.navigationItem.rightBarButtonItems = [self.navigationItem rightItemsWithBarButtonItem:_rightBarButtonItem WithSpace:5];
    [_rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil] forState:UIControlStateNormal];
}

-(void)createUI
{

//    UserInfoModel *model = [[[DBManager sharedManager] userDetailSQ] selectUserDetail];
    
    UserAllModel *userModel = [[[DBManager sharedManager] personnelInformationSQ] selectDepartmentmemberlistById:self.userInfoModel.alarm];
    UnitListModel *uModel = [[[DBManager sharedManager] DepartmentlistSQ] selectDepartmentlistById:userModel.RE_department];
    
    
    self.view.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.95 alpha:1.00];
    
    [self.view addSubview:self.scroller];
    
    UILabel *title =[CHCUI createLabelWithbackGroundColor: white_backgroundColor textAlignment:0 font:font() textColor:font_blackColor text:@"标题"];
    
    
    UILabel *task = [CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:0 font:font()  textColor:font_blackColor text:@"所属任务"];
    
    
    UILabel *peason = [CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:0 font:font() textColor:font_blackColor text:@"记录人"];
   
    
    UIImageView *locationImg =[CHCUI createImageWithbackGroundImageV:@"location_carema"];
    
    
    self.location = [CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:0 font:font() textColor:font_blackColor text:_position];
    self.location.userInteractionEnabled = YES;
    
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
            self.peasonPost.text = [NSString stringWithFormat:@" %@ ",self.userInfoModel.department];
            
        }
        
    }
    
    width = [LZXHelper textWidthFromTextString:self.peasonPost.text height:20 fontSize:10];

    
    [self.peasonName setText:self.userInfoModel.name];
    
    
    UIImageView *taskImg = [CHCUI createImageWithbackGroundImageV:@"rightarrow"];
    
    UIImageView *uploadImg =[CHCUI createImageWithbackGroundImageV:@"update_carema"];
    
    UILabel *uploadLabel =[CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:0 font:font() textColor:font_blackColor text:@"直接上传"];
    
    UILabel *line1 = [UILabel new];
    line1.backgroundColor = LineColor;
    
    UILabel *line2 =[UILabel new];
    line2.backgroundColor = LineColor;
    
    UILabel *line3 =[UILabel new];
    line3.backgroundColor = LineColor;
    
    UILabel *line4 =[UILabel new];
    line4.backgroundColor = LineColor;
    
    
    [self.scroller addSubview:self.topView];
    [self.scroller addSubview:self.centralView];

    
    [self.topView addSubview:title];
    [self.topView addSubview:task];
    [self.topView addSubview:peason];
    [self.topView addSubview:locationImg];
    
    
    
    [self.topView addSubview:self.titleField];
    [self.topView addSubview:self.timeLabel];
    [self.topView addSubview:line1];
    
   
    
    [self.topView addSubview:self.taskLabel];
    [self.topView addSubview:taskImg];
    [self.topView addSubview:self.taskBtn];
    
    [self.topView addSubview:line2];
    
    [self.topView addSubview:self.peasonImg];
    [self.topView addSubview:self.peasonPost];
    [self.topView addSubview:self.peasonName];
    [self.topView addSubview:line3];
    
    [self.topView addSubview:self.location];
    
    [self.topView addSubview:self.locationIndicatorView];
    
    [self.topView addSubview:self.locationBtn];
    
    [self.centralView addSubview:self.descriptionView];
    
    
    [self.centralView addSubview:self.uploadView];
    
   
    [self.uploadView addSubview:line4];
    [self.uploadView addSubview:uploadImg];
    [self.uploadView addSubview:uploadLabel];
    [self.uploadView addSubview:self.uploadSwitch];
    
    
   
    
    
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
        make.height.offset(122+CellHeight);
        
    }];
    
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
    
    [locationImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(peason.mas_bottom).with.offset(12);
        make.left.equalTo(self.topView.mas_left).with.offset(LeftMargin);
        make.width.offset(15);
        make.height.offset(20.5);
    }];
    
    [self.location mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(peason.mas_bottom).with.offset(0);
        make.bottom.equalTo(self.topView.mas_bottom).with.offset(0);
        make.left.equalTo(locationImg.mas_right).with.offset(LeftMargin);
        make.right.equalTo(self.topView.mas_right).with.offset(-12);
    }];
    [self.locationIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(locationImg.mas_right).offset(LeftMargin);
        make.centerY.equalTo(self.location.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(peason.mas_bottom).with.offset(0);
        make.left.equalTo(self.topView.mas_left).with.offset(0);
        make.right.equalTo(self.topView.mas_right).with.offset(0);
        make.height.offset(CellHeight);
        
    }];
    
    [self.titleField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(title.mas_right).with.offset(0);
        make.centerY.equalTo(title.mas_centerY).with.offset(0);
        make.right.equalTo(self.topView.mas_right).with.offset(-80);
        make.height.equalTo(title.mas_height);
    }];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleField.mas_left).with.offset(0);
        make.right.equalTo(self.topView.mas_right).with.offset(0);
        make.top.equalTo(self.titleField.mas_bottom).with.offset(-0.5);
        make.height.equalTo(@0.5);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleField.mas_right).offset(0);
        make.right.equalTo(self.topView.mas_right).offset(-12);
        make.centerY.equalTo(self.titleField.mas_centerY).offset(0);
        make.height.equalTo(title.mas_height);
    }];
    
    
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.taskBtn.mas_left).with.offset(0);
        make.right.equalTo(self.topView.mas_right).with.offset(0);
        make.top.equalTo(self.taskBtn.mas_bottom).with.offset(-0.5);
        make.height.equalTo(@0.5);
    }];
    
    
    [self.taskLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(task.mas_centerY).with.offset(0);
        make.left.equalTo(task.mas_right).with.offset(0);
        make.height.equalTo(task.mas_height).with.offset(0);
        make.width.equalTo(@200);
        
    }];
    
    [taskImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topView.mas_right).with.offset(0);
        make.centerY.equalTo(self.taskBtn.mas_centerY).with.offset(0);
        make.height.offset(30);
        make.width.offset(30);
        
    }];
    
    [self.taskBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(task.mas_right).with.offset(0);
        make.right.equalTo(self.topView.mas_right).with.offset(0);
        make.centerY.equalTo(task.mas_centerY).with.offset(0);
        make.height.equalTo(task.mas_height);
    }];
    
    [self.peasonImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(peason.mas_centerY).with.offset(0);
        make.left.equalTo(peason.mas_right).with.offset(0);
        make.height.width.offset(30);
        
    }];
    
    [self.peasonPost mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(peason.mas_centerY).with.offset(0);
        make.left.equalTo(self.peasonImg.mas_right).with.offset(10);
        make.width.offset(width);
        make.height.offset(20);
    }];
    
    
    [self.peasonName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(peason.mas_centerY).with.offset(0);
        make.left.equalTo(self.peasonPost.mas_right).with.offset(8);
        make.width.mas_greaterThanOrEqualTo(100);
        make.height.equalTo(peason.mas_height).with.offset(0);
    }];
    

    
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left).with.offset(0);
        make.right.equalTo(self.topView.mas_right).with.offset(0);
        make.top.equalTo(peason.mas_bottom).with.offset(-0.5);
        make.height.equalTo(@0.5);
        
    }];
    
    [self.descriptionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centralView.mas_left).with.offset(LeftMargin);
        make.right.equalTo(self.centralView.mas_right).with.offset(0);
        make.top.equalTo(self.centralView.mas_top).with.offset(0);
        make.height.offset(122);
    }];
    
    [self.uploadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descriptionView.mas_bottom);
        make.right.equalTo(self.centralView.mas_right).offset(0);
        make.left.equalTo(self.centralView.mas_left).offset(0);
        make.height.offset(UploadViewH);

    }];
    
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.uploadView.mas_top);
        make.right.equalTo(self.uploadView.mas_right).offset(0);
        make.left.equalTo(self.uploadView.mas_left).offset(0);
        make.height.offset(0.5);
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
    
   
    CGFloat wSpace = (screenWidth()-60)/4;
    
    NSArray *imgArr = @[@"voice_carema",@"photo_carema",@"camera_camera"];
    
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.height.offset(44);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        
    }];
    
    for (int i = 0; i<3; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (i == 0) {
        btn.frame = CGRectMake(wSpace+i*(20+wSpace),11, 18, 28);
        }else if (i == 1) {
        btn.frame = CGRectMake(wSpace+i*(20+wSpace),11, 29, 25.5);
        }else if (i == 2) {
        btn.frame = CGRectMake(wSpace+i*(20+wSpace),11, 27, 23.5);
        }
        
        
        //在正常状态下显示的背景图片
        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imgArr[i]]] forState:UIControlStateNormal];

        [btn setEnlargeEdge:15];
        btn.tag = 90000+i;
        //添加点击事件
        [btn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:btn];
    }
 //当草稿箱进来
    if (self.fromWhere == DraftsController) {
        
        self.uploadView.alpha = 0;
        self.locationIndicatorView.alpha = 0;
        
        SuspectlistModel *sModel = [[[DBManager sharedManager] suspectAlllistSQ] selectSuspectByWorkId:self.model.workId];
        
        self.titleField.text = self.model.title;
        self.taskLabel.text = sModel.suspectname;
        self.location.text = self.model.position;
        
        
        if ([self.model.content isEqualToString:@""]) {
            self.descriptionView.textColor = CHCHexColor(@"a6a6a6");
        }else {
            self.descriptionView.textColor = CHCHexColor(@"000000");
            self.descriptionView.text = self.model.content;
        }
        
        
        if (![self.model.picture isEqualToString:@" "] && ![self.model.picture isEqualToString:@""]) {
            NSArray *pictures = [self.model.picture componentsSeparatedByString:@","];
            for (NSString *url in pictures) {
                [self createPicView:url];
            }
        }
        if (![self.model.video isEqualToString:@" "] && ![self.model.video isEqualToString:@""]) {
            NSArray *videos = [self.model.video componentsSeparatedByString:@","];
            for (NSString *url in videos) {
                [self createVideoView:url];
            }
        }
        if (![self.model.audio isEqualToString:@" "] && ![self.model.audio isEqualToString:@""]) {
            NSArray *audios = [self.model.audio componentsSeparatedByString:@","];
            for (NSString *url in audios) {
                [self createAudioView:url];
            }
        }
        NSInteger count = self.picArray.count+self.audioArray.count+self.videoArray.count;
        if (count == 0) {
            [self.centralView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.offset(122);
            }];
            [UIView animateWithDuration:0.2 animations:^{
                [self.view layoutIfNeeded];
            }];
        }else {
            [self uploadUI];
        }
    }

}

#pragma mark -
#pragma mark scrollerview
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    [self.getAudioView dismiss];

}
//解决UIScrollView不滚的问题
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat H = 0;
    if ((height(self.topView.frame)+ height(self.centralView.frame)+32) > kScreenHeight-44) {
        H = height(self.topView.frame)+ height(self.centralView.frame)+48+16+64;
    }else {
        H = kScreenHeight - 44 + 16;
    }
    self.scroller.contentSize = CGSizeMake(kScreenWidth,H);
    
    
}
#pragma mark -
#pragma mark 当有图片 视频 语音 刷新ui
- (void)uploadUI {
    
    
    NSInteger audioCount = self.audioArray.count;
    NSInteger picCount = self.picArray.count;
    NSInteger videoCount = self.videoArray.count;
    
//    CGFloat picleftM = 12;
//    CGFloat piccenterM = 12;
//    
//    CGFloat centerY = 20;
//    
//    CGFloat audioLeftM = 12;
//    CGFloat audioCenterM = 12;
    
    CGFloat contentHeight = height(self.descriptionView.frame)+10;
    
    CGFloat topHeight = contentHeight;
    
//    CGFloat btnW = (width(self.view.frame)-3*piccenterM-2*picleftM)/4;
//    CGFloat audioBtnW = (width(self.view.frame)-3*audioCenterM-2*audioLeftM)/4;
//    CGFloat audioBtnH = 26;

    
 
    for (int i = 0; i < audioCount; i++) {
        AudioView *audioBtn = self.audioArray[i];
        audioBtn.index = 100000 + i;
        audioBtn.tag = 100000 + i;
        audioBtn.frame = CGRectMake(audioLeftM+(audioBtnW+audioCenterM)*(i%4), topHeight+(audioBtnH+picCenterY)*(i/4), audioBtnW, audioBtnH);
    }
    if (audioCount != 0 ) {
        if (audioCount%4 == 0) {
            topHeight = topHeight + (audioBtnH + picCenterY)*(audioCount/4);
        }else {
            topHeight = topHeight + (audioBtnH + picCenterY)*(audioCount/4 + 1);
        }
        
    }
    for (int i = 0; i < picCount; i++) {
        PicImageView *picBtn = self.picArray[i];
        picBtn.tag = 1000+i;
        picBtn.index = 1000+i;
        picBtn.frame = CGRectMake(picleftM+(btnW+piccenterM)*(i%4), topHeight+(btnW + picCenterY)*(i/4), btnW, btnW);
    }
    if (picCount != 0) {
        if (picCount%4 == 0) {
            topHeight = topHeight + (btnW + picCenterY)*(picCount/4);
        }else {
            topHeight = topHeight + (btnW + picCenterY)*(picCount/4 + 1);
        }
        
    }
    for (int i = 0; i < videoCount; i++) {
        VideoView *videoBtn = self.videoArray[i];
        videoBtn.tag = 10000+i;
        videoBtn.index = 10000+i;
        videoBtn.frame = CGRectMake(picleftM+(btnW+piccenterM)*(i%4), topHeight+(btnW + picCenterY)*(i/4), btnW, btnW);
    }
    if (videoCount != 0) {
        if (videoCount%4 == 0) {
            topHeight = topHeight + (btnW + picCenterY)*(videoCount/4);
        }else {
            topHeight = topHeight + (btnW + picCenterY)*(videoCount/4 + 1);
        }
    }

    if (self.fromWhere == DraftsController) {
        [self.centralView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(122 + topHeight - height(self.descriptionView.frame));
        }];
    }else {
        [self.centralView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(122+UploadViewH + topHeight - height(self.descriptionView.frame));
        }];
    }
    
    [self.uploadView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descriptionView.mas_bottom).offset(topHeight+16 - height(self.descriptionView.frame));;
    }];
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}


#pragma mark -
#pragma mark -Action
//完成
-(void)rightBtnAction
{
    [self.view endEditing:YES];
    self.userInfoModel = [[[DBManager sharedManager] userDetailSQ] selectUserDetail];
    
    _content = self.descriptionView.text;
    _titleName = self.titleField.text;
    _taskName = self.taskLabel.text;
    _position = self.location.text;
     [self configModel];
    
    if (self.fromWhere == DraftsController) {
        if (![[LZXHelper isNullToString:_titleName] isEqual:@""] && ![[LZXHelper isNullToString:_taskName] isEqual:@""] && ![[LZXHelper isNullToString:_position] isEqual:@""]&&[LZXHelper isNullToString:_titleName].length <= 14&&[LZXHelper isNullToString:_content].length <= 50)
        {
            switch (self.markType)
            {
                case CaremaMark:
                {
                    [self httpRequest];
                }
                    break;
                case WalkMark:
                {
                    [self httpRequest];
                }
                    break;
                case QuickRecord:
                {
                    [self httpRequest];
                }
                    break;
                default:
                    break;
            }
            
        }else{
            
            if ([[LZXHelper isNullToString:_titleName] isEqual:@""]){
                [self showHint:@"请输入标题"];
                return;
            }
            if ([LZXHelper isNullToString:_titleName].length > 14) {
                [self showHint:@"标题不能超过14字"];
                return;
            }
            if ([[LZXHelper isNullToString:_taskName] isEqual:@""]) {
                [self showHint:@"请选择任务"];
                return;
            }
            if ([[LZXHelper isNullToString:_position] isEqual:@""]) {
                [self showHint:@"请选择位置"];
                return;
            }
            if ([LZXHelper isNullToString:_content].length > 50) {
                [self showHint:@"描述内容不能超过50字"];
                return;
            }
//            
//            [self showHint:@"请编辑完成后在提交"];
        }
    }else {
    //上传
    if ([self.userInfoModel.autoUploadSet boolValue]) {
        
        if (![[LZXHelper isNullToString:_titleName] isEqual:@""] && ![[LZXHelper isNullToString:_taskName] isEqual:@""] && ![[LZXHelper isNullToString:_position] isEqual:@""]&&[LZXHelper isNullToString:_titleName].length <= 14&&[LZXHelper isNullToString:_content].length <= 50)
        {
            switch (self.markType)
            {
                case CaremaMark:
                {
                    [self httpRequest];
                }
                    break;
                case WalkMark:
                {
                    [self httpRequest];
                }
                    break;
                case QuickRecord:
                {
                    [self httpRequest];
                }
                    break;
                default:
                    break;
            }
            
        }else{
            if ([[LZXHelper isNullToString:_titleName] isEqual:@""]){
                [self showHint:@"请输入标题"];
                return;
            }
            if ([LZXHelper isNullToString:_titleName].length > 14) {
                [self showHint:@"标题不能超过14字"];
                return;
            }
            if ([[LZXHelper isNullToString:_taskName] isEqual:@""]) {
                [self showHint:@"请选择任务"];
                return;
            }
            if ([[LZXHelper isNullToString:_position] isEqual:@""]) {
                [self showHint:@"请选择位置"];
                return;
            }
            if ([LZXHelper isNullToString:_content].length > 50) {
                [self showHint:@"描述内容不能超过50字"];
                return;
            }
            
        }
    } //存草稿箱
    else
    {
        if([[[DBManager sharedManager] draftsListSQ] insertDraftsList:self.wModel])
        {
            [self showHint:@"保存草稿箱成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    }
    
}

-(BOOL)navigationShouldPopOnBackButton
{
    
    if (self.fromWhere == DraftsController && ![self isChange]) {
        return YES;
    }
        NSString *message = @"您是否将未上传的标记存入草稿箱";
        if (self.fromWhere == DraftsController) {
            message = @"您是否需要更新未上传的标记到草稿箱";
        }
        [self configModel];
        
        //    if (![self.wModel.position isEqual:@""] && ![self.wModel.title isEqual:@""] && ![self.wModel.workId isEqual:@""]) {
        UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (self.fromWhere == DraftsController) {
                if([[[DBManager sharedManager] draftsListSQ] updataDraftsList:self.wModel])
                {
                    [self showHint:@"更新成功"];
                    self.block(self);
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }else {
                if([[[DBManager sharedManager] draftsListSQ] insertDraftsList:self.wModel])
                {
                    [self showHint:@"保存草稿箱成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
        }];
        UIAlertAction *action2 =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert addAction:action1];
        [alert addAction:action2];
        [self.navigationController presentViewController:alert animated:YES completion:^{
            
        }];
 
//    }
    return YES;
}



//任务交互
-(void)taskBtnClick
{
    __weak CameraMarkViewController *weakself = self;
    WorkListsViewController *workList = [[WorkListsViewController alloc] init];
    workList.gid = self.gid;
    workList.type = 2;
    workList.taskBlock = ^(NSMutableDictionary *param){
        _workid = param[@"taskId"];
        _taskName = param[@"taskName"];
        weakself.taskLabel.text = _taskName;
    };
    [self.navigationController pushViewController:workList animated:YES];

}
//定位
-(void)locationBtnClick
{
    
    __weak CameraMarkViewController *weakself = self;
    MarkLocationViewController *locationC = [[MarkLocationViewController alloc] init];
    locationC.locationBlock = ^(NSMutableDictionary *param){
        self.locationIndicatorView.hidden = YES;
        [self.locationIndicatorView stopAnimating];
        _position = param[@"position"];
        weakself.location.text = _position;
        _longitude = param[@"longitude"];
        _latitude = param[@"latitude"];
    };
    [self.navigationController pushViewController:locationC animated:YES];
    
}
//底部交互
-(void)bottomBtnClick:(UIButton *)btn
{
    if (btn.tag == 90000) {//语音
        [self.getAudioView showIn:self.view];
    }
    else if (btn.tag == 90001){//图片
        weakify(self);
        [self.actionSheet showPreviewPhotoWithSender:self animate:YES lastSelectPhotoModels:nil completion:^(NSArray<UIImage *> * _Nonnull selectPhotos, NSArray<ZLSelectPhotoModel *> * _Nonnull selectPhotoModels) {
            strongify(weakSelf);
           [strongSelf sendPic:selectPhotos];
        }];
    }
    else if (btn.tag == 90002){//视频
        //录制视频
        VideoRecorderViewController *vrVC = [[VideoRecorderViewController alloc] init];
        vrVC.delegate = self;
        [self presentViewController:vrVC animated:YES completion:nil];
    }
    
}

//upload开关
-(void)uploadSwitchAction:(UISwitch *)sw
{
    if (sw.on) {
        _rightBarButtonItem.title = @"上传";
    }else {
        _rightBarButtonItem.title = @"保存";
    }
    [[[DBManager sharedManager] userDetailSQ] updateUserDetailAutoUploadSet:[NSString stringWithFormat:@"%d",sw.on]];
}

//逆地理编码
-(void)reGeoAction
{
    _currentLocation = [[CLLocation alloc] initWithLatitude:[_latitude  doubleValue] longitude:[_longitude doubleValue]];
    
    if(_currentLocation)
    {
        AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
        request.location = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
        [_search AMapReGoecodeSearch:request];
        
    }
}



-(void)configModel
{
//    UserInfoModel *model = [[[DBManager sharedManager] userDetailSQ] selectUserDetail];
    
    self.wModel.alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    self.wModel.content = self.descriptionView.text;
    self.wModel.create_time = _createTime;
    self.wModel.department = self.userInfoModel.department;
    self.wModel.direction =_direction;
    self.wModel.gid =self.gid;
    self.wModel.headpic = self.userInfoModel.headpic;
    self.wModel.realname = self.userInfoModel.name;
    self.wModel.latitude = _latitude;
    self.wModel.longitude = _longitude;
    self.wModel.mode = [NSString stringWithFormat:@"%ld",_markType];
    self.wModel.type = _type;
    self.wModel.workId = _workid;
    self.wModel.position = _position;
    self.wModel.title = [self.titleField.text trimWhitespaceAndNewline];;
    
    self.wModel.interid = @"";
    self.wModel.orderid = @"";
    
    self.wModel.video = [self.videoUrlArray componentsJoinedByString:@","];
    self.wModel.picture = [self.picUrlArray componentsJoinedByString:@","];
    self.wModel.audio = [self.audioUrlArray componentsJoinedByString:@","];
    if (self.fromWhere == DraftsController) {
        self.wModel.cuid = self.model.cuid;
    }else {
        self.wModel.cuid = [LZXHelper createCUID];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -AMapSearchDelegate
//失败回调
- (void)searchRequest:(id)request didFailWithError:(NSError *)error
{
    self.locationIndicatorView.hidden = YES;
    [self.locationIndicatorView stopAnimating];
    self.location.text = @"获取位置失败";
    NSLog(@"request :%@, error :%@", request, error);
}


//成功回调
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    NSLog(@"response :%@", response);
    self.locationIndicatorView.hidden = YES;
    [self.locationIndicatorView stopAnimating];
    _position = response.regeocode.formattedAddress;
    
    self.location.text = _position;
}

#pragma mark -
#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    _content = self.descriptionView.text;
    self.descriptionView.textColor = CHCHexColor(@"000000");
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    _content = textView.text;
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    return YES;
}

//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self.view endEditing:YES];
//    [self.getAudioView dismiss];
//    if ([self.descriptionView.text isEqualToString:@""]) {
//        self.descriptionView.text = TextFildPLText;
//    }
//    
//    
//}

//请求当前时间
-(NSString *)requestTime{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *time = [formatter stringFromDate:[NSDate date]];
    return time;
}


#pragma mark - 网络请求部分
-(void)httpRequest
{
    
    _content = self.descriptionView.text;
    _titleName = [self.titleField.text trimWhitespaceAndNewline];
    _taskName = self.taskLabel.text;
    _position = self.location.text;
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];


    NSMutableDictionary *param =[[NSMutableDictionary alloc] init];
    param[@"content"] = _content;//内容
    param[@"alarm"] = alarm;   //警号
    param[@"title"] =_titleName;   //标题
    param[@"create_time"] =_createTime;//创建时间
    param[@"mode"]=[NSString stringWithFormat:@"%ld",self.markType];        //0.走访标记 1.快速记录2.摄像头标记
    param[@"type"] =self.type;
    param[@"longitude"]=_longitude;//经度
    param[@"latitude"] =_latitude;//维度
    param[@"position"] = _position; //位置
    param[@"gid"] =self.gid;
    param[@"direction"] =_direction;   //方向
    param[@"workid"] =_workid;
    param[@"picture"] =[self.picUrlArray componentsJoinedByString:@","];     //图片
    param[@"audio"] =[self.audioUrlArray componentsJoinedByString:@","];       //音频
    param[@"video"] =[self.videoUrlArray componentsJoinedByString:@","];       //视频
    ZEBLog(@"%@",param);
    
    [self showloadingName:@"正在提交"];
    [[HttpsManager sharedManager] post:Saverecord_URL parameters:param progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
        
        NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:reponse options:NSJSONReadingMutableContainers error:nil];
        ZEBLog(@"%@",dict);
        [self hideHud];
        [self showHint:@"标记成功"];
            
//        NSMutableDictionary *parm = [NSMutableDictionary dictionary];
//        //将任务添加到地图
//        parm[@"workAllModelMark"] = self.wModel;
//        
//        [LYRouter openURL:@"ly://mapaddmark" withUserInfo:parm completion:nil];

        if (self.fromWhere == DraftsController) {
            [[[DBManager sharedManager] draftsListSQ] deleteDraftsListByCuid:self.wModel.cuid];
            self.block(self);
        }

        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideHud];
        [self showHint:@"标记失败"];
        //失败存草稿箱
        [[[DBManager sharedManager] draftsListSQ] insertDraftsList:self.wModel];
        [self.navigationController popViewControllerAnimated:YES];
        
    }];

}

#pragma mark -
#pragma mark 创建语音view
- (void)createAudioView:(NSString *)audioUrl time:(NSTimeInterval)time{
    
    NSInteger count = self.audioArray.count;
    AudioView *audioBtn = [[AudioView alloc] initWithFrame:CGRectMake(0, 0, audioBtnW, audioBtnH)];
    audioBtn.audioStr = audioUrl;
    audioBtn.delegate = self;
    audioBtn.time = time;
    [self.audioArray addObject:audioBtn];
    [self.audioUrlArray addObject:audioUrl];
    [self.centralView addSubview:audioBtn];
    [self uploadUI];
}
- (void)createAudioView:(NSString *)audioUrl{
    
    NSInteger count = self.audioArray.count;
    AudioView *audioBtn = [[AudioView alloc] initWithFrame:CGRectMake(0, 0, audioBtnW, audioBtnH)];
    audioBtn.audioStr = audioUrl;
    audioBtn.delegate = self;
    [self.audioArray addObject:audioBtn];
    [self.audioUrlArray addObject:audioUrl];
    [self.centralView addSubview:audioBtn];
    [self uploadUI];
}
#pragma mark -
#pragma mark 创建图片view
- (void)createPicView:(NSString *)picUrl {
    
    NSInteger count = self.picArray.count;
    PicImageView *picBtn = [[PicImageView alloc] initWithFrame:CGRectMake(0, 0, btnW, btnW) pic:picUrl];
    picBtn.delegate = self;
    [self.picArray addObject:picBtn];
    [self.picUrlArray addObject:picUrl];
    [self.centralView addSubview:picBtn];
    [self uploadUI];
}
#pragma mark -
#pragma mark 创建视频view
- (void)createVideoView:(NSString *)videoUrl {

    NSInteger count = self.videoArray.count;
    VideoView *videoBtn = [[VideoView alloc] initWithFrame:CGRectMake(0, 0, btnW, btnW) widthVideoUrl:videoUrl];
    videoBtn.delegate = self;
    [self.videoArray addObject:videoBtn];
    [self.videoUrlArray addObject:videoUrl];
    [self.centralView addSubview:videoBtn];
    [self uploadUI];

}
//展示图片
- (void)showPic:(NSInteger)index view:(PicImageView *)view {
    
    NSInteger tag = index - 1000;
    NSMutableArray *ph = [NSMutableArray array];
    for (NSString *string in self.picUrlArray) {
        if (![string isEqualToString:@" "] || ![string isEqualToString:@""]) {
            IDMPhoto *photo = [IDMPhoto photoWithURL:[NSURL URLWithString:string]];
            [ph addObject:photo];
        }
    }
    
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:ph];
    // IDMPhotoBrowser功能设置
    browser.displayActionButton = NO;
    browser.displayArrowButton = NO;
    browser.displayCounterLabel = YES;
    browser.displayDoneButton = NO;
    browser.autoHideInterface = NO;
    browser.usePopAnimation = YES;
    browser.disableVerticalSwipe = YES;
    
    //    browser.longPressGesResponse=^(UIImage *image){
    //        self.image=image;
    //
    //
    //        [ZEBIdentify2Code detectorQRCodeImageWithSourceImage:image isDrawWRCodeFrame:NO  completeBlock:^(NSArray *resultArray, UIImage *resultImage) {
    //
    //            if (resultArray.count==0) {
    //                self.array=@[@"保存到相册"];
    //            }else{
    //                self.array=@[@"保存到相册",@"识别二维码"];
    //                self.codeStr=resultArray.firstObject;
    //            }
    //            CollectCopyView *collect=[[CollectCopyView alloc]initWidthName:self.array];
    //            collect.delegate=self;
    //            [collect show];
    //
    //        }];
    //
    //    };
    // 设置初始页面
    [browser setInitialPageIndex:tag];
    
    self.modalPresentationStyle=UIModalPresentationPageSheet;
    UINavigationController *navigation=[[UINavigationController alloc]initWithRootViewController:browser];
    
    [self presentViewController:navigation animated:YES completion:nil];
    
}
#pragma mark -
#pragma mark 图片代理
- (void)picImageView:(PicImageView *)view index:(NSInteger)index {
    [self showPic:index view:view];
}
- (void)picImageView:(PicImageView *)view deleteImageIndex:(NSInteger)index {
    NSInteger tag = index - 1000;
    [self.picArray removeObjectAtIndex:tag];
    [self.picUrlArray removeObjectAtIndex:tag];
    [UIView animateWithDuration:0.3 animations:^{
        view.transform = CGAffineTransformMakeScale(1.5, 1.5);
        view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self uploadUI];
        [view removeFromSuperview];
    }];
}
#pragma mark -
#pragma mark 语音代理
- (void)audioViewPlayAudio:(AudioView *)view index:(NSInteger)index audio:(NSURL *)url {
    NSInteger tag = index - 100000;
    
    [[XMNAVAudioPlayer sharePlayer] playAudioWithURLString:[url absoluteString] atIndex:tag];
}
- (void)audioPlayerStateDidChanged:(XMNVoiceMessageState)audioPlayerState forIndex:(NSUInteger)index {
    
    AudioView *audioBtn = (AudioView *)[_centralView viewWithTag:index+100000];
    dispatch_async(dispatch_get_main_queue(), ^{
        [audioBtn setVoiceMessageState:audioPlayerState];
    });
    
}
- (void)audioViewPlayAudio:(AudioView *)view deleteAudioIndex:(NSInteger)index {
    NSInteger tag = index - 100000;
    [self.audioArray removeObjectAtIndex:tag];
    [self.audioUrlArray removeObjectAtIndex:tag];
    [UIView animateWithDuration:0.3 animations:^{
        view.transform = CGAffineTransformMakeScale(1.5, 1.5);
        view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self uploadUI];
        [view removeFromSuperview];
    }];
}
#pragma mark -
#pragma mark 视频代理
- (void)videoView:(VideoView *)view index:(NSInteger)index {
    NSInteger tag = index - 10000;
    
    NSString *videoUrl = self.videoUrlArray[tag];
    
    VideoViewController *vc = [[VideoViewController alloc] initWithVideoUrl:videoUrl];
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)videoView:(VideoView *)view deleteVideoIndex:(NSInteger)index {
    NSInteger tag = index - 10000;
    [self.videoArray removeObjectAtIndex:tag];
    [self.videoUrlArray removeObjectAtIndex:tag];
    [UIView animateWithDuration:0.3 animations:^{
        view.transform = CGAffineTransformMakeScale(1.5, 1.5);
        view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self uploadUI];
        [view removeFromSuperview];
    }];

}
#pragma mark - MP3RecordedDelegate

- (void)endConvertWithMP3FileName:(NSString *)fileName {
    if (fileName) {
        [XMProgressHUD dismissWithProgressState:XMProgressSuccess];
        [self.getAudioView dismiss];
        [self sendAudio:fileName time:[XMProgressHUD seconds]];
    }else{
        [XMProgressHUD dismissWithProgressState:XMProgressError];
    }
}

- (void)failRecord{
    [XMProgressHUD dismissWithProgressState:XMProgressError];
}
- (void)beginConvert{
    NSLog(@"开始转换");
    [XMProgressHUD changeSubTitle:@"正在转换..."];
}

#pragma mark - VideoRecorderViewControllerDelegate
- (void)failVideoRecord {
    
}

- (void)cancelVideoRecord {
    
}

- (void)beginVideoRecord {
    
}

- (void)endVideoRecord:(NSURL *)assetURL {
    [self sendVideo:assetURL];
}


#pragma mark -
#pragma mark 上传语音 视频 图片
- (void)sendAudio:(NSString *)fileName time:(NSTimeInterval)time {
    [self showloadingName:@"正在上传"];
    [[HttpsManager sharedManager] uploadFile:fileName progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
         UploadModel *model = [UploadModel uploadWithData:reponse];
        [self createAudioView:model.url time:[XMProgressHUD seconds]];
        [self hideHud];
        [self hideHud];
        [self showHint:@"上传成功"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (void)sendPic:(NSArray *)images {
    
    NSInteger count = images.count;
    _imageTempCount = 0;
    [self showloadingName:@"正在上传"];
    for (int i = 0; i < count; i++) {
        UIImage *image = images[i];
        dispatch_queue_t q = dispatch_queue_create("uploadingImage", DISPATCH_QUEUE_SERIAL);
        
        dispatch_sync(q, ^{
            [[HttpsManager sharedManager] upload:image progress:^(NSProgress * _Nonnull progress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
                UploadModel *model = [UploadModel uploadWithData:reponse];
                [self createPicView:model.url];
                _imageTempCount ++;
                if (_imageTempCount == count) {
                    [self hideHud];
                    [self showHint:@"上传成功"];
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self hideHud];
            }];
        });
        
    }
}
- (void)sendVideo:(NSURL *)fileName {
    [self showloadingName:@"正在上传"];
    [[HttpsManager sharedManager] uploadVideo:fileName progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
        UploadModel *model = [UploadModel uploadWithData:reponse];
        [self createVideoView:model.url];
        [self hideHud];
        [self showHint:@"上传成功"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
//判断内容是否改变，若改变提示是否更新到草稿箱
- (BOOL)isChange {
    BOOL ret = NO;
    
    _content = self.descriptionView.text;
    _titleName = self.titleField.text;
    _taskName = self.taskLabel.text;
    _position = self.location.text;
    
    if (![[LZXHelper isNullToString:_titleName] isEqualToString:[LZXHelper isNullToString:self.model.title]]) {
        ret = YES;
    }
    if (![[LZXHelper isNullToString:_workid] isEqualToString:[LZXHelper isNullToString:self.model.workId]]) {
        ret = YES;
    }
    if (![[LZXHelper isNullToString:_position] isEqualToString:[LZXHelper isNullToString:self.model.position]]) {
        ret = YES;
    }
    if (![[LZXHelper isNullToString:_content] isEqualToString:[LZXHelper isNullToString:self.model.content]]) {
        ret = YES;
    }
    if (![[LZXHelper isNullToString:[self.picUrlArray componentsJoinedByString:@","]] isEqualToString:[LZXHelper isNullToString:self.model.picture]]) {
        ret = YES;
    }
    if (![[LZXHelper isNullToString:[self.audioUrlArray componentsJoinedByString:@","]] isEqualToString:[LZXHelper isNullToString:self.model.audio]]) {
        ret = YES;
    }
    if (![[LZXHelper isNullToString:[self.videoUrlArray componentsJoinedByString:@","]] isEqualToString:[LZXHelper isNullToString:self.model.video]]) {
        ret = YES;
    }
    return ret;
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
