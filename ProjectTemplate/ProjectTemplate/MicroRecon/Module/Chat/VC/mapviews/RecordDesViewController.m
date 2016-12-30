//
//  RecordDesViewController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/24.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "RecordDesViewController.h"
#import "WorkAllTempModel.h"
#import "AudioView.h"
#import "VideoView.h"
#import "UIImageView+CornerRadius.h"
#import "IDMPhotoBrowser.h"
#import "VideoViewController.h"
#import "PicImageView.h"
#import "WorkListsViewController.h"


#define LeftMargin 14

@interface RecordDesViewController ()<UIScrollViewDelegate,VideoViewDelegate,AudioViewDelegate,XMNAVAudioPlayerDelegate, PicImageViewDelegate,AMapSearchDelegate> {
    UIView *_topBgView;
    UIView *_bottomView;
    CLLocation *_currentLocation;
    AMapSearchAPI *_search;
}

@property (nonatomic, copy) NSString *workName;
@property (nonatomic, copy) NSString *workId;

@property (nonatomic, strong) UIScrollView *scroller;
@property (nonatomic, strong) UILabel *titleLabel;
//@property (nonatomic, strong) UITextField *titleFiled;
@property (nonatomic, strong) UILabel *titleFiled;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *taskLabel;
@property (nonatomic, strong) UILabel *taskDesLabel;
@property (nonatomic, strong) UILabel *recordByPersonLabel;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *postLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *posiLabel;
@property (nonatomic, strong) UITextView *contentView;

@property (nonatomic, strong) NSMutableArray *videoArray;
@property (nonatomic, strong) NSMutableArray *pictureArray;
@property (nonatomic, strong) NSMutableArray *audioArray;


//存放展示控件
@property (nonatomic, strong) NSMutableArray *audioBtnArray;
@property (nonatomic, strong) NSMutableArray *picBtnArray;
@property (nonatomic, strong) NSMutableArray *videoBtnArray;

@end

@implementation RecordDesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"记录详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [XMNAVAudioPlayer sharePlayer].delegate = self;
//    if (self.mineCome == DraftsController) {
//       self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"上传" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction)];
//    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[XMNAVAudioPlayer sharePlayer] stopAudioPlayer];
    [XMNAVAudioPlayer sharePlayer].index = NSUIntegerMax;
    [XMNAVAudioPlayer sharePlayer].URLString = nil;
}
- (NSMutableArray *)audioBtnArray {
    if (_audioBtnArray == nil) {
        _audioBtnArray = [NSMutableArray array];
    }
    return _audioBtnArray;
}
- (NSMutableArray *)picBtnArray {
    if (_picBtnArray == nil) {
        _picBtnArray = [NSMutableArray array];
    }
    return _picBtnArray;
}
- (NSMutableArray *)videoBtnArray {
    if (_videoBtnArray == nil) {
        _videoBtnArray = [NSMutableArray array];
    }
    return _videoBtnArray;
}
- (NSMutableArray *)videoArray {
    
    if (_videoArray == nil) {
        _videoArray = [NSMutableArray array];
    }
    return _videoArray;
}
- (NSMutableArray *)pictureArray {
    if (_pictureArray == nil) {
        _pictureArray = [NSMutableArray array];
    }
    return _pictureArray;
}
- (NSMutableArray *)audioArray {
    if (_audioArray == nil) {
        _audioArray= [NSMutableArray array];
    }
    return _audioArray;
}

- (void)initall {
    
    [self reGeoAction];
    [self createUITopView];
    [self createBottomView];
}
- (UIScrollView *)scroller {
    if (!_scroller) {
        _scroller = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scroller.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _scroller;
}
- (void)setModel:(WorkAllTempModel *)model {
    _model = model;
    
    
    [self initall];
}
//解决UIScrollView不滚的问题
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGFloat H = 0;
    if ((height(_topBgView.frame)+ height(_bottomView.frame)+32) > kScreenHeight) {
        H = height(_topBgView.frame)+ height(_bottomView.frame)+48;
    }else {
        H = kScreenHeight + 10;
    }
    _scroller.contentSize = CGSizeMake(kScreenWidth,H);
}

