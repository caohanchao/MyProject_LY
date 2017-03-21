//
//  ChatView.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/23.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "ChatView.h"
#import "ZEBScrollView.h"
#import "TopView.h"
#import "ChatMapBaseModel.h"
#import "ZEBTableView.h"
#import "ChatMapTopTableViewCell.h"
#import "AlView.h"
#import "ChatTableView.h"

#define topViewHeight 64

@interface ChatView ()<UITableViewDelegate, UITableViewDataSource, ChatMapTopTableViewCellDelegate> {
    
    ZEBTableView *_tableView;

}

@property (nonatomic, strong) TopView *topView;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, assign) XMNMessageChat messageChatType;
@property (nonatomic, assign) BOOL isCenter;
@property (nonatomic, assign) BOOL isTop;
@property (nonatomic, assign) BOOL isBottom;

@property (nonatomic, strong) NSMutableArray *soureArray;

@property (nonatomic, strong) UILabel *onlineLabel;
@property (nonatomic, strong) UILabel *notOnlineLabel;

@end

@implementation ChatView 

- (instancetype)init {

    self = [super init];
    if (self) {
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame  ChatType:(XMNMessageChat)messageChatType chatname:(NSString *) chatName type:(NSInteger)type {
    self = [super initWithFrame:frame];
    if (self) {
        self.messageChatType = messageChatType;
        self.chatterName = chatName;
        self.type = type;
       [self initView];
        [self getCacheMember];
        [self initShadow];
        [self initNotificationCenter];
    }
    return self;
}
- (void)initNotificationCenter {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFrame:) name:MapChatChangeFrameNotification object:nil];
    
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)changeFrame:(NSNotification *)notification {

    NSString *type = notification.object;
    if ([type isEqualToString:@"0"]) {//xmchatbar
        if (!self.isTop) {
            [self isToTop];
        }
    }else if ([type isEqualToString:@"1"]) {//点击任务事件
        if (!self.isBottom) {
            [self isToBottom];
        }
    }
}
- (NSMutableArray *)groupMemberArray {

    if (_groupMemberArray == nil) {
        _groupMemberArray = [NSMutableArray array];
    }
    return _groupMemberArray;
}
- (NSMutableArray *)soureArray {

    if (_soureArray == nil) {
        _soureArray = [NSMutableArray array];
    }
    return _soureArray;
}
- (void)initShadow {

    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft |  UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0.0f, 3.0f);
    self.layer.shadowOpacity = 0.9f;
    self.layer.shadowPath = shadowPath.CGPath;
}
-(void)setEffectView:(UIVisualEffectView *)effectView {

    _effectView = effectView;
    self.isCenter = YES;
    self.isTop = NO;
}
- (void)initView {
    
    
    _chatController = [[ChatViewController alloc] initWithChatType:self.messageChatType];
    _chatController.chatterName = self.chatterName;
    if (self.type == 1) {
        _chatController.cType = ChatList1;
    }else if (self.type == 2) {
        _chatController.cType = GroupTeam1;
    }
    
    _bottomView = _chatController.view;
    _bottomView.frame = CGRectMake(0, topViewHeight-1, kScreen_Width, height(self.frame)-topViewHeight+1);
    
    _chatController.tableView.frame = CGRectMake(0, 0, kScreen_Width, height(_bottomView.frame)- kMinHeight);
    _chatController.chatBar.frame = CGRectMake(0, height(_bottomView.frame) - kMinHeight, self.frame.size.width, kMinHeight);
    _chatController.chatBar.winHeight = height(_bottomView.frame);
    [_chatController scrollToBottom:NO];
    [self addSubview:_bottomView];
    
    
    
    _topView = [[TopView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, topViewHeight)];
    _topView.backgroundColor = [UIColor clearColor];
    [self addSubview:_topView];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, topViewHeight+15)];
    bgImageView.image = [UIImage imageNamed:@"bg_head"];
    [_topView addSubview:bgImageView];
    
    
    UILabel *onlineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 15)];
    onlineLabel.center = CGPointMake(kScreen_Width/2-10-0.25, height(bgImageView.frame)-7.5);
    onlineLabel.textColor = zBlueColor;
    onlineLabel.textAlignment = NSTextAlignmentCenter;
    onlineLabel.font = ZEBFont(10);
    
    [bgImageView addSubview:onlineLabel];
    self.onlineLabel = onlineLabel;
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width/2-0.25, height(bgImageView.frame)-10-2.5, 0.5, 10)];
    line.backgroundColor = [UIColor lightGrayColor];
    [bgImageView addSubview:line];
    
    UILabel *notOnlineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 15)];
    notOnlineLabel.center = CGPointMake(kScreen_Width/2+10+0.25, height(bgImageView.frame)-7.5);
    notOnlineLabel.textColor = [UIColor grayColor];
    notOnlineLabel.textAlignment = NSTextAlignmentCenter;
    notOnlineLabel.font = ZEBFont(10);
    
    [bgImageView addSubview:notOnlineLabel];
    self.notOnlineLabel = notOnlineLabel;
    
    
    UILabel *gLabel = [[UILabel alloc] initWithFrame:CGRectMake(width(self.frame)/2-18, 6, 36, 6)];
    gLabel.backgroundColor = [UIColor lightGrayColor];
    gLabel.layer.masksToBounds = YES;
    gLabel.layer.cornerRadius = 3;
    [_topView addSubview:gLabel];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    imageView.center = CGPointMake(kScreenWidth-12.5, (64-25)/2+12.5);
    imageView.image = [UIImage imageNamed:@"rightarrow"];
    [_topView addSubview:imageView];
    
    _tableView = [[ZEBTableView alloc] initWithFrame:CGRectMake(0,0, topViewHeight-18,kScreen_Width-25) style:UITableViewStyleGrouped];
    _tableView.center = CGPointMake(_topView.center.x-25, _topView.center.y+10);
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    // scrollbar 不显示
    _tableView.showsVerticalScrollIndicator = NO;
    [_topView addSubview:_tableView];
    
    UIPanGestureRecognizer *pangesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panPullView:)];
    
    [_topView addGestureRecognizer:pangesture];
    
    AlView *alView = [[AlView alloc] initWithFrame:CGRectMake(0, 0, topViewHeight-19, 30) type:TRANSPARENT_GRADIENT_TYPE];
    alView.center = CGPointMake(kScreenWidth-35.5-15, midY(_tableView)-1);
    alView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    alView.userInteractionEnabled = NO;
    [_topView addSubview:alView];
    
    UISwipeGestureRecognizer *swipgesturedown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipPullView:)];
    swipgesturedown.direction = UISwipeGestureRecognizerDirectionDown; //设置向下清扫
    [_topView addGestureRecognizer:swipgesturedown];

    [pangesture requireGestureRecognizerToFail:swipgesturedown];
    
}
- (void)getCacheMember {
    
    [self.soureArray removeAllObjects];
    NSString *chatId = [[NSUserDefaults standardUserDefaults] objectForKey:@"chatId"];
    TeamsListModel *model = [[[DBManager sharedManager] GrouplistSQ] selectGrouplistById:chatId];
    NSArray *membersArray = [model.memebers componentsSeparatedByString:@","];
    for (NSString *uid in membersArray) {
    GroupMemberModel *gModel = [[[DBManager sharedManager] personnelInformationSQ] selectDepartmentGroupMemberModelById:uid];
        if (gModel != nil) {
            [self.soureArray addObject:gModel];
        }
    }
    [_tableView reloadData];
}
#pragma mark -
#pragma mark 返回分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
#pragma mark -
#pragma mark 返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.soureArray.count;
}
#pragma mark -
#pragma mark UITableViewCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"identifier";
    
    ChatMapTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ChatMapTopTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
    cell.index = indexPath.row;
    cell.model = self.soureArray[indexPath.row];
    cell.delegate = self;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}
