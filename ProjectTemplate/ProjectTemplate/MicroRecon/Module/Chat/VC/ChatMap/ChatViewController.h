//
//  ChatViewController.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/23.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMNChat.h"
#import "XMNChatViewModel.h"

typedef enum : NSUInteger {
    ChatList1,
    GroupTeam1,
    SearchC1
} COMETYPE1;

@interface ChatViewController : UIViewController

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) XMChatBar *chatBar;
@property (copy, nonatomic) NSString *chatterName /**< 正在聊天的用户昵称 */;
@property (copy, nonatomic) NSString *chatterThumb /**< 正在聊天的用户头像 */;
@property (nonatomic, strong) XMNChatViewModel *chatViewModel;
//该界面的UIViewController
@property (nonatomic, weak) UIViewController *myUIViewController;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) COMETYPE1 cType;//区分来自哪个界面

@property (nonatomic,copy)NSString *beginTime;

- (instancetype)initWithChatType:(XMNMessageChat)messageChatType;
# pragma to_do
-(void)loadNewData;
/**
 *  让tableView滚动到最底部
 */
- (void)scrollToBottom:(BOOL)animated;
@end
