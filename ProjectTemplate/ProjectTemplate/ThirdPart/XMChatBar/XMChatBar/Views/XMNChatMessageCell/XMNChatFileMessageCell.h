//
//  XMNChatFileMessageCell.h
//  ProjectTemplate
//
//  Created by caohanchao on 2017/3/14.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "XMNChatMessageCell.h"

@interface XMNChatFileMessageCell : XMNChatMessageCell

@property (nonatomic,assign)NSInteger downloadState;  // 0.未下载    1正在下载   2下载完

@end
