//
//  EmojiViewController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/3/2.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "EmojiViewController.h"
#import "YYImage.h"

#define ZOOM_VIEW_TAG 1000
#define ZOOM_STEP 2.0

@interface EmojiViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) YYAnimatedImageView *animatedImageView;


@property (nonatomic, assign) BOOL singleTap; // 单击
@property (nonatomic, assign) BOOL doubleTap; // 双击

@end

@implementation EmojiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = zWhiteColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
}
- (void)setEmojiName:(NSString *)emojiName {
    _emojiName = emojiName;
    [self initView];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.singleTap) {
        [self showNavigationBar];
        self.singleTap = NO;
    }
}
- (void)initView {
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.animatedImageView];
    
    YYImage *image = [YYImage imageNamed:_emojiName];
    self.animatedImageView.image = image;
    
    CGFloat fixelW = CGImageGetWidth(image.CGImage);
    CGFloat fixelH = CGImageGetHeight(image.CGImage);
    self.animatedImageView.frame = CGRectMake(0, 0, fixelW/2, fixelW/2);
    self.animatedImageView.center = self.scrollView.center;
    
    // calculate minimum scale to perfectly fit image width, and begin at that scale
    [self.scrollView setMinimumZoomScale:1];
    [self.scrollView setMaximumZoomScale:2.0];
    [self.scrollView setZoomScale:1 animated:NO];
    self.scrollView.scrollsToTop = NO;
    self.scrollView.contentSize = CGSizeMake(fixelW/2, fixelH/2);
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
   
    [singleTap setNumberOfTapsRequired:1];
    [doubleTap setNumberOfTapsRequired:2];
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    [self.scrollView addGestureRecognizer:singleTap];
    [self.scrollView addGestureRecognizer:doubleTap];
 
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.multipleTouchEnabled = YES; //是否支持多点触控
        _scrollView.delegate = self;
        _scrollView.backgroundColor = zWhiteColor;
        _scrollView.bouncesZoom = YES;
    }
    return _scrollView;
}
- (YYAnimatedImageView *)animatedImageView {
    if (!_animatedImageView) {
        _animatedImageView = [[YYAnimatedImageView alloc] init];
        _animatedImageView.tag = ZOOM_VIEW_TAG;
    }
    return _animatedImageView;
}


#pragma mark -
#pragma mark scrollViewdelegate
- (void)scrollViewDidZoom:(UIScrollView *)scrollView NS_AVAILABLE_IOS(3_2) {
    //当捏或移动时，需要对center重新定义以达到正确显示未知
    CGFloat xcenter = scrollView.center.x,ycenter = scrollView.center.y;
    NSLog(@"scrollView.contentSize:%@ adjust position,x:%f,y:%f",NSStringFromCGSize(scrollView.contentSize),xcenter,ycenter);
    xcenter = scrollView.contentSize.width > scrollView.frame.size.width?scrollView.contentSize.width/2 :xcenter;
    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ?scrollView.contentSize.height/2 : ycenter;
    
    [self.animatedImageView setCenter:CGPointMake(xcenter, ycenter)];

}
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [self.scrollView viewWithTag:ZOOM_VIEW_TAG];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
    
//    //当捏或移动时，需要对center重新定义以达到正确显示未知
//    CGFloat xcenter = scrollView.center.x,ycenter = scrollView.center.y;
//    NSLog(@"adjust position,x:%f,y:%f",xcenter,ycenter);
//    xcenter = scrollView.contentSize.width > scrollView.frame.size.width?scrollView.contentSize.width/2 :xcenter;
//    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ?scrollView.contentSize.height/2 : ycenter;
//    [UIView animateWithDuration:0.2 animations:^{
//       [self.animatedImageView setCenter:CGPointMake(xcenter, ycenter)];
//    }];
    
    [scrollView setZoomScale:scale animated:YES];
    
}

#pragma mark TapDetectingImageViewDelegate methods

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer {
    // single tap does nothing for now
    if (self.singleTap) {
        [self showNavigationBar];
        self.singleTap = NO;
    } else {
        [self hiddenNavigationBar];
        self.singleTap = YES;
    }
}

- (void)showNavigationBar {
    [UIView animateWithDuration:0.3 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
       
        self.navigationController.navigationBar.transform = CGAffineTransformIdentity;
        
    }];
}
- (void)hiddenNavigationBar {
    [UIView animateWithDuration:0.3 animations:^{
        
        self.navigationController.navigationBar.transform = CGAffineTransformMakeTranslation(0, -TopBarHeight);
        
    }];
}
- (void)handleDoubleTap:(UIGestureRecognizer *)gestureRecognizer {
    // double tap zooms in
    float newScale;
    if (self.scrollView.zoomScale > 1) {
        [self.scrollView setZoomScale:1 animated:YES];
        self.doubleTap = NO;
    }else {
       [self.scrollView setZoomScale:2 animated:YES];
        self.doubleTap = YES;
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
