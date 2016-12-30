//
//  UserPostViewController.m
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/11.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "UserPostViewController.h"
#import "SqureCell.h"
#import "HZIndicatorView.h"
#import "HZImagesGroupView.h"
#import "HZPhotoBrowser.h"
#import "HZPhotoItemModel.h"
#import "CardPostInfoModel.h"
#import "PostListModel.h"
#import "DynamicDetailsViewController.h"
#import "PostListBaseModel.h"
#import "UserHomePageViewController.h"
#import "UserCardModel.h"
#import "CardCountInfoModel.h"

#define circleCellHight 212//cell的固定高度
#define noPicCircleCellHight 123//没有图片cell的固定高度
#define LeftMargin 12

static BOOL _isClear;

float _postLastContentOffset;

@interface UserPostViewController ()<UIGestureRecognizerDelegate,SqureCellDelegate,HZPhotoBrowserDelegate>

@property (nonatomic,strong)  NSArray *modelArray;
@property (nonatomic,strong)  NSArray *imageArray;

@property(nonatomic, strong) PostListBaseModel * postModel;
@property(nonatomic, strong) UserCardModel * userCardModel;
@property(nonatomic, strong) CardCountInfoModel * cardCountModel;

@property(nonatomic,strong)PostListModel * lastModel;

@end

@implementation UserPostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createMJRefresh];
    
    [self getUserAllPost];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserAllPost) name:UserCardPostNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewToTop) name:UserCardPostToTopNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _isClear = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)tableViewToTop
{
    [self.tableView setContentOffset:CGPointMake(0,0) animated:YES];
}

-(void)createMJRefresh
{
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf  getmoreRequest_data];
    }];
}

- (void)getUserAllPost
{
    _modelArray = [[[DBManager sharedManager]userPostInfoSQ]selectUserPostInfoWithAlarm:self.userIDStr];
    
   [self.tableView reloadData];
    
    [self resetContentInset];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _postLastContentOffset = scrollView.contentOffset.y;
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if (!(_postLastContentOffset < scrollView.contentOffset.y))
    {
        NSLog(@"向下滚动");
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY < -50)
        {
            [self showAvtivity];
            [[NSNotificationCenter defaultCenter] postNotificationName:HomeTitleViewNotification object:nil];
        }
    }
}

-(void)showAvtivity
{
    [self getResultsData];
}


- (void)getResultsData
{
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"action"] = @"getusercard";
    paramDict[@"alarm"] = alarm;
    paramDict[@"token"] = token;
    paramDict[@"userid"] = self.userIDStr;
    paramDict[@"mode"] = @"1";
    
    
    [[HttpsManager sharedManager] post:GetCircleList parameters:paramDict  progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
        
        _userCardModel = [UserCardModel getInfoWithData:response];
        
        _cardCountModel = [CardCountInfoModel getInfoWithData:_userCardModel.countInfo];
        //
        [[[DBManager sharedManager]userPostInfoSQ]deleteUserPostInfoByAlarm:self.userIDStr];
        [[[DBManager sharedManager]userPostInfoSQ]transactionInsertUserPostInfoModel:_userCardModel.postInfo];
        
       _modelArray = [[[DBManager sharedManager]userPostInfoSQ]selectUserPostInfoWithAlarm:self.userIDStr];
        
        if (!(_modelArray.count > 0)) {
           // [self getmoreRequest_data];
        }
        else
        {
            self.tableView.mj_footer.hidden  = NO;
        }
        
        if (_isClear) {
          //  [self getmoreRequest_data];
        }
        
        [self.tableView reloadData];
        
         [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0f];
        
        //[[NSNotificationCenter defaultCenter]postNotificationName:UserCardPostNotification object:nil];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        _modelArray = [[[DBManager sharedManager]userPostInfoSQ]selectUserPostInfoWithAlarm:self.userIDStr];
        [self.tableView reloadData];
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0f];
    }];
}

