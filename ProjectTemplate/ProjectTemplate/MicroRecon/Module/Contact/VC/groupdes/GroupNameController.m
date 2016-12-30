//
//  GroupNameController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/25.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "GroupNameController.h"
#import "GroupDesModel.h"

#define LeftMargin 15

@interface GroupNameController ()<UITextViewDelegate> {

    UITextView *_textView;
}

@end

@implementation GroupNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = @"群名片";
}
- (void)initall {
    [self setNavRightBarBtn];
    [self createUI];
}
- (void)setNavRightBarBtn {

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 40);
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    btn.titleLabel.font = ZEBFont(16);
    [btn addTarget:self action:@selector(saveName:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.rightBarButtonItems = [self.navigationItem rightItemsWithBarButtonItem:rightBar WithSpace:5];
    
}
//保存
- (void)saveName:(UIButton *)btn {
    [self.view endEditing:YES];
    if (!self.isgAdmin) {
        [self showHint:@"只有群主可以修改群名"];
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
        [self showHint:@"请输入群名称"];
        return;
    }
    if ([LZXHelper isNullToString:_textView.text].length > 14) {
        [self showHint:@"群名称不能超过14字"];
        return;
    }
    if ([[LZXHelper isNullToString:_textView.text] isEqualToString:_gDesModel.gname]) {
        [self showHint:@"未修改"];
        return;
    }
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    //删除输入文字前面的回车
    NSString *value = [_textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    params[@"action"] = @"change";
    params[@"alarm"] = alarm;
    params[@"token"] = token;
    params[@"gid"] = _gDesModel.gid;
    params[@"key"] = @"1";
    params[@"value"] = value;
    
    [HYBNetworking postWithUrl:ChangeGroupDesUrl refreshCache:YES params:params success:^(id response) {
        [self hideHud];
        ZEBLog(@"--------%@",response);
        if ([response[@"resultmessage"] isEqualToString:@"成功"]) {
            [[[DBManager sharedManager] GrouplistSQ] updateGroupName:value gid:_gDesModel.gid];
            if (_delegate && [_delegate respondsToSelector:@selector(groupNameControllerRefresh:name:)]) {
                [_delegate groupNameControllerRefresh:self name:value];
            }
            [self showHint:@"修改成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else if ([response[@"resultmessage"] isEqualToString:@"群名或任务名已存在"]) {
            [self showHint:@"群名或任务名已存在"];
        }else {
            
            [self showHint:@"修改失败"];
            
        }
        
    } fail:^(NSError *error) {
        
        [self showHint:@"修改失败"];
        
    }];
}
- (void)createUI {

    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreen_Width, 250)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    
    _textView = [[UITextView alloc] init];
    _textView.frame = CGRectMake(LeftMargin, LeftMargin+64, kScreen_Width-2*LeftMargin, height(bgView.frame)-2*LeftMargin);
    _textView.tintColor = [UIColor redColor];
    _textView.font = ZEBFont(18);
    [_textView becomeFirstResponder];
    _textView.textColor = [UIColor blackColor];
    _textView.delegate = self;
    [self.view addSubview:_textView];
    
    
}


- (void)textViewDidBeginEditing:(UITextView *)textView {


}
- (void)textViewDidEndEditing:(UITextView *)textView {

    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    return YES;
}






- (void)setGDesModel:(GroupDesModel *)gDesModel {

    _gDesModel = gDesModel;
    
    [self initall];
    
    _textView.text = _gDesModel.gname;
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
