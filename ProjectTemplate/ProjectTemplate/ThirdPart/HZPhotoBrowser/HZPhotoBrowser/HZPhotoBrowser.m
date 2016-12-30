//
//  HZPhotoBrowser.m
//  photoBrowser
//
//  Created by huangzhenyu on 15/6/23.
//  Copyright (c) 2015年 eamon. All rights reserved.
//

#import "HZPhotoBrowser.h"
#import "HZPhotoBrowserConfig.h"
#import "ChatMessageForwardController.h"

@interface HZPhotoBrowser() <UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,assign) BOOL hasShowedPhotoBrowser;
@property (nonatomic,strong) UILabel *indexLabel;
@property (nonatomic,strong) UIActivityIndicatorView *indicatorView;
@property (nonatomic,strong) UIButton * relayBtn;
@property (nonatomic,strong) UIButton * saveBtn;
@property (nonatomic,strong) UIButton * cancelBtn;
@property (nonatomic,strong) UILabel * lineLabel;
@property (nonatomic,strong) UIView * bgView;
@property (nonatomic,strong) UIView * btnView;

@end

@implementation HZPhotoBrowser

- (void)viewDidLoad
{
    [super viewDidLoad];
    _hasShowedPhotoBrowser = NO;
    self.view.backgroundColor = kPhotoBrowserBackgrounColor;
    [self addScrollView];
    [self addToolbars];
    [self setUpFrames];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_hasShowedPhotoBrowser) {
        [self showPhotoBrowser];
    }
}

#pragma mark 重置各控件frame（处理屏幕旋转）
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self setUpFrames];
}

#pragma mark 设置各控件frame
- (void)setUpFrames
{
    CGRect rect = self.view.bounds;
    rect.size.width += kPhotoBrowserImageViewMargin * 2;
    _scrollView.frame = rect;
    _scrollView.center = CGPointMake(kAPPWidth *0.5, kAppHeight *0.5);
    
    CGFloat y = 0;
    __block CGFloat w = kAPPWidth;
    CGFloat h = kAppHeight;
    
    //设置所有HZPhotoBrowserView的frame
    [_scrollView.subviews enumerateObjectsUsingBlock:^(HZPhotoBrowserView *obj, NSUInteger idx, BOOL *stop) {
        CGFloat x = kPhotoBrowserImageViewMargin + idx * (kPhotoBrowserImageViewMargin * 2 + w);
        obj.frame = CGRectMake(x, y, w, h);
    }];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.subviews.count * _scrollView.frame.size.width, kAppHeight);
    _scrollView.contentOffset = CGPointMake(self.currentImageIndex * _scrollView.frame.size.width, 0);
    
    _indexLabel.bounds = CGRectMake(0, 0, 80, 30);
    _indexLabel.center = CGPointMake(kAPPWidth * 0.5, 30);
    
    _bgView.frame = CGRectMake(0, 0, [LZXHelper getScreenSize].width, [LZXHelper getScreenSize].height);
    [UIView animateWithDuration:0.25 animations:^{
        _btnView.frame = CGRectMake(0, [LZXHelper getScreenSize].height-154, [LZXHelper getScreenSize].width, 154);
    } ];
    _relayBtn.frame =CGRectMake(0, 0, [LZXHelper getScreenSize].width, 50);
    _saveBtn.frame =CGRectMake(0, 50, [LZXHelper getScreenSize].width, 50);
    _cancelBtn.frame =CGRectMake(0, 104, [LZXHelper getScreenSize].width, 50);
    _lineLabel.frame =CGRectMake(kPhotoBrowserImageViewMargin,50, [LZXHelper getScreenSize].width-kPhotoBrowserImageViewMargin*2, 0.5);
}

