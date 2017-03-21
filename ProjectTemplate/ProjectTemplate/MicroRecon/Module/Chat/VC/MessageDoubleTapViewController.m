//
//  MessageDoubleTapViewController.m
//  ProjectTemplate
//
//  Created by caohanchao on 2016/12/15.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "MessageDoubleTapViewController.h"
#import "MLEmojiLabel.h"

@interface MessageDoubleTapViewController ()<MLEmojiLabelDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate>

@property (nonatomic,strong)UIScrollView *scrollview;
@property (nonatomic,strong)UITextView *textLabel;

@end

@implementation MessageDoubleTapViewController

- (UITextView *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UITextView alloc] init];
        _textLabel.font =[UIFont systemFontOfSize:20];
        _textLabel.textColor = [UIColor blackColor];
        _textLabel.userInteractionEnabled = YES;
        _textLabel.editable = NO;
        _textLabel.dataDetectorTypes = NSUIntegerMax;
//        _textLabel.numberOfLines = 0;
//        _textLabel.backgroundColor = [UIColor blueColor];
//        _messageTextL.userInteractionEnabled = YES;
//        _textLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        _textLabel.emojiDelegate = self;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _textLabel;
}

- (UIScrollView *)scrollview {
    if (!_scrollview) {
        _scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth(), screenHeight())];
        _scrollview.bounces = NO;
        _scrollview.delegate = self;
        _scrollview.canCancelContentTouches = NO;
        _scrollview.delaysContentTouches = NO;
        _scrollview.scrollEnabled = YES;
//        _scrollview.contentInset = 
    }
    return _scrollview;
}

- (void)setTextStr:(NSString *)textStr {
    _textStr = textStr;
    _textLabel.text = _textStr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    
    
    
//    [self.view addSubview:self.scrollview];
    CGFloat height = [LZXHelper textHeightFromTextString:self.textStr width:screenWidth()-24 fontSize:20];
    
    if (height>screenHeight()) {
        self.textLabel.frame = CGRectMake(12, 12, screenWidth()-24, screenHeight()-24);
    }
    else {
        self.textLabel.frame = CGRectMake(12, 12, screenWidth()-24, height+20);
        self.textLabel.center = self.view.center;
    }


    self.textLabel.text = self.textStr;
    [self.view addSubview:self.textLabel];
    
//    if (height>screenHeight()) {
//        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.view);
//            make.top.equalTo (self.view.mas_top).offset(12);
//            make.width.offset(screenWidth()-24);
//            make.height.offset(height);
//        }];
//    }
//    else {
//        [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(self.view);
//            make.width.offset(screenWidth()-24);
////            make.height.offset(height);
//        }];
//    }
    
//    if (maxY(self.textLabel)< screenHeight()) {
//        self.scrollview.contentSize = CGSizeMake(screenWidth(), screenHeight());
//    } else {
//        self.scrollview.contentSize = CGSizeMake(screenWidth(),1000);
//    }
    
    
//    UIControl* overlayView = [[UIControl alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    overlayView.backgroundColor = [UIColor clearColor];
//    
//    [overlayView addTarget:self action:@selector(disMiss) forControlEvents:UIControlEventTouchUpInside];
//    
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMiss)];
//    [self.view addSubview:overlayView];
    ges.delegate = self;
    [self.view addGestureRecognizer:ges];
    
    
    
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}

- (void)disMiss{
    
    [self dismissViewControllerAnimated:YES completion:nil];
//    self.tapMissBlock();
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
