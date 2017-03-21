//
//  GroupTaskController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/25.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "GroupTaskController.h"
#import "GroupDesModel.h"
#import "ZMLPlaceholderTextView.h"


#define LeftMargin 15
#define PlText @"请输入描述内容，不能超过50个字"

@interface GroupTaskController ()<UITextViewDelegate> {

    ZMLPlaceholderTextView *_textView;
}

@end

@implementation GroupTaskController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = @"任务介绍";
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
    [self.view endEditing:YES];
    if (!self.isgAdmin) {
        [self showHint:@"只有群主可以修改群任务"];
        return;
    }
    [self httpCommitGroupInfo];
    
}
/*
 &action=change&alarm=%@&gid=%@&key=%@&value=%@&token=%@"//key 修改字段【“1”：群组名称】【“2”：任务介绍】
 */
#pragma mark -
#pragma mark 修改群名片
- (void)httpCommitGroupInfo {
    
    
    [self.view endEditing:YES];
    
    _textView.text = [_textView.text trimWhitespaceAndNewline];

    if ([[LZXHelper isNullToString:_textView.text] isEqualToString:@""]) {
        [self showHint:@"请输入任务介绍"];
        return;
    }
    if ([_textView.text isEqualToString:_gDesModel.description1]) {
        [self showHint:@"未修改"];
        return;
    }
    if ([LZXHelper isNullToString:_textView.text].length > 50) {
        [self showHint:@"任务介绍不能超过50字"];
        return;
    }
    
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    params[@"action"] = @"change";
    params[@"alarm"] = alarm;
    params[@"token"] = token;
    params[@"gid"] = _gDesModel.gid;
    params[@"key"] = @"2";
    params[@"value"] = _textView.text;
    
    
    [HYBNetworking postWithUrl:ChangeGroupDesUrl refreshCache:YES params:params success:^(id response) {
        
        ZEBLog(@"--------%@",response);
        if ([response[@"resultmessage"] isEqualToString:@"成功"]) {
            
            if (_delegate && [_delegate respondsToSelector:@selector(groupTaskControllerRefresh:intro:)]) {
                [_delegate groupTaskControllerRefresh:self intro:_textView.text];
            }
            [self showHint:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } fail:^(NSError *error) {
        
        [self showHint:@"修改失败"];
        
    }];
}
- (void)createUI {
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreen_Width, 250)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    
    _textView = [[ZMLPlaceholderTextView alloc] init];
    _textView.frame = CGRectMake(LeftMargin, LeftMargin+64, kScreen_Width-2*LeftMargin, height(bgView.frame)-2*LeftMargin);
    _textView.tintColor = [UIColor redColor];
    _textView.font = ZEBFont(15);
    _textView.textColor = [UIColor blackColor];
    _textView.placeholder = PlText;
    _textView.delegate = self;
    [self.view addSubview:_textView];
    
    
}


- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    
    
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    
    
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSString *string = [NSString stringWithFormat:@"%@%@", textView.text, text];
    if (string.length > CONTENT_MAXLENGTH){
        [self showloadingError:@"字数不能大于50!"];
        return NO;
    }
    if ([[[UITextInputMode currentInputMode]primaryLanguage] isEqualToString:@"emoji"])
    {
        [self showloadingError:@"输入格式有误!"];
        return NO;
    }
    if ([NSString containEmoji:text])
    {
        [self showloadingError:@"输入格式有误!"];
        return NO;
    }
  
    return YES;
}



- (void)setGDesModel:(GroupDesModel *)gDesModel {
    
    _gDesModel = gDesModel;
    
    [self initall];
    
    _textView.text = _gDesModel.description1;
    
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