- (void)getmoreRequest_data {
    
    _isClear = YES;
    
    if ([[LZXHelper isNullToString:_lastModel.postid] isEqualToString:@""]) {
        _lastModel = [_modelArray lastObject];
    }
    
    // 如果需要请求网络数据, 再调用tableView的reloadData之后，调用下面resetContentInset方法可以消除底部多余空白
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"action"] = @"postlist";
    paramDict[@"alarm"] = alarm;
    paramDict[@"token"] = token;
    paramDict[@"type"] = @"selfall";
    paramDict[@"mode"] = @"1";
    paramDict[@"postid"] = _lastModel.postid;
    paramDict[@"handle"] = @"1";
    paramDict[@"userid"] = self.userIDStr;
    
    [[HttpsManager sharedManager] post:GetCircleList parameters:paramDict  progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
        
        _postModel = [PostListBaseModel getInfoWithData:response];
        
        [[[DBManager sharedManager]userPostInfoSQ]transactionInsertUserPostInfoModel:_userCardModel.postInfo];
        
        _modelArray = [[[DBManager sharedManager]userPostInfoSQ]selectUserPostInfoWithAlarm:self.userIDStr];
        
        _lastModel = [_modelArray lastObject];
        
        if (!(_modelArray.count > 0)) {
            self.tableView.mj_footer.hidden  = YES;
        }
        else
        {
            self.tableView.mj_footer.hidden  = NO;
        }
        
        [self.tableView reloadData];
        [self resetContentInset];
        
        [self.tableView.mj_footer endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        _modelArray = [[[DBManager sharedManager]postListSQ]selectPostList];
        [self.tableView reloadData];
        [self resetContentInset];
        
        [self.tableView.mj_footer endRefreshing];
    }];
}


