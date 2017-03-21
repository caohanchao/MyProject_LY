//
//  XMChatBar.m
//  XMChatBarExample
//
//  Created by shscce on 15/8/17.
//  Copyright (c) 2015年 xmfraker. All rights reserved.
//

#import "XMChatBar.h"
#import "XMLocationController.h"
#import "XMChatMoreView.h"
#import "XMChatFaceView.h"
#import "XMProgressHUD.h"
#import "Mp3Recorder.h"
#import "MBProgressHUD.h"
#import "VideoRecorderViewController.h"
#import "Masonry.h"
#import "ZMLPlaceholderTextView.h"
#import "ZEBPhotoTool.h"
#import "NearestImage.h"
#import "NewTaskController.h"
#import "ZEBVoiceView.h"
#import "ZLPhotoActionSheet.h"
#import "ZLDefine.h"
#import "UIImage+Property.h"
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import "UIImage+UIImageScale.h"
// 带gif的键盘
#import "ZEBEmotionsKeyboardView.h"
#import "ZEBEmotionsKeyboardViewModel.h"

#import "CJFileManagerVC.h"

@interface XMChatBar ()<UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,Mp3RecorderDelegate,XMChatMoreViewDelegate,XMChatMoreViewDataSource,XMChatFaceViewDelegate,XMLocationControllerDelegate,VideoRecorderViewControllerDelegate, TZImagePickerControllerDelegate, ZEBEmotionsKeyboardViewDelegate,FileSelectVcDelegate>

@property (strong, nonatomic) Mp3Recorder *MP3;
@property (strong, nonatomic) UIButton *voiceButton; /**< 切换录音模式按钮 */
//@property (strong, nonatomic) UIButton *voiceRecordButton; /**< 录音按钮 */
@property (strong, nonatomic) ZEBVoiceView *voiceRecordButton; /**< 录音按钮 */
@property (strong, nonatomic) UIButton *faceButton; /**< 表情按钮 */
@property (strong, nonatomic) UIButton *moreButton; /**< 更多按钮 */
//@property (strong, nonatomic) XMChatFaceView *faceView; /**< 当前活跃的底部view,用来指向faceView */
@property (strong, nonatomic) ZEBEmotionsKeyboardView *faceView; /**< 当前活跃的底部view,用来指向faceView */
@property (strong, nonatomic) XMChatMoreView *moreView; /**< 当前活跃的底部view,用来指向moreView */

//@property (strong, nonatomic) UITextView *textView;
@property (assign, nonatomic, readonly) CGFloat screenHeight;
@property (assign, nonatomic, readonly) CGFloat bottomHeight;
@property (strong, nonatomic, readonly) UIViewController *rootViewController;

@property (assign, nonatomic) CGRect keyboardFrame;
@property (copy, nonatomic) NSString *inputText;
@property (nonatomic, strong) NSMutableArray *aTArray;
@property (nonatomic,strong) ZLPhotoActionSheet *actionSheet;
@property (nonatomic,strong) TZImagePickerController *pickerController;
@end

@implementation XMChatBar


#pragma mark - Life Cycle

- (ZLPhotoActionSheet *)actionSheet {
    if (!_actionSheet) {
        _actionSheet = [[ZLPhotoActionSheet alloc] init];
        //设置照片最大选择数
        _actionSheet.maxSelectCount = 6;
        //设置照片最大预览数
        _actionSheet.maxPreviewCount = 500;
    }
    return _actionSheet;
}

-(NSMutableDictionary *)paramData
{
    if (!_paramData) {
        _paramData=[NSMutableDictionary dictionary];
    }
    return _paramData;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)updateConstraints{
    [super updateConstraints];
    [self.voiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left).with.offset(10);
//        make.top.equalTo(self.mas_top).with.offset(8);
//        make.width.equalTo(self.voiceButton.mas_height);
        make.left.equalTo(self.mas_left).with.offset(5);
        make.centerY.equalTo(self.mas_centerY).with.offset(0);
        make.width.equalTo(self.voiceButton.mas_height);
    }];
    
    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.mas_right).with.offset(-10);
//        make.top.equalTo(self.mas_top).with.offset(8);
//        make.width.equalTo(self.moreButton.mas_height);
        make.right.equalTo(self.mas_right).with.offset(-5);
        make.centerY.equalTo(self.mas_centerY).with.offset(0);
        make.width.equalTo(self.moreButton.mas_height);
    }];
    
    [self.faceButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.moreButton.mas_left).with.offset(-10);
//        make.top.equalTo(self.mas_top).with.offset(8);
//        make.width.equalTo(self.faceButton.mas_height);
        make.right.equalTo(self.moreButton.mas_left).with.offset(-9);
        make.centerY.equalTo(self.mas_centerY).with.offset(0);
        make.width.equalTo(self.faceButton.mas_height);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.voiceButton.mas_right).with.offset(10);