#pragma mark 显示图片浏览器
- (void)showPhotoBrowser
{
    UIView *sourceView = self.sourceImagesContainerView.subviews[self.currentImageIndex];
    UIView *parentView = [self getParsentView:sourceView];
    CGRect rect = [sourceView.superview convertRect:sourceView.frame toView:parentView];
    
    //如果是tableview，要减去偏移量
    if ([parentView isKindOfClass:[UITableView class]]) {
        UITableView *tableview = (UITableView *)parentView;
        rect.origin.y =  rect.origin.y - tableview.contentOffset.y;
    }
    
    UIImageView *tempImageView = [[UIImageView alloc] init];
    tempImageView.frame = rect;
    tempImageView.image = [self placeholderImageForIndex:self.currentImageIndex];
    [self.view addSubview:tempImageView];
    tempImageView.contentMode = UIViewContentModeScaleAspectFit;

    CGFloat placeImageSizeW = tempImageView.image.size.width;
    CGFloat placeImageSizeH = tempImageView.image.size.height;
    CGRect targetTemp;
    
    if (!kIsFullWidthForLandScape) {
        if (kAPPWidth < kAppHeight) {
            CGFloat placeHolderH = (placeImageSizeH * kAPPWidth)/placeImageSizeW;
            if (placeHolderH <= kAppHeight) {
                targetTemp = CGRectMake(0, (kAppHeight - placeHolderH) * 0.5 , kAPPWidth, placeHolderH);
            } else {
                targetTemp = CGRectMake(0, 0, kAPPWidth, placeHolderH);
            }
        } else {
            CGFloat placeHolderW = (placeImageSizeW * kAppHeight)/placeImageSizeH;
            if (placeHolderW < kAPPWidth) {
                targetTemp = CGRectMake((kAPPWidth - placeHolderW)*0.5, 0, placeHolderW, kAppHeight);
            } else {
                targetTemp = CGRectMake(0, 0, placeHolderW, kAppHeight);
            }
        }

    } else {
        CGFloat placeHolderH = (placeImageSizeH * kAPPWidth)/placeImageSizeW;
        if (placeHolderH <= kAppHeight) {
            targetTemp = CGRectMake(0, (kAppHeight - placeHolderH) * 0.5 , kAPPWidth, placeHolderH);
        } else {
            targetTemp = CGRectMake(0, 0, kAPPWidth, placeHolderH);
        }
    }
    
    _scrollView.hidden = YES;
    _indexLabel.hidden = YES;
    _saveBtn.hidden = YES;
    _lineLabel.hidden = YES;
    _relayBtn.hidden = YES;
    _cancelBtn.hidden = YES;
    
    [UIView animateWithDuration:kPhotoBrowserShowDuration animations:^{
        tempImageView.frame = targetTemp;
    } completion:^(BOOL finished) {
        _hasShowedPhotoBrowser = YES;
        [tempImageView removeFromSuperview];
        _scrollView.hidden = NO;
        _indexLabel.hidden = NO;
        _saveBtn.hidden = NO;
        _lineLabel.hidden = NO;
        _cancelBtn.hidden = NO;
        _relayBtn.hidden = NO;
    }];
}

#pragma mark 添加scrollview
- (void)addScrollView
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = self.view.bounds;
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.hidden = YES;
    [self.view addSubview:_scrollView];
    
    for (int i = 0; i < self.imageCount; i++) {
        HZPhotoBrowserView *view = [[HZPhotoBrowserView alloc] init];
        view.imageview.tag = i;
        
        //处理单击
        __weak __typeof(self)weakSelf = self;
        view.singleTapBlock = ^(UITapGestureRecognizer *recognizer){
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf hidePhotoBrowser:recognizer];
        };
        
        [_scrollView addSubview:view];
        
        
        UILongPressGestureRecognizer * longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestures:)];
        longPressGestureRecognizer.delegate = self;
        longPressGestureRecognizer.numberOfTouchesRequired = 1;
        longPressGestureRecognizer.allowableMovement = 100.0f;
        longPressGestureRecognizer.minimumPressDuration = 1.0;
        [view addGestureRecognizer:longPressGestureRecognizer];
        
    }
    [self setupImageOfImageViewForIndex:self.currentImageIndex];
}

