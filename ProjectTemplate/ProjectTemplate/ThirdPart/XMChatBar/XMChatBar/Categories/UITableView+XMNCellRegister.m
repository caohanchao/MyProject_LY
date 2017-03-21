//
//  UIself+XMNCellRegister.m
//  XMChatBarExample
//
//  Created by shscce on 15/11/23.
//  Copyright © 2015年 xmfraker. All rights reserved.
//

#import "UITableView+XMNCellRegister.h"

#import "XMNChatMessageCell.h"
#import "XMNChatTextMessageCell.h"
#import "XMNChatImageMessageCell.h"
#import "XMNChatVoiceMessageCell.h"
#import "XMNChatSystemMessageCell.h"
#import "XMNChatLocationMessageCell.h"
#import "XMNChatVideoMessageCell.h"
#import "XMNChatReleaseTaskMessageCell.h"
#import "XMNChatEmotionsMessageCell.h"
#import "XMNChatFireImageMessageCell.h"
#import "XMNChatFileMessageCell.h"
@implementation UITableView (XMNCellRegister)

- (void)registerXMNChatMessageCellClass {
    
    [self registerClass:[XMNChatImageMessageCell class] forCellReuseIdentifier:@"XMNChatMessageCell_OwnerSelf_ImageMessage_GroupCell"];
    [self registerClass:[XMNChatImageMessageCell class] forCellReuseIdentifier:@"XMNChatMessageCell_OwnerSelf_ImageMessage_SingleCell"];
    [self registerClass:[XMNChatImageMessageCell class] forCellReuseIdentifier:@"XMNChatMessageCell_OwnerOther_ImageMessage_GroupCell"];
    [self registerClass:[XMNChatImageMessageCell class] forCellReuseIdentifier:@"XMNChatMessageCell_OwnerOther_ImageMessage_SingleCell"];
    
    [self registerClass:[XMNChatLocationMessageCell class] forCellReuseIdentifier:@"XMNChatMessageCell_OwnerSelf_LocationMessage_GroupCell"];
    [self registerClass:[XMNChatLocationMessageCell class] forCellReuseIdentifier:@"XMNChatMessageCell_OwnerSelf_LocationMessage_SingleCell"];
    [self registerClass:[XMNChatLocationMessageCell class] forCellReuseIdentifier:@"XMNChatMessageCell_OwnerOther_LocationMessage_GroupCell"];
    [self registerClass:[XMNChatLocationMessageCell class] forCellReuseIdentifier:@"XMNChatMessageCell_OwnerOther_LocationMessage_SingleCell"];
    
    [self registerClass:[XMNChatVoiceMessageCell class] forCellReuseIdentifier:@"XMNChatMessageCell_OwnerSelf_VoiceMessage_GroupCell"];
    [self registerClass:[XMNChatVoiceMessageCell class] forCellReuseIdentifier:@"XMNChatMessageCell_OwnerSelf_VoiceMessage_SingleCell"];
    [self registerClass:[XMNChatVoiceMessageCell class] forCellReuseIdentifier:@"XMNChatMessageCell_OwnerOther_VoiceMessage_GroupCell"];
    [self registerClass:[XMNChatVoiceMessageCell class] forCellReuseIdentifier:@"XMNChatMessageCell_OwnerOther_VoiceMessage_SingleCell"];
    
    [self registerClass:[XMNChatTextMessageCell class] forCellReuseIdentifier:@"XMNChatMessageCell_OwnerSelf_TextMessage_GroupCell"];
    [self registerClass:[XMNChatTextMessageCell class] forCellReuseIdentifier:@"XMNChatMessageCell_OwnerSelf_TextMessage_SingleCell"];
    [self registerClass:[XMNChatTextMessageCell class] forCellReuseIdentifier:@"XMNChatMessageCell_OwnerOther_TextMessage_GroupCell"];
    [self registerClass:[XMNChatTextMessageCell class] forCellReuseIdentifier:@"XMNChatMessageCell_OwnerOther_TextMessage_SingleCell"];
    
    [self registerClass:[XMNChatVideoMessageCell class] forCellReuseIdentifier:@"XMNChatMessageCell_OwnerSelf_VideoMessage_GroupCell"];
    [self registerClass:[XMNChatVideoMessageCell class] forCellReuseIdentifier:@"XMNChatMessageCell_OwnerSelf_VideoMessage_SingleCell"];
    [self registerClass:[XMNChatVideoMessageCell class] forCellReuseIdentifier:@"XMNChatMessageCell_OwnerOther_VideoMessage_GroupCell"];
    [self registerClass:[XMNChatVideoMessageCell class] forCellReuseIdentifier:@"XMNChatMessageCell_OwnerOther_VideoMessage_SingleCell"];
    
    [self registerClass:[XMNChatSystemMessageCell class] forCellReuseIdentifier:@"XMNChatMessageCell_OwnerSystem_SystemMessage_"];
    [self registerClass:[XMNChatSystemMessageCell class] forCellReuseIdentifier:@"XMNChatMessageCell_OwnerSystem_SystemMessage_SingleCell"];
    [self registerClass:[XMNChatSystemMessageCell class] forCellReuseIdentifier:@"XMNChatMessageCell_OwnerSystem_SystemMessage_GroupCell"];
    
    //[self registerClass:[XMNChatReleaseTaskMessageCell class] forCellReuseIdentifier:@"XMNChatMessageCell_OwnerSelf_ReleaseTaskMessage_SingleCell"];
    [self registerClass:[XMNChatReleaseTaskMessageCell class] forCellReuseIdentifier:@"XMNChatMessageCell_OwnerSelf_ReleaseTaskMessage_GroupCell"];
    //[self registerClass:[XMNChatReleaseTaskMessageCell class] forCellReuseIdentifier:@"XMNChatMessageCell_OwnerOther_ReleaseTaskMessage_SingleCell"];
    [self registerClass:[XMNChatReleaseTaskMessageCell class] forCellReuseIdentifier:@"XMNChatMessageCell_OwnerOther_ReleaseTaskMessage_GroupCell"];
    
    [self registerClass:[XMNChatEmotionsMessageCell class] forCellReuseIdentifier:@"XMNChatMessageCell_OwnerSelf_EmotionsMessage_GroupCell"];
    [self registerClass:[XMNChatEmotionsMessageCell class] forCellReuseIdentifier:@"XMNChatMessageCell_OwnerSelf_EmotionsMessage_SingleCell"];
    [self registerClass:[XMNChatEmotionsMessageCell class] forCellReuseIdentifier:@"XMNChatMessageCell_OwnerOther_EmotionsMessage_GroupCell"];
    [self registerClass:[XMNChatEmotionsMessageCell class] forCellReuseIdentifier:@"XMNChatMessageCell_OwnerOther_EmotionsMessage_SingleCell"];
    
    [self registerClass:[XMNChatFireImageMessageCell class] forCellReuseIdentifier:@"XMNChatMessageCell_OwnerSelf_FireImageMessage_GroupCell"];
    [self registerClass:[XMNChatFireImageMessageCell class] forCellReuseIdentifier:@"XMNChatMessageCell_OwnerSelf_FireImageMessage_SingleCell"];
    [self registerClass:[XMNChatFireImageMessageCell class] forCellReuseIdentifier:@"XMNChatMessageCell_OwnerOther_FireImageMessage_GroupCell"];
    [self registerClass:[XMNChatFireImageMessageCell class] forCellReuseIdentifier:@"XMNChatMessageCell_OwnerOther_FireImageMessage_SingleCell"];
    
    [self registerClass:[XMNChatFileMessageCell class] forCellReuseIdentifier:@"XMNChatMessageCell_OwnerSelf_FilesMessage_GroupCell"];
    [self registerClass:[XMNChatFileMessageCell class] forCellReuseIdentifier:@"XMNChatMessageCell_OwnerSelf_FilesMessage_SingleCell"];
    [self registerClass:[XMNChatFileMessageCell class] forCellReuseIdentifier:@"XMNChatMessageCell_OwnerOther_FilesMessage_GroupCell"];
    [self registerClass:[XMNChatFileMessageCell class] forCellReuseIdentifier:@"XMNChatMessageCell_OwnerOther_FilesMessage_SingleCell"];
}

@end
