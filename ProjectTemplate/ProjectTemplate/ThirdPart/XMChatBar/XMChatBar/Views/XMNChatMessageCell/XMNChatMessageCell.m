//
//  XMNChatMessageCell.m
//  XMNChatExample
//
//  Created by shscce on 15/11/13.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import "XMNChatMessageCell.h"
#import "XMNChatTextMessageCell.h"
#import "XMNChatImageMessageCell.h"
#import "XMNChatVoiceMessageCell.h"
#import "XMNChatSystemMessageCell.h"
#import "XMNChatLocationMessageCell.h"
#import "XMNChatVideoMessageCell.h"
#import "XMNChatReleaseTaskMessageCell.h"
#import "Masonry.h"
#import <objc/runtime.h>
#import "UIImageView+CornerRadius.h"
#import "UIImageView+XMWebImage.h"
#import "NSDate+Extensions.h"
#import "UIResponder+FirstResponder.h"
#import "ZMLPlaceholderTextView.h"



@interface XMNChatMessageCell ()<UIGestureRecognizerDelegate>

@property (nonatomic,assign)NSInteger qid;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *alarm;
@property (nonatomic, copy) NSString *textField;
@property (nonatomic, copy) NSString *fire;

@end

@implementation XMNChatMessageCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
        [self addNotificationCenter];
    }
    return self;
}

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        [self addNotificationCenter];
    }
    return self;
}
#pragma mark -
#pragma mark NSNotificationCenter
- (void)addNotificationCenter {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(canPerformAction:withSender:) name:XMNChatMessageCellCanPerformActionNotificationCenter object:nil];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - Override Methods


- (void)updateConstraints {
    [super updateConstraints];
    if (self.messageOwner == XMNMessageOwnerSystem) {
        return;
    }
    if (self.messageOwner == XMNMessageOwnerUnknown) {
        return;
    }
    if (self.messageOwner == XMNMessageOwnerSelf) {
        [self.headIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).with.offset(-16);
            make.top.equalTo(self.contentView.mas_top).with.offset(16);
            make.width.equalTo(@50);
            make.height.equalTo(@50);
        }];
        
        [self.nicknameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headIV.mas_top);
            make.right.equalTo(self.headIV.mas_left).with.offset(-9);
            make.width.mas_lessThanOrEqualTo(@120);
            make.height.equalTo(self.messageChatType == XMNMessageChatGroup ? @16 : @0);
        }];
        [self.postnameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headIV.mas_top);
            make.right.equalTo(self.nicknameL.mas_left).offset(-5);
            make.width.mas_lessThanOrEqualTo(@100);
            make.height.equalTo(self.messageChatType == XMNMessageChatGroup ? @16 : @0);
        }];
        [self.messageContentV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.headIV.mas_left).with.offset(-9);
            make.top.equalTo(self.nicknameL.mas_bottom).with.offset(4);
            make.width.lessThanOrEqualTo(@([UIApplication sharedApplication].keyWindow.frame.size.width/5*3)).priorityHigh();
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-16).priorityLow();
        }];
        
//        [self.messageSendStateIV mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.messageContentV.mas_left).with.offset(-8);
//            make.centerY.equalTo(self.messageContentV.mas_centerY);
//            make.width.equalTo(@20);
//            make.height.equalTo(@20);
//        }];
        
        [self.messageReadStateIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.messageContentV.mas_left).with.offset(-8);
            make.centerY.equalTo(self.messageContentV.mas_centerY);
            make.width.equalTo(@10);
            make.height.equalTo(@10);
        }];
        
      //  if (self.fireMessageType == messageLock) {
            [self.fireMessageLockVI mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.messageContentBackgroundIV.mas_left).offset(12);
                make.top.equalTo(self.messageContentBackgroundIV.mas_top).offset(-2);
                make.width.equalTo(@14);
                make.height.equalTo(@14);
            }];
        
        
        [self.fireMessageTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.messageContentBackgroundIV.mas_left).offset(12);
            make.top.equalTo(self.messageContentBackgroundIV.mas_top).offset(-2);
            make.width.equalTo(@14);
            make.height.equalTo(@14);
        }];
        
        //}
        
    }else if (self.messageOwner == XMNMessageOwnerOther){
        [self.headIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(16);
            make.top.equalTo(self.contentView.mas_top).with.offset(16);
            make.width.equalTo(@50);
            make.height.equalTo(@50);
        }];
        [self.postnameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headIV.mas_top);
            make.left.equalTo(self.headIV.mas_right).with.offset(9);
            make.width.mas_lessThanOrEqualTo(@100);
            make.height.equalTo(self.messageChatType == XMNMessageChatGroup ? @16 : @0);
        }];
        [self.nicknameL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headIV.mas_top);
            make.left.equalTo(self.postnameL.mas_right).offset(5);
            make.width.mas_lessThanOrEqualTo(@120);
            make.height.equalTo(self.messageChatType == XMNMessageChatGroup ? @16 : @0);
        }];
        
        [self.messageContentV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headIV.mas_right).with.offset(9);
            make.top.equalTo(self.nicknameL.mas_bottom).with.offset(4);
            make.width.lessThanOrEqualTo(@([UIApplication sharedApplication].keyWindow.frame.size.width/5*3)).priorityHigh();
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-16).priorityLow();
        }];
        
