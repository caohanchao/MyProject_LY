//
//  ZEBEmotionsKeyboardView.m
//  GIF_Keyboard_Demo
//
//  Created by ZEB on 17/2/20.
//  Copyright © 2016年 ZEB. All rights reserved.
//

#import "ZEBEmotionsKeyboardView.h"
#import "Masonry.h"
#import "UIImage+Color.h"
#import "YYImage.h"
#import "ZEBEmotionsKeyboardViewModel.h"
#import "NSArray+Category.h"
#import "NSString+Property.h"

NSString * const GIFNameKey = @"GIFNameKey";
NSString * const GIFDatakey = @"GIFDataKey";

NSString * const PNGNameKey = @"PNGNameKey";
NSString * const PNGDatakey = @"PNGDataKey";

static NSInteger GIF_COL   = 4; //GIF   4列
static NSInteger GIF_ROW   = 2; //GIF   2行
static NSInteger EMOJI_COL = 7; //Emoji 7列
static NSInteger EMOJI_ROW = 3; //Emoji 3行
static NSInteger PNG_COL   = 4; //PNG   4列
static NSInteger PNG_ROW   = 2; //PNG   2行

static CGFloat EMOTION_KEYBOARD_SCALE = 0.85;    //表情区域 底部按钮bar 高度之比
static CGFloat EMOTION_GIF_SCALE      = 0.6;    //GIF表情缩放比例
static CGFloat EMOTION_EMOJI_SCALE    = 1.0;    //Emoji表情缩放比例
static CGFloat EMOTION_PNG_SCALE      = 0.65;    //PNG表情缩放比例

/**
 *  表情分类bar按钮触发事件类型
 */
typedef NS_ENUM(NSUInteger, EmotionCategoryType) {
    /**
     *  点击emoji
     */
    EmotionCategoryTypeEmoji,
    /**
     *  点击PNG
     */
    EmotionCategoryTypePNG,
    /**
     *  点击gif
     */
    EmotionCategoryTypeGIF,

};

@interface ZEBEmotionsKeyboardView ()
<
UIScrollViewDelegate
>

/**
 *  表情scrollView
 */
@property (nonatomic, strong) UIScrollView *emotionsScrollView;

/**
 *  实时记录contentSize的宽度
 */
@property (nonatomic, assign) CGFloat contentSizeWidth;

/**
 *  实时记录当前处于活动状态的表情分类（默认gif）
 */
@property (nonatomic, assign) EmotionCategoryType currentCategoryType;

/**
 *  上一次滚动区域的下标（默认为0）
 */
@property (nonatomic, assign) NSInteger beforeIndex;

/**
 *  pageControl
 */
@property (nonatomic, strong) UIPageControl *pageControl;

/**
 *  表情分类bar
 */
@property (nonatomic, strong) UIView *emotionCategoryBar;

/**
 *  底部表情分类bar 当前被选中按钮
 */
@property (nonatomic, strong) UIButton *currentSelectBtn;
// 发送按钮
@property (nonatomic, strong) UIButton *sendButton;

#pragma mark - GIF
/**
 *  gif图片
 */
@property (nonatomic, strong) NSArray *gifImageNames;

/**
 *  gif初始ContentOffSet
 */
@property (nonatomic, assign) CGPoint gifContentOffset;

/**
 *  gif模块 第一页的下标 （从0开始）
 */
@property (nonatomic, assign) NSInteger gifIndex;

#pragma mark - Emoji
/**
 *  emoji表情
 */
@property (nonatomic, strong) NSArray *emojiNames;

/**
 *  emoji初始ContentOffSet
 */
@property (nonatomic, assign) CGPoint emojiContentOffset;

/**
 *  emoji模块 第一页的下标
 */
@property (nonatomic, assign) NSInteger emojiIndex;

#pragma mark - PNG
/**
 *  png图片
 */
@property (nonatomic, strong) NSArray *pngImageNames;

/**
 *  png初始ContentOffSet
 */
@property (nonatomic, assign) CGPoint pngContentOffset;

/**
 *  png模块 第一页的下标
 */
@property (nonatomic, assign) NSInteger pngIndex;

/**
 切换
 */
@property (nonatomic, assign) BOOL change;

@end

@implementation ZEBEmotionsKeyboardView

#pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame delegate:(id<ZEBEmotionsKeyboardViewDelegate>)delegate gifImageNames:(NSArray *)gifImageNames emojiNames:(NSArray *)emojiNames pngImageNames:(NSArray *)pngImageNames
{
    if (self = [super initWithFrame:frame])
    {
        _delegate = delegate;
        _gifImageNames = gifImageNames;

        _emojiNames = emojiNames;
        _pngImageNames = pngImageNames;
        
        //1、加载子控件
        [self addAllSubViews];
        
        //2、设置emoji模块
        [self configureEmoji];
        //3、设置gif模块
        [self configurePNG];
        //4、设置gif模块
        [self configureGIF];
      
        //后续可以增加任意表情模块...
        
        
        //5、设置pageControl (默认Emoji被选中)
        [self configurePageControlWithZEBEmotionType:ZEBEmotionTypeEmoji currentPage:0];
        
        //6、设置scrollView
        [self configureEmotionScrollView];
        
        self.backgroundColor = [UIColor colorWithRed:235/255.0f green:236/255.0f blue:238/255.0f alpha:1.0f];
        
    }
    return self;
}


#pragma mark - private method

- (void)addAllSubViews
{
    [self addSubview:self.emotionsScrollView];
    [self addSubview:self.emotionCategoryBar];
    [self addSubview:self.pageControl];
    [self addSubview:self.sendButton];
    
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    // 发送按钮
    CGSize size = self.sendButton.currentImage.size;
    
    [self.emotionsScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.mas_equalTo(self);
        make.height.mas_equalTo(height*EMOTION_KEYBOARD_SCALE);
    }];
    
    [self.emotionCategoryBar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.mas_equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(height*(1-EMOTION_KEYBOARD_SCALE));
    }];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.width.mas_equalTo(size.width);
        make.height.equalTo(self.emotionCategoryBar.mas_height);
    }];
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(width, 10));
        make.centerX.mas_equalTo(self);
        make.bottom.mas_equalTo(self.emotionCategoryBar.mas_top).offset(-5);
    }];
}
- (void)configurePNG
{
    CGFloat width  = self.frame.size.width;
    CGFloat height = self.frame.size.height*EMOTION_KEYBOARD_SCALE;
    
    //单页数量
    NSInteger singlePageCount = PNG_COL * PNG_ROW;
    //实际gif图片数量
    NSInteger pngTotalCount = _pngImageNames.count;
    //实际需要png页数
    NSInteger pngPageCount = pngTotalCount%singlePageCount == 0 ? (pngTotalCount/singlePageCount) : (pngTotalCount/singlePageCount+1);
    
    //scrollView 添加 png页
    for (int i=0; i<pngPageCount; i++)
    {
        //获取本页的所有png图片
        NSArray *pngImageNames = [ZEBEmotionsKeyboardViewModel getPngEmotionsWithGifArray:_pngImageNames singleCount:singlePageCount index:i];
        
        //实例化png pageView
        CGRect frame = CGRectMake(self.contentSizeWidth+i*width, 0, width, height);
        ZEBPNGPageView *pngPageView = [[ZEBPNGPageView alloc] initWithFrame:frame pngImageNames:pngImageNames];
        
        typeof(self) __weak weakSelf = self;
        [pngPageView setClickPNGEmotionBlock:^(NSDictionary *gifDict) {
            
            //回调给controller...
            if ([self.delegate respondsToSelector:@selector(emotionsKeyboardView:emotionType:didUseEmoji:didUseGIF:)])
            {
                [self.delegate emotionsKeyboardView:weakSelf
                                        emotionType:ZEBEmotionTypePNG
                                        didUseEmoji:@""
                                          didUseGIF:gifDict];
            }
        
        }];
        
        //逐页添加
        [self.emotionsScrollView addSubview:pngPageView];
    }
    
    //记录gif模块的contentOffSet
    self.pngContentOffset = CGPointMake(self.contentSizeWidth, 0);
    
    //记录contentSize的宽度
    self.contentSizeWidth += width*pngPageCount;
    
    //记录gif模块首页的下标
    self.pngIndex = self.pngContentOffset.x / width;
}
- (void)configureGIF
{
    CGFloat width  = self.frame.size.width;
    CGFloat height = self.frame.size.height*EMOTION_KEYBOARD_SCALE;
    
    //单页数量
    NSInteger singlePageCount = GIF_COL * GIF_ROW;
    //实际gif图片数量
    NSInteger gifTotalCount = _gifImageNames.count;
    //实际需要gif页数
    NSInteger gifPageCount = gifTotalCount%singlePageCount == 0 ? (gifTotalCount/singlePageCount) : (gifTotalCount/singlePageCount+1);
    
    //scrollView 添加 gif页
    for (int i=0; i<gifPageCount; i++)
    {
        //获取本页的所有gif图片
        NSArray *gifImageNames = [ZEBEmotionsKeyboardViewModel getGifEmotionsWithGifArray:_gifImageNames singleCount:singlePageCount index:i];
        
        //实例化gif pageView
        CGRect frame = CGRectMake(self.contentSizeWidth+i*width, 0, width, height);
        ZEBGIFPageView *gifPageView = [[ZEBGIFPageView alloc] initWithFrame:frame gifImageNames:gifImageNames];
        
        typeof(self) __weak weakSelf = self;
        [gifPageView setClickGIFEmotionBlock:^(NSDictionary *gifDict) {
            
            //回调给controller...
            if ([self.delegate respondsToSelector:@selector(emotionsKeyboardView:emotionType:didUseEmoji:didUseGIF:)])
            {
                [self.delegate emotionsKeyboardView:weakSelf
                                        emotionType:ZEBEmotionTypeGIF
                                        didUseEmoji:@""
                                          didUseGIF:gifDict];
            }
            
        }];
        
        //逐页添加
        [self.emotionsScrollView addSubview:gifPageView];
    }
    
    //记录gif模块的contentOffSet
    self.gifContentOffset = CGPointMake(self.contentSizeWidth, 0);
    
    //记录contentSize的宽度
    self.contentSizeWidth += width*gifPageCount;
    
    //记录gif模块首页的下标
    self.gifIndex = self.gifContentOffset.x / width;
}
- (void)configureEmoji
{
    CGFloat width  = self.frame.size.width;
    CGFloat height = self.frame.size.height*EMOTION_KEYBOARD_SCALE;
    
    //单页数量 (每页emoji 右下角有个删除按钮)
    NSInteger singlePageCount = EMOJI_COL * EMOJI_ROW - 1;
    //实际emoji数量
    NSInteger emojiTotalCount = _emojiNames.count;
    //实际需要emoji页数
    NSInteger emojiPageCount = emojiTotalCount%singlePageCount == 0 ? (emojiTotalCount/singlePageCount) : (emojiTotalCount/singlePageCount+1);
    
    //scrollView 添加 emoji页
    for (int i=0; i<emojiPageCount; i++)
    {
        //获取本页的emoji
        NSArray *emojiArray = [ZEBEmotionsKeyboardViewModel getEmojiEmotionsWithEmojiArray:_emojiNames singleCount:singlePageCount index:i];
        
        //实例化emoji 单页
        CGRect frame = CGRectMake(self.contentSizeWidth+i*width, 0, width, height);
        ZEBEmojiPageView *emojiPageView = [[ZEBEmojiPageView alloc] initWithFrame:frame emojiArray:emojiArray];
        
        typeof(self) __weak weakSelf = self;
        [emojiPageView setClickEmojiEmotionBlock:^(NSString *emoji, BOOL isDelete) {
            
            if (isDelete)
            {
                //emoji 点击删除
                if ([weakSelf.delegate respondsToSelector:@selector(emotionsKeyboardView:emotionType:didDelete:)])
                {
                    [weakSelf.delegate emotionsKeyboardView:self emotionType:ZEBEmotionTypeEmoji didDelete:isDelete];
                }
            }
            else
            {
                //emoji 点击表情
                if ([weakSelf.delegate respondsToSelector:@selector(emotionsKeyboardView:emotionType:didUseEmoji:didUseGIF:)])
                {
                    [weakSelf.delegate emotionsKeyboardView:self emotionType:ZEBEmotionTypeEmoji didUseEmoji:emoji didUseGIF:nil];
                }
            }
            
        }];
        
        //逐页添加
        [self.emotionsScrollView addSubview:emojiPageView];
    }
    
    //记录emoji模块的contentOffSet (默认首个被选中)
    self.gifContentOffset = CGPointZero;
    
    //记录contentSize的宽度
    self.contentSizeWidth += width*emojiPageCount;
    
    //记录emoji模块首页的下标
    self.emojiIndex = self.emojiContentOffset.x / width;
}
- (void)configurePageControlWithZEBEmotionType:(ZEBEmotionType)type currentPage:(NSInteger)currentPage
{
    //单页数量
    NSInteger singlePageCount = 0;
    //总数量
    NSInteger totalCount = 0;
    //实际需要页数
    NSInteger pageCount = 0;
    
    switch (type) {
        case ZEBEmotionTypeGIF:
        {
            singlePageCount = GIF_COL * GIF_ROW;
            totalCount = _gifImageNames.count;
            pageCount = totalCount%singlePageCount == 0 ? (totalCount/singlePageCount) : (totalCount/singlePageCount+1);
        }
            break;
        case ZEBEmotionTypePNG:
        {
            singlePageCount = PNG_COL * PNG_ROW;
            totalCount = _pngImageNames.count;
            pageCount = totalCount%singlePageCount == 0 ? (totalCount/singlePageCount) : (totalCount/singlePageCount+1);
        }
            break;
        case ZEBEmotionTypeEmoji:
        {
            singlePageCount = EMOJI_COL * EMOJI_ROW - 1;
            totalCount = _emojiNames.count;
            pageCount = totalCount%singlePageCount == 0 ? (totalCount/singlePageCount) : (totalCount/singlePageCount+1);
        }
            break;
            
        default:
            break;
    }
    
    //更新pageControl
    self.pageControl.numberOfPages = pageCount;
    self.pageControl.currentPage = currentPage;
}
- (void)updateEmotionCategoryBar:(EmotionCategoryType)type
{
    //记录当前被选中的按钮
    self.currentSelectBtn = [self getButtonInCategoryBarWithEmotionCategoryType:type];
    
    //处理被选中高亮状态
    for (id obj  in self.emotionCategoryBar.subviews)
    {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)obj;
            if (btn.tag == type)
            {
                btn.selected = YES;
            }
            else
            {
                btn.selected = NO;
            }
        }
    }
}
- (void)configureEmotionScrollView
{
    //最后一步，设置scrollView 实际滚动范围
    self.emotionsScrollView.contentSize = CGSizeMake(self.contentSizeWidth, 0);
}
- (UIButton *)getButtonInCategoryBarWithEmotionCategoryType:(EmotionCategoryType)type
{
    for (id obj in self.emotionCategoryBar.subviews)
    {
        if ([obj isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)obj;
            if (btn.tag == type)
            {
                return btn;
            }
        }
        
    }
    return [UIButton buttonWithType:UIButtonTypeCustom];
}

