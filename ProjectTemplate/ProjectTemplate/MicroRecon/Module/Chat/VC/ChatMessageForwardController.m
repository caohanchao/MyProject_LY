//
//  ChatMessageForwardController.m
//  ProjectTemplate
//
//  Created by 绿之云 on 16/9/21.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "ChatMessageForwardController.h"
#import "TeamTableViewCell.h"
#import "TeamsListModel.h"
#import "FriendsListModel.h"
#import "SectionHeaderView.h"
#import "ForwardCell.h"
#import "HttpsManager.h"
#import "LZXHelper.h"
#import "ICometModel.h"
#import "ForwardMSGLogic.h"
#import "XMLocationManager.h"

@interface ChatMessageForwardController ()

@property(nonatomic,copy)ICometModel *icModel;

@property(nonatomic)BOOL isEdit;

@property (nonatomic,strong)NSMutableArray *selectorPatnArray;

@property(nonatomic,copy)NSMutableArray *friendListArray;

@property(nonatomic,copy)NSMutableArray *groupListArray;

@property(nonatomic,copy)NSMutableArray *sectionHeaderArray;

@property(nonatomic,strong)XMLocationManager *locationManager;

@property (nonatomic,copy)NSString *latitude;
@property (nonatomic,copy)NSString *longitude;

@end

@implementation ChatMessageForwardController


-(NSMutableArray *)selectorPatnArray
{
    if (_selectorPatnArray == nil)
    {
        _selectorPatnArray =[NSMutableArray array];
    }
    return _selectorPatnArray;
}

-(NSMutableArray *)sectionHeaderArray
{
    if (_sectionHeaderArray == nil)
    {
        _sectionHeaderArray = [NSMutableArray array];
    }
    return _sectionHeaderArray;
}


-(NSMutableArray *)friendListArray
{
    if (_friendListArray ==nil)
    {
        _friendListArray =[NSMutableArray array];
    }
    return _friendListArray;
}

-(NSMutableArray *)groupListArray
{
    if (_groupListArray ==nil)
    {
        _groupListArray =[NSMutableArray array];
    }
    return _groupListArray;
}



#pragma mark -
#pragma mark create

-(void)createNarItem
{
    self.navigationItem.title = @"选择";
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem.title =@"多选";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(leftItemClick)];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
}

-(void)createUI
{
    
    //    self.tbView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64,self.view.frame.size.width , self.view.frame.size.height-64) style:UITableViewStyleGrouped];
    //    self.tbView.dataSource =self;
    //    self.tbView.delegate =self;
    //    self.tbView.backgroundColor =[UIColor whiteColor];;
    //    [self.view addSubview:self.tbView];
    
    //    self.tableView.editing =YES;
    
    self.tableView.allowsMultipleSelectionDuringEditing =YES;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

-(void)createSectionHeaderView
{
    NSArray *titleArr =@[@"好友列表",@"群组列表"];
    
    __weak ChatMessageForwardController *weakself =self;
    
    for (int i = 0; i<titleArr.count; i++)
    {
        SectionHeaderView *headerView =[[SectionHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        headerView.userInteractionEnabled = YES;
        headerView.titleLabel.text =titleArr[i];
        headerView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.00];
        
        headerView.block = ^{
            
            [weakself.tableView reloadData];
        };
        [self.sectionHeaderArray addObject:headerView];
    }
    
}


#pragma mark -
#pragma mark Action
-(void)leftItemClick
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)reloadDataSource
{
    
    [self.groupListArray addObjectsFromArray:[[[DBManager sharedManager] GrouplistSQ] selectGrouplists]];
    
    [self.friendListArray addObjectsFromArray:[[[DBManager sharedManager] personnelInformationSQ] selectFrirndlist]];
    
    
    [self.tableView reloadData];
    
    
}


#pragma mark -
#pragma mark -VC生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNarItem];
    
    [self createUI];
    
    [self createSectionHeaderView];
    
    
    
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadDataSource];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.friendListArray removeAllObjects];
    [self.groupListArray removeAllObjects];
    [self.selectorPatnArray removeAllObjects];
    [self.sectionHeaderArray removeAllObjects];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -
#pragma mark - TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    SectionHeaderView *view = self.sectionHeaderArray[section];
    
    if (section == 0)
    {
        return view.isAppear ? self.friendListArray.count : 0;
    }
    else
    {
        return view.isAppear ? self.groupListArray.count : 0;
    }
    
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier1 = @"identifier1";
    static NSString *identifier2 = @"identifier2";
    
    if (indexPath.section ==0)
    {
        ForwardCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ForwardCell" owner:self options:nil] lastObject];
        }
        cell.selectedBackgroundView = [[UIView alloc] init];
        
        FriendsListModel *model =self.friendListArray[indexPath.row];
        
        [cell configDataSourceOfTModel:nil FModel:model andModelType:IsFriendListModelType];
        
        return cell;
    }
    
    if (indexPath.section == 1)
    {
        ForwardCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier2];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"ForwardCell" owner:self options:nil] lastObject];
        }
        cell.selectedBackgroundView = [[UIView alloc] init];
        
        TeamsListModel *model =self.groupListArray[indexPath.row];
        
        [cell configDataSourceOfTModel:model FModel:nil andModelType:IsTeamsListModelType];
        
        return cell;
    }
    
    return nil;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    return self.sectionHeaderArray[section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
   // NSArray *subviews = cell.subviews;

    if (indexPath.section == 0)
    {
        if (!self.isEdit)
        {
            [self.selectorPatnArray removeAllObjects];
            [self.selectorPatnArray addObject:self.friendListArray[indexPath.row]];
            NSLog(@"转发给好友消息:%@",self.selectorPatnArray);
            [self showAlert];
        }
        else
        {
            
            [self.selectorPatnArray addObject:self.friendListArray[indexPath.row]];
            
            NSLog(@"编辑状态选择:subView:%@",self.selectorPatnArray);
        }
    }
    else
    {
        if (!self.isEdit)
        {
            [self.selectorPatnArray removeAllObjects];
            [self.selectorPatnArray addObject:self.groupListArray[indexPath.row]];
            NSLog(@"转发给群组消息");
            [self showAlert];
        }
        else
        {
            [self.selectorPatnArray addObject:self.groupListArray[indexPath.row]];
            
            NSLog(@"编辑状态选择:subView:%@",self.selectorPatnArray);
        }
        
    }

}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (self.selectorPatnArray.count > 0) {
            
            [self.selectorPatnArray removeObject:self.friendListArray[indexPath.row]];
            NSLog(@"取消选择:%@",self.selectorPatnArray);
        }
        
    }
    else
    {
        if (self.selectorPatnArray.count > 0) {
            
            [self.selectorPatnArray removeObject:self.groupListArray[indexPath.row]];
            NSLog(@"取消选择:%@",self.selectorPatnArray);
        }
    }
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark -
#pragma mark 编辑状态逻辑

//保证在编辑状态下,勾选不被取消掉   在多选时下拉菜单不能被选中
-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    //    [self.navigationItem setHidesBackButton:editing animated:YES];
    self.isEdit = editing;
    
    if (editing)
    {
        [self.selectorPatnArray removeAllObjects];
      //  NSMutableArray *isAppear =[NSMutableArray array];
        for (SectionHeaderView *view in self.sectionHeaderArray)
        {
            if (view.isAppear == NO) {
                
                [view sectionIsAppear];
            }
            view.userInteractionEnabled = NO;
        }
        
        [self.tableView reloadData];
        self.navigationItem.rightBarButtonItem.title =@"完成";
        
    }
    else
    {
        
        for (SectionHeaderView *view in self.sectionHeaderArray)
        {
            view.userInteractionEnabled = YES;
        }
        
        [self.tableView reloadData];
        self.navigationItem.rightBarButtonItem.title =@"多选";
        
        if (self.selectorPatnArray.count>0)
        {
            [self showAlert];
        }

        
    }
    
}


-(void)showAlert
{
    UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"提示" message:@"确定是否转发" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        [self.selectorPatnArray removeAllObjects];
        
    }];
    UIAlertAction *action2 =[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //处理转发的业务
        
        [self forwardMessageAction];
        
    }];
    
    [alert addAction:action1];
    [alert addAction:action2];
    
    [self.navigationController presentViewController:alert animated:YES completion:^{
        
        
//        [self.selectorPatnArray removeAllObjects];
    }];
    
}

#pragma mark -
#pragma mark 消息转发
-(void)forwardMessageAction
{
    NSMutableArray *alarmArr = [NSMutableArray array];
    NSMutableArray *gidArr = [NSMutableArray array];
    
    for (FriendsListModel * model in self.selectorPatnArray)
    {
        if([model isKindOfClass:[FriendsListModel class]])
        {
            [alarmArr addObject:model.alarm];
            
        }
    }
    NSLog(@"alarmArr:%@",alarmArr);
    
    for (TeamsListModel * model in self.selectorPatnArray)
    {
        if([model isKindOfClass:[TeamsListModel class]])
        {
            [gidArr addObject:model.gid];
            
        }
    }
    NSLog(@"gidArr:%@",gidArr);
    
  //  postDetailView
    
    if ([self.pushViewStr isEqualToString:@"postDetailView"])
    {

//        //初始化定位 获取经纬度
//        self.locationManager = [XMLocationManager shareManager];
//        [self.locationManager startLocation];
//        
//        __weak ChatMessageForwardController *weakself = self;
//        self.locationManager.locationCompleteBlock = ^(CLLocationCoordinate2D coordinate2D){
//            
//            weakself.latitude = [NSString stringWithFormat:@"%.8lf",coordinate2D.latitude];
//            weakself.longitude =[NSString stringWithFormat:@"%.8lf",coordinate2D.longitude];
//        };
//        [self.locationManager requestAuthorization:nil];
        
        //转发业务逻辑
        [[ForwardMSGLogic sharedManager] forwardMessageWithUrl:self.imageUrlStr withUsers:alarmArr withGroups:gidArr withgpsH:@"30" withgpsW:@"170" progress:^(NSProgress * _Nonnull progress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
            [self showHint:@"消息转发成功"];
            
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self showHint:@"消息转发失败"];
        }];
       
    }
    else
    {
        //转发业务逻辑
        [[ForwardMSGLogic sharedManager] forwardMessageWithQID:self.messageID withUsers:alarmArr withGroups:gidArr progress:^(NSProgress * _Nonnull progress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
            
            //  NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:reponse options:NSJSONReadingMutableContainers error:nil];
            
            //  NSLog(@"reponse:%@",dict);
            
            [self showHint:@"消息转发成功"];
            
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                
            }];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            //        NSLog(@"error:%@",error);
            [self showHint:@"消息转发失败"];
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