//        [self.messageSendStateIV mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.messageContentV.mas_right).with.offset(8);
//            make.centerY.equalTo(self.messageContentV.mas_centerY);
//            make.width.equalTo(@20);
//            make.height.equalTo(@20);
//        }];
        
        [self.messageReadStateIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.messageContentV.mas_right).with.offset(8);
            make.centerY.equalTo(self.messageContentV.mas_centerY);
            make.width.equalTo(@10);
            make.height.equalTo(@10);
        }];
        
        [self.fireMessageLockVI mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.messageContentBackgroundIV.mas_right).offset(2);
            make.top.equalTo(self.messageContentBackgroundIV.mas_top).offset(-2);
            make.width.equalTo(@14);
            make.height.equalTo(@14);
        }];
        
        [self.fireMessageTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.messageContentBackgroundIV.mas_right).offset(2);
            make.top.equalTo(self.messageContentBackgroundIV.mas_top).offset(-2);
            make.width.equalTo(@14);
            make.height.equalTo(@14);
        }];
        
        [self.fireMessageTVI mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.messageContentBackgroundIV.mas_right).offset(-12);
            make.top.equalTo(self.messageContentBackgroundIV.mas_top).offset(8);
            make.width.equalTo(@15);
            make.height.equalTo(@16);
        }];

    }
    
    [self.timeL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@200);
        make.height.mas_equalTo(@14);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
    
    [self.messageContentBackgroundIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.messageContentV);
    }];
    
    if (self.messageChatType == XMNMessageChatSingle) {
        [self.nicknameL mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        [self.postnameL mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    CGPoint touchPoint = [[touches anyObject] locationInView:self.contentView];
    if (CGRectContainsPoint(self.messageContentV.frame, touchPoint)) {
        self.messageContentBackgroundIV.highlighted = YES;
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    self.messageContentBackgroundIV.highlighted = NO;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    self.messageContentBackgroundIV.highlighted = NO;
}


#pragma mark - Private Methods

- (void)setup {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.timeL];
    [self.contentView addSubview:self.headIV];
    [self.contentView addSubview:self.nicknameL];
    [self.contentView addSubview:self.postnameL];
    [self.contentView addSubview:self.messageContentV];
    [self.contentView addSubview:self.messageReadStateIV];
    
    [self.contentView addSubview:self.fireMessageLockVI];
    [self.contentView addSubview:self.fireMessageTVI];
    
     [self.contentView addSubview:self.fireMessageTimeLabel];
    
    self.fireMessageTimeLabel.hidden = YES;
    self.fireMessageTVI.hidden = YES;
    self.fireMessageLockVI.hidden = YES;
    self.fireMessageLockVI.image = [UIImage imageNamed:@"lock"];
    self.fireMessageTVI.image = [UIImage imageNamed:@"T"];
    
    //处理消息重发的回调
    __weak XMNChatMessageCell *weakself = self;
    self.messageSendStateIV.restartSendBlock = ^(void){
        
        if ([weakself.delegate respondsToSelector:@selector(messageCellFailState:)]) {
            [weakself.delegate messageCellFailState:weakself];
        }
        ZEBLog(@"消息重发的回调");
    };
    
    self.messageSendStateIV.hidden = YES;
    self.messageReadStateIV.hidden = YES;
    
    if (self.messageOwner == XMNMessageOwnerSelf) {
        if (self.messageType == XMNMessageTypeReleaseTask) {
            
            [self.messageContentBackgroundIV setImage:[[UIImage imageNamed:@"chat_track_icon_right"] resizableImageWithCapInsets:UIEdgeInsetsMake(21, 32, 21, 33) resizingMode:UIImageResizingModeStretch]];
        }else if(self.messageType == XMNMessageTypeImage){
            [self.messageContentBackgroundIV setImage:[[UIImage imageNamed:@"send_normal_3"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 16, 18, 19) resizingMode:UIImageResizingModeStretch]];
            
        }else if(self.messageType == XMNMessageTypeVideo){
            [self.messageContentBackgroundIV setImage:[[UIImage imageNamed:@"send_normal_3"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 16, 18, 19) resizingMode:UIImageResizingModeStretch]];
        }else if (self.messageType == XMNMessageTypeLocation)
        {
            [self.messageContentBackgroundIV setImage:[[UIImage imageNamed:@"send_normal_2"] resizableImageWithCapInsets:UIEdgeInsetsMake(17, 56.5, 18, 56.5) resizingMode:UIImageResizingModeStretch]];
//            [self.messageContentBackgroundIV setImage:[[UIImage imageNamed:@"send_normal_3"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 16, 18, 19) resizingMode:UIImageResizingModeStretch]];
        
        }else {
            [self.messageContentBackgroundIV setImage:[[UIImage imageNamed:@"send_normal_1"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 16, 18, 19) resizingMode:UIImageResizingModeStretch]];
            [self.messageContentBackgroundIV setHighlightedImage:[[UIImage imageNamed:@"send_hight_1"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 16, 18, 19) resizingMode:UIImageResizingModeStretch]];
        }
    }else if (self.messageOwner == XMNMessageOwnerOther){
        if (self.messageType == XMNMessageTypeReleaseTask) {
            [self.messageContentBackgroundIV setImage:[[UIImage imageNamed:@"chat_track_icon_left"] resizableImageWithCapInsets:UIEdgeInsetsMake(21, 32, 21, 33) resizingMode:UIImageResizingModeStretch]];
            
        }else if(self.messageType == XMNMessageTypeImage){
        [self.messageContentBackgroundIV setImage:[[UIImage imageNamed:@"rec_normal_3"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 19, 18, 16) resizingMode:UIImageResizingModeStretch]];
            
        }else if(self.messageType == XMNMessageTypeVideo){
            [self.messageContentBackgroundIV setImage:[[UIImage imageNamed:@"rec_normal_3"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 19, 18, 16) resizingMode:UIImageResizingModeStretch]];
        }
        else if (self.messageType == XMNMessageTypeLocation)
        {
            [self.messageContentBackgroundIV setImage:[[UIImage imageNamed:@"rec_normal_2"] resizableImageWithCapInsets:UIEdgeInsetsMake(17, 56.5, 18, 56.5) resizingMode:UIImageResizingModeStretch]];
//            [self.messageContentBackgroundIV setImage:[[UIImage imageNamed:@"rec_normal_3"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 19, 18, 16) resizingMode:UIImageResizingModeStretch]];
            
        }else {
            [self.messageContentBackgroundIV setImage:[[UIImage imageNamed:@"rec_normal_1"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 19, 18, 16) resizingMode:UIImageResizingModeStretch]];
            [self.messageContentBackgroundIV setHighlightedImage:[[UIImage imageNamed:@"rec_hight_1"] resizableImageWithCapInsets:UIEdgeInsetsMake(18, 19, 18, 16) resizingMode:UIImageResizingModeStretch]];
        }
    }
    
    self.messageContentV.maskView = [[UIImageView alloc] initWithImage:self.messageContentBackgroundIV.image highlightedImage:self.messageContentBackgroundIV.highlightedImage];
//    self.messageContentV.layer.mask.contents = (__bridge id _Nullable)(self.messageContentBackgroundIV.image.CGImage);

    [self.contentView insertSubview:self.messageContentBackgroundIV belowSubview:self.messageContentV];
    
    [self updateConstraintsIfNeeded];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    singleTap.delegate = self;
//    [singleTap setNumberOfTapsRequired:1];
    [self.contentView addGestureRecognizer:singleTap];
    
    //文本双击
    if (self.messageType == XMNMessageTypeText) {
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
        [doubleTap setNumberOfTapsRequired:2];
        doubleTap.numberOfTouchesRequired = 1;
        doubleTap.delegate = self;
        [self.contentView addGestureRecognizer:doubleTap];
        [singleTap requireGestureRecognizerToFail:doubleTap];
    }
    
    

    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.numberOfTouchesRequired = 1;
    longPress.minimumPressDuration = 1.f;
    [self.contentView addGestureRecognizer:longPress];
    
}
//解决事件冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件(只解除的是cell与手势间的冲突，cell以外仍然响应手势)
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"MLEmojiLabel"])
    {
        return NO;
    }
        return YES;
}

