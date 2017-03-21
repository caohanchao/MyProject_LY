//
//  NewMarkViewController.m
//  ProjectTemplate
//
//  Created by caohanchao on 2017/1/16.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//



#define white_backgroundColor [UIColor whiteColor]
#define font_blackColor [UIColor blackColor]
#define font_grayColor [UIColor grayColor]

#define font() [UIFont systemFontOfSize:14]

#define SpaceHeightOrWidth 12
#define CellHeight 44.5
#define LeftMargin 12
#define UploadViewH 44.5
#define TextFildPLText @"请输入描述内容..."

//图片 语音 视频 适配
#define picleftM  12
#define piccenterM  12
#define picCenterY  20
#define audioLeftM  12
#define audioCenterM  12
#define btnW  (width(self.view.frame)-3*piccenterM-2*picleftM)/4
#define audioBtnW  (width(self.view.frame)-3*audioCenterM-2*audioLeftM)/4
#define audioBtnH  26

#import "NewMarkViewController.h"
#import "ZEBPickerView.h"
#import "ZMLPlaceholderTextView.h"
#import "MessageBoardViewController.h"
#import "PhotosCollectionViewCell.h"
#import "SuspectCollectionViewCell.h"
#import "MarkLocationViewController.h"
#import "UIButton+EnlargeEdge.h"
#import "RFKeyboardToolbar.h"
#import "RFToolbarButton.h"

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
#import "UIButton+EnlargeEdge.h"
#import "TZImagePickerController.h"
#import "TZImageManager.h"

@interface NewMarkViewController ()<UIScrollViewDelegate,UITextFieldDelegate,UITextViewDelegate,ZEBPickViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,AMapSearchDelegate, AudioViewDelegate, VideoViewDelegate, Mp3RecorderDelegate,VideoRecorderViewControllerDelegate, UIScrollViewDelegate, XMNAVAudioPlayerDelegate, PicImageViewDelegate,TZImagePickerControllerDelegate>


//@property (nonatomic, strong)UITableView *tableView;
{
    NSString *_createTime;
    NSString *_longitude;
    NSString *_latitude;
    NSString *_workid;
    AMapSearchAPI *_search;
    CLLocation *_currentLocation;
    
    NSDateFormatter *_formatter;
    NSInteger _imageTempCount;
}


@property (nonatomic,strong)UserInfoModel *userInfoModel;

@property (nonatomic,strong)UIScrollView *bgview;

@property (nonatomic,strong)UIView *fristView;
@property (nonatomic,strong)UIView *secondView;
@property (nonatomic,strong)UIView *threeView;
@property (nonatomic,strong)UIView *fourView;


@property (nonatomic, strong) UIActivityIndicatorView *locationIndicatorView;

@property (nonatomic,strong)UILabel *peasonPost;        //记录人职务
@property (nonatomic,strong)UIImageView *peasonImg;     //记录人头像
@property (nonatomic,strong)UILabel *peasonName;        //记录人
@property (nonatomic,strong)UILabel *timeLabel;         //创建记录时间
@property (nonatomic,strong)UITextField *titleField;    //标题
@property (nonatomic,strong)UILabel *selectTimer;     //记录输入的时间
@property (nonatomic,strong)UILabel *locationLabel;     //地址
@property (nonatomic,strong)UICollectionView *collectionView;    //嫌疑人列表
@property (nonatomic,strong)UICollectionView *photosCollectionView;   //
@property (nonatomic,strong)UIView *photosView;         //图库
@property (nonatomic,strong)UILabel *cameraLabel;       //关联摄像头
@property (nonatomic,strong)ZMLPlaceholderTextView *descriptionView;    //详情
@property (nonatomic,strong)UILabel *recordLabel;     //评论

@property (nonatomic,strong)GetAudioView *getAudioView;
//@property (nonatomic, strong) ZLPhotoActionSheet *actionSheet;
@property (nonatomic, strong) TZImagePickerController *actionSheet;

@property (strong, nonatomic) Mp3Recorder *MP3;

@property (nonatomic,strong) ZEBPickerView *cuiPickerView;

@property (nonatomic,strong)NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *photosArray;

@property (nonatomic, strong) NSMutableArray *suspectArray;

//存放url
@property (nonatomic, strong) NSMutableArray *audioUrlArray;
@property (nonatomic, strong) NSMutableArray *picUrlArray;
@property (nonatomic, strong) NSMutableArray *videoUrlArray;

//存放展示控件
@property (nonatomic, strong) NSMutableArray *audioArray;
@property (nonatomic, strong) NSMutableArray *picArray;
@property (nonatomic, strong) NSMutableArray *videoArray;

@property (nonatomic,strong) RFKeyboardToolbar *keyBoardTool;

@end



@implementation NewMarkViewController

#pragma mark - 懒加载
#pragma mark - 数据源加载
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

- (NSMutableArray *)suspectArray {
    if (!_suspectArray) {
        _suspectArray = [NSMutableArray arrayWithArray:@[@{@"name":@"王二",@"picture":@"123"},@{@"name":@"张三",@"picture":@"123"},@{@"name":@"李四",@"picture":@"123"}]];
    }
    return _suspectArray;
}

