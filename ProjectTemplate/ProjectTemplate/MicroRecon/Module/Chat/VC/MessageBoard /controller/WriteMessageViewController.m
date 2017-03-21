//
//  WriteMessageViewController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/1/18.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "WriteMessageViewController.h"
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
#import "RFKeyboardToolbar.h"
#import "MessageBoardListModel.h"

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

#define white_backgroundColor [UIColor whiteColor]
#define font_blackColor [UIColor blackColor]
#define font_grayColor [UIColor grayColor]

#define font() [UIFont systemFontOfSize:14]

#define CellHeight 0
#define LeftMargin 12


@interface WriteMessageViewController ()<UITextViewDelegate,AudioViewDelegate, VideoViewDelegate, Mp3RecorderDelegate, UIScrollViewDelegate, XMNAVAudioPlayerDelegate, PicImageViewDelegate, VideoRecorderViewControllerDelegate, TZImagePickerControllerDelegate> {
    NSInteger _imageTempCount;
}


@property (nonatomic, strong) UIScrollView *scroller;
@property (nonatomic, strong) TZImagePickerController *actionSheet;
@property (strong, nonatomic) Mp3Recorder *MP3;
@property (nonatomic, strong) GetAudioView *getAudioView;


@property (nonatomic, strong) UIActivityIndicatorView *locationIndicatorView;
@property(nonatomic,strong)UIView *centralView;
//@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)ZMLPlaceholderTextView *descriptionView;

//存放url
@property (nonatomic, strong) NSMutableArray *audioUrlArray;
@property (nonatomic, strong) NSMutableArray *picUrlArray;
@property (nonatomic, strong) NSMutableArray *videoUrlArray;



//存放展示控件
@property (nonatomic, strong) NSMutableArray *audioArray;
@property (nonatomic, strong) NSMutableArray *picArray;
@property (nonatomic, strong) NSMutableArray *videoArray;

@end

@implementation WriteMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = zWhiteColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"写留言";
    [XMNAVAudioPlayer sharePlayer].delegate = self;
    self.MP3 = [[Mp3Recorder alloc] initWithDelegate:self];
    [self initall];
}
- (void)initall {
    
    [self createRightBtn];
    [self createUI];
}
#pragma mark -
#pragma mark rightbutton
- (void)createRightBtn {
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction)];
    
    self.navigationItem.rightBarButtonItems = [self.navigationItem rightItemsWithBarButtonItem:rightBarButtonItem WithSpace:5];
    [rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil] forState:UIControlStateNormal];
}

//上传评论
- (void)rightBtnAction {
    
    [self.descriptionView endEditing:YES];
    if ([[LZXHelper isNullToString:self.descriptionView.text] isEqualToString:@""]) {
        [self showHint:@"请输入内容"];
        return;
    }
    [self httpRequest];

}
- (void)createUI {
    
    [self.view addSubview:self.scroller];
    
    [self.scroller addSubview:self.centralView];
    [self.centralView addSubview:self.descriptionView];
    
    [self.centralView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scroller.mas_top).with.offset(74);
        make.left.equalTo(self.scroller.mas_left);
        make.width.mas_equalTo(kScreenWidth);
        make.height.offset(122+CellHeight);
        
    }];
    
    [self.descriptionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centralView.mas_left).with.offset(LeftMargin);
        make.right.equalTo(self.centralView.mas_right).with.offset(0);
        make.top.equalTo(self.centralView.mas_top).with.offset(0);
        make.height.offset(122);
    }];
    
    
    CGFloat wSpace = (screenWidth()-60)/4;
    
    NSArray *imgArr = @[@"voice_carema",@"photo_carema",@"camera_camera"];
    
//    [self.view addSubview:self.bottomView];
//    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
//        make.height.offset(44);
//        make.left.equalTo(self.view.mas_left).with.offset(0);
//        make.right.equalTo(self.view.mas_right).with.offset(0);
//        
//    }];
    
    //语音 图片 视频
    NSMutableArray *btnArray = [NSMutableArray array];
    for (int i = 0; i<3; i++) {
        UIButton *btn = [UIButton new];
        btn.tag = 90000+i;
        [btn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btnArray addObject:btn];
    }
    RFKeyboardToolbar *toolBar = [RFKeyboardToolbar sharedManager];
    [toolBar addToTextView:self.descriptionView withButtons:btnArray];
    