#pragma mark - Public Methods

- (void)configureCellWithData:(id)data {

    self.name = data[kXMNMessageConfigurationNicknameKey];
    self.alarm = data[kXMNMessageConfigurationAlarmKey];
    self.textField=data[kXMNMessageConfigurationTextKey];
    
    self.nicknameL.text = data[kXMNMessageConfigurationNicknameKey];
    
    self.fire = data[kXMNMessageConfigurationFireKey];
     if ([self.fire containsString:@"LOCK"]) {
        self.fireMessageLockVI.hidden = NO;
         self.fireMessageTVI.hidden = NO;
         
    }else
    {
        self.fireMessageLockVI.hidden = YES;
        self.fireMessageTVI.hidden = YES;
    }
    
    
    NSString *DE_type = data[kXMNMessageConfigurationDETypeKey];
    NSString *DE_name = data[kXMNMessageConfigurationDENameKey];
    
    if ([[LZXHelper isNullToString:DE_name] isEqualToString:@""]) {
        UserAllModel *model = [[[DBManager sharedManager] personnelInformationSQ] selectDepartmentmemberlistById:self.alarm];
        UnitListModel *uModel = [[[DBManager sharedManager] DepartmentlistSQ] selectDepartmentlistById:model.RE_department];
        DE_type = uModel.DE_type;
        DE_name = [LZXHelper isNullToString:model.RE_post];
    }
    if ([[LZXHelper isNullToString:DE_type] isEqualToString:@""]) {
        self.postnameL.backgroundColor = [UIColor colorWithHexString:@"#96b0fb"];
        self.postnameL.text = @" 武汉市公安局 ";
    }else {
        if ([DE_type isEqualToString:@"0"]) {//0警察公务组织紫，1技术支持绿
            self.postnameL.backgroundColor = [UIColor colorWithHexString:@"#96b0fb"];
            self.postnameL.text = [NSString stringWithFormat:@" %@ ",DE_name];
        }else if ([DE_type isEqualToString:@"1"]) {
            self.postnameL.backgroundColor = [UIColor colorWithHexString:@"#6cd9a3"];
            self.postnameL.text = [NSString stringWithFormat:@" %@ ",DE_name];
        }

    }

//    self.timeL.text =[self timeChage:data[kXMNMessageConfigurationTimeKey]];

    
    if ([data[kXMNMessageConfigurationTimeKey]isEqualToString:@"0"]) {
        
        self.timeL.text = nil;
    }
    else
    {
        self.timeL.text =[ data[kXMNMessageConfigurationTimeKey] timeChage];
    }
    
    
    
    
    self.qid =[data[kXMNMessageConfigurationQIDKey] integerValue];
    
    if (!data[kXMNMessageConfigurationAvatarKey]) {
        //[self.headIV setImage:[UIImage imageNamed:@"ph_s"]];
        [self.headIV imageGetCacheForAlarm:self.alarm forUrl:data[kXMNMessageConfigurationAvatarKey]];
    }else {
        //[self.headIV setImageWithUrlString:data[kXMNMessageConfigurationAvatarKey]];
        [self.headIV imageGetCacheForAlarm:self.alarm forUrl:data[kXMNMessageConfigurationAvatarKey]];
    }
    if (data[kXMNMessageConfigurationReadStateKey]) {
        self.messageReadState = [data[kXMNMessageConfigurationReadStateKey] integerValue];
    }
    if (data[kXMNMessageConfigurationSendStateKey]) {
        self.messageSendState = [data[kXMNMessageConfigurationSendStateKey] integerValue];
    }
    
//    if (data[kXMNMessageConfigurationFireKey]) {
//        self.fireType = data[kXMNMessageConfigurationFireKey];
//        if (![[LZXHelper isNullToString:self.fireType] isEqualToString:@""]) {
//            if ([self.fireType isEqualToString:@"LOCK"]) {
//                self.fireMessageLockVI.hidden = NO;
//            }
//        }
//    }
    
}