- (NSMutableArray *)photosArray {
    if (!_photosArray) {
        _photosArray = [NSMutableArray array];
        
    }
    return _photosArray;
}



- (UserInfoModel *)userInfoModel
{
    if (!_userInfoModel) {
        _userInfoModel = [[[DBManager sharedManager] userDetailSQ] selectUserDetail];
    }
    return _userInfoModel;
}

#pragma mark - 控件加载
//- (ZLPhotoActionSheet *)actionSheet {
//    if (!_actionSheet) {
//        _actionSheet = [[ZLPhotoActionSheet alloc] init];
//        //设置照片最大选择数
//        _actionSheet.maxSelectCount = 10;
//        //设置照片最大预览数
//        _actionSheet.maxPreviewCount = 500;
//    }
//    return _actionSheet;
//}

- (GetAudioView *)getAudioView {
    if (!_getAudioView) {
        WeakSelf
        _getAudioView = [[GetAudioView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 0) startBlock:^(GetAudioView *view) {//开始录音
            if (weakSelf.audioUrlArray.count == 12) {
                [weakSelf showHint:@"语音最多十二条"];
            }else {
            [weakSelf.descriptionView setEditable:NO];
                [XMProgressHUD show];
            }
            [weakSelf.MP3 startRecord];
        } cancelBlock:^(GetAudioView *view) {//取消录音
            if (weakSelf.audioUrlArray.count == 12) {
                [weakSelf showHint:@"语音最多十二条"];
            }else {
            [weakSelf.descriptionView setEditable:YES];
            [XMProgressHUD dismissWithMessage:@"取消录音"];
            [weakSelf.MP3 cancelRecord];
            }
        } confimBlock:^(GetAudioView *view) {//录音结束
            if (weakSelf.audioUrlArray.count == 12) {
                [weakSelf showHint:@"语音最多十二条"];
            }else {
            [weakSelf.descriptionView setEditable:YES];
                [weakSelf.MP3 stopRecord];
            }
        } updateCancelBlock:^(GetAudioView *view) {//更新录音显示状态,手指向上滑动后提示松开取消录音
            if (weakSelf.audioUrlArray.count == 12) {
                [weakSelf showHint:@"语音最多十二条"];
            }else {
                [XMProgressHUD changeSubTitle:@"松开手指取消录音"];
            }
        } updateContinueBlock:^(GetAudioView *view) {//更新录音状态,手指重新滑动到范围内,提示向上取消录音
            if (weakSelf.audioUrlArray.count == 12) {
                [weakSelf showHint:@"语音最多十二条"];
            }else {
                [XMProgressHUD changeSubTitle:@"向上滑动取消录音"];
            }
        }];
    }
    return _getAudioView;
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

- (UICollectionView *)photosCollectionView {
    if (!_photosCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        NSInteger margin = 10;
        layout.itemSize = CGSizeMake((self.photosView.frame.size.width-40)/4 , (self.photosView.frame.size.width-40)/4);
        layout.minimumInteritemSpacing = margin;
        layout.minimumLineSpacing = margin;
        layout.sectionInset = UIEdgeInsetsMake(20, 10, 20, 10);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _photosCollectionView = [[UICollectionView alloc] initWithFrame:_photosView.frame collectionViewLayout:layout];
        _photosCollectionView.delegate = self;
        _photosCollectionView.dataSource = self;
        _photosCollectionView.scrollsToTop = NO;
        _photosCollectionView.showsVerticalScrollIndicator = NO;
        _photosCollectionView.showsHorizontalScrollIndicator = NO;
        _photosCollectionView.backgroundColor = white_backgroundColor;
        [_photosCollectionView registerClass:[PhotosCollectionViewCell class] forCellWithReuseIdentifier:PhotosCollectionViewCellID];
    }
    return _photosCollectionView;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        NSInteger margin = 10;
        layout.itemSize = CGSizeMake(screenWidth()/7 - 20,height(self.secondView.frame)-15);
        layout.minimumInteritemSpacing = margin;
        layout.minimumLineSpacing = 15;
        layout.sectionInset = UIEdgeInsetsMake(10, 20, 5, 20);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollsToTop = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = white_backgroundColor;
        [_collectionView registerClass:[SuspectCollectionViewCell class] forCellWithReuseIdentifier:SuspectCollectionViewCellID];
    }
    return _collectionView;
}

- (UIView *)fristView {
    if (!_fristView) {
        _fristView = [UIView new];
        _fristView.backgroundColor = white_backgroundColor;
    }
    return _fristView;
}

- (UIView *)secondView {
    if (!_secondView) {
        _secondView = [UIView new];
        _secondView.backgroundColor = white_backgroundColor;
    }
    return _secondView;
    
}
- (UIView *)threeView {
    if (!_threeView) {
        _threeView = [UIView new];
        _threeView.backgroundColor = white_backgroundColor;
    }
    return _threeView;
}