#pragma mark - 点击事件

/**
 *  点击pageControl
 *
 *  @param pageControl
 */
- (void)pageChange:(UIPageControl *)pageControl
{
    CGFloat x = pageControl.currentPage * self.bounds.size.width;
    [self.emotionsScrollView setContentOffset:CGPointMake(self.emotionsScrollView.contentOffset.x+x, 0) animated:YES];
}
- (void)sendButtonClick {
    //点击发送 回调吧 -.-
    if ([self.delegate respondsToSelector:@selector(emotionsKeyboardView:didClickSend:)])
    {
        [self.delegate emotionsKeyboardView:self didClickSend:YES];
    }
}
/**
 *  点击底部工具bar
 *
 *  @param button
 */
- (void)clickEmotionsBar:(UIButton *)button
{
    if (self.currentSelectBtn == button)
    {
        return ;
    }
    
    self.change = YES;
    
    self.currentSelectBtn.selected = NO;
    self.currentSelectBtn = button;
    self.currentSelectBtn.selected = YES;
    
    switch (button.tag) {
        case EmotionCategoryTypeGIF:
        {
            //设置contenOffSet
            self.emotionsScrollView.contentOffset = self.gifContentOffset;
            
            //更新pagecontrol
            [self configurePageControlWithZEBEmotionType:ZEBEmotionTypeGIF currentPage:0];
            
            //更新beforeIndex
            self.beforeIndex = self.gifIndex;
            
            //更新当前选中按钮
            [self updateEmotionCategoryBar:EmotionCategoryTypeGIF];
            [self hiddenSendBtn:YES];
        }
            break;
        case EmotionCategoryTypePNG:
        {
            //设置contenOffSet
            self.emotionsScrollView.contentOffset = self.pngContentOffset;
            
            //更新pagecontrol
            [self configurePageControlWithZEBEmotionType:ZEBEmotionTypePNG currentPage:0];
            
            //更新beforeIndex
            self.beforeIndex = self.pngIndex;
            
            //更新当前选中按钮
            [self updateEmotionCategoryBar:EmotionCategoryTypePNG];
            [self hiddenSendBtn:YES];
        }
            break;
        case EmotionCategoryTypeEmoji:
        {
            self.emotionsScrollView.contentOffset = self.emojiContentOffset;
            [self configurePageControlWithZEBEmotionType:ZEBEmotionTypeEmoji currentPage:0];
            self.beforeIndex = self.emojiIndex;
            
            //更新当前选中按钮
            [self updateEmotionCategoryBar:EmotionCategoryTypeEmoji];
            [self hiddenSendBtn:NO];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark -
#pragma mark 隐藏发送按钮
- (void)hiddenSendBtn:(BOOL)ret {
    if (ret) {
        [UIView animateWithDuration:0.3 animations:^{
            self.sendButton.alpha = 0.0;
        }];
    }else {
        [UIView animateWithDuration:0.3 animations:^{
            self.sendButton.alpha = 1.0;
        }];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"start x ==> %lf", scrollView.contentOffset.x);
    //开始...
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"x ==> %lf", scrollView.contentOffset.x);
    
    //下标（每一页表情都有一个唯一的下标）
    
    //上次滚动区域的下标
    NSInteger beforeIndex = self.beforeIndex;
    
    //本次滚动区域的下标
    NSInteger afterIndex = scrollView.contentOffset.x / self.emotionsScrollView.frame.size.width;
    
    
    if (self.change) {
        self.change = NO;
        return;
    }
    if (beforeIndex == afterIndex)
    {
        return ;
    }
    else
    {
        
        //滚动范围：emoji模块内
        if ((self.emojiIndex <= beforeIndex && beforeIndex < self.pngIndex) &&
            (self.emojiIndex <= afterIndex  && afterIndex < self.pngIndex))
        {
            self.pageControl.currentPage = afterIndex;
            self.beforeIndex = afterIndex;
            return ;
        }
        
        //滚动范围：从 emoji模块 进入 png模块
        if ((self.emojiIndex <= beforeIndex && beforeIndex < self.pngIndex) &&
            (self.pngIndex <= afterIndex))
        {
            //更新pageControl
            [self configurePageControlWithZEBEmotionType:ZEBEmotionTypePNG currentPage:0];
            
            //更新当前选中按钮
            [self updateEmotionCategoryBar:EmotionCategoryTypePNG];
            
            self.beforeIndex = afterIndex;
            [self hiddenSendBtn:YES];
            return ;
        }
        
        //滚动范围：png模块内
        if ((self.pngIndex <= beforeIndex && beforeIndex < self.gifIndex) &&
            (self.pngIndex <= afterIndex  && afterIndex < self.gifIndex))
        {
            self.pageControl.currentPage = (afterIndex - self.pngIndex);
            self.beforeIndex = afterIndex;
      
            return ;
        }
        
        //滚动范围：从 png模块 进入 emoji模块
        if ((beforeIndex >= self.pngIndex) && (afterIndex < self.pngIndex))
        {
            [self configurePageControlWithZEBEmotionType:ZEBEmotionTypeEmoji currentPage:self.pngIndex-1];
            [self updateEmotionCategoryBar:EmotionCategoryTypeEmoji];
            self.beforeIndex = afterIndex;
            [self hiddenSendBtn:NO];
            return ;
        }
        
        //滚动范围：从 png模块 进入 gif模块
        if ((self.pngIndex <= beforeIndex && beforeIndex < self.gifIndex) &&
            (self.gifIndex <= afterIndex))
        {
            //更新pageControl
            [self configurePageControlWithZEBEmotionType:ZEBEmotionTypeGIF currentPage:0];
            
            //更新当前选中按钮
            [self updateEmotionCategoryBar:EmotionCategoryTypeGIF];
            
            self.beforeIndex = afterIndex;
      
            return ;
        }
        
        //滚动范围：gif模块内
        if ((beforeIndex >= self.gifIndex) && (afterIndex >= self.gifIndex))
        {
            self.pageControl.currentPage = (afterIndex - self.gifIndex);
            self.beforeIndex = afterIndex;
           
            return ;
        }
        
        //滚动范围：从 gif模块 进入 png模块
        if ((beforeIndex >= self.gifIndex) && (afterIndex < self.gifIndex))
        {
            [self configurePageControlWithZEBEmotionType:ZEBEmotionTypePNG currentPage:self.pngIndex-1];
            [self updateEmotionCategoryBar:EmotionCategoryTypePNG];
            self.beforeIndex = afterIndex;
            
            return ;
        }
        
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"end x ==> %lf", scrollView.contentOffset.x);
    //结束...
}


#pragma mark - getter

- (UIScrollView *)emotionsScrollView
{
    if (!_emotionsScrollView)
    {
        _emotionsScrollView = [[UIScrollView alloc] init];
        _emotionsScrollView.delegate = self;
        _emotionsScrollView.contentInset = UIEdgeInsetsZero;
        _emotionsScrollView.pagingEnabled = YES;
        _emotionsScrollView.scrollEnabled = YES;
        _emotionsScrollView.alwaysBounceHorizontal = YES;
        _emotionsScrollView.alwaysBounceVertical = NO;
        _emotionsScrollView.showsHorizontalScrollIndicator = NO;
        _emotionsScrollView.showsVerticalScrollIndicator = NO;
    }
    return _emotionsScrollView;
}
- (CGFloat)contentSizeWidth
{
    if (!_contentSizeWidth)
    {
        _contentSizeWidth = 0.f;
    }
    return _contentSizeWidth;
}
- (EmotionCategoryType)currentCategoryType
{
    if (!_currentCategoryType)
    {
        _currentCategoryType = EmotionCategoryTypeGIF;
    }
    return _currentCategoryType;
}
- (NSInteger)beforeIndex
{
    if (!_beforeIndex)
    {
        _beforeIndex = 0;
    }
    return _beforeIndex;
}
- (UIPageControl *)pageControl
{
    if (!_pageControl)
    {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
        //根据测试，微信的pagecontrol并没有触发事件
//        [_pageControl addTarget:self action:@selector(pageChange:) forControlEvents:UIControlEventTouchUpInside];
        _pageControl.userInteractionEnabled = NO;
    }
    return _pageControl;
}
- (UIButton *)sendButton{
    if (_sendButton == nil) {
        _sendButton = [[UIButton alloc] init];
        [_sendButton setImage:[UIImage imageNamed:@"btn_comment_expression_send"] forState:UIControlStateNormal];
        [self addSubview:_sendButton];
        [_sendButton addTarget:self action:@selector(sendButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}
- (UIView *)emotionCategoryBar
{
    if (!_emotionCategoryBar)
    {
        _emotionCategoryBar = [[UIView alloc] init];
        _emotionCategoryBar.backgroundColor = [UIColor whiteColor];
        
        //暂时加三个按钮
        NSArray *titles = @[ @"chat_bar_emoji_highlight",@"che_emotion",@"jing_emotion"];
        CGFloat width = 63;
        CGFloat height = self.frame.size.height*(1-EMOTION_KEYBOARD_SCALE);
        
        for (int i=0; i<titles.count; i++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(i*(width+0.5), 0, width, height);
            [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [button setImage:[UIImage imageNamed:titles[i]] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:235/255.0f green:236/255.0f blue:238/255.0f alpha:1.0f]] forState:UIControlStateSelected];
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button.frame), 5, 0.5, height-2*5)];
            line.backgroundColor = [UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1.0f];
            
            switch (i) {
                case 0:
                {
                    button.tag = EmotionCategoryTypeEmoji;
                    //默认Emoji按钮被选中
                    [self clickEmotionsBar:button];
                }
                    break;
                case 1:
                {
                    button.tag = EmotionCategoryTypePNG;
                }
                    break;
                case 2:
                {
                    button.tag = EmotionCategoryTypeGIF;
                }
                    break;
                    default:
                    break;
            }
            
            [button addTarget:self action:@selector(clickEmotionsBar:) forControlEvents:UIControlEventTouchUpInside];
            [_emotionCategoryBar addSubview:button];
            [_emotionCategoryBar addSubview:line];
        }
        
    }
    return _emotionCategoryBar;
}
- (UIButton *)currentSelectBtn
{
    if (!_currentSelectBtn)
    {
        //默认Emoji按钮被选中
        for ( id obj in self.emotionCategoryBar.subviews)
        {
            if ([obj isKindOfClass:[UIButton class]]) {
                UIButton *btn = (UIButton *)obj;
                if (btn.tag == EmotionCategoryTypeEmoji)
                {
                    _currentSelectBtn = btn;
                    break;
                }
            }
            
        }
    }
    return _currentSelectBtn;
}

@end

/**************************** GIF表情页 **************************************/

#pragma mark - GIF表情页

@interface ZEBGIFPageView ()

/**
 *  gif图片数组
 */
@property (nonatomic, strong) NSArray *gifImageNames;
@end

@implementation ZEBGIFPageView

- (instancetype)initWithFrame:(CGRect)frame gifImageNames:(NSArray *)gifImageNames
{
    if (self = [super initWithFrame:frame])
    {
        _gifImageNames = gifImageNames;
        
        CGFloat width  = self.frame.size.width  / GIF_COL;
        CGFloat height = self.frame.size.height / GIF_ROW;
        NSInteger count = _gifImageNames.count;
        for (int i=0; i<count; i++)
        {
            //行号
            NSInteger row = i/GIF_COL;
            //列号
            NSInteger col = i%GIF_COL;
            //x
            CGFloat x = width*col;
            //y
            CGFloat y = height*row;
            //y间距
            NSInteger margin = (row==0)?5:(row+1)*10;
            
            
            NSString *gifName = [_gifImageNames objectAtIndex:i];
            //实例化
            YYImage *gifImage = [YYImage imageNamed:gifName];
            YYAnimatedImageView *gifImageView = [[YYAnimatedImageView alloc] initWithImage:gifImage];
            gifImageView.frame = CGRectMake(x, y, width, height);
            gifImageView.tag = i;
            
            //根据缩放比例进行缩放
            CGSize originSize = gifImageView.frame.size;
            CGSize newSize = CGSizeMake(originSize.width*EMOTION_GIF_SCALE, originSize.height*EMOTION_GIF_SCALE);
            
            CGPoint originXY = gifImageView.frame.origin;
            CGPoint newXY = CGPointMake(originXY.x+(originSize.width-newSize.width)/2, originXY.y+(originSize.height-newSize.height)/2-margin);
          
            gifImageView.frame = (CGRect) {newXY, newSize};
            
            //添加点击事件
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickGIFImage:)];
            tap.numberOfTapsRequired    = 1;
            tap.numberOfTouchesRequired = 1;
            
            gifImageView.userInteractionEnabled = YES;
            [gifImageView addGestureRecognizer:tap];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(gifImageView.frame), CGRectGetMaxY(gifImageView.frame)+5, CGRectGetWidth(gifImageView.frame), 10)];
            titleLabel.textColor = [UIColor lightGrayColor];
            titleLabel.font = [UIFont systemFontOfSize:10];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.text = gifName.name;
            [self addSubview:titleLabel];
            
            [self addSubview:gifImageView];
        }
    }
    return self;
}
/**
 *  点击某个gif表情
 *
 *  @param tap
 */
