//
//  XMNChatImageMessageCell.h
//  XMNChatExample
//
//  Created by shscce on 15/11/16.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import "XMNChatMessageCell.h"

@interface XMNChatImageMessageCell : XMNChatMessageCell

/**
 *  用来显示image的UIImageView
 */
@property (nonatomic, strong) UIImageView *messageImageView;

- (void)setUploadProgress:(CGFloat)uploadProgress;

@end
