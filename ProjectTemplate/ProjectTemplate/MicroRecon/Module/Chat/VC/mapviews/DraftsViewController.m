//
//  DraftsViewController.m
//  ProjectTemplate
//
//  Created by caohanchao on 16/10/27.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//



#import "DraftsViewController.h"
#import "DraftsCell.h"
#import "CameraMarkViewController.h"
#import "PhysicsViewController.h"
#import "PhysicsRequest.h"

@interface DraftsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,copy)NSMutableArray *dataArray;
@property(nonatomic,copy)WorkAllTempModel *wModel;

@property(nonatomic,strong)UITableView *tableView;

@end



@implementation DraftsViewController

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        NSString *chatId = [user objectForKey:@"chatId"];
        _dataArray = [self soureDataArray];
        //        _dataArray = @[@"线上测试1",@"线上测试2"];
        //从数据库取
    }
    return _dataArray;
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, screenWidth(), screenHeight()-64) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate =self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

-(void)initUI
{
    self.title = @"草稿箱";
    [self.view addSubview:self.tableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = zWhiteColor;
    [self initUI];
    
    
    
    // Do any additional setup after loading the view.
}

#pragma mark - UITableViewDelegate/DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"Cellidentifier";
    __weak DraftsViewController *weakself = self;
    DraftsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[DraftsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
//    cell.model = self.dataArray[indexPath.section];
    [cell configureWithCell:self.dataArray[indexPath.section]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //草稿箱上传
    cell.draftsUploadClick = ^(id model,DraftsCellType type){
        
        if (type == markType) {
            WorkAllTempModel *wModel = (WorkAllTempModel *)model;
            [weakself httpUploadDrafts:wModel];
        } else if (type == TrajectoryType) {
            GetPathModel *gModel = (GetPathModel *)model;
            [weakself httpUploadPath:gModel];
        }
        
    };
    
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 11;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view =[[UIView alloc]init];
    view.backgroundColor= [UIColor groupTableViewBackgroundColor];
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *chatId = [user objectForKey:@"chatId"];
    
    id model = self.dataArray[indexPath.section];
    if ([model isKindOfClass:[WorkAllTempModel class]]) {
        CameraMarkViewController *record = [[CameraMarkViewController alloc] init];
        record.fromWhere = DraftsController;
        record.model = self.dataArray[indexPath.section];
        __weak DraftsViewController *weakself = self;
        
        record.block = ^(CameraMarkViewController *controller){
            weakself.dataArray = [weakself soureDataArray];
            [weakself.tableView reloadData];
        };
        [self.navigationController pushViewController:record animated:YES];
    }else if ([model isKindOfClass:[GetPathModel class]]) {
        
        GetPathModel *pathModel = (GetPathModel *)model;
        SuspectlistModel *workModel = [[[DBManager sharedManager] suspectAlllistSQ] selectSuspectByWorkId:pathModel.task_id];
        PhysicsViewController *physics = [[PhysicsViewController alloc] init];
        physics.fromWhere = DraftsPage;
        physics.workInfo = @{@"workId":workModel.suspectid,@"workName":workModel.suspectname};
        physics.gid = pathModel.gid;
        physics.editType = writeType;
        physics.pointInfo = pathModel.location_list;
        physics.gModel = pathModel;
        __weak DraftsViewController *weakself = self;
        
        physics.block = ^(PhysicsViewController *physics){
            weakself.dataArray = [weakself soureDataArray];
            [weakself.tableView reloadData];
        };

        [self.navigationController pushViewController:physics animated:YES];
    }
    

}


-(void)httpUploadDrafts:(WorkAllTempModel *)model
{
    NSMutableDictionary *param =[NSMutableDictionary dictionary];
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *chatId = [user objectForKey:@"chatId"];
    
    param[@"content"] =model.content;//内容
    param[@"alarm"] = model.alarm;   //警号
    param[@"title"] =model.title;   //标题
    param[@"create_time"] =model.create_time;//创建时间
    param[@"mode"]=model.mode;        //0.走访标记 1.快速记录2.摄像头标记
    param[@"type"] =model.type;
    param[@"longitude"]=model.longitude;//经度
    param[@"latitude"] =model.latitude;//维度
    param[@"position"] = model.position; //位置
    param[@"gid"] =model.gid;
    param[@"direction"] =model.direction;   //方向
    param[@"workid"] =model.workId;
    param[@"picture"] =model.picture;     //图片
    param[@"audio"] =model.audio;       //音频
    param[@"video"] =model.video;       //视频
    
    [CHCUI presentAlertStyleDefauleForTitle:@"提示" andMessage:@"是否上传到工作表" andCancel:^(UIAlertAction *action) {
        
    } andDefault:^(UIAlertAction *action) {
        if (![model.title isEqual:@""] && ![model.position isEqual:@""] && ![model.gid isEqual:@""] && ![model.workId isEqual:@""]) {
            [self showloadingName:@"正在提交"];
            
            [[HttpsManager sharedManager] post:Saverecord_URL parameters:param progress:^(NSProgress * _Nonnull progress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
                
                NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:reponse options:NSJSONReadingMutableContainers error:nil];
                
                //            NSLog(@"success:%@",dict);
                [self hideHud];
                [self showHint:@"上传成功"];
                [[[DBManager sharedManager] draftsListSQ] deleteDraftsListByCuid:model.cuid];
                self.dataArray = [self soureDataArray];
                [self.tableView reloadData];
                [self.navigationController popViewControllerAnimated:YES];
//                NSMutableDictionary *parm = [NSMutableDictionary dictionary];
//                //将任务添加到地图
//                parm[@"workAllModelMark"] = model;
//                
//                [LYRouter openURL:@"ly://mapaddmark" withUserInfo:parm completion:nil];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
            }];
        }
        else
        {
            [self showHint:@"上传失败,请编辑完成后再做提交"];
        }
    } andCompletion:^(UIAlertController *alert) {
        [self presentViewController:alert animated:YES completion:nil];
    }];
}
- (NSMutableArray *)soureDataArray {
    
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *chatId = [user objectForKey:@"chatId"];

    NSMutableArray *tempArray = [NSMutableArray array];
    [tempArray addObjectsFromArray:[[[DBManager sharedManager] draftsListSQ] selectDraftsList:chatId]];
    [tempArray addObjectsFromArray:[[[DBManager sharedManager] trajectoryListSQ] selectTrajectoryList:chatId]];
    //将数据按照时间排序
    NSArray *results = [tempArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        
        NSString *time1 = @"";
        NSString *time2 = @"";
        if ([obj1 isKindOfClass:[GetPathModel class]]) {
            GetPathModel *model = (GetPathModel *)obj1;
            time1 = model.createTime;
        }else if ([obj1 isKindOfClass:[WorkAllTempModel class]]) {
            WorkAllTempModel *model = (WorkAllTempModel *)obj1;
            time1 = model.create_time;
        }
        if ([obj2 isKindOfClass:[GetPathModel class]]) {
            GetPathModel *model = (GetPathModel *)obj2;
            time2 = model.createTime;
        }else if ([obj2 isKindOfClass:[WorkAllTempModel class]]) {
            WorkAllTempModel *model = (WorkAllTempModel *)obj2;
            time2 = model.create_time;
        }
       
        NSComparisonResult result = [time1 compare:time2];
        return result == NSOrderedAscending;
    }];
    return results;
}
//上传轨迹
-(void)httpUploadPath:(GetPathModel *)model {
    
    
    if ([[LZXHelper isNullToString:model.route_title] isEqualToString:@""]) {
        [self showHint:@"请输入标题"];
        return;
    }
    if ([[LZXHelper isNullToString:model.task_id ]isEqualToString:@""]) {
        [self showHint:@"请选择任务"];
        return;
    }
    if ([[LZXHelper isNullToString:model.type] isEqualToString:@""]) {
        [self showHint:@"请选择工作模式"];
        return;
    }
    
    NSUserDefaults *user =[NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"alarm"]             = [user objectForKey:@"alarm"];
    param[@"gid"]               = model.gid;
    param[@"token"]             = [user objectForKey:@"token"];
    param[@"task_id"]           = model.task_id;
    param[@"end_posi"]          = model.end_posi;
    param[@"start_posi"]        = model.start_posi;
    param[@"route_title"]       = model.route_title;
    param[@"type"]              = model.type;
    param[@"start_time"]        = model.start_time;
    param[@"end_time"]          = model.end_time;
    param[@"describetion"]      = model.describetion;
    param[@"end_latitude"]      = model.end_latitude;
    param[@"end_longitude"]     = model.end_longitude;
    param[@"start_latitude"]    = model.start_latitude;
    param[@"start_longitude"]   = model.start_longitude;
    param[@"location_list"]     = [LZXHelper toJSONString:model.location_list];
    
    [self showloadingName:@"正在上传轨迹"];
    [PhysicsRequest postUploadPhysicsWithParam:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:reponse
                                                             options:NSJSONReadingMutableContainers error:nil];
        ZEBLog(@"%@",dict);
        if ([dict[@"resultcode"] isEqualToString:@"0"]) {
            
            [self hideHud];
            [self showHint:dict[@"resultmessage"]];
            
            [[[DBManager sharedManager] trajectoryListSQ] deleteTrajectoryListByCuid:model.cuid];
            self.dataArray = [self soureDataArray];
            [self.tableView reloadData];
            [self.navigationController popViewControllerAnimated:YES];

        } else {
            [self showHint:dict[@"resultmessage"]];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showHint:@"上传失败"];
    }];
    
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