- (void)clickGIFImage:(UITapGestureRecognizer *)tap
{
    NSInteger index = tap.view.tag;
    
    if (index < _gifImageNames.count)
    {
        NSString *gifName = [_gifImageNames objectAtIndexNotBeyond:index];
        
        YYImage *image = [YYImage imageNamed:gifName];
        
        NSData *gifData = image.animatedImageData;
        
        //回调...
        if (_clickGIFEmotionBlock)
        {
            NSDictionary *gifDict = @{GIFNameKey:gifName, GIFDatakey:gifData};
            
            _clickGIFEmotionBlock(gifDict);
        }
        
    }
    else
    {
        //数组越界...
        return ;
    }
}

@end


/**************************** Emoji表情页 **************************************/

#pragma mark - Emoji表情页

@interface ZEBEmojiPageView ()

/**
 *  emoji数组
 */
@property (nonatomic, strong) NSArray *emojiArray;
@end

@implementation ZEBEmojiPageView

- (instancetype)initWithFrame:(CGRect)frame emojiArray:(NSArray *)emojiArray
{
    if (self = [super initWithFrame:frame])
    {
        _emojiArray = emojiArray;
        
        CGFloat width  = self.frame.size.width  / EMOJI_COL;
        CGFloat height = self.frame.size.height / EMOJI_ROW;
        
        for (int i=0; i<EMOJI_COL*EMOJI_ROW; i++)
        {
            //行号
            NSInteger row = i/EMOJI_COL;
            //列号
            NSInteger col = i%EMOJI_COL;
            //x
            CGFloat x = width*col;
            //y
            CGFloat y = height*row;
            //y间距
            NSInteger margin = (row==0)?0:(row+1)*5;
            
            //实例化
            UIButton *emojiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            emojiBtn.titleLabel.font = [UIFont boldSystemFontOfSize:32];
            emojiBtn.adjustsImageWhenHighlighted = NO;
            emojiBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            //最后一个 emoji删除按钮
            if (i == EMOJI_COL*EMOJI_ROW-1)
            {
                [emojiBtn setBackgroundImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
                [emojiBtn setBackgroundImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
                emojiBtn.frame = CGRectMake(x, y, width, height);
                emojiBtn.tag = i;
                
                //根据缩放比例进行缩放
                CGSize originSize = emojiBtn.frame.size;
                CGPoint originXY = emojiBtn.frame.origin;
                
                CGSize newSize = CGSizeMake(36, 32);
                CGPoint newXY = CGPointMake(originXY.x+(originSize.width-newSize.width)/2, originXY.y+(originSize.height-newSize.height)/2-margin);
            
                emojiBtn.frame = (CGRect) {newXY, newSize};
            }
            //emoji正常按钮
            else
            {
                NSString *emojiStr = [_emojiArray objectAtIndexNotBeyond:i];
                
                if (emojiStr.length > 0)
                {
                    [emojiBtn setTitle:[_emojiArray objectAtIndexNotBeyond:i] forState:UIControlStateNormal];
//                    [emojiBtn setTitle:@"\ue415" forState:UIControlStateNormal];
                }
                else
                {
                    //不足一页，空位为nil
                    continue;
                }
                emojiBtn.frame = CGRectMake(x, y, width, height);
                emojiBtn.tag = i;
                
                //根据缩放比例进行缩放
                CGSize originSize = emojiBtn.frame.size;
                CGPoint originXY = emojiBtn.frame.origin;
                
                CGSize newSize = CGSizeMake(originSize.width*EMOTION_EMOJI_SCALE, originSize.height*EMOTION_EMOJI_SCALE);
                CGPoint newXY = CGPointMake(originXY.x+(originSize.width-newSize.width)/2, originXY.y+(originSize.height-newSize.height)/2-margin);
                
                emojiBtn.frame = (CGRect) {newXY, newSize};
                
            }

            //添加点击事件
            [emojiBtn addTarget:self action:@selector(clickEmojiOrDelete:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:emojiBtn];
        }
    }
    return self;
}

/**
 *  点击emoji表情 或者 删除按钮
 *
 *  @param btn
 */
- (void)clickEmojiOrDelete:(UIButton *)btn;
{
    if (btn.tag == EMOJI_COL*EMOJI_ROW-1)
    {
        //点击删除
        if (_clickEmojiEmotionBlock)
        {
            _clickEmojiEmotionBlock(@"", YES);
        }
    }
    else
    {
        //点击emoji
        if (_clickEmojiEmotionBlock)
        {
            NSString *emojiStr = [_emojiArray objectAtIndexNotBeyond:btn.tag];
            _clickEmojiEmotionBlock(emojiStr, NO);
        }
        
    }
}

@end



#pragma mark - PNG表情页
/**************************** PNG表情页 **************************************/


@interface ZEBPNGPageView ()

/**
 *  png图片数组
 */
@property (nonatomic, strong) NSArray *pngImageNames;
@end
@implementation ZEBPNGPageView

- (instancetype)initWithFrame:(CGRect)frame pngImageNames:(NSArray *)pngImageNames
{
    if (self = [super initWithFrame:frame])
    {
        _pngImageNames = pngImageNames;
        
        CGFloat width  = self.frame.size.width  / GIF_COL;
        CGFloat height = self.frame.size.height / GIF_ROW;
        NSInteger count = _pngImageNames.count;
        
        for (int i=0; i<count; i++)
        {
            //行号
            NSInteger row = i/GIF_COL;
            //列号
            NSInteger col = i%GIF_COL;
            //x
            CGFloat x = width*col;
            //y
            CGFloat y = height*row;
            //y间距
            NSInteger margin = (row==0)?0:(row+1)*10;
            
            //实例化
            YYImage *pngImage = [YYImage imageNamed:[_pngImageNames objectAtIndex:i]];
            UIImageView *pngImageView = [[UIImageView alloc] initWithImage:pngImage];
            pngImageView.frame = CGRectMake(x, y, width, height);
            pngImageView.tag = i;
            
            //根据缩放比例进行缩放
            CGSize originSize = pngImageView.frame.size;
            CGSize newSize = CGSizeMake(originSize.width*EMOTION_PNG_SCALE, originSize.height*EMOTION_PNG_SCALE);
            
            CGPoint originXY = pngImageView.frame.origin;
            CGPoint newXY = CGPointMake(originXY.x+(originSize.width-newSize.width)/2, originXY.y+(originSize.height-newSize.height)/2-margin);
            
            pngImageView.frame = (CGRect) {newXY, newSize};
            
            //添加点击事件
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPNGImage:)];
            tap.numberOfTapsRequired    = 1;
            tap.numberOfTouchesRequired = 1;
            
            pngImageView.userInteractionEnabled = YES;
            [pngImageView addGestureRecognizer:tap];
            
            
            [self addSubview:pngImageView];
        }
    }
    return self;
}
/**
 *  点击某个png表情
 *
 *  @param tap
 */
- (void)clickPNGImage:(UITapGestureRecognizer *)tap
{
    NSInteger index = tap.view.tag;
    
    if (index < _pngImageNames.count)
    {
        NSString *pngName = [_pngImageNames objectAtIndexNotBeyond:index];
        
        YYImage *image = [YYImage imageNamed:pngName];
        
        NSData *pngData =  UIImagePNGRepresentation(image);
        
        //回调...
        if (_clickPNGEmotionBlock)
        {
            NSDictionary *gifDict = @{PNGNameKey:pngName, PNGDatakey:pngData};
            
            _clickPNGEmotionBlock(gifDict);
        }
        
    }
    else
    {
        //数组越界...
        return ;
    }
}
@end