- (UIView *)fourView {
    if (!_fourView) {
        _fourView = [UIView new];
        _fourView.backgroundColor = white_backgroundColor;
    }
    return _fourView;
}


- (UILabel *)recordLabel {
    if (!_recordLabel) {
        _recordLabel = [CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:0 font:[UIFont systemFontOfSize:14] textColor:font_blackColor text:@"记录"];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectRecordAction)];
        [_recordLabel addGestureRecognizer:tap];
    }
    return _recordLabel;
}

- (UIView *)photosView {
    if (!_photosView) {
        _photosView = [UIView new];
        _photosView.backgroundColor = white_backgroundColor;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPhotosAction)];
//        [_photosView addGestureRecognizer:tap];
    }
    return _photosView;
}

-(ZMLPlaceholderTextView *)descriptionView
{
    if (!_descriptionView) {
        _descriptionView = [[ZMLPlaceholderTextView alloc]init];
        _descriptionView.tintColor = zBlueColor;
        _descriptionView.font = ZEBFont(14);
        _descriptionView.textColor = zBlackColor;
        _descriptionView.placeholder = TextFildPLText;
        _descriptionView.delegate = self;
        _descriptionView.scrollEnabled = YES;
    }
    return _descriptionView;
}

- (UILabel *)cameraLabel {
    if (!_cameraLabel) {
        _cameraLabel = [CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:0 font:font() textColor:font_blackColor text:@"默认摄像头"];
        _cameraLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectCameraAction)];
        [_cameraLabel addGestureRecognizer:tap];
    }
    return _cameraLabel;
}

- (UIImageView *)peasonImg
{
    if (!_peasonImg) {
        _peasonImg = [[UIImageView alloc]init];
        _peasonImg.layer.cornerRadius = 15;
        _peasonImg.layer.masksToBounds = YES;
        
    }
    return _peasonImg;
}

-(UILabel *)peasonName
{
    if (!_peasonName) {
        _peasonName = [CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:0 font:[UIFont systemFontOfSize:14] textColor:CHCHexColor(@"808080") text:self.userInfoModel.name];
    }
    return _peasonName;
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

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _createTime = [self requestTime];
        _timeLabel = [CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:2 font:[UIFont systemFontOfSize:10] textColor:font_grayColor text:[_createTime timeChage]];
        
    }
    return _timeLabel;
}

- (UITextField *)titleField {
    if (!_titleField) {
        _titleField = [[UITextField alloc] init];
        _titleField.placeholder = @"请输入标题";
        _titleField.delegate = self;
        _titleField.font = font();
        _titleField.backgroundColor = white_backgroundColor;
    }
    return _titleField;
}


- (UILabel *)selectTimer {
    if (!_selectTimer) {
        _selectTimer = [CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:0 font:font() textColor:font_blackColor text:@"请选择时间"];
        _selectTimer.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectTimerAction)];
        [_selectTimer addGestureRecognizer:tap];
        
    }
    return _selectTimer;
}

- (UILabel *)locationLabel {
    if (!_locationLabel) {
        _locationLabel = [CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:0 font:font() textColor:font_blackColor text:@""];
        _locationLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectLocationAction)];
        [_locationLabel addGestureRecognizer:tap];
    }
    return  _locationLabel;
}

- (UIScrollView *)bgview {
    if (!_bgview) {
        _bgview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _bgview.delegate = self;
        _bgview.backgroundColor= [UIColor groupTableViewBackgroundColor];
        
    }
    return  _bgview;
}

- (UIActivityIndicatorView *)locationIndicatorView {
    if (!_locationIndicatorView) {
        _locationIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_locationIndicatorView startAnimating];
    }
    return _locationIndicatorView;
}

-(void)setMarkParam:(NSMutableDictionary *)markParam
{
    _markParam = markParam;
    _longitude = _markParam[@"longitude"];
    _latitude = _markParam[@"latitude"];
    _gid = _markParam[@"gid"];
    _direction = _markParam[@"direction"];
    _workid = _markParam[@"workid"];
    _markType = [_markParam[@"mode"] integerValue];
    _type = _markParam[@"type"];
    
//    _taskName = param[@"workname"];
//    if ([_taskName isEqualToString:@"全部"]) {
//        _taskName = @"";
//    }
    [self initSearch];
    [self reGeoAction];
}

- (void)initSearch
{
    _search = [[AMapSearchAPI alloc]init];
    _search.delegate =self;
    
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

#pragma mark -AMapSearchDelegate
//失败回调
- (void)searchRequest:(id)request didFailWithError:(NSError *)error
{
    self.locationIndicatorView.hidden = YES;
    [self.locationIndicatorView stopAnimating];
    self.locationLabel.text = @"获取位置失败";
    NSLog(@"request :%@, error :%@", request, error);
}


//成功回调
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    NSLog(@"response :%@", response);
    self.locationIndicatorView.hidden = YES;
    [self.locationIndicatorView stopAnimating];
    self.locationLabel.text = response.regeocode.formattedAddress;
    
}

