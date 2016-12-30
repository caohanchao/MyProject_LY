//
//  HZImagesGroupView.m
//  photoBrowser
//
//  Created by huangzhenyu on 15/6/23.
//  Copyright (c) 2015年 eamon. All rights reserved.
//

#import "HZImagesGroupView.h"
#import "HZPhotoBrowser.h"
#import "UIButton+WebCache.h"
#import "HZPhotoItemModel.h"
#import "IDMPhotoBrowser.h"
#import "ChatMessageForwardController.h"

#define kImagesMargin 12

@interface HZImagesGroupView() <HZPhotoBrowserDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIButton * relayBtn;
@property (nonatomic,strong) UIButton * saveBtn;
@property (nonatomic,strong) UIButton * cancelBtn;
@property (nonatomic,strong) UILabel * lineLabel;
@property (nonatomic,strong) UIView * bgView;
@property (nonatomic,strong) UIView * btnView;

@property (nonatomic,strong) UIImage * selsetImage;

@property (nonatomic,strong) UIViewController *superVC;;

@end

@implementation HZImagesGroupView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 清除图片缓存，便于测试
      //  [[SDWebImageManager sharedManager].imageCache clearDisk];
//        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)setPhotoItemArray:(NSArray *)photoItemArray
{
    [self removeAllSubviews];
    
    _photoItemArray = photoItemArray;
    [photoItemArray enumerateObjectsUsingBlock:^(HZPhotoItemModel *obj, NSUInteger idx, BOOL *stop) {
        UIButton *btn = [[UIButton alloc] init];
        
        //让图片不变形，以适应按钮宽高，按钮中图片部分内容可能看不到
        btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        btn.clipsToBounds = YES;
        
        [btn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?height=100&width=100",obj.thumbnail_pic]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"whiteplaceholder"]];
        btn.tag = idx;
        
        [btn addTarget:self action:@selector(imageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    long imageCount = self.photoItemArray.count;
    int perRowImageCount =imageCount;
    CGFloat perRowImageCountF = (CGFloat)perRowImageCount;
    int totalRowCount = ceil(imageCount / perRowImageCountF); // ((imageCount + perRowImageCount - 1) / perRowImageCount)
    
    CGFloat w ;
    CGFloat h ;
    
    if ([self.tempStr isEqualToString:@"issue"])
    {
         w = (screenWidth()-kImagesMargin*5)/4;
         h = (screenWidth()-kImagesMargin*5)/4;
        
        [self.subviews enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
            
            long rowIndex = idx / 4;
            int columnIndex = idx % 4;
            CGFloat x = columnIndex * (w + kImagesMargin);
            CGFloat y = rowIndex * (h + kImagesMargin);
            btn.frame = CGRectMake(x, y, w, h);
        }];
        
         self.frame = CGRectMake(12, 0, imageCount*w+kImagesMargin*(imageCount-1), 88);
    }
    else
    {
        w = 88;
        h = 88;
        
        [self.subviews enumerateObjectsUsingBlock:^(UIButton *btn, NSUInteger idx, BOOL *stop) {
            
            long rowIndex = idx / perRowImageCount;
            int columnIndex = idx % perRowImageCount;
            CGFloat x = columnIndex * (w + kImagesMargin);
            CGFloat y = rowIndex * (h + kImagesMargin);
            btn.frame = CGRectMake(x, y, w, h);
        }];
        self.frame = CGRectMake(0, 0, imageCount*w+kImagesMargin*(imageCount-1), 88);
    }
    
}

- (void)imageButtonClick:(UIButton *)button
{
     HZPhotoItemModel * model =  self.photoItemArray[button.tag];
    
    self.imageUrl = model.thumbnail_pic;
//    
//    //启动图片浏览器
//    HZPhotoBrowser *browserVc = [[HZPhotoBrowser alloc] init];
//    browserVc.sourceImagesContainerView = self; // 原图的父控件
//    browserVc.imageCount = self.photoItemArray.count; // 图片总数
//    browserVc.currentImageIndex = (int)button.tag;
//    browserVc.delegate = self;
//    browserVc.imageUrl =  model.thumbnail_pic;
//    browserVc.longPress = self.longPress;
//    [browserVc show];
    NSMutableArray *ph = [NSMutableArray array];
    for (HZPhotoItemModel * model in self.photoItemArray) {
        if (![model.thumbnail_pic isEqualToString:@" "] || ![model.thumbnail_pic isEqualToString:@""]) {
            IDMPhoto *photo = [IDMPhoto photoWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?height=100&width=100",model.thumbnail_pic]]];
            [ph addObject:photo];
        }
    }
    
    IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:ph animatedFromView:button];
    // IDMPhotoBrowser功能设置
    browser.displayActionButton = NO;
    browser.displayArrowButton = NO;
    browser.displayCounterLabel = YES;
    browser.displayDoneButton = NO;
    browser.autoHideInterface = NO;
    browser.usePopAnimation = YES;
    browser.disableVerticalSwipe = YES;
    [browser setInitialPageIndex:button.tag];
    
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:browser animated:NO completion:nil];
    
    browser.longPressGesResponse=^(UIImage *image){
        _selsetImage = image;
        [self createThreeBtn];
    };

}

- (UIView*)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor clearColor];
        _bgView.frame = CGRectMake(0, 0, [LZXHelper getScreenSize].width, [LZXHelper getScreenSize].height);
        UITapGestureRecognizer * PrivateLetterTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAvatarView:)];
        PrivateLetterTap.numberOfTouchesRequired = 1;
        PrivateLetterTap.numberOfTapsRequired = 1;
        PrivateLetterTap.delegate= self;
        [_bgView addGestureRecognizer:PrivateLetterTap];
    }
    return _bgView;
}

