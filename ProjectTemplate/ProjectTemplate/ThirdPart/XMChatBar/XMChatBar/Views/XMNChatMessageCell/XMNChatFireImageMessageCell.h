//
//  XMNChatFireImageMessageCell.h
//  ProjectTemplate
//
//  Created by 李凯华 on 17/3/8.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "XMNChatMessageCell.h"

@interface XMNChatFireImageMessageCell : XMNChatMessageCell
@property (nonatomic, strong) UIImageView *messageImageView;

- (void)setUploadProgress:(CGFloat)uploadProgress;
@end
