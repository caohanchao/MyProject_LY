//
//  EditRollCallViewController.m
//  ProjectTemplate
//
//  Created by 李凯华 on 17/2/16.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "EditRollCallViewController.h"
#import "DuplicateViewController.h"
#import "CollCallPickerView.h"
#import "LKHTimePickerView.h"
#import "NSArray+JSON.h"
#import "XMLocationManager.h"
#import "LocationManager.h"
#import "AddGroupMemberController.h"
#import "GroupMemberModel.h"

#define LeftMargin 12

@interface EditRollCallViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,CollCallPickerViewDelegate,LKHTimePickerViewDelegate,AddGroupMemberControllerDelegate>

{
    NSDateFormatter* _formatter;
}

@property(nonatomic, strong) UITableView* collcallTableView;
@property(nonatomic, strong) UITextView * contentTextView;
@property(nonatomic,strong)UILabel * contentLabel;
@property(nonatomic, strong) NSArray* imageArray;
@property(nonatomic, strong) NSArray* titleArray;
@property(nonatomic, assign) CGFloat  dateWidth;

@property(nonatomic, strong) NSArray* selectIndexArray;

@property (nonatomic, strong) NSMutableArray *memberDataArray;
@property(nonatomic, strong) NSMutableArray* selecthpicArray;
@property(nonatomic, strong) NSMutableArray* selectNameArray;

//信息字符串数据源
@property(nonatomic, copy) NSString* nameStr;
@property(nonatomic, copy) NSString* dateStr;
@property(nonatomic, copy) NSString* timeStr;
@property(nonatomic, copy) NSString* limitStr;
@property(nonatomic, copy) NSString* weekStr;
@property(nonatomic, copy) NSString*userListStr;

//日历选择日期
@property(nonatomic,strong) CollCallPickerView *cuiPickerView;
//选择时间
@property(nonatomic,strong) LKHTimePickerView *timePickerView;

//有效时间
@property(nonatomic,strong) UIView *limitBgView;
@property(nonatomic,strong) UIView *limitView;
@property(nonatomic,strong) UIButton *firstBtn;
@property(nonatomic,strong) UIButton *secondBtn;
@property(nonatomic,strong) UIButton *threeBtn;

//位置
@property(nonatomic,strong) LocationManager *locationManager;
@property (nonatomic,copy)NSString *latitude;
@property (nonatomic,copy)NSString *longitude;

@end

@implementation EditRollCallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = zWhiteColor;
    self.title = @"编辑点名";
    [self installUI];
    
    [self initFormater];
}

- (void)installUI
{
    [self initData];
    
    [self createRightBtn];
    [self.view addSubview:self.collcallTableView];
    [self.view addSubview:self.cuiPickerView];
    [self.view addSubview:self.timePickerView];
    
    _selecthpicArray = [NSMutableArray array];
    _selectNameArray = [NSMutableArray array];
    
    //获取经纬度
    [self getLocation];
}

- (void)initData
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateWeekStr:) name:@"UpdateWeekStr" object:nil];
    
    _dateWidth = [LZXHelper textWidthFromTextString:@"1970 - 01 - 01" height:20 fontSize:13];
    _nameStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"name"];
    
    //分割时间
    NSArray *array = [self.deatilModel.start_time componentsSeparatedByString:@" "];
    if (array.count>1) {
        _dateStr = array[0];
        _timeStr = [array[1] substringToIndex:5];
    }
    else if (array.count>0)
    {
        _dateStr = array[0];
    }
    if ([self.deatilModel.isrepeat isEqualToString:@"0"]) {
         _weekStr = [self getselectWeek];
    }
    else{
         _weekStr = @"永不";
    }
    
    _limitStr = self.deatilModel.keeptime;
    
    
    //获取发送的人的姓名
    NSMutableArray * nameArr = [NSMutableArray array];
    for (CallTheRollUserListModel *mode in self.deatilModel.userlist) {
        if (![[LZXHelper isNullToString:mode.report_name] isEqualToString:@""]) {
            [nameArr addObject:mode.report_name];
            [self.memberDataArray addObject:mode.report_alarm];
        }
    }
    
    [self getAllUserName:nameArr];
}

- (void)initFormater {
    _formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
}

#pragma mark ----- 右上角确定按钮
- (void)createRightBtn
{
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 40, 35);
    [rightButton setTitle:@"确认" forState:UIControlStateNormal];
    [rightButton setTitleColor:CHCHexColor(@"ffffff") forState:UIControlStateNormal];
    rightButton.titleLabel.font = ZEBFont(16);
    [rightButton addTarget:self action:@selector(rightBtnToSure) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItems = [self.navigationItem rightItemsWithBarButtonItem:rightBar WithSpace:5];
}