//        make.right.equalTo(self.faceButton.mas_left).with.offset(-10);
//        make.top.equalTo(self.mas_top).with.offset(4);
//        make.bottom.equalTo(self.mas_bottom).with.offset(-4);
        make.left.equalTo(self.voiceButton.mas_right).with.offset(9);
        make.right.equalTo(self.faceButton.mas_left).with.offset(-9);
        make.top.equalTo(self.mas_top).with.offset(5);
        make.bottom.equalTo(self.mas_bottom).with.offset(-5);
    }];
}
- (NSMutableArray *)aTArray {

    if (_aTArray == nil) {
        _aTArray = [NSMutableArray array];
    }
    return _aTArray;
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark textView delegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if(![textView hasText] && [text isEqualToString:@""]) {
        return NO;
    }
    if ([text isEqualToString:@"@"]) {
        if (_delegate && [_delegate respondsToSelector:@selector(chatBarForAt:)]) {
            [_delegate chatBarForAt:self];
        }
    }
    if ([text isEqualToString:@"\n"]) {
        [self sendTextMessage:textView.text];
        return NO;
    }
    return YES;
}
//#pragma mark - UITextViewDelegate
//
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    
//    if ([text isEqualToString:@"\n"]) {
//        [self sendTextMessage:textView.text];
//        return NO;
//    }else if (text.length == 0){
//        //判断删除的文字是否符合表情文字规则
//        NSString *deleteText = [textView.text substringWithRange:range];
//        if ([deleteText isEqualToString:@"]"]) {
//            NSUInteger location = range.location;
//            NSUInteger length = range.length;
//            NSString *subText;
//            while (YES) {
//                if (location == 0) {
//                    return YES;
//                }
//                location -- ;
//                length ++ ;
//                subText = [textView.text substringWithRange:NSMakeRange(location, length)];
//                if (([subText hasPrefix:@"["] && [subText hasSuffix:@"]"])) {
//                    break;
//                }
//            }
//            textView.text = [textView.text stringByReplacingCharactersInRange:NSMakeRange(location, length) withString:@""];
//            [textView setSelectedRange:NSMakeRange(location, 0)];
//            [self textViewDidChange:self.textView];
//            return NO;
//        }
//    }
//    return YES;
//}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.faceButton.selected = self.moreButton.selected = self.voiceButton.selected = NO;
    [self showFaceView:NO];
    [self showMoreView:NO];
    [self showVoiceView:NO];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IsChatMap]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MapChatChangeFrameNotification object:@"0"];
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{

    CGRect textViewFrame = self.textView.frame;
    
    CGSize textSize = [self.textView sizeThatFits:CGSizeMake(CGRectGetWidth(textViewFrame), 1000.0f)];
    
    CGFloat offset = 10;
    textView.scrollEnabled = (textSize.height + 0.1 > kMaxHeight-offset);
    textViewFrame.size.height = MAX(34, MIN(kMaxHeight, textSize.height));
    
    CGRect addBarFrame = self.frame;
    addBarFrame.size.height = textViewFrame.size.height+offset;
    addBarFrame.origin.y = self.screenHeight - self.bottomHeight - addBarFrame.size.height;
//    self.frame = addBarFrame;
    [self setFrame:addBarFrame animated:NO];
//    if (textView.scrollEnabled) {
//        [textView scrollRangeToVisible:NSMakeRange(textView.text.length - 2, 1)];
//    }

}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo {
   // NSLog(@"UIImagePickerControllerDelegate-didFinishPickingImage");
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{

    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:picker.view];
    [picker.view addSubview:HUD];
    
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        // 保存相片
        UIImageWriteToSavedPhotosAlbum(info[UIImagePickerControllerOriginalImage], nil, nil, nil);
    } else if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
    } else if (picker.sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum) {
    }
    
    //如果设置此属性则当前的view置于后台
    HUD.dimBackground = YES;
    
    //设置对话框文字
    HUD.labelText = @"请稍等";
    __block UIImage *image = info[UIImagePickerControllerOriginalImage];
    //显示对话框
    [HUD showAnimated:YES whileExecutingBlock:^{
        //对话框显示时需要执行的操作
        
    } completionBlock:^{
        
        [self sendImageMessage:[image compressionImageToDataMaxFileSize:300]];//初始化进度框，置于当前的View当中
        [self.rootViewController dismissViewControllerAnimated:YES completion:nil];
        //操作执行完后取消对话框
        [HUD removeFromSuperview];
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
   // NSLog(@"UIImagePickerControllerDelegate-imagePickerControllerDidCancel");
    [self.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - XMLocationControllerDelegate

- (void)cancelLocation{
    [self.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendLocation:(NSString *)location locationText:(NSString *)locationText {
    [self cancelLocation];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatBar:sendLocation:locationText:)]) {
        [self.delegate chatBar:self sendLocation:location locationText:locationText];
    }
}

#pragma mark - VideoRecorderViewControllerDelegate
- (void)failVideoRecord {
    
}

- (void)cancelVideoRecord {
    
}

- (void)beginVideoRecord {
    
}

- (void)endVideoRecord:(NSURL *)assetURL {
    [self sendVideoMessage:assetURL];
}



#pragma mark - MP3RecordedDelegate

- (void)endConvertWithMP3FileName:(NSString *)fileName {
    if (fileName) {
        [XMProgressHUD dismissWithProgressState:XMProgressSuccess];
        [self sendVoiceMessage:fileName seconds:[XMProgressHUD seconds]];
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

- (void)sendPic:(NSArray *)images {

    
    NSInteger count = images.count;
//    _imageTempCount = 0;
//    [self.rootViewController showloadingName:@"正在上传"];
    for (int i = 0; i < count; i++) {
        UIImage *imageView = images[i];
        if (self.actionSheet.isSelectOriginalPhoto) {
            imageView.type = @"original";
        }
        dispatch_queue_t q = dispatch_queue_create("uploadingImage", DISPATCH_QUEUE_SERIAL);
        
        dispatch_sync(q, ^{
            
            [self sendImageMessage:imageView];
        });
        
    }
}
#pragma mark -
#pragma mark ZEBEmotionsKeyboardViewDelegate
//点击表情回调
- (void)emotionsKeyboardView:(id)emojiKeyboardView
                 emotionType:(ZEBEmotionType)type
                 didUseEmoji:(NSString *)emoji
                   didUseGIF:(NSDictionary *)gifDict
{
    NSLog(@"%s", __func__);
    
    switch (type) {
        case ZEBEmotionTypeGIF:
        {
            NSString *gifName = [gifDict valueForKey:GIFNameKey];
            NSData   *gifData = [gifDict valueForKey:GIFDatakey];
            
            //...
         //   NSLog(@"点击了gif表情！\n gifName ==> %@ \n gifData ==> %@", gifName, gifData);
            [self sendTextMessage:[NSString stringWithFormat:@"[img]file:///storage/emulated/0/MicroRecon/Emoticons/emojipolice/%@",gifName]];
        }
            break;
        case ZEBEmotionTypePNG:
        {
            NSString *pngName = [gifDict valueForKey:PNGNameKey];
            NSData   *pngData = [gifDict valueForKey:PNGDatakey];
            
            //...
          //  NSLog(@"点击了png表情！\n gifName ==> %@ \n gifData ==> %@", gifName, gifData);
            [self sendTextMessage:[NSString stringWithFormat:@"[img]file:///storage/emulated/0/MicroRecon/Emoticons/emojinj/%@.png",pngName]];
        }
            break;
        case ZEBEmotionTypeEmoji:
        {
            //NSLog(@"点击了emoji表情！\n ==> %@", emoji);
            self.textView.text = [self.textView.text stringByAppendingString:emoji];
            
            [self textViewDidChange:self.textView];
        }
            break;
        default:
            break;
    }
    
    
}
//点击删除回调
- (void)emotionsKeyboardView:(ZEBEmotionsKeyboardView *)emojiKeyboardView emotionType:(ZEBEmotionType)type didDelete:(BOOL)didDelete
{
    if (didDelete)
    {
        //目前只有emoji页面需要删除按钮
        NSLog(@"emoji点击了删除...");
      
        [self emotionDidDelete];
    }
}
- (void)emotionsKeyboardView:(ZEBEmotionsKeyboardView *)emojiKeyboardView didClickSend:(BOOL)isSend
{
    if (isSend)
    {
        NSLog(@"点击了发送按钮!");
        [self emotionDidSend];
    }
}



#pragma mark - XMChatMoreViewDelegate & XMChatMoreViewDataSource

- (void)moreView:(XMChatMoreView *)moreView selectIndex:(XMChatMoreItemType)itemType{
    
    
    switch (itemType) {
        case XMChatMoreItemAlbum:
        {
            //显示相册
//            UIImagePickerController *pickerC = [[UIImagePickerController alloc] init];
//            pickerC.delegate = self;
//            [self.rootViewController presentViewController:pickerC animated:YES completion:nil];
            weakify(self);
//            [self.actionSheet showPhotoLibraryWithSender:self.rootViewController lastSelectPhotoModels:nil completion:^(NSArray<UIImage *> * _Nonnull selectPhotos, NSArray<ZLSelectPhotoModel *> * _Nonnull selectPhotoModels) {
//                strongify(weakSelf);
//                [strongSelf sendPic:selectPhotos];
//            }];
            _pickerController = [[TZImagePickerController alloc] initWithMaxImagesCount:6 delegate:self];;
            // _actionSheet.allowPickingOriginalPhoto = NO;
            _pickerController.allowPickingVideo = NO;
            _pickerController.allowTakePicture = NO;
           // _pickerController.autoDismiss = NO;
//            __weak typeof(_pickerController) pickerController = _pickerController;
//            [_pickerController setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//             });
            
            [self.rootViewController presentViewController:_pickerController animated:YES completion:nil];

        }
            break;
        case XMChatMoreItemCamera:
        {
            //显示拍照
            if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您的设备不支持拍照" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                [alertView show];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的设备不支持拍照" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                 }];
                    
                [alertController addAction:action1];
                
                UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
                [rootViewController presentViewController:alertController animated:YES completion:nil];
                    
                break;
            }
            UIImagePickerController *pickerC = [[UIImagePickerController alloc] init];
            pickerC.sourceType = UIImagePickerControllerSourceTypeCamera;
            pickerC.delegate = self;
//            pickerC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            pickerC.allowsEditing = YES;
//            pickerC.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            [self.rootViewController presentViewController:pickerC animated:YES completion:nil];
        }
            break;
        case XMChatMoreItemLocation:
        {
            //显示地理位置
            XMLocationController *locationC = [[XMLocationController alloc] init];
            locationC.delegate = self;
            UINavigationController *locationNav = [[UINavigationController alloc] initWithRootViewController:locationC];
            [self.rootViewController presentViewController:locationNav animated:YES completion:nil];
        }
            break;
        case XMChatMoreItemVideoRecorder: {
            //录制视频
            VideoRecorderViewController *vrVC = [[VideoRecorderViewController alloc] init];
            vrVC.delegate = self;
            [self.rootViewController presentViewController:vrVC animated:YES completion:nil];
        }
            break;
        case XMchatMoreItemFile: {
            //文件
            CJFileManagerVC *fileVC = [[CJFileManagerVC alloc] init];
            fileVC.fileSelectVcDelegate = self;
            [self.rootViewController presentViewController:[[UINavigationController alloc] initWithRootViewController:fileVC] animated:YES completion:nil];
            
        }
            break;
            
        case XMChatMoreItemPublicTask: {
            if (self.chatBarType == ChatBarShowMapGroup) {
                //发布任务
                NewTaskController *task = [[NewTaskController alloc] init];
                task.paramData = self.paramData;
                UINavigationController *nav =[[UINavigationController alloc] initWithRootViewController:task];
                self.rootViewController.modalPresentationStyle = UIModalPresentationPageSheet;
                [self.rootViewController presentViewController:nav animated:YES completion:nil];
            }
            else if (self.chatBarType == ChatBarShowNomalSingel)
            {
                //阅后即焚
                [self readChangeUI];
            }
            else
            {
                //普通群点名
               [self gotoCallRoll];
            }
            
        }
            break;
        case XMChatMoreItemCallRoll: {
            //地图群点名
             if (self.chatBarType == ChatBarShowMapGroup)
             {
                 [self mapGroupGotoCallRoll];
             }
        }
            break;
        default:
            break;
    }

}

- (NSArray *)titlesOfMoreView:(XMChatMoreView *)moreView{
    
    if (self.chatBarType == ChatBarShowMapGroup){

        return @[@"拍摄",@"照片",@"位置",@"视频",@"文件",@"发布任务",@"点名"];
      //  return @[@"拍摄",@"照片",@"位置",@"视频",@"发布任务"];

//        return @[@"拍摄",@"照片",@"位置",@"视频",@"发布任务",@"点名"];
       // return @[@"拍摄",@"照片",@"位置",@"视频",@"发布任务"];

    }
    else if (self.chatBarType == ChatBarShowNomalSingel)
    {
        return @[@"拍摄",@"照片",@"位置",@"视频",@"文件",@"阅后即焚"];
    }

    return @[@"拍摄",@"照片",@"位置",@"视频",@"文件",@"点名"];
  //  return @[@"拍摄",@"照片",@"位置",@"视频"];

//    return @[@"拍摄",@"照片",@"位置",@"视频",@"点名"];
    //return @[@"拍摄",@"照片",@"位置",@"视频"];

}

- (NSArray *)imageNamesOfMoreView:(XMChatMoreView *)moreView{
    
    if (self.chatBarType == ChatBarShowMapGroup){

        return @[@"chat_bar_icons_camera",@"chat_bar_icons_pic",@"chat_bar_icons_location",@"chat_bar_icons_video",@"chat_bar_icons_file",@"chat_bar_icons_task",@"dianming"];
      //  return @[@"chat_bar_icons_camera",@"chat_bar_icons_pic",@"chat_bar_icons_location",@"chat_bar_icons_video",@"chat_bar_icons_task"];

//        return @[@"chat_bar_icons_camera",@"chat_bar_icons_pic",@"chat_bar_icons_location",@"chat_bar_icons_video",@"chat_bar_icons_task",@"dianming"];
       // return @[@"chat_bar_icons_camera",@"chat_bar_icons_pic",@"chat_bar_icons_location",@"chat_bar_icons_video",@"chat_bar_icons_task"];

    }
    else if (self.chatBarType == ChatBarShowNomalSingel)
    {
       return @[@"chat_bar_icons_camera",@"chat_bar_icons_pic",@"chat_bar_icons_location",@"chat_bar_icons_video",@"chat_bar_icons_file",@"fire"];
    }

    return @[@"chat_bar_icons_camera",@"chat_bar_icons_pic",@"chat_bar_icons_location",@"chat_bar_icons_video",@"chat_bar_icons_file",@"dianming"];
   // return @[@"chat_bar_icons_camera",@"chat_bar_icons_pic",@"chat_bar_icons_location",@"chat_bar_icons_video"];

//    return @[@"chat_bar_icons_camera",@"chat_bar_icons_pic",@"chat_bar_icons_location",@"chat_bar_icons_video",@"dianming"];
  //  return @[@"chat_bar_icons_camera",@"chat_bar_icons_pic",@"chat_bar_icons_location",@"chat_bar_icons_video"];

}
//
//#pragma mark - XMChatFaceViewDelegate
//
//- (void)faceViewSendFace:(NSString *)faceName{
//    if ([faceName isEqualToString:@"[删除]"]) {
//        [self textView:self.textView shouldChangeTextInRange:NSMakeRange(self.textView.text.length - 1, 1) replacementText:@""];
//    }else if ([faceName isEqualToString:@"发送"]){
//        NSString *text = self.textView.text;
//        if (!text || text.length == 0) {
//            return;
//        }
//        if (self.delegate && [self.delegate respondsToSelector:@selector(chatBar:sendMessage:)]) {
//            [self.delegate chatBar:self sendMessage:text];
//        }
//        self.inputText = @"";
//        self.textView.text = @"";
//        [self setFrame:CGRectMake(0, self.screenHeight - self.bottomHeight - kMinHeight, self.frame.size.width, kMinHeight) animated:NO];
//        [self showViewWithType:XMFunctionViewShowFace];
//    }else{
//        self.textView.text = [self.textView.text stringByAppendingString:faceName];
//        [self textViewDidChange:self.textView];
//    }
//}

#pragma mark - Public Methods

- (void)endInputing{
    [self showViewWithType:XMFunctionViewShowNothing];
}

#pragma mark - Private Methods

- (void)keyboardWillHide:(NSNotification *)notification{
    self.keyboardFrame = CGRectZero;
    [self textViewDidChange:self.textView];
}

- (void)keyboardFrameWillChange:(NSNotification *)notification{
    self.keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self textViewDidChange:self.textView];
}

