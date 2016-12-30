//
//  DynamicDetailsViewController.m
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/1.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "DynamicDetailsViewController.h"
#import "UserHomePageViewController.h"
#import "DownMenuView.h"
#import "SqureCell.h"
#import "DetailTopCell.h"
#import "HonourListViewController.h"
#import "CommentTableViewCell.h"
#import "PostInfoBaseModel.h"
#import "PostInfoModel.h"
#import "CommentModel.h"
#import "HZIndicatorView.h"
#import "HZImagesGroupView.h"
#import "HZPhotoBrowser.h"
#import "HZPhotoItemModel.h"
#import "UserInfoModel.h"
#import "UIViewController+BackButtonHandler.h"
#import "DetailCommentTF.h"

#define equalStr @"postComent"
#define circleCellHight 200//cell的固定高度
#define noPicCircleCellHight 111//没有图片cell的固定高度
#define commentCellHight 70//评论cell的固定高度
#define LeftMargin 12
#define inputViewHeight 43

@interface DynamicDetailsViewController ()<JHDownMenuViewDelegate,UITableViewDelegate,UITableViewDataSource,SqureCellDelegate,UIGestureRecognizerDelegate,HZPhotoBrowserDelegate>


@property (nonatomic, strong) DownMenuView *menuView;
@property (nonatomic,strong) UIScrollView * bigScrollView ;
@property (nonatomic,strong) UITableView * topTableView;
@property (nonatomic,strong) UIScrollView * praiseScrView;
@property (nonatomic,strong) UITableView * comTableView;
@property(nonatomic,strong) PostInfoBaseModel *  infoModel;
//@property(nonatomic,strong) NSMutableArray *  userArrayM;
//@property(nonatomic,strong) NSMutableArray *  commentArrayM;
@property(nonatomic,strong) NSDictionary *  infoDic;
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UIView * inputView;
@property (nonatomic,strong) DetailCommentTF * commentTF;
@property (nonatomic,strong) UIButton * sendBtn;
@property (nonatomic,strong)  NSArray *imageArray;

@property (assign, nonatomic) CGRect keyboardFrame;

@property(nonatomic,strong) NSArray *  userArrayM;
@property(nonatomic,strong) NSArray *  commentArrayM;

//@property(nonatomic,strong) NSString *  showkeyboard;

@end

