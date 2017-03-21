//
//  MessageBoardViewController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/1/16.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "MessageBoardViewController.h"
#import "MessageBoardTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "MessageBoardListBaseModel.h"
#import "VideoViewController.h"
#import "XMNAVAudioPlayer.h"
#import "PicImageView.h"
#import "IDMPhotoBrowser.h"
#import "AudioView.h"
#import "WriteMessageViewController.h"
//唯一标识
#define identifier @"MessageBoardTableViewCell"


@interface MessageBoardViewController ()<UITableViewDelegate, UITableViewDataSource, XMNAVAudioPlayerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation MessageBoardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = zWhiteColor;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [XMNAVAudioPlayer sharePlayer].delegate = self;
    self.title = @"留言板";
    [self initall];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[XMNAVAudioPlayer sharePlayer] stopAudioPlayer];
    [XMNAVAudioPlayer sharePlayer].index = NSUIntegerMax;
    [XMNAVAudioPlayer sharePlayer].URLString = nil;
}
- (void)initall {
    
    [self initRoutable];
    [self httpResquestGetlist];
    [self createRightBtn];
    [self createTableView];
    
}
//注册block路由
- (void)initRoutable{
    
    WeakSelf
    //播放语音
    [LYRouter registerURLPattern:@"ly://MessageBoardViewControllerplayAudio" toHandler:^(NSDictionary *routerParameters) {
        NSDictionary *userInfo = routerParameters[LYRouterParameterUserInfo];
        NSString *index  = userInfo[@"index"];
        NSURL *audioUrl  = userInfo[@"audioUrl"];
        [[XMNAVAudioPlayer sharePlayer] playAudioWithURLString:[audioUrl absoluteString] atIndex:[index integerValue]];
    }];
    // 播放视频
    [LYRouter registerURLPattern:@"ly://MessageBoardViewControllerplayvideo" toHandler:^(NSDictionary *routerParameters) {
        
        NSDictionary *userInfo = routerParameters[LYRouterParameterUserInfo];
        NSString *videoUrl  = userInfo[@"videoUrl"];
        
        VideoViewController *vc = [[VideoViewController alloc] initWithVideoUrl:videoUrl];
        [weakSelf presentViewController:vc animated:YES completion:nil];

    }];
    // 展示图片
    [LYRouter registerURLPattern:@"ly://MessageBoardViewControllershowPicimage" toHandler:^(NSDictionary *routerParameters) {
        
        NSDictionary *userInfo = routerParameters[LYRouterParameterUserInfo];
        NSString *index  = userInfo[@"index"];
        NSMutableArray *pictureArray  = userInfo[@"imageArr"];
        PicImageView *view = userInfo[@"picImageView"];
        NSMutableArray *ph = [NSMutableArray array];
        for (NSString *string in pictureArray) {
            if (![string isEqualToString:@" "]) {
                IDMPhoto *photo = [IDMPhoto photoWithURL:[NSURL URLWithString:string]];
                [ph addObject:photo];
            }
        }
        
        IDMPhotoBrowser *browser = [[IDMPhotoBrowser alloc] initWithPhotos:ph animatedFromView:view];
        // IDMPhotoBrowser功能设置
        browser.displayActionButton = NO;
        browser.displayArrowButton = NO;
        browser.displayCounterLabel = YES;
        browser.displayDoneButton = NO;
        browser.autoHideInterface = NO;
        browser.usePopAnimation = YES;
        browser.disableVerticalSwipe = YES;

        [browser setInitialPageIndex:[index integerValue]];
        
        weakSelf.modalPresentationStyle=UIModalPresentationPageSheet;
        
        [weakSelf presentViewController:browser animated:YES completion:nil];
    }];
}
#pragma mark -
#pragma mark 语音代理