#pragma mark -------- UITABLEVIEWDELEGATE/UITABLEVIEWDATASOURCE
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 2) {
//        return 3;
//    }
//    else
//    {
//        return 1;
//    }
    return [(NSArray*)self.titleArray[section]count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"collcall";
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    else
    {
        for (UIView * view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
    }
    
    cell.preservesSuperviewLayoutMargins = NO;
    cell.separatorInset = UIEdgeInsetsZero;
    cell.layoutMargins = UIEdgeInsetsZero;
    
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",self.imageArray[indexPath.section][indexPath.row]]];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.titleArray[indexPath.section][indexPath.row]];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = CHCHexColor(@"303030");
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section !=0&&indexPath.section !=1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    UILabel * textLabel = [[UILabel alloc]init];
    
    if (indexPath.section == 0) {
        [cell.contentView addSubview:self.contentTextView];
        [cell.contentView addSubview:self.contentLabel];
        self.contentTextView.text = self.deatilModel.title;
        self.contentLabel.hidden = YES;
    }
    else
    {
        CGFloat width = [LZXHelper textWidthFromTextString:@"周日 周一 周二 周三 周四 周五" height:20 fontSize:13];
        
        textLabel.font = [UIFont systemFontOfSize:13];
        textLabel.textColor = CHCHexColor(@"808080");
        textLabel.textAlignment = NSTextAlignmentRight;
        
        if (indexPath.section == 3) {
            textLabel.frame = CGRectMake(screenWidth()-37-width, 10, width, 20);
            if ([self.deatilModel.isrepeat isEqualToString:@"1"]) {
                textLabel.textColor = zBlueColor;
            }
        }
        else if (indexPath.section == 4)
        {
            textLabel.frame = CGRectMake(screenWidth()-37-width, 10, width, 20);
            textLabel.textColor = zBlueColor;
        }
        else
        {
            textLabel.frame = CGRectMake(screenWidth()-37-_dateWidth, 10, _dateWidth, 20);
        }
        
        [cell.contentView addSubview:textLabel];
    }
    
    if (indexPath.section == 1)
    {
        if ([[LZXHelper isNullToString:_nameStr] isEqualToString:@""]) {
            textLabel.text = @"";
        }
        else
        {
            textLabel.text = _nameStr;
        }
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            if ([self.deatilModel.isrepeat isEqualToString:@"0"]) {
                if ([[LZXHelper isNullToString:_timeStr] isEqualToString:@""]) {
                    textLabel.text = @"";
                }
                else
                {
                    textLabel.text = _timeStr;
                }
            }
            else
            {
                if ([[LZXHelper isNullToString:_dateStr] isEqualToString:@""]) {
                    textLabel.text = @"";
                }
                else
                {
                    textLabel.text = _dateStr;
                }
            }
        }
        else if (indexPath.row == 1)
        {
            if ([self.deatilModel.isrepeat isEqualToString:@"0"]) {
                if ([[LZXHelper isNullToString:_limitStr] isEqualToString:@""]) {
                    textLabel.text = @"";
                }
                else
                {
                    if ([_limitStr isEqualToString:@"0"]) {
                        textLabel.text = @"30分钟";
                    }
                    else if ([_limitStr isEqualToString:@"1"])
                    {
                        textLabel.text = @"一小时";
                    }
                    else if ([_limitStr isEqualToString:@"2"])
                    {
                        textLabel.text = @"两小时";
                    }
                }
            }
            else
            {
                if ([[LZXHelper isNullToString:_timeStr] isEqualToString:@""]) {
                    textLabel.text = @"";
                }
                else
                {
                    textLabel.text = _timeStr;
                }
            }
        }
        else if (indexPath.row == 2)
        {
            if ([[LZXHelper isNullToString:_limitStr] isEqualToString:@""]) {
                textLabel.text = @"";
            }
            else
            {
                if ([_limitStr isEqualToString:@"0"]) {
                    textLabel.text = @"30分钟";
                }
                else if ([_limitStr isEqualToString:@"1"])
                {
                    textLabel.text = @"一小时";
                }
                else if ([_limitStr isEqualToString:@"2"])
                {
                    textLabel.text = @"两小时";
                }
            }
        }
    }
    else if (indexPath.section == 3)
    {
        if ([self.deatilModel.isrepeat isEqualToString:@"0"]) {
            if ([[LZXHelper isNullToString:_weekStr] isEqualToString:@""]) {
                textLabel.text = @"";
            }
            else
            {
                textLabel.text = _weekStr;
            }
        }
        else
        {
            if ([[LZXHelper isNullToString:_userListStr] isEqualToString:@""]) {
                textLabel.text = @"";
            }
            else
            {
                textLabel.text = _userListStr;
            }
        }
    }
    else if (indexPath.section == 4)
    {
        if ([[LZXHelper isNullToString:_userListStr] isEqualToString:@""]) {
            textLabel.text = @"";
        }
        else
        {
            textLabel.text = _userListStr;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        if ([self.deatilModel.isrepeat isEqualToString:@"0"]) {
            if (indexPath.row == 0)
            {//开始时间
                [self chooseStartTime];
            }
            else if (indexPath.row == 1)
            {//有效时间
                [self chooseLimitTime];
                [self cuiPickerHide];
                [self timePickerHide];
            }
        }
        else
        {
            if (indexPath.row == 0)
            {//日期
                [self chooseDate];
            }
            else if (indexPath.row == 1)
            {//开始时间
                [self chooseStartTime];
            }
            else if (indexPath.row == 2)
            {//有效时间
                [self chooseLimitTime];
                [self cuiPickerHide];
                [self timePickerHide];
            }
        }
    }
    else if (indexPath.section == 3)
    {
        if ([self.deatilModel.isrepeat isEqualToString:@"0"]) {
            //重复
            DuplicateViewController * duplicateVC = [[DuplicateViewController alloc]init];
            duplicateVC.IndexArray = _selectIndexArray;
            duplicateVC.rollCallType = @"edit";
            [self.navigationController pushViewController:duplicateVC animated:YES];
        }
        else
        {
            //选择发送给谁
            for (CallTheRollUserListModel *mode in self.deatilModel.userlist) {
                [_selectNameArray addObject:mode.report_name];
                [_selecthpicArray addObject:mode.report_headpic];
            }
            
            NSMutableArray * tempArray = [NSMutableArray array];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *cachesDirectory = [paths objectAtIndex:0];
            for (int i = 0; i<self.memberDataArray.count; i++) {
                NSString * str  = self.memberDataArray[i];
                
                GroupMemberModel * model = [[GroupMemberModel alloc]init];
                model.ME_uid = str;
                model.headpic =_selecthpicArray[i];
                model.ME_nickname = _selectNameArray[i];
                [tempArray addObject:model];
            }
            
            AddGroupMemberController * addController = [[AddGroupMemberController alloc]init];
            [addController.TempTMArray addObjectsFromArray:tempArray];
            [addController.selectTempTMArray addObjectsFromArray:tempArray];
            addController.fromeWhere = FromeGroupDes;
            addController.delegate = self;
            addController.gMCount = self.memberDataArray.count ;
            [self.navigationController pushViewController:addController animated:YES];
        }
    }
    else if (indexPath.section == 4)
    { //选择发送给谁
        for (CallTheRollUserListModel *mode in self.deatilModel.userlist) {
            [_selectNameArray addObject:mode.report_name];
            [_selecthpicArray addObject:mode.report_headpic];
        }
        
        NSMutableArray * tempArray = [NSMutableArray array];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachesDirectory = [paths objectAtIndex:0];
        for (int i = 0; i<self.memberDataArray.count; i++) {
            NSString * str  = self.memberDataArray[i];
            
            GroupMemberModel * model = [[GroupMemberModel alloc]init];
            model.ME_uid = str;
            model.headpic =_selecthpicArray[i];
            model.ME_nickname = _selectNameArray[i];
            [tempArray addObject:model];
        }
        
        AddGroupMemberController * addController = [[AddGroupMemberController alloc]init];
        [addController.TempTMArray addObjectsFromArray:tempArray];
        [addController.selectTempTMArray addObjectsFromArray:tempArray];
        addController.fromeWhere = FromeGroupDes;
        addController.delegate = self;
        addController.gMCount = self.memberDataArray.count ;
        [self.navigationController pushViewController:addController animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 130;
    }
    else
    {
        return 40;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1;
    }
    else
    {
        return 16;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(void)viewDidLayoutSubviews
{
    if ([self.collcallTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.collcallTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.collcallTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.collcallTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark ----- 输入框编辑状态监听、键盘取消第一响应
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length>0)
    {
        self.contentLabel.hidden = YES;
    }
    else
    {
        self.contentLabel.hidden = NO;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *string = [NSString stringWithFormat:@"%@%@", textView.text, text];
    if (string.length > CALL_MAXLENGTH){
        [self showloadingError:@"字数不能大于30!"];
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

#pragma mark ----- 所有控件
- (UITableView*)collcallTableView
{
    if (!_collcallTableView) {
        _collcallTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth(), screenHeight()) style:UITableViewStyleGrouped];
        _collcallTableView.showsVerticalScrollIndicator = NO;
        _collcallTableView.delegate = self;
        _collcallTableView.dataSource = self;
        _collcallTableView.separatorColor = CHCHexColor(@"EBEAF1");
        _collcallTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
        UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(textViewResign)];
        tableViewGesture.numberOfTapsRequired = 1;
        tableViewGesture.cancelsTouchesInView = NO;
        [_collcallTableView addGestureRecognizer:tableViewGesture];
    }
    return _collcallTableView;
}
//输入
-(UITextView*)contentTextView
{
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc]initWithFrame:CGRectMake(LeftMargin, 10, screenWidth()-LeftMargin*2, 130)];
        _contentTextView.font = [UIFont systemFontOfSize:14.0];
        _contentTextView.backgroundColor = zClearColor;
        _contentTextView.delegate = self;
    }
    return _contentTextView;
}
//占位字符
-(UILabel*)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(LeftMargin+5, 20, screenWidth()-LeftMargin*2-5, 20)];
        _contentLabel.text = @"请填写备注内容";
        _contentLabel.textColor = CHCHexColor(@"CBCBCB");
        _contentLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _contentLabel;
}
//图片
- (NSArray *)imageArray
{
    if (!_imageArray) {
        if ([self.deatilModel.isrepeat isEqualToString:@"0"]) {
            _imageArray = @[@[@""],@[@"icon_sponsor"],@[@"icon_start-time",@"icon_effective-time"],@[@"icon_repeat"],@[@"icon_@"]];
        }
        else
        {
            _imageArray = @[@[@""],@[@"icon_sponsor"],@[@"icon_date",@"icon_start-time",@"icon_effective-time"],@[@"icon_@"]];
        }
    }
    return _imageArray;
}
//标题
- (NSArray *)titleArray
{
    if (!_titleArray) {
        if ([self.deatilModel.isrepeat isEqualToString:@"0"]) {
            _titleArray = @[@[@""],@[@"发起人"],@[@"开始时间",@"有效时间"],@[@"重复"],@[@"发送给谁"]];
        }
        else
        {
            _titleArray = @[@[@""],@[@"发起人"],@[@"点名日期",@"开始时间",@"有效时间"],@[@"发送给谁"]];
        }
    }
    return _titleArray;
}
//日期选择
- (CollCallPickerView *)cuiPickerView {
    if (!_cuiPickerView) {
        _cuiPickerView = [CollCallPickerView new];
        _cuiPickerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200);
        _cuiPickerView.delegate = self;
        _cuiPickerView.backgroundColor = [UIColor whiteColor];
    }
    return _cuiPickerView;
}
//时间选择
- (LKHTimePickerView *)timePickerView {
    if (!_timePickerView) {
        _timePickerView = [LKHTimePickerView new];
        _timePickerView.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200);
        _timePickerView.delegate = self;
        _timePickerView.backgroundColor = [UIColor whiteColor];
    }
    return _timePickerView;
}