@implementation DynamicDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = zGroupTableViewBackgroundColor;
    
    self.title = @"动态详情";
    
    [self initall];
    
    [self request_data];
    if ([_topTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_topTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([_topTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_topTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    if ([_showkeyboard isEqualToString:@"show" ]) {
//        
//        _showkeyboard = @"";
//    }
//    
//}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
     {
         _inputView.frame = CGRectMake(0, [LZXHelper getScreenSize].height-inputViewHeight, [LZXHelper getScreenSize].width, inputViewHeight);
     } completion:nil];
}

- (void)keyboardFrameWillShow:(NSNotification *)notification
{
    NSDictionary *dict = notification.userInfo;
    
    NSValue *value = [dict objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect rect = [value CGRectValue];
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^
     {
         _inputView.frame = CGRectMake(0, rect.origin.y-inputViewHeight, [LZXHelper getScreenSize].width, inputViewHeight);
         
     } completion:nil];
}

-(UIView*)inputView
{
    if (!_inputView)
    {
        _inputView = [[UIView alloc]initWithFrame:CGRectMake(0, [LZXHelper getScreenSize].height-inputViewHeight, [LZXHelper getScreenSize].width, inputViewHeight)];
        _inputView.backgroundColor =CHCHexColor(@"F5F5F5");
        
    }
    
    return _inputView;
}

-(DetailCommentTF*)commentTF
{
    if (!_commentTF)
    {
        _commentTF = [[DetailCommentTF alloc]initWithFrame:CGRectMake(LeftMargin, 8, [LZXHelper getScreenSize].width-85, 27)];
        _commentTF.borderStyle = UITextBorderStyleRoundedRect;
        _commentTF.placeholder = @"评论";
        _commentTF.textColor = CHCHexColor(@"000000");
    }
    
    return _commentTF;
}
-(UIButton*)sendBtn
{
    if (!_sendBtn)
    {
        _sendBtn = [[UIButton alloc]initWithFrame:CGRectMake([LZXHelper getScreenSize].width-61, 8, 49, 27)];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:CHCHexColor(@"ffffff")];
        [_sendBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
        [_sendBtn setTitleFont:FontNameAlNile size:12.0f];
        [_sendBtn setBackgroundImage:[UIImage imageNamed:@"criclerectangle"] forState:UIControlStateNormal];
        [_sendBtn addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}


-(UITableView*)topTableView
{
    if (!_topTableView)
    {
        _topTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [LZXHelper getScreenSize].width, [LZXHelper getScreenSize].height-inputViewHeight) style:UITableViewStylePlain];
        _topTableView.showsVerticalScrollIndicator = NO;
        _topTableView.showsHorizontalScrollIndicator = NO;
        _topTableView.delegate = self;
        _topTableView.dataSource = self;
        _topTableView.separatorInset = UIEdgeInsetsMake(0, -30, 0, 0);
        _topTableView.separatorColor = CHCHexColor(@"e5e5e6");
        
        _topTableView.tableFooterView = [[UIView alloc]init];
        _topTableView.tableFooterView.backgroundColor =CHCHexColor(@"e5e5e6");
        
        _topTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];
        tableViewGesture.numberOfTapsRequired = 1;
        tableViewGesture.cancelsTouchesInView = NO;
        
        [_topTableView addGestureRecognizer:tableViewGesture];
    }
    return _topTableView;
}


- (void)initall
{
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    
    if ([self.model.alarm isEqualToString:alarm])
    {
        [self createRightBarBtn];
        
        [self createDownMenu];
    }
    
    [self createAllUI];

}

#pragma mark  --------  delPost删除帖子

- (void)createRightBarBtn
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 30, 35);
    [button setImage:[UIImage imageNamed:@"threePoint"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItems = [self.navigationItem rightItemsWithBarButtonItem:rightBar WithSpace:5];
    
}

//右上按钮点击
-(void)rightBtnClick
{
    if (self.menuView.isShow) {
        [self.menuView dismiss];
    }else {
        [self.menuView show];
    }
}

//下拉删除菜单
- (void)createDownMenu
{
    //屏幕的宽度
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    //计算ableView的frame
    CGFloat ViewW = 120;
    CGFloat ViewH = 75/2;
    CGFloat ViewX = screenWidth - ViewW - 7;
    CGFloat ViewY = 65;
    
    DownMenuView *menuView = [[DownMenuView alloc]initWithFrame:CGRectMake(ViewX, ViewY, ViewW, ViewH)];
    menuView.delegate = self;
    self.menuView = menuView;
    
}


-(void)createAllUI
{
    
    [self.view addSubview:self.topTableView];
    
    [self.view addSubview:self.inputView];
    
    [self.inputView addSubview:self.commentTF];
    
    [self.inputView addSubview:self.sendBtn];
    
}

#pragma mark -
#pragma mark downmenuview代理实现
- (void)jHDownMenuView:(DownMenuView *)view tag:(NSInteger)tag {
    
    if (self.menuView.isShow) {
        [self.menuView dismiss];
    }else {
        [self.menuView show];
    }
    switch (tag) {
        case 0:
            [self delPost];
            break;
        case 1:

            break;
   
        default:
            break;
    }
    
}


#pragma mark -------  tableview
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 ||section == 1)
    {
        return 1;
    }
    else
    {
        return _commentArrayM.count+1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        static NSString *identifier = @"SqureCell";
        SqureCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[SqureCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.delegate = self;
        
        NSString*string = _model.picture;
        
        _imageArray = [string componentsSeparatedByString:@","];
        
        cell.postDetail = @"postDetail";
        cell.model = _model;
        cell.isShowPicture = YES;
        
        [cell.imageScrollview removeAllSubviews];
        HZImagesGroupView *imagesGroupView = [[HZImagesGroupView alloc] init];
        imagesGroupView.longPress = YES;
        NSMutableArray *temp = [NSMutableArray array];
        [_imageArray enumerateObjectsUsingBlock:^(NSString *src, NSUInteger idx, BOOL *stop) {
            HZPhotoItemModel *item = [[HZPhotoItemModel alloc] init];
            item.thumbnail_pic = src;
            [temp addObject:item];
        }];
        
        imagesGroupView.photoItemArray = [temp copy];
        [cell.imageScrollview addSubview:imagesGroupView];
        
        DynamicDetailsViewController  __weak * weakSelf = self;
        
        [cell setUserInfoBlock:^{
            UserHomePageViewController * userHomePageVC = [[UserHomePageViewController alloc]init];
            userHomePageVC.userIDStr = _model.alarm;
            [weakSelf.navigationController pushViewController:userHomePageVC animated:YES];
        }];
        
        [cell setCommentBlock:^{
           
            [_commentTF becomeFirstResponder];
        }];
        
        return cell;
    }
    else if (indexPath.section == 1)
    {
        static NSString *identifier = @"DetailTopCell";
        DetailTopCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[DetailTopCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.praiseAarray = _userArrayM;
        
        UILabel * topLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screenWidth(), 0.5)];
        topLineLabel.backgroundColor = CHCHexColor(@"e5e5e6");
        [cell.contentView addSubview:topLineLabel];
        
        UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 95/2-0.5, screenWidth(), 0.5)];
        lineLabel.backgroundColor = CHCHexColor(@"e5e5e6");
        [cell.contentView addSubview:lineLabel];
        
        return cell;
    }
    else
    {
        static NSString *identifier = @"cmIdentifier";
        CommentTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell == nil) {
            cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0)
        {
            CGFloat titleLabelWidth = [LZXHelper textWidthFromTextString:@"全部评论 99＋" height:20 fontSize:12.0f];
            
            _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, 10, titleLabelWidth , 20)];
            if (_commentArrayM.count>0)
            {
                _titleLabel.text = [NSString stringWithFormat:@"全部评论 %lu",(unsigned long)_commentArrayM.count];
            }
            else
            {
                _titleLabel.text = [NSString stringWithFormat:@"全部评论 "];
            }
            _titleLabel.textAlignment = NSTextAlignmentLeft;
            _titleLabel.numberOfLines = 1;
            _titleLabel.textColor = CHCHexColor(@"808080");
            _titleLabel.font = [UIFont systemFontOfSize:12.0f];
            [cell.contentView addSubview:_titleLabel];
            
            UILabel * topLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, screenWidth(), 0.5)];
            topLineLabel.backgroundColor = CHCHexColor(@"e5e5e6");
            [cell.contentView addSubview:topLineLabel];
            
            UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 39.5, screenWidth(), 0.5)];
            lineLabel.backgroundColor = CHCHexColor(@"e5e5e6");
            [cell.contentView addSubview:lineLabel];
            
        }
        else
        {
            if (_commentArrayM.count>0)
            {
                CommentModel * model = _commentArrayM[indexPath.row-1];
                cell.model =model;
                DynamicDetailsViewController  __weak * weakSelf = self;
                
                [cell setUserInfoBlock:^{
                    NSLog(@"点击信息");
                    UserHomePageViewController * userHomePageVC = [[UserHomePageViewController alloc]init];
                    userHomePageVC.userIDStr = model.alarm;
                    userHomePageVC.selectIDStr = model.alarm;
                    [weakSelf.navigationController pushViewController:userHomePageVC animated:YES];
                }];
            }
        }
        
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return ScalesHeight(0.1);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0||section == 1)
    {
        return ScalesHeight(12);
    }
    else
    {
        return ScalesHeight(0.1);
    }
}

