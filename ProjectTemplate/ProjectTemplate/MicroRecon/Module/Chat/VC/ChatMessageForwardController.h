//
//  ChatMessageForwardController.h
//  ProjectTemplate
//
//  Created by 绿之云 on 16/9/21.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICometModel.h"
@interface ChatMessageForwardController : UITableViewController

//@property(nonatomic,copy)NSString *mType;
//
//@property(nonatomic,copy)NSString *message;

@property(nonatomic,assign)NSInteger messageID;//消息的唯一标识

@property(nonatomic,copy)NSString * pushViewStr;//

@property(nonatomic,copy)NSString * imageUrlStr;//

@end