- (NSMutableArray *)memberDataArray {
    if (_memberDataArray == nil) {
        _memberDataArray = [NSMutableArray array];
    }
    return _memberDataArray;
}

#pragma mark ----- 取消第一响应
- (void)textViewResign
{
    [_contentTextView resignFirstResponder];
    [self cuiPickerHide];
    [self timePickerHide];
}

#pragma mark -----  选择日期
- (void)chooseDate
{
    [self timePickerHide];
    
    if (![[LZXHelper isNullToString:_dateStr]isEqualToString:@""]) {
        self.cuiPickerView.curDate = [_formatter dateFromString:[NSString stringWithFormat:@"%@ 00:00:00",_dateStr]];
    } else {
        self.cuiPickerView.curDate = [self getCurrentTime];
    }
    [_cuiPickerView showInView:self.view];
}
//获取当前时间
- (NSDate *)getCurrentTime {
    NSString *dateTime=[_formatter stringFromDate:[NSDate date]];
    NSDate *date = [_formatter dateFromString:dateTime];
    return date;
}

#pragma mark -----  选择开始时间
- (void)chooseStartTime
{
    [self cuiPickerHide];
    
    if (![[LZXHelper isNullToString:_timeStr]isEqualToString:@""]) {
        if ([[LZXHelper isNullToString:_dateStr] isEqualToString:@""]) {
            self.timePickerView.curDate = [_formatter dateFromString:[NSString stringWithFormat:@"1970-01-01 %@:00",_timeStr]];
        }
        else
        {
            self.timePickerView.curDate = [_formatter dateFromString:[NSString stringWithFormat:@"%@ %@:00",_dateStr,_timeStr]];
        }
    } else {
        self.timePickerView.curDate = [self getCurrentTime];
    }
    [_timePickerView showInView:self.view];
}