#pragma mark - Private Methods
- (void)handleTap:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateEnded) {
        CGPoint tapPoint = [tap locationInView:self.contentView];
        if (CGRectContainsPoint(self.messageContentV.frame, tapPoint)) {
            [self.delegate messageCellTappedMessage:self];
        }else if (CGRectContainsPoint(self.headIV.frame, tapPoint)) {
            [self.delegate messageCellTappedHead:self];
        }else {
            [self.delegate messageCellTappedBlank:self];
        }
    }
}

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (tap.state == UIGestureRecognizerStateEnded) {
        CGPoint tapPoint = [tap locationInView:self.contentView];
        if (CGRectContainsPoint(self.messageContentV.frame, tapPoint)) {
            [self.delegate messageCellDoubleTappedMessage:self];
        }

    }
}

#pragma mark - Setters

- (void)setMessageSendState:(XMNMessageSendState)messageSendState {
    _messageSendState = messageSendState;
    if (self.messageOwner == XMNMessageOwnerOther) {
        self.messageSendStateIV.hidden = YES;
    }
    
//     self.messageSendStateIV.hidden = NO;
    switch (_messageSendState) {
        case XMNMessageSendSuccess:
            self.messageSendStateIV.hidden = YES;
            break;
        case XMNMessageSendStateSending:
            self.messageSendStateIV.hidden = YES;
            break;
        case XMNMessageSendFail:
            self.messageSendStateIV.hidden = NO;
            break;
        default:
            self.messageSendStateIV.hidden = YES;
            break;
    }
    self.messageSendStateIV.messageSendState = messageSendState;
    
}

