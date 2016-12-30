//
//  ChatGroupAtController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/2.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "ChatGroupAtController.h"
#import "GroupMemberModel.h"
#import "GroupMemberBaseModel.h"
#import "FZHPopView.h"
#import "ZEBSearchBar.h"

//#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
//#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
//#define SEARCHH 43
static CGFloat viewOffset = 64;

@interface ChatGroupAtController ()<UISearchBarDelegate, FZHPopViewDelegate> {

    
}

@property (nonatomic, strong) UILabel *resultLabel;
@property (nonatomic, strong) UIVisualEffectView *effectView;
@property (nonatomic, copy) NSString *gid;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *resultArray;
@property (nonatomic, strong) NSMutableArray *nameArray;
@property (nonatomic, strong) NSMutableArray *alarmArray;
@property (nonatomic, strong) ZEBSearchBar *searchBar;
@property (nonatomic, strong) FZHPopView *popView;

@end

@implementation ChatGroupAtController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = @"选择回复的人";
    [self initall];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    
}
- (NSMutableArray *)nameArray {
    
    if (_nameArray == nil) {
        _nameArray = [NSMutableArray array];
    }
    return _nameArray;
}
- (NSMutableArray *)alarmArray {
    
    if (_alarmArray == nil) {
        _alarmArray = [NSMutableArray array];
    }
    
    return _alarmArray;
}
- (NSMutableArray *)dataArray {

    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableArray *)resultArray {

    if (_resultArray == nil) {
        _resultArray = [NSMutableArray array];
    }
    return _resultArray;
}
- (void)initall {
    [self httpGetGroupMemberInfo];
    [self setLeftNavbar];
    [self setupSearchBar];
    [self setupPopView];
   
}

- (void)setLeftNavbar {

    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 50, 30);
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = ZEBFont(17);
    [btn addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = leftBar;

}
- (void)cancelBtn:(UIButton *)btn {

    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setupSearchBar{
    
    UIImage *bgImage = [LZXHelper buttonImageFromColor:[UIColor groupTableViewBackgroundColor]];
    self.searchBar = [[ZEBSearchBar alloc]init];
    self.searchBar.frame = CGRectMake(0, viewOffset, SCREEN_WIDTH, SEARCHH);
    
    [self.searchBar setBackgroundImage:bgImage];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"搜索";
    self.searchBar.returnKeyType = UIReturnKeySearch;
    
    [self.view addSubview:self.searchBar];
    
    _resultLabel = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentCenter font:ZEBFont(15) textColor:zGrayColor text:@"没有更多的搜索结果"];
    _resultLabel.frame = CGRectMake(0, 0, 200, 30);
    _resultLabel.center = CGPointMake(kScreen_Width/2, 79);
    _resultLabel.hidden = YES;
    [self.effectView addSubview:_resultLabel];
    
}
- (void)setupPopView{
    
    self.popView = [[FZHPopView alloc]init];
    self.popView.frame = CGRectMake(0, viewOffset+SEARCHH, SCREEN_WIDTH, SCREEN_HEIGHT - 64-SEARCHH);
    self.popView.fzhPopViewDelegate = self;
    [self.view addSubview:self.popView];
}
#pragma mark -
#pragma mark 请求群好友列表数据
- (void)httpGetGroupMemberInfo {
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSString *chatId = [[NSUserDefaults standardUserDefaults] objectForKey:@"chatId"];
    self.gid = chatId;
    NSString *urlString = [NSString stringWithFormat:FriendsLise_URL,alarm,@"3",chatId,token];
    
    
    ZEBLog(@"%@",urlString);
    
    [self showloadingName:@"正在加载"];
    [HYBNetworking getWithUrl:urlString refreshCache:YES success:^(id response) {
        
        
        GroupMemberBaseModel *baseModel = [GroupMemberBaseModel getInfoWithData:response];
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:baseModel.results];
        [self getSoureArray];//去除自己
        [self getSoureGArray];
        [self hideHud];
        
    } fail:^(NSError *error) {
        [self hideHud];
    }];
    
}
- (void)getSoureArray {

    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.dataArray];
    for (GroupMemberModel *model in tempArray) {
        if ([model.ME_uid isEqualToString:alarm]) {
            [self.dataArray removeObject:model];
        }
    }
    self.popView.dataSource = self.dataArray;
    [self.popView reloadData];
    
}
#pragma mark -UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    
    [self.view addSubview:self.effectView];
    _resultLabel.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        //1.
        self.navigationController.navigationBar.transform = CGAffineTransformMakeTranslation(0, -viewOffset);
        
        self.searchBar.transform = CGAffineTransformMakeTranslation(0, -NavigationBarHeight);
        
        //2.
        self.searchBar.showsCancelButton = YES;
        [self setupCancelButton];
        
        [self.popView showThePopViewWithArray];
    }];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {

    [self textFileGSearch:searchBar.text];
}