#pragma mark - viewController加载

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[XMNAVAudioPlayer sharePlayer] stopAudioPlayer];
    [XMNAVAudioPlayer sharePlayer].index = NSUIntegerMax;
    [XMNAVAudioPlayer sharePlayer].URLString = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self creatNavBar];
    
    [self initAll];
    // Do any additional setup after loading the view.
}

//请求当前时间
-(NSString *)requestTime{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *time = [formatter stringFromDate:[NSDate date]];
    return time;
}

- (NSDate *)getCurrentDate {
    NSString *dateTime=[_formatter stringFromDate:[NSDate date]];
    NSDate *date = [_formatter dateFromString:dateTime];
    return date;
}

- (void)creatNavBar {
    self.title = @"标记";
    if (self.editMode == isOnlyWriteMode) {
        UIBarButtonItem *rightItems = [[UIBarButtonItem alloc] initWithTitle:@"上传" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction)];
        self.navigationItem.rightBarButtonItems = [self.navigationItem rightItemsWithBarButtonItem:rightItems WithSpace:5];
        [rightItems setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil] forState:UIControlStateNormal];
    }

}

//解决UIScrollView不滚的问题
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat H = 0;
    if ((height(self.fristView.frame)+ height(self.secondView.frame)+height(self.threeView.frame)+height(self.fourView.frame)) > kScreenHeight) {
        H = height(self.fristView.frame)+ height(self.secondView.frame)+ height(self.threeView.frame) + height(self.fourView.frame)+64*2;
    }else {
        H = kScreenHeight+64*2;
    }
    self.bgview.contentSize = CGSizeMake(kScreenWidth,H);
    
}

#pragma  mark - INIT
- (void)initAll {
    [self initFormater];
    [self initBackgroundVC];
    [self initFirstViewOFBackgroundVC];
    [self initSecondViewOFBackgroundVC];
    [self initThridViewOFBackgroundVC];
    [self initFourthViewOFBackgroundVC];
    [self initMedia];
    
    if (self.editMode == isOnlyReadMode) {
        [self updateUIOfAdjust];
    }
//
    
    [self.view addSubview:self.cuiPickerView];
}


- (void)updateUIOfAdjust {
    self.titleField.enabled  = NO;
    self.selectTimer.userInteractionEnabled = NO;
    self.cameraLabel.userInteractionEnabled = NO;
    self.locationLabel.userInteractionEnabled = NO;
    self.descriptionView.editable = NO;
    
    self.titleField.text = self.model.title;
    self.timeLabel.text = self.model.create_time;
    self.peasonName.text = self.model.realname;
    [self.peasonImg imageGetCacheForAlarm:self.model.alarm forUrl:self.model.headpic];
    self.descriptionView.text = self.model.content;
    self.locationLabel.text =self.model.position;
    [self.locationIndicatorView stopAnimating];
    self.locationIndicatorView.hidden = YES;
}


- (void)initFormater {
    _formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
}

- (void)initBackgroundVC {
    
    
    [self.view addSubview:self.bgview];
    
    [self.bgview addSubview:self.fristView];
    [self.bgview addSubview:self.secondView];
    [self.bgview addSubview:self.threeView];
    
    
    
    [self.fristView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgview.mas_left).offset(0);
        make.width.offset(kScreenWidth);
        make.top.equalTo(self.bgview.mas_top).offset(SpaceHeightOrWidth + 64);
        make.height.offset(45*5+80);
    }];
    [self.secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgview.mas_left).offset(0);
        make.width.offset(kScreenWidth);
        make.top.equalTo(self.fristView.mas_bottom).offset(SpaceHeightOrWidth);
        make.height.offset(80);
    }];
    [self.threeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgview.mas_left).offset(0);
        make.width.offset(kScreenWidth);
        make.top.equalTo(self.secondView.mas_bottom).offset(SpaceHeightOrWidth);
        make.height.offset(122);
    }];
    
    if (self.editMode == isOnlyReadMode) {
        [self.bgview addSubview:self.fourView];
        [self.fourView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bgview.mas_left).offset(0);
            make.width.offset(kScreenWidth);
            make.top.equalTo(self.threeView.mas_bottom).offset(SpaceHeightOrWidth);
            make.height.offset(45);
        }];
    }
    
}