- (void)setup{
    
    
    self.MP3 = [[Mp3Recorder alloc] initWithDelegate:self];
    [self addSubview:self.voiceButton];
    [self addSubview:self.moreButton];
    [self addSubview:self.faceButton];
    [self addSubview:self.textView];
    [self.textView addSubview:self.voiceRecordButton];
    
    UIImageView *topLine = [[UIImageView alloc] init];
    topLine.backgroundColor = [UIColor colorWithRed:184/255.0f green:184/255.0f blue:184/255.0f alpha:1.0f];
    [self addSubview:topLine];
    
    UIImageView *bottomLine = [[UIImageView alloc] init];
    bottomLine.backgroundColor = [UIColor colorWithRed:184/255.0f green:184/255.0f blue:184/255.0f alpha:1.0f];
    [self addSubview:bottomLine];
    
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.height.mas_equalTo(@.5f);
    }];
    [bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_bottom).offset(-0.5f);
        make.height.mas_equalTo(@.5f);
    }];
    

    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addAtMemeber:) name:ChatGroupAtNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.backgroundColor = [UIColor colorWithRed:235/255.0f green:236/255.0f blue:238/255.0f alpha:1.0f];
    [self updateConstraintsIfNeeded];
    
    //FIX 修复首次初始化页面 页面显示不正确 textView不显示bug
    [self layoutIfNeeded];
}