- (void)reload:(NSArray *)memberArray {

    
    //将数据按照status排序
    NSMutableArray *notOnLine = [NSMutableArray array];
    NSMutableArray *onLineHavePost = [NSMutableArray array];
    NSMutableArray *onLineNotHavePost = [NSMutableArray array];
    NSMutableArray *results = [NSMutableArray array];
    NSInteger count = memberArray.count;
    NSInteger onlineCount = 0;
    for (ChatMapModel *model in memberArray) {
        if ([model.status integerValue] == ONLINEHAVEPOST) {
            onlineCount++;
            [onLineHavePost addObject:model];
        }else if ([model.status integerValue] == NOTONLINE) {
            [notOnLine addObject:model];
        }else if ([model.status integerValue] == ONLINENOTHAVEPOSI) {
            onlineCount++;
            [onLineNotHavePost addObject:model];
        }
    }
    [results addObjectsFromArray:onLineHavePost];
    [results addObjectsFromArray:onLineNotHavePost];
    [results addObjectsFromArray:notOnLine];
    [self.soureArray removeAllObjects];
    [self.soureArray addObjectsFromArray:results];
   
    [_tableView reloadData];
    self.onlineLabel.text = [NSString stringWithFormat:@"%ld",onlineCount];
    self.notOnlineLabel.text = [NSString stringWithFormat:@"%ld",count-onlineCount];

}

#pragma mark -
#pragma mark pan手势