- (void)setMessageReadState:(XMNMessageReadState)messageReadState {
    _messageReadState = messageReadState;
    if (self.messageOwner == XMNMessageOwnerSelf) {
        self.messageReadStateIV.hidden = YES;
    }
    switch (_messageReadState) {
        case XMNMessageUnRead:
            self.messageReadStateIV.hidden = NO;
            break;
        default:
            self.messageReadStateIV.hidden = YES;
            break;
    }
}

#pragma mark - Getters

- (UIView *)timeL {
    if (!_timeL) {
        _timeL = [[UILabel alloc] init];
        _timeL.font = [UIFont systemFontOfSize:9.0f];
        _timeL.textColor = [UIColor grayColor];
        _timeL.textAlignment = NSTextAlignmentCenter;
    }
    return _timeL;
}

- (UIImageView *)headIV {
    if (!_headIV) {
        _headIV = [[UIImageView alloc] initWithCornerRadiusAdvance:25 rectCornerType:UIRectCornerAllCorners];
        _headIV.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _headIV;
}

- (UILabel *)nicknameL {
    if (!_nicknameL) {
        _nicknameL = [[UILabel alloc] init];
        _nicknameL.font = [UIFont systemFontOfSize:12.0f];
        _nicknameL.textColor = [UIColor blackColor];
        
    }
    return _nicknameL;
}
- (UILabel *)postnameL {
    if (!_postnameL) {
        _postnameL = [[UILabel alloc] init];
        _postnameL.font = [UIFont systemFontOfSize:8.0f];
        _postnameL.textColor = [UIColor whiteColor];
        _postnameL.layer.masksToBounds = YES;
        _postnameL.layer.cornerRadius = 3;
    }
    return _postnameL;
}
- (XMNContentView *)messageContentV {
    if (!_messageContentV) {
        _messageContentV = [[XMNContentView alloc] init];
    }
    return _messageContentV;
}

- (UIImageView *)messageReadStateIV {
    if (!_messageReadStateIV) {
        _messageReadStateIV = [[UIImageView alloc] init];
        _messageReadStateIV.backgroundColor = [UIColor redColor];
    }
    return _messageReadStateIV;
}

- (XMNSendImageView *)messageSendStateIV {
    if (!_messageSendStateIV) {
        _messageSendStateIV = [[XMNSendImageView alloc] init];
    }
    return _messageSendStateIV;
}

- (UIImageView *)messageContentBackgroundIV {
    if (!_messageContentBackgroundIV) {
        _messageContentBackgroundIV = [[UIImageView alloc] init];
    }
    return _messageContentBackgroundIV;
}
- (UIImageView *)fireMessageLockVI {
    if (!_fireMessageLockVI) {
        _fireMessageLockVI = [[UIImageView alloc] init];
    }
    return _fireMessageLockVI;
}

- (UIImageView *)fireMessageTVI {
    if (!_fireMessageTVI) {
        _fireMessageTVI = [[UIImageView alloc] init];
    }
    return _fireMessageTVI;
}

- (UILabel *)fireMessageTimeLabel {
    if (!_fireMessageTimeLabel) {
        _fireMessageTimeLabel = [[UILabel alloc] init];
        _fireMessageTimeLabel.backgroundColor = CHCHexColor(@"ff7200");
        _fireMessageTimeLabel.layer.masksToBounds = YES;
        _fireMessageTimeLabel.layer.cornerRadius = 7;
        _fireMessageTimeLabel.font = [UIFont systemFontOfSize:8];
        _fireMessageTimeLabel.textColor = CHCHexColor(@"ffffff");
        _fireMessageTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _fireMessageTimeLabel;
}

- (XMNMessageType)messageType {
    
    if ([self isKindOfClass:[XMNChatTextMessageCell class]]) {
        return XMNMessageTypeText;
    }else if ([self isKindOfClass:[XMNChatImageMessageCell class]]) {
        return XMNMessageTypeImage;
    }else if ([self isKindOfClass:[XMNChatVoiceMessageCell class]]) {
        return XMNMessageTypeVoice;
    }else if ([self isKindOfClass:[XMNChatLocationMessageCell class]]) {
        return XMNMessageTypeLocation;
    }else if ([self isKindOfClass:[XMNChatSystemMessageCell class]]) {
        return XMNMessageTypeSystem;
    } else if ([self isKindOfClass:[XMNChatVideoMessageCell class]]) {
        return XMNMessageTypeVideo;
    }else if ([self isKindOfClass:[XMNChatReleaseTaskMessageCell class]]) {
        return XMNMessageTypeReleaseTask;
    }
    return XMNMessageTypeUnknow;
}

- (XMNMessageChat)messageChatType {
    if ([self.reuseIdentifier containsString:@"GroupCell"]) {
        return XMNMessageChatGroup;
    } {
        return XMNMessageChatSingle;
    }
}

- (XMNMessageOwner)messageOwner {
    if ([self.reuseIdentifier containsString:@"OwnerSelf"]) {
        return XMNMessageOwnerSelf;
    }else if ([self.reuseIdentifier containsString:@"OwnerOther"]) {
        return XMNMessageOwnerOther;
    }else if ([self.reuseIdentifier containsString:@"OwnerSystem"]) {
        return XMNMessageOwnerSystem;
    }
    return XMNMessageOwnerUnknown;
}


@end



#pragma mark - XMNChatMessageCellMenuActionCategory

NSString * const kXMNChatMessageCellMenuControllerKey;


@implementation XMNChatMessageCell (XMNChatMessageCellMenuAction)

#pragma mark - Private Methods

//以下两个方法必须有
/*
 *  让UIView成为第一responser
 */
- (BOOL)canBecomeFirstResponder{
    return YES;
}

/*
 *  根据action,判断UIMenuController是否显示对应aciton的title
 */
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    if (self.messageType == XMNMessageTypeText) {
        
        if (self.messageOwner == XMNMessageOwnerSelf) {
             if ([self.fire containsString:@"LOCK"])
             {
                 if (action == @selector(menuWithdrawAction)) {
                     return YES;
                 }
             }
            else
            {
                if (action == @selector(menuRelayAction) || action == @selector(menuCopyAction) || action == @selector(menuWithdrawAction)) {
                    return YES;
                }
            }
            
        }else {
            if (![self.fire containsString:@"LOCK"])
            {
                if (action == @selector(menuRelayAction) || action == @selector(menuCopyAction)) {
                    return YES;
                }
            }
        }
        
    }else if (self.messageType == XMNMessageTypeImage ||self.messageType ==XMNMessageTypeLocation)
    {
        if (self.messageOwner == XMNMessageOwnerSelf) {
            if (action == @selector(menuRelayAction) || action == @selector(menuWithdrawAction)) {
                return YES;
            }
        }else {
            if (action == @selector(menuRelayAction)) {
                return YES;
            }
        }
        
    }else {
        return [super canPerformAction:action withSender:sender];
    }
    
    return NO;
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPressGes {
    if (longPressGes.state == UIGestureRecognizerStateBegan) {
        CGPoint longPressPoint = [longPressGes locationInView:self.contentView];
        if (CGRectContainsPoint(self.messageContentV.frame, longPressPoint)) {
            
            //获取第一响应者
            UIView *view = [UIResponder currentFirstResponder];
            if ([view isKindOfClass:[ZMLPlaceholderTextView class]]) {
                self.zmlPlaceholderTextView = (ZMLPlaceholderTextView *)view;
                self.zmlPlaceholderTextView.overrideNextResponder = self;
                [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerDidHideMenuNotification object:nil];
                
                [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(menuDidHide:) name:UIMenuControllerDidHideMenuNotification object:nil];
            }else {
                [self becomeFirstResponder];
            }
            
            [self.menuController setMenuVisible:NO];
            //!!!此处使用self.superview.superview 获得到cell所在的tableView,不是很严谨,有哪位知道更加好的方法请告知
            CGRect targetRect = [self convertRect:self.messageContentV.frame toView:self.superview.superview];
            [self.menuController setTargetRect:targetRect inView:self.superview.superview];
            [self.menuController setMenuVisible:YES animated:YES];
            
        }else if (CGRectContainsPoint(self.headIV.frame, longPressPoint)) {
            
            if (self.messageOwner == XMNMessageOwnerOther) {
                NSString *chatType = [[NSUserDefaults standardUserDefaults] objectForKey:@"chatType"];
                if ([@"G" isEqualToString:chatType]) {
                    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                    dic[@"alarm"] = self.alarm;
                    dic[@"name"] = [NSString stringWithFormat:@"@%@ ",self.name];
                    [[NSNotificationCenter defaultCenter] postNotificationName:ChatGroupAtNotification object:dic];
                }
            }
            
        }
        
    }
}
- (void)menuDidHide:(NSNotification*)notification {
    
    self.zmlPlaceholderTextView.overrideNextResponder = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIMenuControllerDidHideMenuNotification object:nil];
}

- (void)menuCopyAction {
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageCell:withActionType:textField:)]) {
        [self.delegate messageCell:self withActionType: XMNChatMessageCellMenuActionTypeCopy textField:self.textField];
    }
}