/**
 *  开始录音
 */
- (void)startRecordVoice{
    ZEBLog(@"开始录音");
    [XMProgressHUD show];
    [self.MP3 startRecord];
}

/**
 *  取消录音
 */
- (void)cancelRecordVoice{
    ZEBLog(@"取消录音");
    [XMProgressHUD dismissWithMessage:@"取消录音"];
    [self.MP3 cancelRecord];
}

/**
 *  录音结束
 */
- (void)confirmRecordVoice{
    ZEBLog(@"录音结束");
    [self.MP3 stopRecord];
}

/**
 *  更新录音显示状态,手指向上滑动后提示松开取消录音
 */
- (void)updateCancelRecordVoice{
    ZEBLog(@"松开手指取消录音");
    [XMProgressHUD changeSubTitle:@"松开手指取消录音"];
}

/**
 *  更新录音状态,手指重新滑动到范围内,提示向上取消录音
 */
- (void)updateContinueRecordVoice{
    ZEBLog(@"向上滑动取消录音");
    [XMProgressHUD changeSubTitle:@"向上滑动取消录音"];
}


- (void)showViewWithType:(XMFunctionViewShowType)showType{
    
    //显示对应的View
    [self showMoreView:showType == XMFunctionViewShowMore && self.moreButton.selected];
    [self showVoiceView:showType == XMFunctionViewShowVoice && self.voiceButton.selected];
    [self showFaceView:showType == XMFunctionViewShowFace && self.faceButton.selected];
    
    switch (showType) {
        case XMFunctionViewShowNothing:
            self.inputText = self.textView.text;
            [self setFrame:CGRectMake(0, self.screenHeight - kMinHeight, self.frame.size.width, kMinHeight) animated:NO];
            [self.textView resignFirstResponder];
            break;
        case XMFunctionViewShowVoice:
        {
            self.inputText = self.textView.text;
            self.textView.text = nil;
            [self setFrame:CGRectMake(0, self.screenHeight - kMinHeight, self.frame.size.width, kMinHeight) animated:NO];
            [self.textView resignFirstResponder];
        }
            break;
        case XMFunctionViewShowMore:
        case XMFunctionViewShowFace:
            self.inputText = self.textView.text;
//            self.frame = CGRectMake(0, self.screenHeight - kFunctionViewHeight - self.textView.frame.size.height - 10, self.frame.size.width, self.textView.frame.size.height + 10);
            [self setFrame:CGRectMake(0, self.screenHeight - kFunctionViewHeight - self.textView.frame.size.height - 10, self.frame.size.width, self.textView.frame.size.height + 10) animated:NO];
            
            [self.textView resignFirstResponder];
            [self textViewDidChange:self.textView];
            break;
        case XMFunctionViewShowKeyboard:
            
            self.textView.text = self.inputText;
            [self textViewDidChange:self.textView];
            self.inputText = nil;
            [self.textView becomeFirstResponder];
            break;
            
        case XMFunctionViewCloseRead:
            
            [self closeReadAndreturnUI];
            
            self.textView.text = self.inputText;
            self.inputText = nil;
            break;
            
        default:
            break;
    }
    
}