CGFloat ScalesHeight(CGFloat height) {
    return ([UIScreen mainScreen].bounds.size.height/568.f) * height;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {//详情动态高度
        CGFloat contentHight;
        contentHight = [LZXHelper textHeightFromTextString:self.model.text width: screenWidth() - LeftMargin*2 fontSize:15];
        if ([[LZXHelper isNullToString:self.model.text] isEqualToString:@""]) {
            contentHight = 0;
        }
        
        if (self.model.picture.length>0)
        {
            return circleCellHight+contentHight;
        }
        else
        {
            return noPicCircleCellHight+contentHight;
        }
    }
    else if (indexPath.section == 1)
    {
        return 95/2;
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            return 40;
        }
        else
        {//评论cell动态高度
            if (_commentArrayM.count>0)
            {
                CommentModel * commentModel;
                if (_commentArrayM.count>0) {
                    commentModel = _commentArrayM[indexPath.row-1];
                }
                CGFloat comContentHight;
                comContentHight = [LZXHelper textHeightFromTextString:commentModel.content width: screenWidth() - LeftMargin*2 fontSize:15];
                return commentCellHight+comContentHight;
            }
            else
            {
                return commentCellHight;
            }
        }
    }
    else
    {
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        HonourListViewController * honourView = [[HonourListViewController alloc]init];
        
        honourView.honourArray = _userArrayM;
        [self.navigationController pushViewController:honourView animated:YES];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



//获取状态详情
- (void)request_data {
    // 如果需要请求网络数据, 再调用tableView的reloadData之后，调用下面resetContentInset方法可以消除底部多余空白
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"action"] = @"postinfo";
    paramDict[@"alarm"] = alarm;
    paramDict[@"token"] = token;
    paramDict[@"postid"] = self.model.postid;
    paramDict[@"mode"] = @"1";
    
    [[HttpsManager sharedManager] post:GetCircleList parameters:paramDict  progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {

          _infoModel = [PostInfoBaseModel getInfoWithData:response];
        
//        [[[DBManager sharedManager]postPraiseUserSQ]clearPostPraise];
//        [[[DBManager sharedManager]postCommentSQ]clearPostList];
        [[[DBManager sharedManager] postPraiseUserSQ]  deletePostListWithPostid:self.model.postid];
        [[[DBManager sharedManager]postCommentSQ]deletePostListByPuid:self.model.postid];
        
        [[[DBManager sharedManager]postPraiseUserSQ]transactionInsertPostPraiseModel:_infoModel.praiseuser  withPostID:self.model.postid];
        [[[DBManager sharedManager]postCommentSQ]transactionInsertPostCommentModel:_infoModel.commentinfo];
        
        _userArrayM = [[[DBManager sharedManager]postPraiseUserSQ]selectPostPraiseWithPostid:self.model.postid];
        _commentArrayM = [[[DBManager sharedManager]postCommentSQ]selectPostCommentWithPostID:self.model.postid];
 
        _model.praisenum = _infoModel.praisenum;
        _model.comment  = _infoModel.comment;
        
        self.model.comment = _infoModel.comment;
        
        if ([self.postComment isEqualToString:equalStr])
        {
            //点击评论进来
            [_commentTF becomeFirstResponder];
        }
        
        [_topTableView reloadData];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        _userArrayM = [[[DBManager sharedManager]postPraiseUserSQ]selectPostPraiseWithPostid:self.model.postid];
        _commentArrayM = [[[DBManager sharedManager]postCommentSQ]selectPostCommentWithPostID:self.model.postid];
        [_topTableView reloadData];
    }];
}


