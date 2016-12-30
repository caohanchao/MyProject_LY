//
//  GetrecordByGroupModel.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/20.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface GetrecordByGroupModel : MTLModel<MTLJSONSerializing>


@property (nonatomic, nonnull, copy) NSString *alarm;//用户唯一标识ID
@property (nonatomic, nonnull, copy) NSString *content;//标记描述内容
@property (nonatomic, nonnull, copy) NSString *create_time;//打标时间
@property (nonatomic, nonnull, copy) NSString *department;//用户所属部门
@property (nonatomic, nonnull, copy) NSString *direction;//摄像头方向
@property (nonatomic, nonnull, copy) NSString *gid;//所属群ID
@property (nonatomic, nonnull, copy) NSString *headpic;//用户头像
@property (nonatomic, nonnull, copy) NSString *interid;//线索ID
@property (nonatomic, nonnull, copy) NSString *latitude;//纬度
@property (nonatomic, nonnull, copy) NSString *longitude;//经度
@property (nonatomic, nonnull, copy) NSString *mode;//0 走访标记 1 快速记录 2 摄像头标记
@property (nonatomic, nonnull, copy) NSString *orderid;//指令id
@property (nonatomic, nonnull, copy) NSString *position;//位置
@property (nonatomic, nonnull, copy) NSString *realname;//姓名
@property (nonatomic, nonnull, copy) NSString *title;//标题
@property (nonatomic, nonnull, copy) NSString *type;//摄像头的类型 或走访的类型
@property (nonatomic, nonnull, copy) NSString *picture;//图片
@property (nonatomic, nonnull, copy) NSString *video;//视频
@property (nonatomic, nonnull, copy) NSString *audio;//语音
@property (nonatomic, nonnull, copy) NSString *workid;//所属任务id
@property (nonatomic, nonnull, copy) NSString *workname;//
@end
