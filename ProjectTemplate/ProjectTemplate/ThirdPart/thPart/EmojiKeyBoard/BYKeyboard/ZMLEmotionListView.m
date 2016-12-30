//
//  ViewController.m
//  自定义键盘
//
//  Created by 张马亮 on 16/7/1.
//  Copyright © 2016年 Apress. All rights reserved.
//  表情键盘顶部的内容:scrollView + pageControl

#import "ZMLEmotionListView.h"
#import "ZMLEmotionPageView.h"
#import "UIView+ZMLFrame.h"
#import "ZMLKeyboardConst.h"

#define bottomBtnW      75

@interface ZMLEmotionListView() <UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIScrollView *bottomScrollView;
@property (nonatomic, weak) UIPageControl *pageControl;
// 发送按钮
@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic, strong) NSArray<ZMLEmotion *> *emotions;
@property (nonatomic, strong) NSArray *bottomArray;
@property (nonatomic, strong) NSArray *bottomHighArray;
// 点击了表情中的删除按钮回调
@property (nonatomic, copy) void (^emotionDidDeleteBlock)();
// 点击了表情中的发送按钮回调
@property (nonatomic, copy) void (^emotionDidSendBlock)();
// 点击了表情中的某一个表情回调
@property (nonatomic, copy) void (^emotionDidSelectBlock)(ZMLEmotion *emotion);


@end

@implementation ZMLEmotionListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.pagingEnabled = YES;
        scrollView.delegate = self;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:scrollView];
        self.scrollView = scrollView;
        
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.hidesForSinglePage = YES;
        pageControl.userInteractionEnabled = NO;
        pageControl.currentPageIndicatorTintColor = ZMLRGB(66, 66, 66);
        pageControl.pageIndicatorTintColor = ZMLRGB(150, 150, 150);
        [self addSubview:pageControl];
        self.pageControl = pageControl;
        
        UIScrollView *bottomScroller = [[UIScrollView alloc] init];
        bottomScroller.backgroundColor = [UIColor whiteColor];
        bottomScroller.showsHorizontalScrollIndicator = NO;
        bottomScroller.showsVerticalScrollIndicator = NO;
        [self addSubview:bottomScroller];
        self.bottomScrollView = bottomScroller;
        
    }
    return self;
}

- (void)setEmotions:(NSArray<ZMLEmotion *> *)emotions deleteBlock:(void (^)())deleteBlock sendBlock:(void (^)())sendBlock selectBlock:(void (^)(ZMLEmotion *emotion))selectBlock{
    
    self.emotionDidDeleteBlock = deleteBlock;
    self.emotionDidSelectBlock = selectBlock;
    self.emotionDidSendBlock = sendBlock;
    self.emotions = emotions;
}

- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSUInteger count = (emotions.count + ZMLEmotionPageSize - 1) / ZMLEmotionPageSize;
    
    NSInteger imageCount = self.bottomArray.count;
    self.pageControl.numberOfPages = count;
    
    for (int i = 0; i<count; i++) {
        ZMLEmotionPageView *pageView = [[ZMLEmotionPageView alloc] init];
        
        pageView.emotionDidDeleteBlock = self.emotionDidDeleteBlock;
        pageView.emotionDidSelectBlock = self.emotionDidSelectBlock;

        NSRange range;
        range.location = i * ZMLEmotionPageSize;
        // left：剩余的表情个数（可以截取的）
        NSUInteger left = emotions.count - range.location;
        if (left >= ZMLEmotionPageSize) { // 这一页足够20个
            range.length = ZMLEmotionPageSize;
        } else {
            range.length = left;
        }

        pageView.emotions = [emotions subarrayWithRange:range];
        [self.scrollView addSubview:pageView];
    }
    
    for (int j = 0; j < imageCount; j++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:self.bottomArray[j]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:self.bottomHighArray[j]] forState:UIControlStateSelected];
        btn.tag = 10000+j;
        if (j == 0) {
            btn.selected = YES;
        }
        [btn addTarget:self action:@selector(chooseEmoji:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomScrollView addSubview:btn];
    }
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 发送按钮
    CGSize size = self.sendButton.currentImage.size;
 
    
    self.scrollView.frame = CGRectMake(0, 0, kScreenWidth, 155);
    
    NSInteger imageCount = self.bottomArray.count;
    
    NSUInteger count = self.scrollView.subviews.count;
    
    for (int i = 0; i<count; i++) {
        ZMLEmotionPageView *pageView = self.scrollView.subviews[i];

        pageView.frame = CGRectMake(kScreenWidth * i, 0, kScreenWidth, 155);
    }
    
    self.scrollView.contentSize = CGSizeMake(count * self.scrollView.width, 155);
    
    self.pageControl.frame = CGRectMake(0, maxY(self.scrollView), kScreenWidth, 20);
    self.sendButton.frame = CGRectMake(kScreenWidth-size.width, height(self.frame)-size.height, size.width, size.height);
    
    
    self.bottomScrollView.frame = CGRectMake(0, minY(self.sendButton), kScreenWidth-size.width, size.height);
    
    
    for (int j = 0; j < imageCount; j++) {
        UIButton *btn = self.bottomScrollView.subviews[j];
        btn.frame = CGRectMake(bottomBtnW*j, 0, bottomBtnW, size.height);
    }
    self.bottomScrollView.contentSize = CGSizeMake(imageCount*bottomBtnW, size.height);
    
    
    ZEBLog(@"%@",NSStringFromCGRect(self.frame));
}

/**
 *  监听发送按钮点击
 */
- (void)sendButtonClick{
    !self.emotionDidSendBlock ?: self.emotionDidSendBlock();
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    double pageNo = scrollView.contentOffset.x / scrollView.width;
    self.pageControl.currentPage = (int)(pageNo + 0.5);
}

- (UIButton *)sendButton{
    if (_sendButton == nil) {
        _sendButton = [[UIButton alloc] init];
        [_sendButton setImage:ZMLKeyboardBundleImage(@"btn_comment_expression_send") forState:UIControlStateNormal];
        [self addSubview:_sendButton];
        [_sendButton addTarget:self action:@selector(sendButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}
- (NSArray *)bottomArray {
    if (_bottomArray == nil) {
        _bottomArray = @[@"chat_bar_emoji_normal"];
    }
    return _bottomArray;
}
- (NSArray *)bottomHighArray {

    if (_bottomHighArray == nil) {
        _bottomHighArray = @[@"chat_bar_emoji_highlight"];
    }
    return _bottomHighArray;
}
- (void)chooseEmoji:(UIButton *)btn {

    NSInteger tag = btn.tag - 10000;
    switch (tag) {
        case 0:
            [self addSubview:self.scrollView];
            break;
            
        default:
            break;
    }
}
@end