- (void)initFirstViewOFBackgroundVC {
    
    NSString *memberId;
    if (self.editMode == isOnlyWriteMode) {
        memberId = self.userInfoModel.alarm;
    } else if (self.editMode == isOnlyReadMode) {
        memberId = self.model.alarm;
    }
    UserAllModel *userModel = [[[DBManager sharedManager] personnelInformationSQ] selectDepartmentmemberlistById:memberId];
    UnitListModel *uModel = [[[DBManager sharedManager] DepartmentlistSQ] selectDepartmentlistById:userModel.RE_department];
//
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
    //标题
    UILabel *title =  [CHCUI createLabelWithbackGroundColor: white_backgroundColor textAlignment:0 font:font() textColor:font_blackColor text:@"标           题"];
    UILabel *peason = [CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:0 font:font() textColor:font_blackColor text:@"记    录    人"];
    UILabel *time =   [CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:0 font:font() textColor:font_blackColor text:@"时           间"];
    UILabel *location = [CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:0 font:font() textColor:font_blackColor text:@"地           址"];
    UILabel *camera =     [CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:0 font:font()  textColor:font_blackColor text:@"关联摄像头"];
    UILabel *photosLabel = [CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:0 font:font() textColor:font_blackColor text:@"照 片  图 库"];
    
    //线
    UILabel *line1 = [CHCUI createLabelWithbackGroundColor:LineColor textAlignment:0 font:font() textColor:font_blackColor text:@""];

    UILabel *line2 = [CHCUI createLabelWithbackGroundColor:LineColor textAlignment:0 font:font() textColor:font_blackColor text:@""];

    UILabel *line3 = [CHCUI createLabelWithbackGroundColor:LineColor textAlignment:0 font:font() textColor:font_blackColor text:@""];

    UILabel *line4 = [CHCUI createLabelWithbackGroundColor:LineColor textAlignment:0 font:font() textColor:font_blackColor text:@""];
    
    UILabel *line5 = [CHCUI createLabelWithbackGroundColor:LineColor textAlignment:0 font:font() textColor:font_blackColor text:@""];
    
    //内容
    [self.peasonImg imageGetCacheForAlarm:self.userInfoModel.alarm forUrl:self.userInfoModel.headpic];
    
//    UILabel *peasonName = [CHCUI createLabelWithbackGroundColor:white_backgroundColor textAlignment:0 font:[UIFont systemFontOfSize:14] textColor:CHCHexColor(@"808080") text:self.userInfoModel.name];
//    peasonName.text = self.userInfoModel.name;
    
    UIImageView *cameraRightImg = [CHCUI createImageWithbackGroundImageV:@"rightarrow"];
    UIImageView *photosRightImg = [CHCUI createImageWithbackGroundImageV:@"rightarrow"];
    
    [self.fristView addSubview:title];
    [self.fristView addSubview:line1];
    
    [self.fristView addSubview:peason];
    [self.fristView addSubview:line2];
    
    [self.fristView addSubview:time];
    [self.fristView addSubview:line3];
    
    [self.fristView addSubview:location];
    [self.fristView addSubview:line4];
    
    [self.fristView addSubview:camera];
    [self.fristView addSubview:line5];
    
    [self.fristView addSubview:photosLabel];
    
    [self.fristView addSubview:self.titleField];
    [self.fristView addSubview:self.timeLabel];
    
    [self.fristView addSubview:self.peasonImg];
    [self.fristView addSubview:self.peasonPost];
    [self.fristView addSubview:self.peasonName];
    
    [self.fristView addSubview:self.selectTimer];
   
    [self.fristView addSubview:self.locationLabel];
    
    [self.fristView addSubview:self.locationIndicatorView];
    
    [self.fristView addSubview:cameraRightImg];
    [self.fristView addSubview:self.cameraLabel];
    
    [self.fristView addSubview:photosRightImg];
    [self.fristView addSubview:self.photosView];
    
    
    
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fristView.mas_top).with.offset(0);
        make.height.offset(CellHeight);
        make.left.equalTo(self.fristView.mas_left).with.offset(LeftMargin);
        make.width.offset(86);
    }];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title.mas_bottom).offset(0);
        make.height.equalTo(@0.5);
        make.left.equalTo(self.fristView.mas_left).offset(0);
        make.right.equalTo(self.fristView.mas_right).offset(0);
    }];
    [peason mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fristView.mas_top).with.offset(CellHeight+0.5);
        make.height.offset(CellHeight);
        make.left.equalTo(self.fristView.mas_left).with.offset(LeftMargin);
        make.width.offset(86);
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(peason.mas_bottom).offset(0);
        make.height.equalTo(@0.5);
        make.left.equalTo(self.fristView.mas_left).offset(0);
        make.right.equalTo(self.fristView.mas_right).offset(0);
    }];
    [time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fristView.mas_top).with.offset((CellHeight+0.5)*2);
        make.height.offset(CellHeight);
        make.left.equalTo(self.fristView.mas_left).with.offset(LeftMargin);
        make.width.offset(86);
    }];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(time.mas_bottom).offset(0);
        make.height.equalTo(@0.5);
        make.left.equalTo(self.fristView.mas_left).offset(0);
        make.right.equalTo(self.fristView.mas_right).offset(0);
    }];
    [location mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fristView.mas_top).with.offset((CellHeight+0.5)*3);
        make.height.offset(CellHeight);
        make.left.equalTo(self.fristView.mas_left).with.offset(LeftMargin);
        make.width.offset(86);
    }];
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(location.mas_bottom).offset(0);
        make.height.equalTo(@0.5);
        make.left.equalTo(self.fristView.mas_left).offset(0);
        make.right.equalTo(self.fristView.mas_right).offset(0);
    }];
    
    [camera mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fristView.mas_top).with.offset((CellHeight+0.5)*4);
        make.height.offset(CellHeight);
        make.left.equalTo(self.fristView.mas_left).with.offset(LeftMargin);
        make.width.offset(86);
    }];
    [line5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(camera.mas_bottom).offset(0);
        make.height.equalTo(@0.5);
        make.left.equalTo(self.fristView.mas_left).offset(0);
        make.right.equalTo(self.fristView.mas_right).offset(0);
    }];
    [photosLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fristView.mas_top).with.offset((CellHeight+0.5)*5);
        make.bottom.equalTo(self.fristView.mas_bottom).with.offset(0);
        make.left.equalTo(self.fristView.mas_left).with.offset(LeftMargin);
        make.width.offset(86);
    }];
    
    [self.titleField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(title.mas_right).offset(0);
        make.right.equalTo(self.fristView.mas_right).offset(-80);
        make.centerY.equalTo(title.mas_centerY).offset(0);
        make.height.mas_equalTo(title);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleField.mas_right).offset(0);
        make.right.equalTo(self.fristView.mas_right).offset(-12);
        make.centerY.equalTo(self.titleField.mas_centerY).offset(0);
        make.height.equalTo(title.mas_height);
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
        make.top.equalTo(peason.mas_top).with.offset(0);
        make.left.equalTo(self.peasonPost.mas_right).with.offset(8);
        make.width.mas_greaterThanOrEqualTo(100);
        make.height.offset(CellHeight-0.5);
    }];
    
    [self.selectTimer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(time);
        make.left.mas_equalTo(time.mas_right);
        make.height.mas_equalTo(time);
        make.right.mas_equalTo(self.fristView.mas_right);
    }];
    
    [self.locationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(location);
        make.left.mas_equalTo(location.mas_right);
        make.height.mas_equalTo(location);
        make.right.mas_equalTo(self.fristView.mas_right);
    }];
    
    [self.locationIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(location.mas_right);
        make.centerY.equalTo(location.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [cameraRightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.fristView.mas_right).with.offset(0);
        make.centerY.equalTo(camera.mas_centerY).with.offset(0);
        make.height.offset(30);
        make.width.offset(30);
    }];
    
    [self.cameraLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(camera);
        make.left.mas_equalTo(camera.mas_right);
        make.height.mas_equalTo(camera);
        make.right.mas_equalTo(cameraRightImg.mas_left);
    }];
    
    [photosRightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.fristView.mas_right).with.offset(0);
        make.centerY.equalTo(photosLabel.mas_centerY).with.offset(0);
        make.height.offset(30);
        make.width.offset(30);
    }];
    
    [self.photosView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(photosLabel);
        make.left.mas_equalTo(photosLabel.mas_right);
        make.height.mas_equalTo(photosLabel);
        make.right.mas_equalTo(photosRightImg.mas_left);
    }];
    
    [self.photosView addSubview:self.photosCollectionView];
    [self.photosCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.photosView);
    }];
    
}