//进入阅后即焚状态的输入
- (void)readChangeUI
{
    self.fireMessageType = messageLock;
    
//    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.voiceButton.mas_left);
//        make.right.equalTo(self.moreButton.mas_left).with.offset(-9);
//        make.top.equalTo(self.mas_top).with.offset(5);
//        make.bottom.equalTo(self.mas_bottom).with.offset(-5);
//    }];
    
    _moreButton.tag = XMFunctionViewCloseRead;
    [_moreButton setBackgroundImage:[UIImage imageNamed:@"chatclose"] forState:UIControlStateNormal];
    [_voiceButton setBackgroundImage:[UIImage imageNamed:@"firevoice"] forState:UIControlStateNormal];
    [_voiceButton setBackgroundImage:[UIImage imageNamed:@"firekeyb"] forState:UIControlStateSelected];
    [_faceButton setBackgroundImage:[UIImage imageNamed:@"fireimage"] forState:UIControlStateNormal];
    [_faceButton setBackgroundImage:[UIImage imageNamed:@"fireimage"] forState:UIControlStateSelected];
    _textView.layer.borderColor = [CHCHexColor(@"ff7200") CGColor];
    
   // [self.textView becomeFirstResponder];
    [self showViewWithType:XMFunctionViewShowKeyboard];
}

//结束阅后即焚状态恢复原来
- (void)closeReadAndreturnUI
{
    self.fireMessageType = messageUNLock;
    
    [self.textView removeFromSuperview];
    
    [self addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.voiceButton.mas_right).with.offset(9);
        make.right.equalTo(self.faceButton.mas_left).with.offset(-9);
        make.top.equalTo(self.mas_top).with.offset(5);
        make.bottom.equalTo(self.mas_bottom).with.offset(-5);
    }];
    
   // [self.textView becomeFirstResponder];
    _moreButton.tag = XMFunctionViewShowMore;
    _moreButton.selected = NO;
    [_moreButton setBackgroundImage:[UIImage imageNamed:@"chat_bar_more_normal"] forState:UIControlStateNormal];
    
    [_voiceButton setBackgroundImage:[UIImage imageNamed:@"chat_bar_voice_normal"] forState:UIControlStateNormal];
    [_voiceButton setBackgroundImage:[UIImage imageNamed:@"chat_bar_input_normal"] forState:UIControlStateSelected];
    [_faceButton setBackgroundImage:[UIImage imageNamed:@"chat_bar_face_normal"] forState:UIControlStateNormal];
    [_faceButton setBackgroundImage:[UIImage imageNamed:@"chat_bar_input_normal"] forState:UIControlStateSelected];
    
    self.textView.layer.borderColor = [UIColor colorWithRed:204.0/255.0f green:204.0/255.0f blue:204.0/255.0f alpha:1.0f].CGColor;
    
//    [self showViewWithType:XMFunctionViewShowNothing];
}

- (void)buttonAction:(UIButton *)button{
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatBar:scrollBottom:)]) {
        [self.delegate chatBar:self scrollBottom:YES];
    }
    self.inputText = self.textView.text;
    XMFunctionViewShowType showType = button.tag;
    
    //更改对应按钮的状态
    if (button == self.faceButton) {
        [self.faceButton setSelected:!self.faceButton.selected];
        [self.moreButton setSelected:NO];
        [self.voiceButton setSelected:NO];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:IsChatMap]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:MapChatChangeFrameNotification object:@"0"];
        }
    }else if (button == self.moreButton){
        //展示最近相册的图片
        [self showNearestPhoto];
        
        [self.faceButton setSelected:NO];
        [self.moreButton setSelected:!self.moreButton.selected];
        [self.voiceButton setSelected:NO];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:IsChatMap]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:MapChatChangeFrameNotification object:@"0"];
        }
    }else if (button == self.voiceButton){
        [self.faceButton setSelected:NO];
        [self.moreButton setSelected:NO];
        [self.voiceButton setSelected:!self.voiceButton.selected];
    }
    
    if (!button.selected) {
        showType = XMFunctionViewShowKeyboard;
        [self.textView becomeFirstResponder];
    }else{
        self.inputText = self.textView.text;
    }
    
    if (button == self.faceButton) {
        if (self.fireMessageType == messageLock) {
            weakify(self);
            _pickerController = [[TZImagePickerController alloc] initWithMaxImagesCount:6 delegate:self];
            _pickerController.allowPickingVideo = NO;
            _pickerController.allowTakePicture = NO;
            [self.rootViewController presentViewController:_pickerController animated:YES completion:nil];
        }
        else
        {
            [self showViewWithType:showType];
        }
    }
    else
    {
        [self showViewWithType:showType];
    }
    
    
    
    
    
}