#pragma mark  ----- postPraise点赞
- (void)postPraise:(SqureCell *)praise
{
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    if ([self.model.ispraise isEqualToString:@"0"])
    {
        paramDict[@"action"] = @"setpraise";
    }
    else
    {
        paramDict[@"action"] = @"delpraise";
    }
    paramDict[@"alarm"] = alarm;
    paramDict[@"token"] = token;
    paramDict[@"postid"] = self.model.postid;
    paramDict[@"postuser"] = self.model.alarm;
    paramDict[@"mode"] = @"1";
    
    
    [[HttpsManager sharedManager] post:GetCircleList parameters:paramDict  progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response)
     {
         if ([self.model.ispraise isEqualToString:@"0"])
         {
             self.model.praisenum  = [NSString stringWithFormat:@"%d",[self.model.praisenum intValue]+1];
             self.model.ispraise = @"1";
             NSArray * array = [[NSArray alloc]init];
             
             if ([self.posttypes isEqualToString:@"all"])
             {
                 [self updateSQ];
                 array = [[[DBManager sharedManager] postListSQ]  selectPostListWithPostID:self.model.postid];
             }
             else if ([self.posttypes isEqualToString:@"follow"])
             {
                 [self updateSQ];
                 array = [[[DBManager sharedManager] followPostListSQ]  selectPostListWithPostID:self.model.postid];
             }
             else if ([self.model.posttype isEqualToString:@"0"])
             {
                 [self updateSQ];
                 array = [[[DBManager sharedManager] privacyPostListSQ]  selectPostListWithPostID:self.model.postid];
             }
             else
             {
                 [self updateSQ];
                 array = [[[DBManager sharedManager] privacyPostListSQ]  selectPostListWithPostID:self.model.postid];
             }
             
             if (array.count>0)
             {
                 self.model = array[0];
             }
             
             PostInfoModel * model = [[PostInfoModel alloc]init];
             model.alarm = alarm;
             UserInfoModel * userInfoModel = [[[DBManager sharedManager]userDetailSQ]selectUserDetail];
             model.headpic = userInfoModel.headpic;
             model.department = userInfoModel.department;
             model.name = userInfoModel.name;
             
             
             //获取当前时间并转为时间戳
             NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
             NSTimeInterval a=[date timeIntervalSince1970];
             NSString *timeString = [NSString stringWithFormat:@"%f", a];
             NSString * string = [timeString substringToIndex:10];
             
             model.time = string;
             
             [[[DBManager sharedManager] postPraiseUserSQ]  insertPostPraise:model withPostID:self.model.postid];
            _userArrayM = [[[DBManager sharedManager]postPraiseUserSQ]selectPostPraiseWithPostid:self.model.postid];
             
             [self transferNotification];
             
             [self.topTableView reloadData];
             
             [self showHint:@"点赞成功"];
         }
         else
         {
             self.model.praisenum  = [NSString stringWithFormat:@"%d",[self.model.praisenum intValue]-1];
             self.model.ispraise = @"0";
             
             NSArray * array = [[NSArray alloc]init];
             
             if ([self.posttypes isEqualToString:@"all"])
             {
                 [self updateSQ];
                 array = [[[DBManager sharedManager] postListSQ]  selectPostListWithPostID:self.model.postid];
             }
             else if ([self.posttypes isEqualToString:@"follow"])
             {
                [self updateSQ];
                 array = [[[DBManager sharedManager] followPostListSQ]  selectPostListWithPostID:self.model.postid];
             }
             else if ([self.model.posttype isEqualToString:@"0"])
             {
                 [self updateSQ];
                 array = [[[DBManager sharedManager] privacyPostListSQ]  selectPostListWithPostID:self.model.postid];
             }
             else
             {
                 [self updateSQ];
                 array = [[[DBManager sharedManager] privacyPostListSQ]  selectPostListWithPostID:self.model.postid];
             }
             if (array.count>0)
             {
                 self.model = array[0];
             }
             
             [[[DBManager sharedManager] postPraiseUserSQ]  deletePostListByPuid:alarm WithPostid:self.model.postid];
             _userArrayM = [[[DBManager sharedManager]postPraiseUserSQ]selectPostPraiseWithPostid:self.model.postid];
             
             [self transferNotification];
             
             [self.topTableView reloadData];
             
             [self showHint:@"取消成功"];
             
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSLog(@"失败");
     }];
    
}