- (void)initSecondViewOFBackgroundVC {
    [self.secondView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.secondView);
    }];
}

- (void)initThridViewOFBackgroundVC {
    [self.threeView addSubview:self.descriptionView];
    
//    [self.descriptionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.threeView).insets(UIEdgeInsetsMake(5, 5, -5, -5));
//    }];
    [self.descriptionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.threeView.mas_left).with.offset(LeftMargin);
        make.right.equalTo(self.threeView.mas_right).with.offset(-LeftMargin);
        make.top.equalTo(self.threeView.mas_top).with.offset(0);
        make.height.offset(122);
    }];
    
    //语音 图片 视频
    NSMutableArray *btnArray = [NSMutableArray array];
    for (int i = 0; i<3; i++) {
        UIButton *btn = [UIButton new];
        btn.tag = 50000+i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btnArray addObject:btn];
    }
    self.keyBoardTool = [RFKeyboardToolbar sharedManager];
    [self.keyBoardTool addToTextView:self.descriptionView withButtons:btnArray];
}

- (void)initFourthViewOFBackgroundVC {
    if (self.editMode == isOnlyWriteMode) {
        return;
    }
    
    UIImageView *recordImg = [CHCUI createImageWithbackGroundImageV:@""];
    recordImg.backgroundColor = [UIColor grayColor];
    UIImageView *right = [CHCUI createImageWithbackGroundImageV:@"rightarrow"];
    [self.fourView addSubview:recordImg];
    [self.fourView addSubview:right];
    [self.fourView addSubview:self.recordLabel];
    
    [recordImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.fourView);
        make.height.and.width.offset(30);
        make.left.equalTo(self.fourView.mas_left).with.offset(LeftMargin);
    }];
    [right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.fourView.mas_right).with.offset(0);
        make.centerY.equalTo(recordImg.mas_centerY).with.offset(0);
        make.height.offset(30);
        make.width.offset(30);
    }];
    [self.recordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(recordImg);
        make.left.mas_equalTo(recordImg.mas_right).offset(10);
        make.height.mas_equalTo(recordImg);
        make.right.mas_equalTo(right.mas_left);
    }];
 
}

- (void)initMedia {
    [XMNAVAudioPlayer sharePlayer].delegate = self;
    self.MP3 = [[Mp3Recorder alloc] initWithDelegate:self];
}