-(void)showNearestPhoto
{

    [ZEBPhotoTool latestAsset:^(ZEBAsset * _Nullable asset) {
        
        if ([@(asset.creationTimeInterval)isEqual:[[NSUserDefaults standardUserDefaults] objectForKey:@"NearImageTimeInterval"]]) {
            
            return ;
        }
        else
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SendNearestImageNotification" object:asset.image];

            [[NSUserDefaults standardUserDefaults] setObject:@(asset.creationTimeInterval) forKey:@"NearImageTimeInterval"];
            
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
     

    }];
    
    
}
- (void)setWinHeight:(CGFloat)winHeight {

    _winHeight = winHeight;
    self.faceView.frame = CGRectMake(0, self.screenHeight , self.frame.size.width, kFunctionViewHeight);
}
- (void)showFaceView:(BOOL)show{
    
    if (show) {
       
        [self.superview addSubview:self.faceView];
        
        [UIView animateWithDuration:.3 animations:^{
            [self.faceView setFrame:CGRectMake(0, self.screenHeight - kFunctionViewHeight, self.frame.size.width, kFunctionViewHeight)];
        } completion:nil];
    }else{
        [UIView animateWithDuration:.3 animations:^{
            [self.faceView setFrame:CGRectMake(0, self.screenHeight, self.frame.size.width, kFunctionViewHeight)];
        } completion:^(BOOL finished) {
            [self.faceView removeFromSuperview];
        }];
    }
}

/**
 *  显示moreView
 *  @param show 要显示的moreView
 */
- (void)showMoreView:(BOOL)show{
    
    //CGRect supRect = self.superview.frame;
    
    if (show) {
        [self.superview addSubview:self.moreView];
        [UIView animateWithDuration:.3 animations:^{
            
            [self.moreView setFrame:CGRectMake(0, self.screenHeight - kFunctionViewHeight, self.frame.size.width, kFunctionViewHeight)];
        } completion:nil];
    }else{
        [UIView animateWithDuration:.3 animations:^{
        
            [self.moreView setFrame:CGRectMake(0, self.screenHeight, self.frame.size.width, kFunctionViewHeight)];
        } completion:^(BOOL finished) {
            [self.moreView removeFromSuperview];
        }];
    }
}

- (void)showVoiceView:(BOOL)show{
    self.voiceButton.selected = show;
    //self.voiceRecordButton.selected = show;
    self.voiceRecordButton.hidden = !show;
    self.textView.scrollEnabled = !show;
    if (self.fireMessageType == messageLock) {
        if (show == YES) {
            [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.voiceButton.mas_right).with.offset(9);
                make.right.equalTo(self.moreButton.mas_left).with.offset(-9);
                make.top.equalTo(self.mas_top).with.offset(5);
                make.bottom.equalTo(self.mas_bottom).with.offset(-5);
            }];
        }
        else
        {
            [self.textView removeFromSuperview];
            
            [self addSubview:self.textView];
            [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.voiceButton.mas_right).with.offset(9);
                make.right.equalTo(self.faceButton.mas_left).with.offset(-9);
                make.top.equalTo(self.mas_top).with.offset(5);
                make.bottom.equalTo(self.mas_bottom).with.offset(-5);
            }];
        }
    }

}


/**
 *  发送普通的文本信息,通知代理
 *
 *  @param text 发送的文本信息
 */
- (void)sendTextMessage:(NSString *)text{
    if (!text || text.length == 0) {
        return;
    }
    NSString *atAlarm = @"";
    if (self.aTArray.count == 0) {
        atAlarm = @"";
    }else {
        atAlarm = [self.aTArray componentsJoinedByString:@","];
    }
    [[NSUserDefaults standardUserDefaults] setObject:atAlarm forKey:atAlarms];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatBar:sendMessage:withType:)]) {
        if (self.fireMessageType == messageLock) {
            [self.delegate chatBar:self sendMessage:text withType:messageLock];
        }
        else
        {
            [self.delegate chatBar:self sendMessage:text withType:messageUNLock];
        }
    }
    
    [self.aTArray removeAllObjects];
    self.inputText = @"";
    self.textView.text = @"";
    [self setFrame:CGRectMake(0, self.screenHeight - self.bottomHeight - kMinHeight, self.frame.size.width, kMinHeight) animated:NO];
   // [self showViewWithType:XMFunctionViewShowKeyboard]; // 没必要 屏蔽掉
}

/**
 *  通知代理发送语音信息
 *
 *  @param voiceData 发送的语音信息data
 *  @param seconds   语音时长
 */
- (void)sendVoiceMessage:(NSString *)voiceFileName seconds:(NSTimeInterval)seconds{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatBar:sendVoice:seconds:withType:)]) {
        [self.delegate chatBar:self sendVoice:voiceFileName seconds:seconds withType:self.fireMessageType];
    }
}

/**
 *  通知代理发送视频信息
 *
 *  @param videoFileName 发送的语音信息data
 *  @param seconds   语音时长
 */
- (void)sendVideoMessage:(NSURL *)assetURL {
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatBar:sendVideo:)]) {
        [self.delegate chatBar:self sendVideo:assetURL];
    }
}
/**
 *  通知代理发送图片信息
 *
 *  @param image 发送的图片
 */
- (void)sendImageMessage:(UIImage *)image{
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatBar:sendPictures:withType:)]) {
        [self.delegate chatBar:self sendPictures:@[image] withType:self.fireMessageType];
    }
}

//#pragma mark - Getters
//
//- (XMChatFaceView *)faceView{
//    if (!_faceView) {
//        _faceView = [[XMChatFaceView alloc] initWithFrame:CGRectMake(0, self.screenHeight , self.frame.size.width, kFunctionViewHeight)];
//        _faceView.delegate = self;
//        _faceView.backgroundColor = self.backgroundColor;
//    }
//    return _faceView;
//}
#pragma mark - 懒加载

