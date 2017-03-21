//
//  VdResultModel.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/2.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Mantle/Mantle.h>

@class LKXXModel;
@class SBXXModel;

@interface VdResultModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, nonnull, copy) NSString *hpzl; // 号牌种类
@property (nonatomic, nonnull, copy) NSArray *sbxx;
@property (nonatomic, nonnull, copy) NSString *jgsj; // 经过时刻
@property (nonatomic, nonnull, copy) NSString *cllx; // 车辆类型
@property (nonatomic, nonnull, copy) NSString *gctx; // 图像名称
@property (nonatomic, nonnull, copy) NSString *cdbh; // 车道编号
@property (nonatomic, nonnull, copy) NSString *hpys; // 号牌颜色
@property (nonatomic, nonnull, copy) NSString *hphm; // 完整号牌号码
@property (nonatomic, nonnull, copy) NSString *csys; // 车身颜色
@property (nonatomic, nonnull, copy) NSString *kkbh; // 卡口编号
@property (nonatomic, nonnull, copy) NSString *xsfx; // 行驶方向
@property (nonatomic, nonnull, copy) NSString *clsd; // 车辆速度
@property (nonatomic, nonnull, copy) NSString *sbbh;
@property (nonatomic, nonnull, copy) NSString *xszt; // 行驶状态
@property (nonatomic, nonnull, copy) NSString *clxxbh; // 车辆信息编号
@property (nonatomic, nonnull, strong) NSNumber *kknum; // 通行次数

@property (nonatomic, assign) NSInteger kkindex; // 排序


//@property (nonatomic, nonnull, copy) NSString *PUID; // 设备编码
//@property (nonatomic, nonnull, copy) NSString *JGSK; // 经过时刻
//@property (nonatomic, nonnull, copy) NSString *JGDAY; // 经过日期
//@property (nonatomic, nonnull, copy) NSString *HPHM1; // 号牌号码前两位
//@property (nonatomic, nonnull, copy) NSString *HPHM2; // 号牌号码其它字符
//@property (nonatomic, nonnull, copy) NSString *TXMC1; // 图像1名称
//@property (nonatomic, nonnull, copy) NSString *latitude;//纬度
//@property (nonatomic, nonnull, copy) NSString *longitude;//经度
//@property (nonatomic, nonnull, copy) NSString *bayonetName;//卡口位置
//@property (nonatomic, nonnull, copy) NSString *deviceName;


@end

@interface SBXXModel : MTLModel<MTLJSONSerializing>

@property (nonatomic,nonnull, strong)NSNumber * latitude;
@property (nonatomic,nonnull, strong)NSNumber * longitude;
@property (nonatomic, nonnull, copy)NSString *kkbh;
@property (nonatomic, nonnull, copy)NSString *deviceName; //卡口位置
@property (nonatomic, nonnull, copy)NSArray *lkxx;

@property (nonatomic, assign) NSInteger index; // 排次数

@end


@interface LKXXModel : MTLModel<MTLJSONSerializing>

@property (nonatomic,nonnull, strong)NSNumber * kkwd;
@property (nonatomic,nonnull, strong)NSNumber * kkjd;
@property (nonatomic, nonnull, copy)NSString *kkmc;

@end