- (void)setupCancelButton{
    
    UIButton *cancelButton = [self.searchBar valueForKey:@"_cancelButton"];
    [cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    //[cancelButton addTarget:self action:@selector(cancelButtonClickEvent) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self cancelButtonClickEvent];
}
- (void)cancelButtonClickEvent{
    
    _resultLabel.hidden = YES;
    [self.effectView removeFromSuperview];
    [UIView animateWithDuration:0.3 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        //1.
        self.navigationController.navigationBar.transform = CGAffineTransformIdentity;
        self.searchBar.transform = CGAffineTransformIdentity;
        //2.
        self.searchBar.showsCancelButton = NO;
        [self.searchBar endEditing:YES];
        //3.
        [self.popView dismissThePopView];
    }];
    self.popView.dataSource = self.dataArray;
    [self.popView reloadData];
    self.searchBar.text = @"";
    self.searchBar.placeholder = @"搜索";
    
}
#pragma mark -FZHPopViewDelegate
-(void)getTheButtonTitleWithButton:(UIButton *)button{
    self.searchBar.placeholder = button.titleLabel.text;
    [self.searchBar setImage:[UIImage imageNamed:@"common"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    [self.popView dismissThePopView];
}
- (void)atAllMember:(FZHPopView *)view {
    
        NSMutableArray *array = [NSMutableArray array];
    for (GroupMemberModel *model in self.dataArray) {
        [array addObject:model.ME_uid];
        
    }
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"alarm"] = array;
    dic[@"name"] = @"所有人 ";
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ChatGroupAtNotification object:dic];
    
   
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)atOneMember:(FZHPopView *)view model:(GroupMemberModel *)model {

    [UIView animateWithDuration:0.2 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        //1.
        self.navigationController.navigationBar.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        dic[@"alarm"] = model.ME_uid;
        dic[@"name"] = [NSString stringWithFormat:@"%@ ",model.ME_nickname];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ChatGroupAtNotification object:dic];
        
        [self.navigationController popViewControllerAnimated:YES];
    }];

}

/**
 *  得到群成员的姓名和警号数组
 */
- (void)getSoureGArray {
    
    for (GroupMemberModel *gModel in self.dataArray) {
        [self.nameArray addObject:gModel.ME_nickname];
        [self.alarmArray addObject:gModel.ME_uid];
    }
    
}
#pragma mark -
#pragma mark 群成员搜索
-(void)textFileGSearch:(NSString *)TextField{
    
    
    if (TextField == nil || [TextField isEqualToString:@""]) {
        
        
        [self.popView reloadData];
        
    }
    //    // 完成具体的搜索功能
    //    // 1.清空搜索结果数组
    [self.resultArray removeAllObjects];
    
    int k = 0;
    
    //2。通过循环数据，找出与搜索关键字匹配的内容，把匹配的内容添加到数组中
    
    for (NSString *str in self.nameArray) {
        
        NSString *ste = [NSString stringWithFormat:@"%@",str];
        
        NSRange range = [ste rangeOfString:TextField];
        NSRange rangAlarm = [self.alarmArray[k] rangeOfString:TextField];
        
        if (range.length) {
            
            [self.resultArray addObject:self.dataArray[k]];
        }else {
            
            if (rangAlarm.length) {
                [self.resultArray addObject:self.dataArray[k]];
            }
        }
        
        k++;
        
    }
    if (self.resultArray.count == 0) {
        _resultLabel.hidden = NO;
        return;
    }else {
        [self.effectView removeFromSuperview];
    }

    self.popView.dataSource = self.resultArray;
    [self.popView reloadData];
    
    
}
- (UIVisualEffectView *)effectView {
    if (!_effectView) {
        /**  毛玻璃特效类型
         *   UIBlurEffectStyleExtraLight,
         *   UIBlurEffectStyleLight,
         *   UIBlurEffectStyleDark
         */
        UIBlurEffect * blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        //  毛玻璃视图
        _effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        //开启事件响应
        _effectView.userInteractionEnabled = YES;
        //添加到要有毛玻璃特效的控件中
        _effectView.frame = CGRectMake(0, TopBarHeight-5, kScreenWidth, kScreenHeight-TopBarHeight+5);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelButtonClickEvent)];
        [_effectView addGestureRecognizer:tap];
        
    }
    return _effectView;
}
- (void)fZHPopViewDidScroll:(FZHPopView *)fZHPopView {
    [self.searchBar endEditing:YES];
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
