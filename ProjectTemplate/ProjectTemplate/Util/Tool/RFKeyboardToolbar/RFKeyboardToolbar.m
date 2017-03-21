//
//  KeyboardToolbar.m
//
//  Created by caohanchao on 17/1/18.
//  Copyright (c) 2017 caohanchao All rights reserved.
//

#define ToolbarTag 50000

#import "RFKeyboardToolbar.h"

@interface RFKeyboardToolbar ()

@property (nonatomic,strong) UIView *toolbarView;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) CALayer *topBorder;
@property (nonatomic,strong) NSArray *buttonsToAdd;

//@property (nonatomic,copy) KeyboardToolBar_CallBack toolCallBack;

@end

@implementation RFKeyboardToolbar

+ (nonnull RFKeyboardToolbar *)sharedManager {
    
    static RFKeyboardToolbar *manager = nil;
    
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        manager = [[self alloc] init];
    });
    return manager;
}


- (id)initWithButtons:(NSArray*)buttons {
    self = [super initWithFrame:CGRectMake(0, 0, self.window.rootViewController.view.bounds.size.width, 40)];
    if (self) {
        _buttonsToAdd = buttons;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:[self inputAccessoryView]];
    }
    return self;
}

- (void)addToTextView:(UITextView *)textView  withCallBack:(KeyboardToolBar_CallBack)callBack{
    NSMutableArray *btnArray = [NSMutableArray array];
    for (int i = 0; i<3; i++) {
        UIButton *btn = [UIButton new];
//        btn.tag = ToolbarTag+i;
        [btnArray addObject:btn];
    }
    [self addToTextView:textView withButtons:btnArray withCallBack:callBack];
}

- (void)addToTextView:(UITextView *)textView withButtons:(NSArray *)buttons {
    RFKeyboardToolbar *keyboardToolbar = [[RFKeyboardToolbar alloc] initWithButtons:buttons];
    [textView setInputAccessoryView:keyboardToolbar];
}

- (void)addToTextView:(UITextView*)textView withButtons:(NSArray*)buttons withCallBack:(KeyboardToolBar_CallBack)callBack {

    RFKeyboardToolbar *keyboardToolbar = [[RFKeyboardToolbar alloc] initWithButtons:buttons];
    
    [textView setInputAccessoryView:keyboardToolbar];
    self.toolCallBack = callBack;
}

- (void)addToTextField:(UITextField *)textField withButtons:(NSArray *)buttons {
//    [RFToolbarButton setTextFieldForButton:textField];
    RFKeyboardToolbar *keyboardToolbar = [[RFKeyboardToolbar alloc] initWithButtons:buttons];
    [textField setInputAccessoryView:keyboardToolbar];
}

- (void)layoutSubviews {
    CGRect frame = _toolbarView.bounds;
    frame.size.height = 0.5f;
    
    _topBorder.frame = frame;
}

- (UIView*)inputAccessoryView {
    _toolbarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 40)];
    _toolbarView.backgroundColor = [UIColor colorWithWhite:0.973 alpha:1.0];
    _toolbarView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    _topBorder = [CALayer layer];
    _topBorder.frame = CGRectMake(0.0f, 0.0f, self.bounds.size.width, 0.5f);
    _topBorder.backgroundColor = [UIColor colorWithWhite:0.678 alpha:1.0].CGColor;
    
    [_toolbarView.layer addSublayer:_topBorder];
    [_toolbarView addSubview:[self fakeToolbar]];
    
    return _toolbarView;
}

- (UIScrollView*)fakeToolbar {
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 40)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _scrollView.showsHorizontalScrollIndicator = NO;
//    _scrollView.contentInset = UIEdgeInsetsMake(6.0f, 7.0f, 7.0f, 6.0f);
    
    NSUInteger index = 0;
    NSUInteger originX = 0;
    
    CGRect originFrame;
    CGFloat wSpace = (screenWidth()-60)/4;
    NSArray *imgArr = @[@"voice_carema",@"photo_carema",@"camera_camera"];
    
    for (UIButton *eachButton in _buttonsToAdd) {
        
        if (index == 0) {
            eachButton.frame = CGRectMake(wSpace+index*(20+wSpace),5, 18, 28);
        }else if (index == 1) {
            eachButton.frame = CGRectMake(wSpace+index*(20+wSpace),5, 29, 25.5);
        }else if (index == 2) {
            eachButton.frame = CGRectMake(wSpace+index*(20+wSpace),5, 27, 23.5);
        }
        //在正常状态下显示的背景图片
        [eachButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",imgArr[index]]] forState:UIControlStateNormal];
//        [eachButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_scrollView addSubview:eachButton];
        
        originX = originX + eachButton.bounds.size.width + 8;
        index++;
    }
    
    CGSize contentSize = _scrollView.contentSize;
    contentSize.width = originX - 8;
    _scrollView.contentSize = contentSize;
    
    return _scrollView;
}

- (void)btnClick:(UIButton *)btn {
    
    NSInteger tag = btn.tag % ToolbarTag;

    if (self.toolCallBack == nil) {
        return;
    }
//
    if (btn.tag == ToolbarTag) {
        self.toolCallBack();
    } else if (btn.tag == ToolbarTag + 1) {
        self.toolCallBack();
    } else if (btn.tag == ToolbarTag + 2) {
        self.toolCallBack();
    }
    
//    if (btn.tag == ToolbarTag) {
////        self.toolCallBack();
//        if (self.delegate && [self.delegate respondsToSelector:@selector(toolBarOfStyle:)]) {
//            [self.delegate toolBarOfStyle:KeyboardToolBarVoiceStyle];
//        }
//        
//    } else if (btn.tag == ToolbarTag + 1) {
//        if (self.delegate && [self.delegate respondsToSelector:@selector(toolBarOfStyle:)]) {
//            [self.delegate toolBarOfStyle:KeyboardToolBarPhotoStyle];
//        }
//
//    } else if (btn.tag == ToolbarTag + 2) {
//        if (self.delegate && [self.delegate respondsToSelector:@selector(toolBarOfStyle:)]) {
//            [self.delegate toolBarOfStyle:KeyboardToolBarVideoStyle];
//        }
//
//    }
    
}



@end