#pragma mark -----  选择有效时间
- (void)chooseLimitTime
{
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    [self.view addSubview:self.limitBgView];
    [self.view addSubview:self.limitView];
    [self.limitView addSubview:self.firstBtn];
    [self.limitView addSubview:self.secondBtn];
    [self.limitView addSubview:self.threeBtn];
    
    [UIView animateWithDuration:0.3f animations:^{
        weakSelf.limitView.frame = CGRectMake(0, screenHeight()-150, screenWidth(), 150);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark ------ 日期/时间选择相关操作
#pragma mark - PickViewDelegate
//日期选择完成回调
- (void)didFinishPickView:(NSString *)date
{
    self.dateStr = [NSString stringWithFormat:@"%@",date];
    NSIndexPath *index=[NSIndexPath indexPathForRow:0 inSection:2];
    [self.collcallTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index,nil] withRowAnimation:UITableViewRowAnimationNone];
}
//时间选择完成回调
- (void)timeDidFinishPickView:(NSString *)date
{
    self.timeStr = [NSString stringWithFormat:@"%@",date];
    if ([self.deatilModel.isrepeat isEqualToString:@"0"]) {
        NSIndexPath *index=[NSIndexPath indexPathForRow:0 inSection:2];
        [self.collcallTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
    else
    {
        NSIndexPath *index=[NSIndexPath indexPathForRow:1 inSection:2];
        [self.collcallTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
}
//点击蓝色区域消失
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    
    [self cuiPickerHide];
    [self timePickerHide];
}
//日期选择消失
- (void)cuiPickerHide
{
    if (!self.cuiPickerView) {
        return;
    }else {
        [self.cuiPickerView hiddenPickerView];
    }
}
//时间选择消失
- (void)timePickerHide
{
    if (!self.timePickerView) {
        return;
    }else {
        [self.timePickerView hiddenPickerView];
    }
}
#pragma mark ------ 有效时间选择相关页面与操作
- (UIView*)limitBgView
{
    if (!_limitBgView) {
        _limitBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth(), screenHeight())];
        _limitBgView.backgroundColor = zClearColor;
        
        UITapGestureRecognizer *limitGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(limitHide)];
        limitGesture.numberOfTapsRequired = 1;
        limitGesture.cancelsTouchesInView = NO;
        [_limitBgView addGestureRecognizer:limitGesture];
    }
    return _limitBgView;
}

- (UIView*)limitView
{
    if (!_limitView) {
        _limitView = [[UIView alloc]initWithFrame:CGRectMake(0, screenHeight(), screenWidth(), 150)];
        _limitView.backgroundColor = zWhiteColor;
    }
    return _limitView;
}

- (UIButton*)firstBtn
{
    if (!_firstBtn) {
        _firstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _firstBtn.frame = CGRectMake(0, 0, screenWidth()+4, 49.5);
        [_firstBtn setTitle:@"30分钟" forState:UIControlStateNormal];
        [_firstBtn setTitleColor:CHCHexColor(@"303030") forState:UIControlStateNormal];
        _firstBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_firstBtn addTarget:self action:@selector(chooseLimit:) forControlEvents:UIControlEventTouchUpInside];
        _firstBtn.layer.borderColor = [LineColor CGColor];
        _firstBtn.layer.borderWidth = 1;
    }
    return _firstBtn;
}

- (UIButton*)secondBtn
{
    if (!_secondBtn) {
        _secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _secondBtn.frame = CGRectMake(0, 50, screenWidth()+4, 50);
        [_secondBtn setTitle:@"一小时" forState:UIControlStateNormal];
        [_secondBtn setTitleColor:CHCHexColor(@"303030") forState:UIControlStateNormal];
        _secondBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_secondBtn addTarget:self action:@selector(chooseLimit:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _secondBtn;
}

- (UIButton*)threeBtn
{
    if (!_threeBtn) {
        _threeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _threeBtn.frame = CGRectMake(0, 100, screenWidth()+4, 49.5);
        [_threeBtn setTitle:@"两小时" forState:UIControlStateNormal];
        [_threeBtn setTitleColor:CHCHexColor(@"303030") forState:UIControlStateNormal];
        _threeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_threeBtn addTarget:self action:@selector(chooseLimit:) forControlEvents:UIControlEventTouchUpInside];
        _threeBtn.layer.borderColor = [LineColor CGColor];
        _threeBtn.layer.borderWidth = 1;
    }
    return _threeBtn;
}
//选择有效时间
- (void)chooseLimit:(UIButton*)button
{
    if (button == self.firstBtn) {
        _limitStr = @"0";
    }
    else if (button == self.secondBtn)
    {
        _limitStr = @"1";
    }
    else if (button == self.threeBtn)
    {
        _limitStr = @"2";
    }
    
    if ([self.deatilModel.isrepeat isEqualToString:@"0"]) {
        NSIndexPath *index=[NSIndexPath indexPathForRow:1 inSection:2];
        [self.collcallTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
    else
    {
        NSIndexPath *index=[NSIndexPath indexPathForRow:2 inSection:2];
        [self.collcallTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    [self limitHide];
}

//移除有效时间选择
- (void)limitHide
{
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.3f animations:^{
        weakSelf.limitView.frame = CGRectMake(0, screenHeight(), screenWidth(), 150);
    } completion:^(BOOL finished) {
        [weakSelf removeLimitUI];
    }];
    
}
//移除有效时间控件
- (void)removeLimitUI
{
    [self.firstBtn removeFromSuperview];
    [self.secondBtn removeFromSuperview];
    [self.threeBtn removeFromSuperview];
    [self.limitView removeFromSuperview];
    [self.limitBgView removeFromSuperview];
}

//重复时间变化
- (void)updateWeekStr:(NSNotification *)infoDic
{
    NSString * tempStr = @"";
    
    _selectIndexArray = infoDic.userInfo[@"selectRow"];
    
//    if (_selectIndexArray.count==7) {
//        _weekStr = @"每天";
//    }
//    else
    if (_selectIndexArray.count==0)
    {
        _weekStr = @"永不";
    }
    else
    {
        for (NSString * str in _selectIndexArray) {
            NSString * string = [self changeStringToInt:str];
            
            if (![[LZXHelper isNullToString:tempStr] isEqualToString:@""])
            {
                _weekStr = [NSString stringWithFormat:@"%@，%@",tempStr,string];
            }
            else
            {
                _weekStr = [NSString stringWithFormat:@"%@",string];
            }
            tempStr = _weekStr;
        }
    }
    
    if ([self.deatilModel.isrepeat isEqualToString:@"0"]) {
        NSIndexPath *index=[NSIndexPath indexPathForRow:0 inSection:3];
        [self.collcallTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index,nil] withRowAnimation:UITableViewRowAnimationNone];
    }

}

- (NSString*)changeStringToInt:(NSString*)str
{
    NSString * string = @"";
    
    if ([str isEqualToString:@"0"]) {
        string = @"周日";
    }
    else if ([str isEqualToString:@"1"])
    {
        string = @"周一";
    }
    else if ([str isEqualToString:@"2"])
    {
        string = @"周二";
    }
    else if ([str isEqualToString:@"3"])
    {
        string = @"周三";
    }
    else if ([str isEqualToString:@"4"])
    {
        string = @"周四";
    }
    else if ([str isEqualToString:@"5"])
    {
        string = @"周五";
    }
    else if ([str isEqualToString:@"6"])
    {
        string = @"周六";
    }
    return string;
}
#pragma mark -- ---- 保存点名修改
- (void)rightBtnToSure
{
    //获取开始结束时间
    NSString * startTime = [self getStartTime];
    NSString * endTime = [self getEndTime];
    
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
    NSString * nowTime = [NSString stringWithFormat:@"%0.f",interval];
    
    if ([[LZXHelper isNullToString:self.contentTextView.text] isEqualToString:@""]) {
        [self showHint:@"请填写备注信息"];
        return;
    }
    
    if ([[LZXHelper isNullToString:_dateStr] isEqualToString:@""]||[[LZXHelper isNullToString:_timeStr] isEqualToString:@""]) {
        [self showHint:@"请选择开始时间"];
        return;
    }
    if ([[LZXHelper isNullToString:_limitStr] isEqualToString:@""]||[[LZXHelper isNullToString:endTime] isEqualToString:@""]) {
        [self showHint:@"请选择有效时间"];
        return;
    }
    
//    if ([startTime integerValue]<[nowTime integerValue]) {
//        [self showHint:@"不能选择过去的时间"];
//        return;
//    }
    
    if (!(self.memberDataArray.count>0)) {
        [self showHint:@"至少选择一个成员"];
        return;
    }
    
    //转换重复日期为01
    NSString * weekString = [self changeWeekToString];
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"action"] = @"createrallcall";
    paramDict[@"alarm"] = alarm;
    paramDict[@"token"] = token;
    paramDict[@"title"] = self.contentTextView.text;
    paramDict[@"starttime"] = [NSString stringWithFormat:@"%@ %@:00",self.dateStr,self.timeStr];
    paramDict[@"endtime"] = endTime;
    paramDict[@"rallcallid"] = self.deatilModel.rallcallid;
    paramDict[@"keeptime"] = self.limitStr;
    paramDict[@"week"] = weekString;
    paramDict[@"userlist"] = [self.memberDataArray toJSONString];
    
    [self showloadingName:@"正在保存"];
    
    [[HttpsManager sharedManager] post:ChangeAllCallUrl parameters:paramDict  progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response
                                                             options:NSJSONReadingMutableContainers error:nil];
        
        if ([dict[@"resultcode"] isEqualToString:@"0"]) {
            [self showHint:@"编辑成功"];
            [self hideHud];
            
            [self finishEdit];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self showHint:@"编辑失败"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showHint:@"连接失败，请稍后再试"];
    }];
}

//取消
- (void)leftBtnToCancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ------ 开始时间拼接转时间戳
- (NSString*)getStartTime
{
    
    NSDate *date = [self stringToDate:[NSString stringWithFormat:@"%@ %@:00",[self getNowDate],self.timeStr] withDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //转成时间戳
    NSString *startTime = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]*1000];
    
    return startTime;
}
#pragma mark ------ 算出结束时间转时间戳
- (NSString*)getEndTime
{
    NSDate *date = [self stringToDate:[NSString stringWithFormat:@"%@ %@:00",[self getNowDate],self.timeStr] withDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //转成时间戳
    NSString *endTime = @"";
    if ([self.limitStr isEqualToString:@"0"]) {
        endTime = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]*1000+60000*30];
    }
    else if ([self.limitStr isEqualToString:@"1"])
    {
        endTime = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]*1000+60000*60];
    }
    else if ([self.limitStr isEqualToString:@"2"])
    {
        endTime = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]*1000+60000*120];
    }
    
    
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // 毫秒值转化为秒
    NSDate* tdate = [NSDate dateWithTimeIntervalSince1970:[endTime doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:tdate];
    return dateString;
    
}
#pragma mark ------ 时间字符串转日期并转为中国时间
//字符串转日期格式
- (NSDate *)stringToDate:(NSString *)dateString withDateFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}