-(void)reGeoAction
{
    
    if([[LZXHelper isNullToString:self.model.position] isEqualToString:@""] && ![[LZXHelper isNullToString:_model.latitude] isEqualToString:@""] && ![[LZXHelper isNullToString:_model.longitude] isEqualToString:@""])
    {
        _search = [[AMapSearchAPI alloc]init];
        _search.delegate =self;
        
        _currentLocation = [[CLLocation alloc] initWithLatitude:[_model.latitude  doubleValue] longitude:[_model.longitude doubleValue]];
        
        if(_currentLocation)
        {
            AMapReGeocodeSearchRequest *request = [[AMapReGeocodeSearchRequest alloc] init];
            request.location = [AMapGeoPoint locationWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
            [_search AMapReGoecodeSearch:request];
            
        }
    }
    
}



- (void)createUITopView {

    [self.view addSubview:self.scroller];
    
    _topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 16, kScreenWidth, 178+2.5)];
    _topBgView.backgroundColor = [UIColor whiteColor];
    [self.scroller addSubview:_topBgView];
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = LineColor;
    
    self.titleLabel = [self getLabelFont:ZEBFont(13) textColor:[UIColor blackColor]];
    self.titleLabel.text = @"标题";
    
    self.titleFiled = [self getLabelFont:ZEBFont(13) textColor:[UIColor grayColor]];
    self.titleFiled.text = self.model.title;
    self.timeLabel = [self getLabelFont:ZEBFont(10) textColor:[UIColor lightGrayColor]];
    self.timeLabel.text = [self.model.create_time timeChage];
    
    UILabel *line1 = [[UILabel alloc] init];
    line1.backgroundColor = LineColor;
    
    self.taskLabel = [self getLabelFont:ZEBFont(13) textColor:[UIColor blackColor]];
    self.taskLabel.text = @"所属任务";
    
    SuspectlistModel *sModel = [[[DBManager sharedManager] suspectAlllistSQ] selectSuspectByWorkId:self.model.workId];
    self.taskDesLabel = [self getLabelFont:ZEBFont(13) textColor:[UIColor grayColor]];
    self.taskDesLabel.text = sModel.suspectname;
    
    UILabel *line2 = [[UILabel alloc] init];
    line2.backgroundColor = LineColor;
    
    self.recordByPersonLabel = [self getLabelFont:ZEBFont(13) textColor:[UIColor blackColor]];
    self.recordByPersonLabel.text = @"记录人";
    
   UserAllModel *uModel = [[[DBManager sharedManager] personnelInformationSQ] selectDepartmentmemberlistById:self.model.alarm];
    
    self.headerImageView = [[UIImageView alloc] initWithCornerRadiusAdvance:25/2 rectCornerType:UIRectCornerAllCorners];
    self.headerImageView.clipsToBounds = YES;
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.headerImageView imageGetCacheForAlarm:self.model.alarm forUrl:uModel.RE_headpic];
    self.postLabel = [self getLabelFont:ZEBFont(10) textColor:[UIColor whiteColor]];
    self.postLabel.layer.cornerRadius = 3;
    self.postLabel.layer.masksToBounds = YES;
    self.nameLabel = [self getLabelFont:ZEBFont(13) textColor:[UIColor grayColor]];
    self.nameLabel.text = uModel.RE_name;
    
    UnitListModel *lModel = [[[DBManager sharedManager] DepartmentlistSQ] selectDepartmentlistById:uModel.RE_department];
    
    if ([[LZXHelper isNullToString:lModel.DE_type] isEqualToString:@""]) {
        self.postLabel.backgroundColor = [UIColor colorWithHexString:@"#96b0fb"];
        self.postLabel.text = [NSString stringWithFormat:@" %@ ",uModel.RE_post];
    }else {
        if ([lModel.DE_type isEqualToString:@"0"]) {//0警察公务组织紫，1技术支持绿
            self.postLabel.backgroundColor = [UIColor colorWithHexString:@"#96b0fb"];
            self.postLabel.text = [NSString stringWithFormat:@" %@ ",uModel.RE_post];
        }else if ([lModel.DE_type isEqualToString:@"1"]) {
            self.postLabel.backgroundColor = [UIColor colorWithHexString:@"#6cd9a3"];
            self.postLabel.text = [NSString stringWithFormat:@" %@ ",uModel.RE_post];
        }
        
    }

    
    UILabel *line3 = [[UILabel alloc] init];
    line3.backgroundColor = LineColor;
    
    UIImageView *poImage = [[UIImageView alloc] init];
    poImage.image = [UIImage imageNamed:@"PIN"];
    self.posiLabel = [self getLabelFont:ZEBFont(13) textColor:[UIColor blackColor]];
    self.posiLabel.text = self.model.position;
    
    UILabel *line4 = [[UILabel alloc] init];
    line4.backgroundColor = LineColor;
    
    [_topBgView addSubview:line];
    [_topBgView addSubview:self.titleLabel];
    [_topBgView addSubview:self.titleFiled];
    [_topBgView addSubview:self.timeLabel];
    [_topBgView addSubview:line1];
    [_topBgView addSubview:self.taskLabel];
    [_topBgView addSubview:self.taskDesLabel];
    [_topBgView addSubview:line2];
    [_topBgView addSubview:self.recordByPersonLabel];
    [_topBgView addSubview:self.headerImageView];
    [_topBgView addSubview:self.postLabel];
    [_topBgView addSubview:self.nameLabel];
    [_topBgView addSubview:line3];
    [_topBgView addSubview:poImage];
    [_topBgView addSubview:self.posiLabel];
    [_topBgView addSubview:line4];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topBgView.mas_top);
        make.left.equalTo(_topBgView.mas_left);
        make.right.equalTo(_topBgView.mas_right);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topBgView.mas_left).offset(LeftMargin);
        make.top.equalTo(line.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(80, 44.5));
    }];
    [self.titleFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.left.equalTo(self.titleLabel.mas_right).offset(20);
        make.right.equalTo(_topBgView.mas_right).offset(-120);
        make.height.equalTo(@44.5);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.right.equalTo(_topBgView.mas_right).offset(-10);
        make.height.equalTo(@40);
        make.width.mas_lessThanOrEqualTo(60);
    }];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.equalTo(_topBgView.mas_left).offset(100);
        make.right.equalTo(_topBgView.mas_right);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5));
    }];
    [self.taskLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topBgView.mas_left).offset(LeftMargin);
        make.top.equalTo(line1.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(100, 44.5));
    }];
    [self.taskDesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom);
        make.left.equalTo(self.titleFiled.mas_left);
        make.right.equalTo(_topBgView.mas_right).offset(-44);
        make.height.equalTo(@44.5);
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.taskLabel.mas_bottom);
        make.left.equalTo(_topBgView.mas_left).offset(100);
        make.right.equalTo(_topBgView.mas_right);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5));
    }];
    [self.recordByPersonLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topBgView.mas_left).offset(LeftMargin);
        make.top.equalTo(line2.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(100, 44.5));
    }];
    [self.headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.recordByPersonLabel.mas_centerY);
        make.left.equalTo(self.titleFiled.mas_left);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    [self.postLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.recordByPersonLabel.mas_centerY);
        make.left.equalTo(self.headerImageView.mas_right).offset(5);
        make.height.equalTo(@15);
        make.width.mas_lessThanOrEqualTo(60);

    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.recordByPersonLabel.mas_centerY);
        make.left.equalTo(self.postLabel.mas_right).offset(5);
        make.height.equalTo(@30);
        make.width.mas_lessThanOrEqualTo(100);
    }];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.recordByPersonLabel.mas_bottom);
        make.left.equalTo(_topBgView.mas_left).offset(100);
        make.right.equalTo(_topBgView.mas_right);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5));
    }];
    [poImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topBgView.mas_left).offset(LeftMargin);
        make.top.equalTo(line3.mas_bottom).offset((44.5-17.5)/2);
        make.size.mas_equalTo(CGSizeMake(13, 17.5));
    }];
    [self.posiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(poImage.mas_right).offset(15);
        make.top.equalTo(line3.mas_bottom);
        make.height.equalTo(@44.5);
        make.right.equalTo(_topBgView.mas_right).offset(-10);
    }];
    [line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.posiLabel.mas_bottom);
        make.left.equalTo(_topBgView.mas_left);
        make.right.equalTo(_topBgView.mas_right);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, 0.5));
    }];
    
