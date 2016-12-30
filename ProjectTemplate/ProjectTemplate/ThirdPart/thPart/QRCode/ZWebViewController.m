//
//  ZWebViewController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/2.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "ZWebViewController.h"
#import "ZEBWebView.h"

#define isiOS8 __IPHONE_OS_VERSION_MAX_ALLOWED>=__IPHONE_8_0

@interface ZWebViewController ()<ZEBWebViewDelegate>

@end

@implementation ZWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor grayColor];
    ZEBWebView *webView = [[ZEBWebView alloc] initWithFrame:self.view.bounds];
    [webView loadURLString:self.webURL];
    webView.delegate = self;
    [self.view addSubview:webView];
}

- (void)zlcwebViewDidStartLoad:(ZEBWebView *)webview
{
    ZEBLog(@"页面开始加载");

}

- (void)zlcwebView:(ZEBWebView *)webview shouldStartLoadWithURL:(NSURL *)URL
{

    ZEBLog(@"截取到URL：%@",URL);
}
- (void)zlcwebView:(ZEBWebView *)webview didFinishLoadingURL:(NSURL *)URL
{
    ZEBLog(@"页面加载完成");


}

- (void)zlcwebView:(ZEBWebView *)webview didFailToLoadURL:(NSURL *)URL error:(NSError *)error
{

    ZEBLog(@"加载出现错误");

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