// 获取经纬度
-(void)getLocation
{
    self.locationManager = [LocationManager shareManager];
    [self.locationManager startLocation];
    
    __weak EditRollCallViewController *weakself = self;
    self.locationManager.locationCompleteBlock = ^(CLLocation *location){
        weakself.latitude = [NSString stringWithFormat:@"%.6lf",location.coordinate.latitude];
        weakself.longitude =[NSString stringWithFormat:@"%.6lf",location.coordinate.longitude];
    };
    [[XMLocationManager shareManager] requestAuthorization:nil];
    
}
#pragma  mark ------  选择的周几变成01
- (NSString*)changeWeekToString
{
    NSString * string = @"";
    
    NSString * string0 = @"0";
    NSString * string1 = @"0";
    NSString * string2 = @"0";
    NSString * string3 = @"0";
    NSString * string4 = @"0";
    NSString * string5 = @"0";
    NSString * string6 = @"0";
    if (_selectIndexArray.count >0) {
        for (NSString * str in _selectIndexArray) {
            if ([str isEqualToString:@"0"]) {
                string0 = @"1";
            }
            else if ([str isEqualToString:@"1"])
            {
                string1 = @"1";
            }
            else if ([str isEqualToString:@"2"])
            {
                string2 = @"1";
            }
            else if ([str isEqualToString:@"3"])
            {
                string3 = @"1";
            }
            else if ([str isEqualToString:@"4"])
            {
                string4 = @"1";
            }
            else if ([str isEqualToString:@"5"])
            {
                string5 = @"1";
            }
            else if ([str isEqualToString:@"6"])
            {
                string6 = @"1";
            }
        }
        string = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",string0,string1,string2,string3,string4,string5,string6];
    }
    else
    {
        string = self.deatilModel.week;
    }
    
    return string;
}