//    if (self.mineCome == DraftsController) {
//        self.taskDesLabel.userInteractionEnabled = YES;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseTask)];
//        [self.taskDesLabel addGestureRecognizer:tap];
//        UIImageView *taskImg = [CHCUI createImageWithbackGroundImageV:@"rightarrow"];
//        [_topBgView addSubview:taskImg];
//        
//        [taskImg mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.taskLabel.mas_centerY);
//            make.right.equalTo(_topBgView.mas_right).offset(-14);
//            make.size.mas_equalTo(CGSizeMake(30, 30));
//        }];
//    }
    
    
}
- (void)createBottomView {
    
    
    CGFloat contentHeight = [LZXHelper textHeightFromTextString:self.model.content width:kScreenWidth-28 fontSize:13];
    CGFloat topHeight = contentHeight + 16*2 + 0.5;
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, maxY(_topBgView)+16, kScreenWidth, 0)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.scroller addSubview:_bottomView];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    line.backgroundColor = LineColor;
    
    self.contentView = [[UITextView alloc] initWithFrame:CGRectMake(14, maxY(line)+16, kScreenWidth-28, topHeight)];
    self.contentView.text = self.model.content;//@"泛海工地盗窃案，附近有没有增援的小伙伴呀，我们需要增援";
    self.contentView.font = ZEBFont(13);
    self.contentView.textColor = [UIColor blackColor];
    self.contentView.scrollEnabled = NO;
    self.contentView.editable = NO;
    [_bottomView addSubview:line];
    [_bottomView addSubview:self.contentView];
    
    
    [self addImageView];
    
}
- (void)addImageView {
    
    ZEBLog(@"string------%@--------%@----------%@",self.model.picture,self.model.video,self.model.audio);
    if (![self.model.picture isEqualToString:@" "] && ![self.model.picture isEqualToString:@""]) {
        NSArray *pictures = [self.model.picture componentsSeparatedByString:@","];
        [self.pictureArray addObjectsFromArray:pictures];
    }
    if (![self.model.video isEqualToString:@" "] && ![self.model.video isEqualToString:@""]) {
        NSArray *videos = [self.model.video componentsSeparatedByString:@","];
        [self.videoArray addObjectsFromArray:videos];
    }
    if (![self.model.audio isEqualToString:@" "] && ![self.model.audio isEqualToString:@""]) {
        NSArray *audios = [self.model.audio componentsSeparatedByString:@","];
        [self.audioArray addObjectsFromArray:audios];
    }
    
    ZEBLog(@"------%@--------%@----------%@",self.pictureArray,self.videoArray,self.audioArray);
    
    NSInteger picCount = self.pictureArray.count;
    NSInteger videoCount = self.videoArray.count;
    NSInteger audioCount = self.audioArray.count;
    
    CGFloat picleftM = 12;
    CGFloat piccenterM = 12;
    
    CGFloat centerY = 20;

    CGFloat audioLeftM = 12;
    CGFloat audioCenterM = 12;
    
    CGFloat contentHeight = 60;
    if (![self.model.content isEqualToString:@""]) {
        contentHeight = [LZXHelper textHeightFromTextString:self.model.content width:kScreenWidth-28 fontSize:13];
    }
    
    CGFloat topHeight = contentHeight + 16*2 + 0.5 + 30;
    
    CGFloat btnW = (width(self.view.frame)-3*piccenterM-2*picleftM)/4;
    CGFloat audioBtnW = (width(self.view.frame)-3*audioCenterM-2*audioLeftM)/4;
    CGFloat audioBtnH = 26;
    
    for (int i = 0; i < audioCount; i++) {
        NSString *audio = self.audioArray[i];
        AudioView *audioBtn = [[AudioView alloc] initWithFrame:CGRectMake(audioLeftM+(audioBtnW+audioCenterM)*(i%4), topHeight+(audioBtnH+centerY)*(i/4), audioBtnW, audioBtnH)];
        audioBtn.audioStr = self.audioArray[i];
        audioBtn.index = 100000 + i;
        audioBtn.tag = 100000 + i;
        audioBtn.delegate = self;
        audioBtn.delhidden = YES;
        [_bottomView addSubview:audioBtn];
        [self.audioBtnArray addObject:audioBtn];
    }
    if (audioCount != 0 ) {
        if (audioCount%4 == 0) {
            topHeight = topHeight + (audioBtnH + centerY)*(audioCount/4);
        }else {
            topHeight = topHeight + (audioBtnH + centerY)*(audioCount/4 + 1);
        }
        
    }
    for (int i = 0; i < picCount; i++) {
        NSString *pic = self.pictureArray[i];
        if ([pic hasPrefix:@"http"]) {
    
            CGRect rect = CGRectMake(picleftM+(btnW+piccenterM)*(i%4), topHeight+(btnW + centerY)*(i/4), btnW, btnW);
            PicImageView *picBtn = [[PicImageView alloc] initWithFrame:rect pic:pic];
//            [picBtn.bgView sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[LZXHelper buttonImageFromColor:[UIColor groupTableViewBackgroundColor]]];
//            picBtn.clipsToBounds = YES;
//            picBtn.contentMode = UIViewContentModeScaleAspectFill;
            picBtn.tag = 1000+i;
            picBtn.userInteractionEnabled =YES;
            picBtn.delegate = self;
            picBtn.index = 1000+i;
            picBtn.delhidden = YES;
            [_bottomView addSubview:picBtn];
            [self.picBtnArray addObject:picBtn];
        }
    }
    if (picCount != 0) {
        if (picCount%4 == 0) {
            topHeight = topHeight + (btnW + centerY)*(picCount/4);
        }else {
            topHeight = topHeight + (btnW + centerY)*(picCount/4 + 1);
        }
        
    }
    for (int i = 0; i < videoCount; i++) {
        NSString *video = self.videoArray[i];
        if ([video hasPrefix:@"http"]) {
            VideoView *videoBtn = [[VideoView alloc] initWithFrame:CGRectMake(picleftM+(btnW+piccenterM)*(i%4), topHeight+(btnW + centerY)*(i/4), btnW, btnW) widthVideoUrl:video];
            videoBtn.tag = 10000+i;
            videoBtn.delegate = self;
            videoBtn.delhidden = YES;
            //videoBtn.backgroundColor = [UIColor redColor];
            [_bottomView addSubview:videoBtn];
            [self.videoBtnArray addObject:videoBtn];
        }
        
    }
    if (videoCount != 0) {
        if (videoCount%4 == 0) {
            topHeight = topHeight + (btnW + centerY)*(videoCount/4);
        }else {
            topHeight = topHeight + (btnW + centerY)*(videoCount/4 + 1);
        }
    }
    _bottomView.frame = CGRectMake(0, maxY(_topBgView)+20, kScreenWidth, topHeight+20);
    
}
//展示图片
- (void)showPic:(NSInteger)index {
    
    NSInteger tag = index - 1000;
    NSMutableArray *ph = [NSMutableArray array];
    for (NSString *string in self.pictureArray) {
        if (![string isEqualToString:@" "]) {
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
//图片代理
- (void)picImageView:(PicImageView *)view index:(NSInteger)index {
    [self showPic:index];
}
//播放视频
- (void)videoView:(VideoView *)view index:(NSInteger)index {
    NSInteger tag = view.tag - 10000;
    
    NSString *videoUrl = self.videoArray[tag];
    
    VideoViewController *vc = [[VideoViewController alloc] initWithVideoUrl:videoUrl];
    [self presentViewController:vc animated:YES completion:nil];
}
//播放语音
- (void)audioViewPlayAudio:(AudioView *)view index:(NSInteger)index audio:(NSURL *)url {
    
    
    NSInteger tag = index - 100000;
    
    [[XMNAVAudioPlayer sharePlayer] playAudioWithURLString:[url absoluteString] atIndex:tag];
    
}

- (void)audioPlayerStateDidChanged:(XMNVoiceMessageState)audioPlayerState forIndex:(NSUInteger)index {
    
    AudioView *audioBtn = (AudioView *)[_bottomView viewWithTag:index+100000];
    dispatch_async(dispatch_get_main_queue(), ^{
        [audioBtn setVoiceMessageState:audioPlayerState];
    });
    
}
- (void)chooseTask {
    ZEBLog(@"选任务");
    __weak RecordDesViewController *weakself = self;
    WorkListsViewController *workList = [[WorkListsViewController alloc] init];
    workList.gid = self.model.gid;
    workList.type = 1;
    workList.taskBlock = ^(NSMutableDictionary *param){
        _workId = param[@"taskId"];
        _workName = param[@"taskName"];
        weakself.taskDesLabel.text = _workName;
    };
    [self.navigationController pushViewController:workList animated:YES];
}

//#pragma mark - 网络请求部分
//-(void)httpRequest
//{
//    
//    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
//    
//    
//    NSMutableDictionary *param =[[NSMutableDictionary alloc] init];
//    param[@"content"] = self.model.content;//内容
//    param[@"alarm"] = alarm;   //警号
//    param[@"title"] = self.model.title;   //标题
//    param[@"create_time"] = self.model.create_time;//创建时间
//    param[@"mode"]= self.model.mode;        //0.走访标记 1.快速记录2.摄像头标记
//    param[@"type"] =self.model.type;
//    param[@"longitude"]= self.model.longitude;//经度
//    param[@"latitude"] = self.model.latitude;//维度
//    param[@"position"] = self.model.position; //位置
//    param[@"gid"] =self.model.gid;
//    param[@"direction"] =self.model.direction;   //方向
//    param[@"workid"] = self.workId;
//    param[@"picture"] = self.model.picture;     //图片
//    param[@"audio"] = self.model.audio;       //音频
//    param[@"video"] = self.model.video;       //视频
//    ZEBLog(@"%@",param);
//    
//    [self showloadingName:@"正在提交"];
//    [[HttpsManager sharedManager] post:Saverecord_URL parameters:param progress:^(NSProgress * _Nonnull progress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
//        
//        NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:reponse options:NSJSONReadingMutableContainers error:nil];
//        
//        [self hideHud];
//        [self showHint:@"标记成功"];
//        
//        
//        NSMutableDictionary *parm = [NSMutableDictionary dictionary];
//        //将任务添加到地图
//        parm[@"workAllModelMark"] = self.model;
//        [LYRouter openURL:@"ly://mapaddmark" withUserInfo:parm completion:nil];
//        
//        [[[DBManager sharedManager] draftsListSQ] deleteDraftsListByCuid:self.model.cuid];
//        
//        
//        [self.navigationController popViewControllerAnimated:YES];
//        
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [self hideHud];
//        [self showHint:@"标记失败"];
//    }];
//    
//}
//
- (UILabel *)getLabelFont:(UIFont *)font textColor:(UIColor *)color {
    
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = color;
    return label;
}

#pragma mark -AMapSearchDelegate
//失败回调
- (void)searchRequest:(id)request didFailWithError:(NSError *)error
{
//    self.locationIndicatorView.hidden = YES;
//    [self.locationIndicatorView stopAnimating];
//    self.location.text = @"获取位置失败";
    NSLog(@"request :%@, error :%@", request, error);
}


//成功回调
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
//    NSLog(@"response :%@", response);
//    self.locationIndicatorView.hidden = YES;
//    [self.locationIndicatorView stopAnimating];
//    _position = response.regeocode.formattedAddress;
    
     self.posiLabel.text = response.regeocode.formattedAddress;
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
