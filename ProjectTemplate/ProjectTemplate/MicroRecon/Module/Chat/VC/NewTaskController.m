//
//  NewTaskController.m
//  ProjectTemplate
//
//  Created by caohanchao on 2016/11/1.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//


#define white_backgroundColor   [UIColor whiteColor]
//#define lineColor               [UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1.0f]
#define font_blackColor [UIColor blackColor]
#define font_grayColor [UIColor grayColor]

#define font() [UIFont systemFontOfSize:14]

#define textBeginColor  [UIColor colorWithHexString:@"#a4a4a4"]
#define textEndColor    [UIColor colorWithHexString:@"#000000"]
#define TaskContent     @"任务介绍..."
#define bgViewHeight     245
#define TOP             16


#import "NewTaskController.h"


@interface NewTaskController ()<UITextViewDelegate>

@property(nonatomic,copy)NSString *content;

@property(nonatomic,strong)UITextField *titleField;

@property(nonatomic,strong)UITextView *taskDesView;

@property(nonatomic,strong)UIView *bgView;


@end



@implementation NewTaskController

-(UITextView*)taskDesView
{
    if (!_taskDesView) {
        _taskDesView = [[UITextView alloc] init];
        _taskDesView.delegate = self;
        _taskDesView.font = font();
        _taskDesView.textAlignment = NSTextAlignmentLeft;
        _taskDesView.textColor = textBeginColor;
        _taskDesView.text = TaskContent;
    }
    return _taskDesView;

}

-(UITextField *)titleField
{
    if (!_titleField) {
        _titleField = [[UITextField alloc] init];
        _titleField.placeholder = @"任务名称";
        _titleField.textColor = textEndColor;
        _titleField.font = font();
        _titleField.textAlignment = NSTextAlignmentLeft;
        [_titleField setValue:textBeginColor forKeyPath:@"placeholderLabel.textColor"];
    }
    return _titleField;
}

-(UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = white_backgroundColor;
    }
    return _bgView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNav];
    
    [self createUI];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)createUI
{
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
    [self.view addSubview:self.bgView];
    
    
    UILabel *line1 =[UILabel new];
    line1.backgroundColor = LineColor;
    UILabel *line2 =[UILabel new];
    line2.backgroundColor = LineColor;
    UILabel *line3 =[UILabel new];
    line3.backgroundColor = LineColor;
    [self.bgView addSubview:line1];
    [self.bgView addSubview:line2];
    [self.bgView addSubview:line3];
    
    [self.bgView addSubview:self.titleField];
    [self.bgView addSubview:self.taskDesView];
    
   
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.view.mas_top).with.offset(64+TOP);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
        make.height.offset(bgViewHeight);
    }];
    
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.bgView.mas_top).offset(0);
        make.left.equalTo(self.bgView.mas_left).offset(0);
        make.right.equalTo(self.bgView.mas_right).offset(0);
        make.height.offset(0.5);
    }];
    [self.titleField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.bgView.mas_top).with.offset(0.5);
        make.left.equalTo(self.bgView.mas_left).with.offset(TOP+5);
        make.right.equalTo(self.bgView.mas_right).with.offset(0);;
        make.height.offset(44.5);
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.titleField.mas_bottom).offset(0);
        make.height.equalTo(@0.5);
        make.left.equalTo(self.titleField.mas_left).offset(0);
        make.right.equalTo(self.titleField.mas_right).offset(0);
    }];
    [self.taskDesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line2.mas_bottom).offset(0);
        make.height.equalTo(@199);
        make.left.equalTo(self.bgView.mas_left).offset(TOP);
        make.right.equalTo(self.bgView.mas_right).offset(0);
    }];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.taskDesView.mas_bottom).offset(0);
        make.height.offset(0.5);
        make.left.equalTo(self.bgView.mas_left).offset(0);
        make.right.equalTo(self.bgView.mas_right).offset(0);
    }];
    

    
    
}

-(void)createNav
{
    self.title = @"新建任务";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"chatmapBack"] style:UIBarButtonItemStylePlain target:self action:@selector(leftClick)];
}



#pragma mark - Click

-(void)rightClick
{
    [self.view endEditing:YES];

    [self httpRequest];
}

-(void)leftClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.taskDesView.text isEqual:TaskContent]) {
        self.taskDesView.text = @"";
    }
    self.taskDesView.textColor = textEndColor;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.content = textView.text;
    if ([textView.text isEqual:@""]) {
        self.taskDesView.text = TaskContent;
        self.taskDesView.textColor = textBeginColor;
    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - 网络请求
-(void)httpRequest
{

    self.titleField.text = [self.titleField.text trimWhitespaceAndNewline];
    
    if ([self.titleField.text isEqual:@""]) {
        
        [CHCUI presentAlertStyleDefauleForTitle:@"提示" andMessage:@"请您输入任务名称在提交" andCancel:^(UIAlertAction *action) {
            
        } andCompletion:^(UIAlertController *alert) {
            [self presentViewController:alert animated:YES completion:nil];
        }];
    }else
    {
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *chatId = [user objectForKey:@"chatId"];
        NSString *alarm = [user objectForKey:@"alarm"];
        NSString *token = [user objectForKey:@"token"];
        TeamsListModel *model =[[[DBManager sharedManager] GrouplistSQ] selectGrouplistById:chatId];
        
        param[@"alarm"]        =   alarm;
        param[@"token"]        =   token;
        param[@"grname"]       =   model.gname;
        param[@"suspectname"]  =   self.titleField.text;   //任务名称
        param[@"suspectdec"]   =   self.content;           //任务介绍
        param[@"action"]       =   @"createsuspect";
        param[@"gid"]          =   chatId;
        param[@"participant"]  =   model.memebers;         //参与人员
        param[@"type"]         =   @"0";                   //任务类型
        
        
        [self showloadingName:@"正在新建任务"];
        
        [[HttpsManager sharedManager] post:PublishTaskURL parameters:param progress:^(NSProgress * _Nonnull progress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:reponse
                                                                 options:NSJSONReadingMutableContainers error:nil];
            if ([dict[@"resultcode"] isEqualToString:@"1020"]) {
                [self showHint:@"任务名已存在"];
            }else if ([dict[@"resultcode"] isEqualToString:@"0"]) {
                [self showHint:@"新建任务成功"];
                [LYRouter openURL:@"ly://ChatMapAddAndChangeTask"];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [self showHint:@"新建任务失败"];
        }];
    }
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