- (void)btnClick:(UIButton *)btn {
    if (btn.tag == 50000) {
        [self sendVoiceAction];
    } else if (btn.tag == 50000 + 1) {
        [self sendPhotosAction];
    } else if (btn.tag == 50000 + 2) {
        [self sendVideoAction];
    }
}




#pragma  mark - ACTION

- (void)sendVoiceAction {
    [self.view endEditing:YES];
    [self.getAudioView showIn:self.view];
}

- (void)sendPhotosAction {
    [self.view endEditing:YES];
    WeakSelf;
    _actionSheet = [[TZImagePickerController alloc] initWithMaxImagesCount:12 delegate:self];;
    _actionSheet.allowPickingOriginalPhoto = NO;
    _actionSheet.allowPickingVideo = NO;
    _actionSheet.allowTakePicture = NO;
    if (self.picUrlArray.count == 12) {
        [self showHint:@"图片最多十二个"];
    }else {
       _actionSheet.maxImagesCount = 12 - self.picUrlArray.count;
    [_actionSheet setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
        [weakSelf sendPic:photos];
    }];
    [self presentViewController:_actionSheet animated:YES completion:^{
        
    }];
    }
}

- (void)sendVideoAction {
    [self.view endEditing:YES];
    if (self.videoUrlArray.count == 12) {
        [self showHint:@"视频最多十二个"];
    }else {
    VideoRecorderViewController *vrVC = [[VideoRecorderViewController alloc] init];
    vrVC.delegate = self;
    [self presentViewController:vrVC animated:YES completion:nil];
    }
}

- (void)rightBtnAction {
    
    [self httpRequest];
}


- (void)selectTimerAction {
    [self.titleField resignFirstResponder];
    if (![[LZXHelper isNullToString:self.selectTimer.text]isEqualToString:@""] && ![self.selectTimer.text isEqualToString:@"请选择时间"]) {
        self.cuiPickerView.curDate = [_formatter dateFromString:self.selectTimer.text];
    } else {
        self.cuiPickerView.curDate = [self getCurrentDate];
    }
    self.cuiPickerView.myResponder = self.selectTimer;
    
    [_cuiPickerView showInView:self.view];
}

- (void)selectCameraAction {
    
}

- (void)selectLocationAction {
    __weak NewMarkViewController *weakself = self;
    MarkLocationViewController *locationC = [[MarkLocationViewController alloc] init];
    locationC.locationBlock = ^(NSMutableDictionary *param){
        self.locationIndicatorView.hidden = YES;
        [self.locationIndicatorView stopAnimating];
        weakself.locationLabel.text = param[@"position"];
        _longitude = param[@"longitude"];
        _latitude = param[@"latitude"];
    };
    [self.navigationController pushViewController:locationC animated:YES];
}

//- (void)selectPhotosAction {
//    
//}
//添加嫌疑人
- (void)selectAddSuspectAction {
    
}


- (void)selectRecordAction {
    MessageBoardViewController *messageBoardViewController = [[MessageBoardViewController alloc] init];

    messageBoardViewController.mark_id = self.model.interid;

    messageBoardViewController.type = @"1";

    [self.navigationController pushViewController:messageBoardViewController animated:YES];
}
- (void)selectOfPhotosItemAction:(NSIndexPath *)indexPath {
    
}

- (void)selectOfSuspectItemAction:(NSIndexPath *)indexPath {
    

}


#pragma mark - 网络请求部分
-(void)httpRequest{
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    
    
    NSMutableDictionary *param =[[NSMutableDictionary alloc] init];
    param[@"content"] = self.descriptionView.text;//内容
    param[@"alarm"] = alarm;   //警号
    param[@"title"] = self.titleField.text;   //标题
    param[@"create_time"] = _createTime;//创建时间
    param[@"mode"]=[NSString stringWithFormat:@"%ld",self.markType];       //0.走访标记 1.快速记录2.摄像头标记 3.案发地  4.中间点
    param[@"type"] =self.type;
    param[@"longitude"]=_longitude;//经度
    param[@"latitude"] =_latitude;//维度
    param[@"position"] = self.locationLabel.text; //位置
    param[@"gid"] =self.gid;
    param[@"direction"] = _direction;   //方向
    param[@"workid"] =_workid;
    param[@"picture"] =[self.picUrlArray componentsJoinedByString:@","];     //图片
    param[@"audio"] =[self.audioUrlArray componentsJoinedByString:@","];       //音频
    param[@"video"] =[self.videoUrlArray componentsJoinedByString:@","];       //视频
    
    param[@"camera_id"] = @"";
    param[@"input_time"] = self.selectTimer.text;
    param[@"suspects_ids"] = @"";
    param[@"big_type"] = @"";
    param[@"camera_time"] = @"";
    param[@"time_error"] = @"";
    
    
    
    ZEBLog(@"%@",param);
    
    [self showloadingName:@"正在提交"];
    [[HttpsManager sharedManager] post:Saverecord_URL parameters:param progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
        
        NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:reponse options:NSJSONReadingMutableContainers error:nil];
        ZEBLog(@"%@",dict);
        
        if ([dict[@"resultcode"] isEqualToString:@"0"]) {
            [self hideHud];
            [self showHint:@"标记成功"];
        }
        
        
        //        NSMutableDictionary *parm = [NSMutableDictionary dictionary];
        //        //将任务添加到地图
        //        parm[@"workAllModelMark"] = self.wModel;
        //
        //        [LYRouter openURL:@"ly://mapaddmark" withUserInfo:parm completion:nil];
    
        
//        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        
    }];
    
}