- (UIView*)btnView
{
    if (!_btnView) {
        _btnView = [[UIView alloc]init];
       _btnView.frame = CGRectMake(0, [LZXHelper getScreenSize].height-154, [LZXHelper getScreenSize].width, 0);
        _btnView.backgroundColor = CHCHexColor(@"000000");
        _btnView.frame = CGRectMake(0, [LZXHelper getScreenSize].height, [LZXHelper getScreenSize].width, 0);
    }
    return _btnView;
}

- (UIButton*)relayBtn
{
    if (!_relayBtn) {
        _relayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _relayBtn.frame =CGRectMake(0, 0, [LZXHelper getScreenSize].width, 50);
        _relayBtn.backgroundColor = CHCHexColor(@"ffffff");
        [_relayBtn setTitle:@"转发" forState:UIControlStateNormal];
        [_relayBtn setTitleColor:CHCHexColor(@"000000")];
        [_relayBtn addTarget:self action:@selector(relayBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _relayBtn;
}

- (UIButton*)saveBtn
{
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveBtn.frame =CGRectMake(0, 50, [LZXHelper getScreenSize].width, 50);
        _saveBtn.backgroundColor = CHCHexColor(@"ffffff");
        [_saveBtn setTitle:@"保存到手机" forState:UIControlStateNormal];
        [_saveBtn setTitleColor:CHCHexColor(@"000000")];
        [_saveBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveBtn;
}

- (UIButton*)cancelBtn
{
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame =CGRectMake(0, 104, [LZXHelper getScreenSize].width, 50);
        _cancelBtn.backgroundColor =CHCHexColor(@"ffffff");
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:CHCHexColor(@"000000")];
        [_cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UILabel*)lineLabel
{
    if (!_lineLabel) {
        _lineLabel = [[UILabel alloc]init];
        _lineLabel.frame =CGRectMake(kImagesMargin,50, [LZXHelper getScreenSize].width-kImagesMargin*2, 0.5);
        _lineLabel.backgroundColor = LineColor;
    }
    return _lineLabel;
}

-(void)createThreeBtn
{
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.bgView];
//    [[[UIApplication sharedApplication] keyWindow] addSubview:self.bgView];
    [self.bgView addSubview:self.btnView];
    [UIView animateWithDuration:0.25 animations:^{
        _btnView.frame = CGRectMake(0, [LZXHelper getScreenSize].height-154, [LZXHelper getScreenSize].width, 154);
    } ];
    
    [self.btnView addSubview:self.relayBtn];
    [self.btnView addSubview:self.saveBtn];
    [self.btnView addSubview:self.cancelBtn];
    [self.btnView addSubview:self.lineLabel];
    
}

//转发
-(void)relayBtnClick
{
//    if (_delegate && [_delegate respondsToSelector:@selector(pushToForwardVCWith:)]) {
//        [_delegate pushToForwardVCWith:self.imageUrl];
//    }
    
    NSDictionary *dict =[[NSDictionary alloc] initWithObjectsAndKeys:self.imageUrl,@"imageUrl",nil];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:ImageForwardPostNotification object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
//    [self.navigationController popViewControllerAnimated:YES];
//    [[NSNotificationCenter defaultCenter]postNotificationName:ImageForwardPostNotification object:nil];
    
    [self removeView];
    
}
- (UIViewController *)viewController:(UIView *)view{
    
    UIResponder *responder = view;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    
    return nil;
}

//取消
-(void)cancelBtnClick
{
    [self removeView];
}

#pragma mark 保存图像
- (void)saveImage
{
    UIImageWriteToSavedPhotosAlbum(_selsetImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
//    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
//    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
//    indicator.center = self.view.center;
//    _indicatorView = indicator;
//    [[UIApplication sharedApplication].keyWindow addSubview:indicator];
//    [indicator startAnimating];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    [self cancelBtnClick];
}

#pragma mark ---点击隐藏下方按钮
- (void)tapAvatarView: (UITapGestureRecognizer *)gesture
{
    [self removeView];
}

-(void)removeView
{
    [UIView animateWithDuration:0.25 animations:^{
        _btnView.frame = CGRectMake(0, [LZXHelper getScreenSize].height, [LZXHelper getScreenSize].width, 0);
    } completion:^(BOOL finished) {
        [_bgView removeFromSuperview];
        [_btnView removeFromSuperview];
        [_relayBtn removeFromSuperview];
        [_saveBtn removeFromSuperview];
        [_cancelBtn removeFromSuperview];
        [_lineLabel removeFromSuperview];
    }];
    
}


#pragma mark - photobrowser代理方法
- (UIImage *)photoBrowser:(HZPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    return [self.subviews[index] currentImage];
}

- (NSURL *)photoBrowser:(HZPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = [[self.photoItemArray[index] thumbnail_pic] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    return [NSURL URLWithString:urlStr];
}
@end