-(void)delayMethod
{
    //[self showHint:@"已经是最新的啦！"];
    [[NSNotificationCenter defaultCenter] postNotificationName:HomeTitleDisViewNotification object:nil];
}
//-(void)createMJRefresh
//{
//    __unsafe_unretained __typeof(self) weakSelf = self;
//    
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [weakSelf  getmoreRequest_data];
//    }];
//}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_modelArray.count>0) {
         return _modelArray.count;
    }
    else
    {
        return 0;
    }
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cardIdentifier";
    SqureCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[SqureCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    else
    {
        for (UIView *subView in cell.contentView.subviews)
        {
            [subView removeFromSuperview];
        }
    }
    
    cell.delegate = self;
    
    CardPostInfoModel * model;
    if (_modelArray.count>0) {
        model = _modelArray[indexPath.row];
    }
    cell.model = model;
    cell.LineLabel.hidden = YES;
    
    NSString*string = model.picture;
    _imageArray = [string componentsSeparatedByString:@","];
    
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
    
    
    UserPostViewController  __weak * weakSelf = self;
    
    [cell setUserInfoBlock:^{
        NSLog(@"点击信息");
        if (![self.userIDStr isEqualToString:model.alarm]) {
            UserHomePageViewController * userHomePageVC = [[UserHomePageViewController alloc]init];
            userHomePageVC.userIDStr = model.alarm;
            userHomePageVC.selectIDStr = model.alarm;
            [weakSelf.navigationController pushViewController:userHomePageVC animated:YES];
        }
        
    }];
    
    [cell setCommentBlock:^{
        NSLog(@"评论");
        //点击评论跳转详情并打开输入面板
        DynamicDetailsViewController * dynamicDetailsVC = [[DynamicDetailsViewController alloc]init];
        dynamicDetailsVC.model = model;
        if ([model.posttype isEqualToString:@"1"]) {
            dynamicDetailsVC.posttypes = @"all";
        }
        else
        {
            dynamicDetailsVC.posttypes = model.posttype;
        }
        dynamicDetailsVC.postComment = @"postComent";
        [weakSelf.navigationController pushViewController:dynamicDetailsVC animated:YES];
        
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CardPostInfoModel * model;
    if (_modelArray.count>0) {
        model = _modelArray[indexPath.row];
    }
    
    DynamicDetailsViewController * dynamicDetailsVC = [[DynamicDetailsViewController alloc]init];
    dynamicDetailsVC.model = model;
    if ([model.posttype isEqualToString:@"1"]) {
        dynamicDetailsVC.posttypes = @"all";
    }
    else
    {
        dynamicDetailsVC.posttypes = model.posttype;
    }
    [self.navigationController pushViewController:dynamicDetailsVC animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CardPostInfoModel * model;
    if (_modelArray.count>0) {
        model = _modelArray[indexPath.row];
    }
    
    CGFloat contentHight;
    contentHight = [LZXHelper textHeightFromTextString:model.text width: screenWidth() - LeftMargin*2 fontSize:15];
    if ([[LZXHelper isNullToString:model.text] isEqualToString:@""]) {
        contentHight = 0;
    }
    
    if (model.picture.length>0)
    {
        return circleCellHight+contentHight;
    }
    else
    {
        return noPicCircleCellHight+contentHight;
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


#pragma mark - Private
- (void)resetContentInset {
    [self.tableView layoutIfNeeded];
    
    if (self.tableView.contentSize.height < kScreenHeight + 136) {  // 136 = 200
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, kScreenHeight+156-self.tableView.contentSize.height, 0);
    } else {
        self.tableView.contentInset = UIEdgeInsetsZero;
    }
}

#pragma mark  ----- postPraise
- (void)postPraise:(SqureCell *)praise
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:praise];
    
    CardPostInfoModel * model;
    if (_modelArray.count>0) {
        model = _modelArray[indexPath.row];
    }
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    if ([model.ispraise isEqualToString:@"0"])
    {
        paramDict[@"action"] = @"setpraise";
    }
    else
    {
        paramDict[@"action"] = @"delpraise";
    }
    paramDict[@"alarm"] = alarm;
    paramDict[@"token"] = token;
    paramDict[@"postid"] = model.postid;
    paramDict[@"postuser"] = model.alarm;
    paramDict[@"mode"] = @"1";
    
    [[HttpsManager sharedManager] post:GetCircleList parameters:paramDict  progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response)
     {
         if ([model.ispraise isEqualToString:@"0"])
         {
             model.praisenum  = [NSString stringWithFormat:@"%d",[model.praisenum intValue]+1];
             model.ispraise = @"1";
             
             [[[DBManager sharedManager] postListSQ]updataPostList:model];
             [[[DBManager sharedManager] followPostListSQ]updataFollowPostList:model];
             [[[DBManager sharedManager] privacyPostListSQ]updataPrivacyPostList:model];
             [[[DBManager sharedManager] userPostInfoSQ]updataUserPostInfo:model];
             _modelArray = [[[DBManager sharedManager] userPostInfoSQ]  selectUserPostInfoWithAlarm:model.alarm];
             
             [[NSNotificationCenter defaultCenter] postNotificationName:AllPostNotification object:nil];
             [[NSNotificationCenter defaultCenter] postNotificationName:FollowPostNotification object:nil];
             [[NSNotificationCenter defaultCenter] postNotificationName:PrivacyPostNotification object:nil];
             
             [self.tableView reloadData];
             
             [self showHint:@"点赞成功"];
         }
         else
         {
             model.praisenum  = [NSString stringWithFormat:@"%d",[model.praisenum intValue]-1];
             model.ispraise = @"0";
             
             [[[DBManager sharedManager] postListSQ]updataPostList:model];
             [[[DBManager sharedManager] followPostListSQ]updataFollowPostList:model];
             [[[DBManager sharedManager] privacyPostListSQ]updataPrivacyPostList:model];
             [[[DBManager sharedManager] userPostInfoSQ]updataUserPostInfo:model];
             _modelArray = [[[DBManager sharedManager] userPostInfoSQ]  selectUserPostInfoWithAlarm:model.alarm];
             
             [[NSNotificationCenter defaultCenter] postNotificationName:AllPostNotification object:nil];
             [[NSNotificationCenter defaultCenter] postNotificationName:FollowPostNotification object:nil];
             [[NSNotificationCenter defaultCenter] postNotificationName:PrivacyPostNotification object:nil];
             
              [[NSNotificationCenter defaultCenter] postNotificationName:HomeTitleViewNotification object:nil];
             
             [self.tableView reloadData];
             
             [self showHint:@"取消成功"];
             
         }
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       //  [self showHint:@"点赞失败了，看看网络吧！"];
     }];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
