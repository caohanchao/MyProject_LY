//
//  zebWebView.h
//  测试
//
//  Created by shining3d on 16/6/17.
//  Copyright © 2016年 shining3d. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@class ZEBWebView;
@protocol ZEBWebViewDelegate <NSObject>
@optional
- (void)zebwebView:(ZEBWebView *)webview didFinishLoadingURL:(NSURL *)URL;
- (void)zebwebView:(ZEBWebView *)webview didFailToLoadURL:(NSURL *)URL error:(NSError *)error;
- (void)zebwebView:(ZEBWebView *)webview shouldStartLoadWithURL:(NSURL *)URL;
- (void)zebwebViewDidStartLoad:(ZEBWebView *)webview;
@end

@interface ZEBWebView : UIView<WKNavigationDelegate, WKUIDelegate, UIWebViewDelegate>









#pragma mark - Public Properties

//zebdelegate
@property (nonatomic, weak) id <ZEBWebViewDelegate> delegate;

// The main and only UIProgressView
@property (nonatomic, strong) UIProgressView *progressView;
// The web views
// Depending on the version of iOS, one of these will be set
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIWebView *uiWebView;



#pragma mark - Initializers view
- (instancetype)initWithFrame:(CGRect)frame;


#pragma mark - Static Initializers
@property (nonatomic, strong) UIBarButtonItem *actionButton;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) UIColor *barTintColor;
@property (nonatomic, assign) BOOL actionButtonHidden;
@property (nonatomic, assign) BOOL showsURLInNavigationBar;
@property (nonatomic, assign) BOOL showsPageTitleInNavigationBar;

//Allow for custom activities in the browser by populating this optional array
@property (nonatomic, strong) NSArray *customActivityItems;

#pragma mark - Public Interface


// Load a NSURLURLRequest to web view
// Can be called any time after initialization
- (void)loadRequest:(NSURLRequest *)request;

// Load a NSURL to web view
// Can be called any time after initialization
- (void)loadURL:(NSURL *)URL;

// Loads a URL as NSString to web view
// Can be called any time after initialization
- (void)loadURLString:(NSString *)URLString;


// Loads an string containing HTML to web view
// Can be called any time after initialization
- (void)loadHTMLString:(NSString *)HTMLString;

@end
