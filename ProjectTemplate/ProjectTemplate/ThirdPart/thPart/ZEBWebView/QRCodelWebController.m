//
//  NewDetailController.m
//  WCLDConsulting
//
//  Created by apple on 16/1/4.
//  Copyright © 2016年 Shondring. All rights reserved.
//

#import "QRCodelWebController.h"

@interface QRCodelWebController ()<UIWebViewDelegate>

// The main and only UIProgressView
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) NSTimer *fakeProgressTimer;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIWebView * web;
@property (nonatomic, weak) UIButton * backItem;
@property (nonatomic, weak) UIButton * closeItem;

@end

@implementation QRCodelWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self initNaviBar];
    [self initWebView];
    
    
}
- (void)initWebView {
    
    
    _web = [[UIWebView alloc]initWithFrame:CGRectZero];
    _web.delegate = self;
    _web.scrollView.showsHorizontalScrollIndicator = NO;
    _web.scrollView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_web];
    
    
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [self.progressView setTrackTintColor:[UIColor colorWithWhite:1.0f alpha:0.0f]];
    [self.progressView setFrame:CGRectMake(0, 64, self.view.frame.size.width, self.progressView.frame.size.height)];
    [self.progressView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
    
    
    //设置进度条颜色
    [self setTintColor:[UIColor colorWithRed:0.400 green:0.863 blue:0.133 alpha:1.000]];
    [self.view addSubview:self.progressView];
    
    
    
    if (![[LZXHelper isNullToString:_detailURL] isEqualToString:@""]) {
        
        self.view.backgroundColor = [UIColor grayColor];
        if ([ZEBUtils checkURLWWW:self.detailURL]) {
            self.detailURL = [NSString stringWithFormat:@"http://%@",self.detailURL];
        }else if ([ZEBUtils checkURL:self.detailURL]) {
            self.detailURL = [NSString stringWithFormat:@"http://www.%@",self.detailURL];
        }
        NSURL *url = [[NSURL alloc]initWithString:self.detailURL];
        
        [_web loadRequest:[NSURLRequest requestWithURL:url]];
        [_web mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.mas_equalTo(UIEdgeInsetsMake(64, 0, 0, 0));
            
        }];
    }

}
- (void)initNaviBar{
    
    UIView * backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    UIButton * backItem = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 56, 44)];
    [backItem setImage:[UIImage imageNamed:@"back_white"] forState:UIControlStateNormal];
    [backItem setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [backItem setTitle:@"返回" forState:UIControlStateNormal];
    [backItem setTitleEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
    [backItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [backItem addTarget:self action:@selector(clickedBackItem:) forControlEvents:UIControlEventTouchUpInside];
    self.backItem = backItem;
    [backView addSubview:backItem];
    
    UIButton * closeItem = [[UIButton alloc]initWithFrame:CGRectMake(44+12, 0, 44, 44)];
    [closeItem setTitle:@"关闭" forState:UIControlStateNormal];
    [closeItem setTintColor:[UIColor whiteColor]];
    [closeItem addTarget:self action:@selector(clickedCloseItem:) forControlEvents:UIControlEventTouchUpInside];
    closeItem.hidden = YES;
    self.closeItem = closeItem;
    [backView addSubview:closeItem];
    
    UIBarButtonItem * leftItemBar = [[UIBarButtonItem alloc]initWithCustomView:backView];
    self.navigationItem.leftBarButtonItem = leftItemBar;
    
}


#pragma mark - clickedBackItem
- (void)clickedBackItem:(UIBarButtonItem *)btn{
    if (self.web.canGoBack) {
        [self.web goBack];
        self.closeItem.hidden = NO;
    }else{
        [self clickedCloseItem:nil];
    }
}

#pragma mark - clickedCloseItem
- (void)clickedCloseItem:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    [self.progressView setTintColor:tintColor];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if (self.web.canGoBack) {
        self.closeItem.hidden = NO;
    }
    //NSLog(@"url: %@", request.URL.absoluteURL.description);
     [self fakeProgressViewStartLoading];
    
    return YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if(!self.web.isLoading) {
        [self fakeProgressBarStopLoading];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    if(!self.web.isLoading) {
       // self.codeStr = @"该网址无法访问";
        [self fakeProgressBarStopLoading];
    }
}

#pragma mark - Fake Progress Bar Control (UIWebView)

- (void)fakeProgressViewStartLoading {
    [self.progressView setProgress:0.0f animated:NO];
    [self.progressView setAlpha:1.0f];
    
    if(!self.fakeProgressTimer) {
        self.fakeProgressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f/60.0f target:self selector:@selector(fakeProgressTimerDidFire:) userInfo:nil repeats:YES];
    }
}
- (void)fakeProgressBarStopLoading {
    if(self.fakeProgressTimer) {
        [self.fakeProgressTimer invalidate];
        self.fakeProgressTimer = nil;
    }
    
    if(self.progressView) {
        [self.progressView setProgress:1.0f animated:YES];
        [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.progressView setAlpha:0.0f];
        } completion:^(BOOL finished) {
            [self.progressView setProgress:0.0f animated:NO];
        }];
    }
}

- (void)fakeProgressTimerDidFire:(id)sender {
    CGFloat increment = 0.005/(self.progressView.progress + 0.2);
    if([self.web isLoading]) {
        CGFloat progress = (self.progressView.progress < 0.75f) ? self.progressView.progress + increment : self.progressView.progress + 0.0005;
        if(self.progressView.progress < 0.95) {
            [self.progressView setProgress:progress animated:YES];
        }
    }
}

#pragma mark - Dealloc

- (void)dealloc {
    
    [self.web setDelegate:nil];
    
}
- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    [self.web stopLoading];
}
- (void)setCodeStr:(NSString *)codeStr {

    _codeStr = codeStr;
    [self createCodeLabel];
    
}
- (void)createCodeLabel {

    UILabel *codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, kScreenWidth-20, 100)];
    codeLabel.numberOfLines = 0;
    codeLabel.center = self.view.center;
    codeLabel.textColor = [UIColor grayColor];
    codeLabel.text = _codeStr;
    codeLabel.font = ZEBFont(15);
    codeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:codeLabel];
    
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