- (void)panPullView:(UIPanGestureRecognizer *)pangesture {
    [self endEditing:YES];
    [LYRouter openURL:@"ly://mapdismiss"];
    CGPoint offset = [pangesture translationInView:self];//得到手指的位移
   // CameraMoveDirection direction = [LZXHelper commitTranslation:offset];
    
    CGRect rect = self.frame;
    CGFloat h = rect.origin.y;
    
    if (pangesture.state == UIGestureRecognizerStateBegan) {
        
        //处理拖动过程漏出白底界面
        _bottomView.frame = CGRectMake(0, topViewHeight-1, kScreen_Width, kScreenHeight);
        [_chatController.chatBar endInputing];
        _chatController.chatBar.winHeight = height(_bottomView.frame);
        
        [UIView animateWithDuration:0.3 animations:^{
            _chatController.tableView.frame = CGRectMake(0, 0, kScreen_Width, height(_bottomView.frame)- kMinHeight);
            
            _chatController.chatBar.frame = CGRectMake(0, height(_chatController.view.frame) - kMinHeight, self.frame.size.width, kMinHeight);
            
        } completion:^(BOOL finished) {
           
        }];
        
        
    }
    if (pangesture.state == UIGestureRecognizerStateChanged) {
        
        if (h >= 64) {
            [UIView animateWithDuration:0.15 animations:^{
                [self setCenter:CGPointMake(self.center.x, self.center.y + offset.y)];
                [pangesture setTranslation:CGPointMake(0, 0) inView:self];
            }];
            
        }else if (h <= kScreenHeight-64) {
            [UIView animateWithDuration:0.15 animations:^{
                [self setCenter:CGPointMake(self.center.x, self.center.y + offset.y)];
                [pangesture setTranslation:CGPointMake(0, 0) inView:self];
            }];
            
        }
        
                
        self.effectView.alpha = 1 - (h/(HeightC));
              
         
       // NSLog(@"我的大小%@---HeightC= %f---h=%f========alpha=%f",NSStringFromCGRect(rect),HeightC,h,1 - (h/(HeightC)));
        
    } else if(pangesture.state == UIGestureRecognizerStateEnded){
        
        
                
        if ( h <= HeightC/2) {
            
            [self isToTop];
       
        } else if( h > HeightC/2 && h < kScreenHeight*0.75){
          
            [self isToCenter];
            
        }else if (h >= kScreenHeight*0.75) {
            [self isToBottom];
        }
    }
}
#pragma mark -
#pragma mark swip手势
- (void)swipPullView:(UISwipeGestureRecognizer *)swipgesture {
    [self endEditing:YES];
    [LYRouter openURL:@"ly://mapdismiss"];
    [_chatController.chatBar endInputing];
    if (self.isTop) {
       if (swipgesture.direction == UISwipeGestureRecognizerDirectionDown){
            [self isToCenter];
        }

    }else if (self.isCenter) {
        if (swipgesture.direction == UISwipeGestureRecognizerDirectionDown){
            [self isToBottom];

        }
    }else if (self.isBottom) {
       if (swipgesture.direction == UISwipeGestureRecognizerDirectionDown){
            [self isToBottom];
        }
        
    }
}
- (void)isToTop {
    self.isTop = YES;
    self.isCenter = NO;
    self.isBottom = NO;
    self.effectView.userInteractionEnabled = YES;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, 64, kScreen_Width, kScreenHeight-64);
        self.effectView.alpha = 0.7;
    }];
    
    _bottomView.frame = CGRectMake(0, topViewHeight-1, kScreen_Width, height(self.frame)-topViewHeight+1);
    
    _chatController.chatBar.winHeight = height(_bottomView.frame);
    [UIView animateWithDuration:0.3 animations:^{
        _chatController.tableView.frame = CGRectMake(0, 0, kScreen_Width, height(_bottomView.frame)- kMinHeight);
        _chatController.chatBar.frame = CGRectMake(0, height(_chatController.view.frame) - kMinHeight, self.frame.size.width, kMinHeight);
    }];


}
- (void)isToCenter {
    self.isTop = NO;
    self.isCenter = YES;
    self.isBottom = NO;
    self.effectView.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, HeightC, kScreen_Width, kScreenHeight - HeightC);
        self.effectView.alpha = 0.0;
    }];
    
    _bottomView.frame = CGRectMake(0, topViewHeight-1, kScreen_Width, height(self.frame)-topViewHeight+1);
    
    _chatController.chatBar.winHeight = height(_bottomView.frame);
    [UIView animateWithDuration:0.3 animations:^{
        _chatController.tableView.frame = CGRectMake(0, 0, kScreen_Width, height(_bottomView.frame)- kMinHeight);
        _chatController.chatBar.frame = CGRectMake(0, height(_bottomView.frame) - kMinHeight, self.frame.size.width, kMinHeight);
    }];

}
- (void)isToBottom {
    self.isTop = NO;
    self.isCenter = NO;
    self.isBottom = YES;
    self.effectView.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, kScreenHeight-63, kScreen_Width, 64);
        self.effectView.alpha = 0.0;
    }];
    
}


#pragma mark -
#pragma mark 点击头像
- (void)chatMapTopTableViewCell:(ChatMapTopTableViewCell *)cell index:(NSInteger)index {
    [self endEditing:YES];
    if ([self.soureArray[index] isKindOfClass:[GroupMemberModel class]]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowHudNotfication" object:@"正在获取位置信息"];
    }else if ([self.soureArray[index] isKindOfClass:[ChatMapModel class]]) {
    ChatMapModel *model = self.soureArray[index];
    if ([model.status integerValue] == NOTONLINE) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowHudNotfication" object:@"对方不在线"];
    }else {
        if ([model.status integerValue] == ONLINENOTHAVEPOSI) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowHudNotfication" object:@"对方没有共享位置信息"];
        }else{
            if (!self.isBottom) {
                [self isToBottom];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:MapShowMemberNotification object:model];
        }
    }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