#pragma mark ---  -- 删除帖子
- (void)delPost
{
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"action"] = @"delpost";
    paramDict[@"alarm"] = alarm;
    paramDict[@"token"] = token;
    paramDict[@"postid"] = self.model.postid;
    paramDict[@"mode"] = @"1";
    
    [[HttpsManager sharedManager] post:GetCircleList parameters:paramDict  progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
        
        if ([self.posttypes isEqualToString:@"all"])
        {
            [[[DBManager sharedManager]postListSQ]deletePostListByPuid:self.model.postid];
            [[NSNotificationCenter defaultCenter] postNotificationName:AllPostNotification object:nil];
            [[[DBManager sharedManager]followPostListSQ]deleteFollowPostListByPFuid:self.model.postid];
            [[NSNotificationCenter defaultCenter] postNotificationName:FollowPostNotification object:nil];
        }
        else if ([self.posttypes isEqualToString:@"follow"])
        {
            [[[DBManager sharedManager]postListSQ]deletePostListByPuid:self.model.postid];
            [[NSNotificationCenter defaultCenter] postNotificationName:AllPostNotification object:nil];
            [[[DBManager sharedManager]followPostListSQ]deleteFollowPostListByPFuid:self.model.postid];
            [[NSNotificationCenter defaultCenter] postNotificationName:FollowPostNotification object:nil];
        }
        else if ([self.model.posttype isEqualToString:@"0"])
        {
            [[[DBManager sharedManager]privacyPostListSQ]deletePrivacyPostListByPPuid:self.model.postid];
            [[NSNotificationCenter defaultCenter] postNotificationName:PrivacyPostNotification object:nil];
        }
        else
        {
            [[[DBManager sharedManager]privacyPostListSQ]deletePrivacyPostListByPPuid:self.model.postid];
            [[NSNotificationCenter defaultCenter] postNotificationName:PrivacyPostNotification object:nil];
        }
        
         [[[DBManager sharedManager]userPostInfoSQ]deleteUserPostInfoByPuid:self.model.postid];
         [[NSNotificationCenter defaultCenter] postNotificationName:UserCardPostNotification object:nil];
        
        [[[DBManager sharedManager]postPraiseUserSQ]deletePostListWithPostid:self.model.postid];
        [[[DBManager sharedManager]postCommentSQ]deletePostListByPuid:self.model.postid];
        
        [self.navigationController popViewControllerAnimated:YES];
        
        [self showHint:@"删除成功"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      //  [self showHint:@"点赞失败了，看看网络吧！"];
    }];
}