-(void)handleLongPressGestures:(UILongPressGestureRecognizer *)paramSender
{
    if (self.longPress) {
        if (paramSender.state == UIGestureRecognizerStateBegan)
        {
            [self createThreeBtn];
        }
    }
}
#pragma mark 添加操作按钮
- (void)addToolbars
{
    //序标
    UILabel *indexLabel = [[UILabel alloc] init];
    indexLabel.textAlignment = NSTextAlignmentCenter;
    indexLabel.textColor = [UIColor whiteColor];
    indexLabel.font = [UIFont boldSystemFontOfSize:20];
    indexLabel.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.3f];
    indexLabel.bounds = CGRectMake(0, 0, 100, 40);
    indexLabel.center = CGPointMake(kAPPWidth * 0.5, 30);
    indexLabel.layer.cornerRadius = 15;
    indexLabel.clipsToBounds = YES;
 
    if (self.imageCount > 1) {
        indexLabel.text = [NSString stringWithFormat:@"1/%ld", (long)self.imageCount];
        _indexLabel = indexLabel;
        [self.view addSubview:indexLabel];
    }
    
}

- (UIView*)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc]init];
        _bgView.backgroundColor = [UIColor clearColor];
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
        _btnView.backgroundColor = CHCHexColor(@"000000");
        _btnView.frame = CGRectMake(0, [LZXHelper getScreenSize].height, [LZXHelper getScreenSize].width, 0);
    }
    return _btnView;
}

- (UIButton*)relayBtn
{
    if (!_relayBtn) {
        _relayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
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
        _lineLabel.backgroundColor = LineColor;
    }
    return _lineLabel;
}

-(void)createThreeBtn
{
    [self.view addSubview:self.bgView];
    [self.bgView addSubview:self.btnView];
    [self.btnView addSubview:self.relayBtn];
    [self.btnView addSubview:self.saveBtn];
    [self.btnView addSubview:self.cancelBtn];
    [self.btnView addSubview:self.lineLabel];
    
}

//转发
-(void)relayBtnClick
{
//    int index = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
//    
//    HZPhotoBrowserView *currentView = _scrollView.subviews[index];

    ChatMessageForwardController *forwardVC =[[ChatMessageForwardController alloc]init];
    forwardVC.pushViewStr = @"postDetailView";
    forwardVC.imageUrlStr = self.imageUrl;
    UINavigationController *nvc =[[UINavigationController alloc]initWithRootViewController:forwardVC];
    
    [self presentViewController:nvc animated:YES completion:^{
        [self removeView];
    } ];
    
}

//取消
-(void)cancelBtnClick
{
    [self removeView];
}

#pragma mark 保存图像
- (void)saveImage
{
    int index = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
    
    HZPhotoBrowserView *currentView = _scrollView.subviews[index];
    
    UIImageWriteToSavedPhotosAlbum(currentView.imageview.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] init];
    indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    indicator.center = self.view.center;
    _indicatorView = indicator;
    [[UIApplication sharedApplication].keyWindow addSubview:indicator];
    [indicator startAnimating];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    [_indicatorView removeFromSuperview];
    
    if (error == nil)
    {
        [self showHint:@"图片保存成功"];
        [self removeView];
    }
    else
    {
        [self showHint:@"图片保存失败"];
    }

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

- (void)show
{
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:self animated:NO completion:nil];
}