#pragma mark ------- 选择发送人
- (void)addGroupMemberController:(AddGroupMemberController *)con selectFRArray:(NSMutableArray *)FRArray selectTMArray:(NSMutableArray *)TMArray selectUTArray:(NSMutableArray *)UTArray selectTempFRArray:(NSMutableArray *)tempFRArray selectTempTMArray:(NSMutableArray *)tempTMArray selectTempUTArray:(NSMutableArray *)tempUTArray selGid:(NSString *)selGid {
    self.selectFRArray = tempFRArray;
    self.selectTMArray = tempTMArray;
    self.selectUTArray = tempUTArray;
    self.selGid = selGid;
    
    
    NSMutableArray *ridSameArray = [NSMutableArray array];
    NSMutableArray *nameArray = [NSMutableArray array];
    NSMutableArray *hpicArray = [NSMutableArray array];
    
    for (FriendsListModel *model1 in self.selectFRArray) {
        [ridSameArray addObject:model1.alarm];
        [nameArray addObject:model1.name];
        [hpicArray addObject:model1.headpic];
    }
    
    for (GroupMemberModel *model1 in self.selectTMArray) {
        [ridSameArray addObject:model1.ME_uid];
        [nameArray addObject:model1.ME_nickname];
        [hpicArray addObject:model1.headpic];
    }
    
    for (UserAllModel *model1 in self.selectUTArray) {
        [ridSameArray addObject:model1.RE_alarmNum];
        [nameArray addObject:model1.RE_name];
        [hpicArray addObject:model1.RE_headpic];
    }
    
    [self getAllUserName:nameArray];
    
    if ([self.deatilModel.isrepeat isEqualToString:@"0"]) {
        NSIndexPath *index=[NSIndexPath indexPathForRow:0 inSection:4];
        [self.collcallTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
    else
    {
        NSIndexPath *index=[NSIndexPath indexPathForRow:0 inSection:3];
        [self.collcallTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:index,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    [self.memberDataArray removeAllObjects];
    [self.memberDataArray addObjectsFromArray:ridSameArray];
    _selecthpicArray = hpicArray;
    _selectNameArray = nameArray;
}
#pragma mark ------ 拼接姓名
- (void)getAllUserName:(NSArray*)array
{
    NSString * tempStr = @"";
    _userListStr = @"";
    for (NSString * string in array) {
        
        if (![[LZXHelper isNullToString:tempStr] isEqualToString:@""])
        {
            _userListStr = [NSString stringWithFormat:@"%@,%@",tempStr,string];
        }
        else
        {
            _userListStr = [NSString stringWithFormat:@"%@",string];
        }
        tempStr = _userListStr;
    }
}

#pragma mark -
#pragma mark 返回选中周几的字符串
- (NSString *)getselectWeek {
    
    NSMutableArray * array = [NSMutableArray array];
    
    NSMutableString *string = [[NSMutableString alloc] initWithString:@""];
    NSMutableString *weekstring = self.deatilModel.week;
    if ([self.deatilModel.isrepeat isEqualToString:@"0"]) {
        for (int i = 0; i < weekstring.length; i++) {
            NSString *str = [NSString stringWithFormat:@"%c",[weekstring characterAtIndex:i]];
            if ([str isEqualToString:@"1"]) {
                switch (i) {
                    case 0:
                        [string  appendString:@"周日"];
                        [array addObject:@"0"];
                        break;
                    case 1: {
                        if (string.length == 0) {
                            [string appendString:@"周一"];
                        }else {
                            [string appendString:@"，周一"];
                        }
                        [array addObject:@"1"];
                    }
                        break;
                    case 2:
                        if (string.length == 0) {
                            [string appendString:@"周二"];
                        }else {
                            [string appendString:@"，周二"];
                        }
                        [array addObject:@"2"];
                        break;
                    case 3:
                        if (string.length == 0) {
                            [string appendString:@"周三"];
                        }else {
                            [string appendString:@"，周三"];
                        }
                        [array addObject:@"3"];
                        break;
                    case 4:
                        if (string.length == 0) {
                            [string appendString:@"周四"];
                        }else {
                            [string appendString:@"，周四"];
                        }
                        [array addObject:@"4"];
                        break;
                    case 5:
                        if (string.length == 0) {
                            [string appendString:@"周五"];
                        }else {
                            [string appendString:@"，周五"];
                        }
                        [array addObject:@"5"];
                        break;
                    case 6:
                        if (string.length == 0) {
                            [string appendString:@"周六"];
                        }else {
                            [string appendString:@"，周六"];
                        }
                        [array addObject:@"6"];
                        break;
                    default:
                        break;
                }
            }
        }
        _selectIndexArray = array;
    }
    return string;
}
//完成编辑回调详情页面刷新
- (void)finishEdit
{
    if (_delegate&&[_delegate respondsToSelector:@selector(finishEditRollCall:)]) {
        [_delegate finishEditRollCall:self];
    }
}

#pragma mark -----  获取当前日期
- (NSString*)getNowDate
{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