- (ZEBEmotionsKeyboardView *)faceView{
    if (_faceView == nil) {
        
        NSArray *gifs   = [ZEBEmotionsKeyboardViewModel getAllGifs];
        NSArray *emojis = [ZEBEmotionsKeyboardViewModel getAllEmojis];
        NSArray *pngs = [ZEBEmotionsKeyboardViewModel getAllPNGs];
        
        _faceView = [[ZEBEmotionsKeyboardView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kFunctionViewHeight) delegate:self gifImageNames:gifs emojiNames:emojis pngImageNames:pngs];
        _faceView.backgroundColor = self.backgroundColor;
        
    }
    return _faceView;
}
- (XMChatMoreView *)moreView{
    if (!_moreView) {
        _moreView = [[XMChatMoreView alloc] initWithFrame:CGRectMake(0, self.screenHeight , self.frame.size.width, kFunctionViewHeight)];
        _moreView.delegate = self;
        _moreView.dataSource = self;
        _moreView.backgroundColor = self.backgroundColor;
    }
    return _moreView;
}

- (ZMLPlaceholderTextView *)textView{
    if (!_textView) {
        _textView = [[ZMLPlaceholderTextView alloc] init];
        _textView.font = [UIFont systemFontOfSize:16.0f];
        _textView.enablesReturnKeyAutomatically = YES; //这里设置为无文字就灰色不可点
        _textView.delegate = self;
        _textView.layer.cornerRadius = 4.0f;
        _textView.layer.borderColor = [UIColor colorWithRed:204.0/255.0f green:204.0/255.0f blue:204.0/255.0f alpha:1.0f].CGColor;
        _textView.returnKeyType = UIReturnKeySend;
        _textView.layer.borderWidth = .8f;
        _textView.layer.masksToBounds = YES;
    }
    return _textView;
}

- (UIButton *)voiceButton{
    if (!_voiceButton) {
        _voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _voiceButton.tag = XMFunctionViewShowVoice;
        [_voiceButton setBackgroundImage:[UIImage imageNamed:@"chat_bar_voice_normal"] forState:UIControlStateNormal];
        [_voiceButton setBackgroundImage:[UIImage imageNamed:@"chat_bar_input_normal"] forState:UIControlStateSelected];
        [_voiceButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_voiceButton sizeToFit];
    }
    return _voiceButton;
}

//- (UIButton *)voiceRecordButton{
//    if (!_voiceRecordButton) {
//        _voiceRecordButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _voiceRecordButton.hidden = YES;
//        _voiceRecordButton.frame = self.textView.bounds;
//        _voiceRecordButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        [_voiceRecordButton setBackgroundColor:[UIColor lightGrayColor]];
//        _voiceRecordButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
//        [_voiceRecordButton setTitle:@"按住录音" forState:UIControlStateNormal];
//        [_voiceRecordButton addTarget:self action:@selector(startRecordVoice) forControlEvents:UIControlEventTouchDown];
//        [_voiceRecordButton addTarget:self action:@selector(cancelRecordVoice) forControlEvents:UIControlEventTouchUpOutside];
//        [_voiceRecordButton addTarget:self action:@selector(confirmRecordVoice) forControlEvents:UIControlEventTouchUpInside];
//        [_voiceRecordButton addTarget:self action:@selector(updateCancelRecordVoice) forControlEvents:UIControlEventTouchDragExit];
//        [_voiceRecordButton addTarget:self action:@selector(updateContinueRecordVoice) forControlEvents:UIControlEventTouchDragEnter];
//    }
//    return _voiceRecordButton;
//}
- (ZEBVoiceView *)voiceRecordButton {
    if (!_voiceRecordButton) {
        _voiceRecordButton = [[ZEBVoiceView alloc] initWithFrame:self.textView.bounds startBlock:^(ZEBVoiceView *view) {
            [self startRecordVoice];
        } cancelBlock:^(ZEBVoiceView *view) {
            [self cancelRecordVoice];
        } confimBlock:^(ZEBVoiceView *view) {
            [self confirmRecordVoice];
        } updateCancelBlock:^(ZEBVoiceView *view) {
            [self updateCancelRecordVoice];
        } updateContinueBlock:^(ZEBVoiceView *view) {
            [self updateContinueRecordVoice];
        }];
        _voiceRecordButton.hidden = YES;
        _voiceRecordButton.backgroundColor = zLightGrayColor;
        _voiceRecordButton.text = @"按住说话";
        _voiceRecordButton.textAlignment = NSTextAlignmentCenter;
        _voiceRecordButton.font = ZEBFont(14);
        _voiceRecordButton.textColor = zWhiteColor;
        _voiceRecordButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return _voiceRecordButton;
}
- (UIButton *)moreButton{
    if (!_moreButton) {
        _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreButton.tag = XMFunctionViewShowMore;
        [_moreButton setBackgroundImage:[UIImage imageNamed:@"chat_bar_more_normal"] forState:UIControlStateNormal];
        [_moreButton setBackgroundImage:[UIImage imageNamed:@"chat_bar_input_normal"] forState:UIControlStateSelected];
        [_moreButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_moreButton sizeToFit];
    }
    return _moreButton;
}

- (UIButton *)faceButton{
    if (!_faceButton) {
        _faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _faceButton.tag = XMFunctionViewShowFace;
        [_faceButton setBackgroundImage:[UIImage imageNamed:@"chat_bar_face_normal"] forState:UIControlStateNormal];
        [_faceButton setBackgroundImage:[UIImage imageNamed:@"chat_bar_input_normal"] forState:UIControlStateSelected];
        [_faceButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [_faceButton sizeToFit];
    }
    return _faceButton;
}

- (CGFloat)screenHeight{
    //return [[UIApplication sharedApplication] keyWindow].bounds.size.height;
    return self.winHeight;
}

- (CGFloat)bottomHeight{
    
    if (self.faceView.superview || self.moreView.superview) {
        return MAX(self.keyboardFrame.size.height, MAX(self.faceView.frame.size.height, self.moreView.frame.size.height));
    }else{
        return MAX(self.keyboardFrame.size.height, CGFLOAT_MIN);
    }
    
}

- (UIViewController *)rootViewController{
    return [[UIApplication sharedApplication] keyWindow].rootViewController;
}

#pragma mark - Getters

- (void)setFrame:(CGRect)frame animated:(BOOL)animated{
    if (animated) {
        [UIView animateWithDuration:.3 animations:^{
            [self setFrame:frame];
        }];
    }else{
        [self setFrame:frame];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatBarFrameDidChange:frame:)]) {
        [self.delegate chatBarFrameDidChange:self frame:frame];
    }
}
/**
 *  点击了表情键盘中的删除按钮回调
 */