- (void)audioPlayerStateDidChanged:(XMNVoiceMessageState)audioPlayerState forIndex:(NSUInteger)index {
    AudioView *audioView = (AudioView *)[self.tableView viewWithTag:index+100000];
    dispatch_async(dispatch_get_main_queue(), ^{
        [audioView setVoiceMessageState:audioPlayerState];
    });
    
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
#pragma mark -
#pragma mark rightbutton
- (void)createRightBtn {
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"留言" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnAction)];
    
    self.navigationItem.rightBarButtonItems = [self.navigationItem rightItemsWithBarButtonItem:rightBarButtonItem WithSpace:5];
    [rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName, nil] forState:UIControlStateNormal];
}
- (void)rightBtnAction {
    WriteMessageViewController *con = [[WriteMessageViewController alloc] init];
    con.type = self.type;
    con.mark_id = self.mark_id;
    WeakSelf
    con.refreshBlock = ^(WriteMessageViewController *message){
        [weakSelf httpResquestGetlistRefresh];
    };
    [self.navigationController pushViewController:con animated:YES];
}
// 请求列表
- (void)httpResquestGetlist {
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    NSString *urlString = [NSString stringWithFormat:CommentlistbyrecordUrl,alarm,token,self.mark_id,self.type];
    [self.dataArray removeAllObjects];
    [self showloadingName:@"正在加载..."];
    [HYBNetworking getWithUrl:urlString refreshCache:YES success:^(id response) {
        
        MessageBoardListBaseModel *baseModel = [MessageBoardListBaseModel getInfoWithData:response];
        
        //将数据按照距离排序
        NSArray *results = [baseModel.results sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            MessageBoardListModel *model1 = obj1;
            MessageBoardListModel *model2 = obj2;
            NSComparisonResult result = [model1.record_time compare:model2.record_time];
            return result == NSOrderedAscending;
        }];
        
        [self.dataArray addObjectsFromArray:results];
        [self.tableView reloadData];
        [self hideHud];
    } fail:^(NSError *error) {
        
    }];
}
// 请求列表
- (void)httpResquestGetlistRefresh {
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
    NSString *urlString = [NSString stringWithFormat:CommentlistbyrecordUrl,alarm,token,self.mark_id,self.type];
    [self.dataArray removeAllObjects];
    
    [HYBNetworking getWithUrl:urlString refreshCache:YES success:^(id response) {
        
        MessageBoardListBaseModel *baseModel = [MessageBoardListBaseModel getInfoWithData:response];
        
        //将数据按照距离排序
        NSArray *results = [baseModel.results sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            MessageBoardListModel *model1 = obj1;
            MessageBoardListModel *model2 = obj2;
            NSComparisonResult result = [model1.record_time compare:model2.record_time];
            return result == NSOrderedAscending;

        }];
        
        [self.dataArray addObjectsFromArray:results];
        [self.tableView reloadData];
    
    } fail:^(NSError *error) {
        
    }];
}

#pragma mark -
#pragma mark 创建UITableView
- (void)createTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screenWidth(), height(self.view.frame)-64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[MessageBoardTableViewCell class] forCellReuseIdentifier:identifier];
    [self.view addSubview:_tableView];
}
#pragma mark -
#pragma mark 返回分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
#pragma mark -
#pragma mark 返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
#pragma mark -
#pragma mark UITableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    MessageBoardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MessageBoardTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setupModelOfCell:cell atIndexPath:indexPath];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [self.tableView fd_heightForCellWithIdentifier:identifier cacheByIndexPath:indexPath configuration:^(MessageBoardTableViewCell *cell) {
        [self setupModelOfCell:cell atIndexPath:indexPath];
    }];
    // collectionview高度需要自己计算
    
    CGFloat picleftM = 12;
    CGFloat piccenterM = 12;
    
    CGFloat audioLeftM = 12;
    CGFloat audioCenterM = 12;
    
    CGFloat picCenterY = 12;
    
    CGFloat btnW = (kScreenWidth-3*piccenterM-2*picleftM)/4;
    CGFloat audioBtnW = (kScreenWidth-3*audioCenterM-2*audioLeftM)/4;
    CGFloat audioBtnH = 26;
    
    NSInteger picCount = 0;
    NSInteger videoCount = 0;
    NSInteger audioCount = 0;
    
    MessageBoardListModel *model = self.dataArray[indexPath.row];
    NSInteger topHeight = 0;
    

    if (![model.audio isEqualToString:@" "] && ![model.audio isEqualToString:@""]) {
        NSArray *audios = [model.audio componentsSeparatedByString:@","];
        audioCount = audios.count;

    }
    if (audioCount != 0 ) {
        if (audioCount%4 == 0) {
            topHeight = topHeight + (audioBtnH + picCenterY)*(audioCount/4);
        }else {
            topHeight = topHeight + (audioBtnH + picCenterY)*(audioCount/4 + 1);
        }
        
    }

    if (![model.picture isEqualToString:@" "] && ![model.picture isEqualToString:@""]) {
        NSArray *pictures = [model.picture componentsSeparatedByString:@","];
        picCount = pictures.count;

    }
    if (picCount != 0) {
        if (picCount%4 == 0) {
            topHeight = topHeight + (btnW + picCenterY)*(picCount/4);
        }else {
            topHeight = topHeight + (btnW + picCenterY)*(picCount/4 + 1);
        }
        
    }

    if (![model.video isEqualToString:@" "] && ![model.video isEqualToString:@""]) {
        NSArray *videos = [model.video componentsSeparatedByString:@","];
        videoCount = videos.count;
       
    }
    if (videoCount != 0) {
        if (videoCount%4 == 0) {
            topHeight = topHeight + (btnW + picCenterY)*(videoCount/4);
        }else {
            topHeight = topHeight + (btnW + picCenterY)*(videoCount/4 + 1);
        }
    }

    if (audioCount + picCount + videoCount == 0) {
        return height;
    }
    return height+topHeight;

}
- (void)setupModelOfCell:(MessageBoardTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    cell.model = self.dataArray[indexPath.row];
    cell.row = indexPath.row;
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
