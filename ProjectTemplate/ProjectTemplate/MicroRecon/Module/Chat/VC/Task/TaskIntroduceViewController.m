//
//  TaskIntroduceViewController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/31.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "TaskIntroduceViewController.h"
#import "ZMLPlaceholderTextView.h"

#define LeftMargin 15
#define PlText @"请输入描述内容，不能超过50个字"

@interface TaskIntroduceViewController ()<UITextViewDelegate> {
    
    ZMLPlaceholderTextView *_textView;
}


@end

@implementation TaskIntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = zGroupTableViewBackgroundColor;
    self.title = @"任务介绍";
    [self initall];
}
- (void)initall {
    [self setNavRightBarBtn];
    [self createUI];
}
- (void)setNavRightBarBtn {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    btn.titleLabel.font = ZEBFont(16);
    [btn addTarget:self action:@selector(saveName:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItems = [self.navigationItem rightItemsWithBarButtonItem:rightBar WithSpace:5];
}
//保存
- (void)saveName:(UIButton *)btn {
    
    if ([[LZXHelper isNullToString:_textView.text] isEqualToString:@""] || [_textView.text isEqualToString:PlText]) {
        [_textView resignFirstResponder];
        _textView.text = PlText;
        [self showHint:@"请输入任务介绍"];
        return;
    }
    self.block(self,_textView.text);
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createUI {
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreen_Width, 250)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    
    _textView = [[ZMLPlaceholderTextView alloc] init];
    _textView.frame = CGRectMake(LeftMargin, LeftMargin+64, kScreen_Width-2*LeftMargin, height(bgView.frame)-2*LeftMargin);
    _textView.tintColor = [UIColor redColor];
    _textView.font = ZEBFont(15);
    _textView.placeholderColor = [UIColor grayColor];
    _textView.placeholder = PlText;
    _textView.delegate = self;
    _textView.text = [LZXHelper isNullToString:self.text];
    _textView.textColor = [UIColor blackColor];
    [self.view addSubview:_textView];
    
    
}


- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    return YES;
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