//    for (int i = 0; i<3; i++)
//    {
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        if (i == 0) {
//            btn.frame = CGRectMake(wSpace+i*(20+wSpace),11, 18, 28);
//        }else if (i == 1) {
//            btn.frame = CGRectMake(wSpace+i*(20+wSpace),11, 29, 25.5);
//        }else if (i == 2) {
//            btn.frame = CGRectMake(wSpace+i*(20+wSpace),11, 27, 23.5);
//        }
//        
//        
//        //在正常状态下显示的背景图片
//        [btn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imgArr[i]]] forState:UIControlStateNormal];
//        
//        [btn setEnlargeEdge:15];
//        btn.tag = 90000+i;
//        //添加点击事件
//        [btn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        [self.bottomView addSubview:btn];
//    }

    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[XMNAVAudioPlayer sharePlayer] stopAudioPlayer];
    [XMNAVAudioPlayer sharePlayer].index = NSUIntegerMax;
    [XMNAVAudioPlayer sharePlayer].URLString = nil;
}
#pragma mark - 懒加载

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
- (UIScrollView *)scroller {
    if (!_scroller) {
        _scroller = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
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

-(UIView *)centralView
{
    if (!_centralView) {
        _centralView = [[UIView alloc]init];
        _centralView.backgroundColor = zWhiteColor;
    }
    return _centralView;
}
//-(UIView *)bottomView
//{
//    if (!_bottomView) {
//        _bottomView = [[UIView alloc] init];
//        _bottomView.backgroundColor = white_backgroundColor;
//    }
//    return _bottomView;
//    
//}
#pragma mark -
#pragma mark 当有图片 视频 语音 刷新ui
- (void)uploadUI {
    
    
    NSInteger audioCount = self.audioArray.count;
    NSInteger picCount = self.picArray.count;
    NSInteger videoCount = self.videoArray.count;
    
    
    CGFloat contentHeight = height(self.descriptionView.frame)+10;
    
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
    
 
    [self.centralView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(122 + topHeight - height(self.descriptionView.frame));
    }];
    
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}
//底部交互
-(void)bottomBtnClick:(UIButton *)btn
{
    [self.view endEditing:YES];
    if (btn.tag == 90000) {//语音
        [self.getAudioView showIn:self.view];
    }
    else if (btn.tag == 90001){//图片
        weakify(self);
        
        _actionSheet = [[TZImagePickerController alloc] initWithMaxImagesCount:6 delegate:self];;
        _actionSheet.allowPickingOriginalPhoto = NO;
        _actionSheet.allowPickingVideo = NO;
        _actionSheet.allowTakePicture = NO;
        [_actionSheet setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            
            [weakSelf sendPic:photos];
        }];
        [self presentViewController:_actionSheet animated:YES completion:^{
            
        }];
    }
    else if (btn.tag == 90002){//视频
        //录制视频
        VideoRecorderViewController *vrVC = [[VideoRecorderViewController alloc] init];
        vrVC.delegate = self;
        [self presentViewController:vrVC animated:YES completion:nil];
    }
    
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

//请求当前时间
-(NSString *)requestTime{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *time = [formatter stringFromDate:[NSDate date]];
    return time;
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
    if ((height(self.centralView.frame)+20) > kScreenHeight-44-64) {
        H = height(self.centralView.frame)+64+44+20;
    }else {
        H = kScreenHeight - 44 + 16;
    }
    self.scroller.contentSize = CGSizeMake(kScreenWidth,H);
    
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
#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}

// The picker should dismiss itself; when it dismissed these handle will be called.
// If isOriginalPhoto is YES, user picked the original photo.
// You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
// The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
   
}
#pragma mark - 网络请求部分
-(void)httpRequest
{
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    NSMutableDictionary *param =[[NSMutableDictionary alloc] init];
    param[@"alarm"] = alarm; //唯一id
    param[@"token"] = token;   //登陆时返回的token
    param[@"content"] =self.descriptionView.text;   //描述内容
    param[@"type"] = self.type; // "0" 嫌疑人; "1"标记; "2"案发地
    param[@"mark_id"] = self.mark_id;        //唯一id ,具体要看什么类型,可能是嫌疑人id,或者标记id,或者案发地id                    |
    param[@"picture"] =[self.picUrlArray componentsJoinedByString:@","];     //图片
    param[@"audio"] =[self.audioUrlArray componentsJoinedByString:@","];       //音频
    param[@"video"] =[self.videoUrlArray componentsJoinedByString:@","];       //视频
    ZEBLog(@"%@",param);
    
    [self showloadingName:@"正在提交"];
    [[HttpsManager sharedManager] post:SetCommentUrl parameters:param progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:reponse
                                                                 options:NSJSONReadingMutableContainers error:nil];
        if ([dict[@"resultcode"] isEqualToString:@"0"]) {
            [self showHint:@"提交成功"];
            self.refreshBlock(self);
            [self.navigationController popViewControllerAnimated:YES];
        }else {
            [self showHint:@"提交失败"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self hideHud];
        [self showHint:@"提交失败"];
       
    }];
    
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