#pragma mark ---  -- sendComment发表评论
-(void)sendComment
{
    [self showloadingName:@"上传评论"];
    
    if (![[LZXHelper isNullToString:_commentTF.text] isEqualToString:@""])
    {
        NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
        paramDict[@"action"] = @"setcomment";
        paramDict[@"alarm"] = alarm;
        paramDict[@"token"] = token;
        paramDict[@"postid"] = self.model.postid;
        paramDict[@"mode"] = @"1";
        paramDict[@"postuser"] = self.model.alarm;
        paramDict[@"content"] = _commentTF.text;
        
        [[HttpsManager sharedManager] post:GetCircleList parameters:paramDict  progress:^(NSProgress * _Nonnull progress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
            
            CommentModel * model = [[CommentModel alloc]init];
            
            UserInfoModel * userInfoModel = [[[DBManager sharedManager]userDetailSQ]selectUserDetail];
            
            //获取当前时间并转为时间戳
            NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
            NSTimeInterval a=[date timeIntervalSince1970];
            NSString *timeString = [NSString stringWithFormat:@"%f", a];
            NSString * string = [timeString substringToIndex:10];
            
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
            NSNumber *numTemp = [numberFormatter numberFromString:string];
            
            model.alarm = alarm;
            model.department = userInfoModel.department;
            model.headpic = userInfoModel.headpic;
            model.name = userInfoModel.name;
            model.pushtime = numTemp ;
            model.content = _commentTF.text;
            model.postid = self.model.postid;
            
            self.model.comment  = [NSString stringWithFormat:@"%d",[self.model.comment intValue]+1];
            
            [self updateSQ];
            
            [[[DBManager sharedManager]postCommentSQ]insertPostComment:model];
            
            _commentArrayM = [[[DBManager sharedManager]postCommentSQ]selectPostCommentWithPostID:self.model.postid];
            
            [self transferNotification];
            
            [self.topTableView reloadData];
            
            [self commentTableViewTouchInSide];
            
            [self showHint:@"评论成功！"];
            
             _commentTF.text = nil;
            
            [self hideHud];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            [self commentTableViewTouchInSide];
            [self showHint:@"评论失败！"];
            [self hideHud];
        }];
    }
    else
    {
        [self showHint:@"请输入评论内容！"];
        [self hideHud];
    }
}

//更新数据库
-(void)updateSQ
{
    [[[DBManager sharedManager] postListSQ]updataPostList:self.model];
    [[[DBManager sharedManager] followPostListSQ]updataFollowPostList:self.model];
    [[[DBManager sharedManager] privacyPostListSQ]updataPrivacyPostList:self.model];
}

//通知页面刷新数据
-(void)transferNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:AllPostNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:FollowPostNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:PrivacyPostNotification object:nil];
}

-(void)commentTableViewTouchInSide
{
   [_commentTF resignFirstResponder];
}

////返回事件
//- (BOOL)navigationShouldPopOnBackButton
//{
//    
//    [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
//    
//    return NO;
//}


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