- (void)menuRelayAction {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageCell:withActionType:textField:)]) {
        [self.delegate messageCell:self withActionType: XMNChatMessageCellMenuActionTypeRelay textField:[NSString stringWithFormat:@"%ld",(long)self.qid]];
    }
}
- (void)menuWithdrawAction {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(messageCell:withActionType:textField:)]) {
        [self.delegate messageCell:self withActionType: XMNChatMessageCellMenuActionTypeWithdraw textField:[NSString stringWithFormat:@"%ld",(long)self.qid]];
    }
}
#pragma mark - Getters


- (UIMenuController *)menuController{
    UIMenuController *menuController = objc_getAssociatedObject(self,&kXMNChatMessageCellMenuControllerKey);
    if (!menuController) {
        menuController = [UIMenuController sharedMenuController];
        UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(menuCopyAction)];
        UIMenuItem *shareItem = [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(menuRelayAction)];
        UIMenuItem *withdrawItem = [[UIMenuItem alloc] initWithTitle:@"撤回" action:@selector(menuWithdrawAction)];
        [menuController setMenuItems:@[copyItem,shareItem,withdrawItem]];
        [menuController setArrowDirection:UIMenuControllerArrowDown];
        objc_setAssociatedObject(self, &kXMNChatMessageCellMenuControllerKey, menuController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return menuController;
}


@end

