//
//  NewFriendModel.h
//  ProjectTemplate
//
//  Created by 郑胜 on 16/8/24.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//  与新朋友表映射Model

#import <Foundation/Foundation.h>

@interface NewFriendModel : NSObject

@property (nonatomic, nonnull, copy) NSString *nf_id; // 主键
@property (nonatomic, nonnull, copy) NSString *nf_fid; // 新朋友警号
@property (nonatomic, nonnull, copy) NSString *nf_mtype; // 操作类型
@property (nonatomic, nonnull, copy) NSString *nf_data; // 验证信息
@property (nonatomic, nonnull, copy) NSString *nf_isactive; // isactive 请求  notactive 被请求
@property (nonatomic, nonnull, copy) NSString *nf_ptime; // 时间

@property (nonatomic, nonnull, copy) NSString *name; // 姓名
@property (nonatomic, nonnull, copy) NSString *headpic; // 头像地址

@end