- (void)emotionDidDelete{
    
    [self.textView deleteBackward];
}
/**
 *  点击了表情键盘中的发送按钮回调
 */
- (void)emotionDidSend{
    
    NSString *text = [self.textView.text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
   

    //NSLog(@"%@",text);
    [self faceViewSendFace:text];
    
    
}

/**
 *  选中了表情键盘中的某一个表情回调
 */
//- (void)emotionDidSelect:(ZMLEmotion *)emotion{
//    
//    self.textView.text = [self.textView.text stringByAppendingString:emotion.code.emoji];
//    
//    [self textViewDidChange:self.textView];
//}
/**
 *  表情页发送
 *
 *  @param text 表情页发送
 */
- (void)faceViewSendFace:(NSString *)text{
    if (!text || text.length == 0) {
        return;
    }
    NSString *atAlarm = @"";
    if (self.aTArray.count == 0) {
        atAlarm = @"";
    }else {
        atAlarm = [self.aTArray componentsJoinedByString:@","];
    }
    [[NSUserDefaults standardUserDefaults] setObject:atAlarm forKey:atAlarms];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(chatBar:sendMessage:withType:)]) {
        if (self.fireMessageType == messageLock) {
            [self.delegate chatBar:self sendMessage:text withType:messageLock];
        }
        else
        {
            [self.delegate chatBar:self sendMessage:text withType:messageUnknow];
        }
    }
   
    [self.aTArray removeAllObjects];
    self.inputText = @"";
    self.textView.text = @"";
    [self setFrame:CGRectMake(0, self.screenHeight - self.bottomHeight - kMinHeight, self.frame.size.width, kMinHeight) animated:NO];
    [self showViewWithType:XMFunctionViewShowFace];
}
- (void)addAtMemeber:(NSNotification *)notification {
    
    NSRange range = self.textView.selectedRange;
    NSDictionary *atDic= notification.object;
    NSMutableString *textString = [NSMutableString stringWithString:[LZXHelper isNullToString:self.textView.text]];
    
    NSString *atname = atDic[@"name"];
    [textString insertString:atname atIndex:range.location];
  //  textString = [textString stringByAppendingString:];
    self.textView.text = textString;
//    
    NSRange newRange = NSMakeRange(range.location+atname.length, 0);
    self.textView.selectedRange = newRange;
    
    if ([atDic[@"alarm"] isKindOfClass:[NSMutableArray class]]) {
        [self.aTArray addObjectsFromArray:atDic[@"alarm"]];
    }else {
        
        NSString *alarm = atDic[@"alarm"];
        [self.aTArray addObject:alarm];
    }
    [self.textView becomeFirstResponder];
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
    if (isSelectOriginalPhoto) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSInteger count = assets.count;
            for (int i = 0; i < count; i++) {
                PHAsset *asset = assets[i];
                dispatch_queue_t q = dispatch_queue_create("uploadingImage", DISPATCH_QUEUE_SERIAL);
                dispatch_sync(q, ^{
                    [[TZImageManager manager] getOriginalPhotoDataWithAsset:asset completion:^(NSData *data, NSDictionary *info) {
                        UIImage *image = [[TZImageManager manager] fixOrientation:[UIImage imageWithData:data]];
                        NSData *tempdata = UIImageJPEGRepresentation(image, 1);
                        UIImage *tempImage = image;
                        tempImage = [tempImage newOriginalOfChat];
                        tempImage.Bytes = [NSString stringWithFormat:@"%ld",data.length];
                        tempImage.imageData = tempdata;
                        tempImage.type = @"original";
                        [self sendImageMessage:tempImage];
                    }];

                });
            }
        });
        
    }else {
        NSInteger count = photos.count;
        for (int i = 0; i < count; i++) {
            UIImage *image = photos[i];
            dispatch_queue_t q = dispatch_queue_create("uploadingImage", DISPATCH_QUEUE_SERIAL);
            dispatch_sync(q, ^{
                [self sendImageMessage:[image compressionImageToDataMaxFileSize:300]];
            });
           
        }
    }
}
//- (void)setFrame:(CGRect)frame{
//    [super setFrame:frame];
//    [UIView animateWithDuration:.3 animations:^{
//        [super setFrame:frame];
//    }completion:nil];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(chatBarFrameDidChange:frame:)]) {
//        [self.delegate chatBarFrameDidChange:self frame:frame];
//    }
//}

//- (void)chatBar:(XMChatBar *)chatBar sendfile:(NSString *)fileURL withName:(NSString *)fileName withSize:(NSString *)fileSize;

#pragma mark - 发送文件
- (void)fileViewControlerSelected:(NSArray <CJFileObjModel *> *)fileModels {
    
    [fileModels enumerateObjectsUsingBlock:^(CJFileObjModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (self.delegate &&[self.delegate respondsToSelector:@selector(chatBar:sendfile:)]) {
            [self.delegate chatBar:self sendfile:obj];
        }
        
//        if (!obj.asset) {
//         
//            if (self.delegate && [self.delegate respondsToSelector:@selector(chatBar:sendfile:withName:withSize:orAsset:)]) {
//                [self.delegate chatBar:self sendfile:obj.fileUrl withName:obj.name withSize:obj.fileSize orAsset:nil];
//            }
//        }else {
//            if (self.delegate && [self.delegate respondsToSelector:@selector(chatBar:sendfile:withName:withSize:orAsset:)]) {
//                [self.delegate chatBar:self sendfile:nil withName:obj.name withSize:obj.fileSize orAsset:obj.asset];
//            }
//        }
    }];
    
    
    
    
}


#pragma mark ----- 点名
//普通群
- (void)gotoCallRoll
{
    [LYRouter openURL:@"ly://gotoCallRoll"];
}
//地图聊天
- (void)mapGroupGotoCallRoll
{
     [LYRouter openURL:@"ly://mapGroupGotoCallRoll"];
}

@end