#pragma mark - ZEBPickViewDelegate
- (void)didFinishPickView:(NSString *)date {
    if (self.cuiPickerView.myResponder == self.selectTimer) {
        self.selectTimer.text = [NSString stringWithFormat:@"%@",date];
//        _searchStartTime = date;
    }
    
}

#pragma mark -
#pragma mark ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    [self.getAudioView dismiss];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    //替换数据源
    if (collectionView == self.photosCollectionView) {
        return 5;
    }
    else if (collectionView == self.collectionView) {
        return self.suspectArray.count+1;
    }
    return 0;
}


- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == self.photosCollectionView) {
        PhotosCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:PhotosCollectionViewCellID forIndexPath:indexPath];
        [cell configureCellWithData:@"123" withCallBack:^(UIImageView *imageView) {
            
        }];
        return cell;
    } else if (collectionView == self.collectionView) {
        SuspectCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SuspectCollectionViewCellID forIndexPath:indexPath];

        if (indexPath.row == self.suspectArray.count) {
            [cell configWithData:@{@"name":@"关联嫌疑对象",@"picture":@"mark_suspectw"} callBackWithSuspect:^(UIImageView *imageView) {
                
            }];
        } else {
            [cell configWithData:self.suspectArray[indexPath.row] callBackWithSuspect:^(UIImageView *imageView) {
                
            }];
        }
        return cell;
        
    }
    return nil;
}

//- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
//    if ([cell isKindOfClass: [SuspectCollectionViewCell class]]) {
//        
//    } else if([cell isKindOfClass: [PhotosCollectionViewCell class]]){
//    
//    }
//}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.photosCollectionView) {
        return CGSizeMake((width(self.photosView.frame)-40)/4 ,(width(self.photosView.frame)-40)/4);
    }else {
        return CGSizeMake(screenWidth()/7 - 15,height(self.secondView.frame)-15);
    }
    
    return CGSizeZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.photosCollectionView) {
        [self selectOfPhotosItemAction:indexPath];
    } else {
        if (indexPath.row == self.suspectArray.count) {
            [self selectAddSuspectAction];
        } else {
            [self selectOfSuspectItemAction:indexPath];
        }
        
    }
}


#pragma mark - MemoryWaring
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark -
#pragma mark 当有图片 视频 语音 刷新ui
- (void)uploadUI {
    
    
    NSInteger audioCount = self.audioArray.count;
    NSInteger picCount = self.picArray.count;
    NSInteger videoCount = self.videoArray.count;
    
    
    CGFloat contentHeight = height(self.descriptionView.frame);
    
    CGFloat topHeight = contentHeight;
    
    
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
    
    
    [self.threeView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(120 + topHeight - height(self.descriptionView.frame));
    }];
    
//    [self.fourView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.bgview.mas_left).offset(0);
//        make.width.offset(kScreenWidth);
//        make.top.equalTo(self.threeView.mas_bottom).offset(SpaceHeightOrWidth);
//        make.height.offset(45);
//    }];

    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)layoutSubviews {
    CGFloat h = height(self.fristView.frame)+ height(self.secondView.frame)+ height(self.threeView.frame) + height(self.fourView.frame)+16+64;
    self.bgview.contentSize = CGSizeMake(kScreenWidth,h);
}

#pragma mark -
#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    
    
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
    [self.threeView addSubview:audioBtn];
    [self uploadUI];
}
- (void)createAudioView:(NSString *)audioUrl{
    
    NSInteger count = self.audioArray.count;
    AudioView *audioBtn = [[AudioView alloc] initWithFrame:CGRectMake(0, 0, audioBtnW, audioBtnH)];
    audioBtn.audioStr = audioUrl;
    audioBtn.delegate = self;
    [self.audioArray addObject:audioBtn];
    [self.audioUrlArray addObject:audioUrl];
    [self.threeView addSubview:audioBtn];
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
    [self.threeView addSubview:picBtn];
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
    [self.threeView addSubview:videoBtn];
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
    
    AudioView *audioBtn = (AudioView *)[self.threeView viewWithTag:index+100000];
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
- (void)videoView:(VideoView *)view index:(NSInteger)index videlUrl:(NSString *)videoUrl{
    NSInteger tag = index - 10000;
    
    NSString *videourl = self.videoUrlArray[tag];
    
    VideoViewController *vc = [[VideoViewController alloc] initWithVideoUrl:videourl];
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



//#pragma mark - UICollectionViewDelegateFlowLayout
//
//- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (collectionView == self.photosCollectionView) {
//        [(PhotosCollectionViewCell *)cell configureCellWithData:@"whiteplaceholder"];
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