#pragma mark 单击隐藏图片浏览器
- (void)hidePhotoBrowser:(UITapGestureRecognizer *)recognizer
{
    HZPhotoBrowserView *view = (HZPhotoBrowserView *)recognizer.view;
    UIImageView *currentImageView = view.imageview;
    
    UIView *sourceView = self.sourceImagesContainerView.subviews[self.currentImageIndex];
    UIView *parentView = [self getParsentView:sourceView];
    CGRect targetTemp = [sourceView.superview convertRect:sourceView.frame toView:parentView];
    
    // 减去偏移量
    if ([parentView isKindOfClass:[UITableView class]]) {
        UITableView *tableview = (UITableView *)parentView;
        targetTemp.origin.y =  targetTemp.origin.y - tableview.contentOffset.y;
    }
    
    CGFloat appWidth;
    CGFloat appHeight;
    if (kAPPWidth < kAppHeight) {
        appWidth = kAPPWidth;
        appHeight = kAppHeight;
    } else {
        appWidth = kAppHeight;
        appHeight = kAPPWidth;
    }
    
    UIImageView *tempImageView = [[UIImageView alloc] init];
    tempImageView.image = currentImageView.image;
    if (tempImageView.image) {
        CGFloat tempImageSizeH = tempImageView.image.size.height;
        CGFloat tempImageSizeW = tempImageView.image.size.width;
        CGFloat tempImageViewH = (tempImageSizeH * appWidth)/tempImageSizeW;
        if (tempImageViewH < appHeight) {
            tempImageView.frame = CGRectMake(0, (appHeight - tempImageViewH)*0.5, appWidth, tempImageViewH);
        } else {
            tempImageView.frame = CGRectMake(0, 0, appWidth, tempImageViewH);
        }
    } else {
        tempImageView.backgroundColor = [UIColor whiteColor];
        tempImageView.frame = CGRectMake(0, (appHeight - appWidth)*0.5, appWidth, appWidth);
    }
    
    [self.view.window addSubview:tempImageView];
    
    [self dismissViewControllerAnimated:NO completion:nil];
    [UIView animateWithDuration:kPhotoBrowserHideDuration animations:^{
        tempImageView.frame = targetTemp;
        
    } completion:^(BOOL finished) {
        [tempImageView removeFromSuperview];
    }];
}

#pragma mark 网络加载图片
- (void)setupImageOfImageViewForIndex:(NSInteger)index
{
    HZPhotoBrowserView *view = _scrollView.subviews[index];
    if (view.beginLoadingImage) return;
    if ([self highQualityImageURLForIndex:index]) {
        [view setImageWithURL:[self highQualityImageURLForIndex:index] placeholderImage:[self placeholderImageForIndex:index]];
    } else {
        view.imageview.image = [self placeholderImageForIndex:index];
    }
    view.beginLoadingImage = YES;
}

#pragma mark 获取控制器的view
- (UIView *)getParsentView:(UIView *)view{
    if ([[view nextResponder] isKindOfClass:[UIViewController class]] || view == nil) {
        return view;
    }
    return [self getParsentView:view.superview];
}

#pragma mark 获取低分辨率（占位）图片
- (UIImage *)placeholderImageForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:placeholderImageForIndex:)]) {
        return [self.delegate photoBrowser:self placeholderImageForIndex:index];
    }
    return nil;
}

#pragma mark 获取高分辨率图片url
- (NSURL *)highQualityImageURLForIndex:(NSInteger)index
{
    if ([self.delegate respondsToSelector:@selector(photoBrowser:highQualityImageURLForIndex:)]) {
        return [self.delegate photoBrowser:self highQualityImageURLForIndex:index];
    }
    return nil;
}


#pragma mark - scrollview代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int index = (scrollView.contentOffset.x + _scrollView.bounds.size.width * 0.5) / _scrollView.bounds.size.width;
    
    _indexLabel.text = [NSString stringWithFormat:@"%d/%ld", index + 1, (long)self.imageCount];
    long left = index - 2;
    long right = index + 2;
    left = left>0?left : 0;
    right = right>self.imageCount?self.imageCount:right;
    
    //预加载三张图片
    for (long i = left; i < right; i++) {
        [self setupImageOfImageViewForIndex:i];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int autualIndex = scrollView.contentOffset.x  / _scrollView.bounds.size.width;
    //设置当前下标
    self.currentImageIndex = autualIndex;
    
    //将不是当前imageview的缩放全部还原 (这个方法有些冗余，后期可以改进)
    for (HZPhotoBrowserView *view in _scrollView.subviews) {
        if (view.imageview.tag != autualIndex) {
            view.scrollview.zoomScale = 1.0;
        }
    }
}

#pragma mark 横竖屏设置
- (BOOL)shouldAutorotate
{
    return shouldSupportLandscape;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if (shouldSupportLandscape) {
        return UIInterfaceOrientationMaskAll;
    } else{
        return UIInterfaceOrientationMaskPortrait;
    }
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}
@end
