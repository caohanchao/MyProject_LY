//
//  MapBtnBtnsView.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/11.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Property.h"


typedef void(^BtnClickBlock)(UIButton *btn);

@interface MapBtnBtnsView : UIView

/**
 *  数据源数组
 */
@property (nonatomic, strong) NSMutableArray *dataArray;

/**
 *  标题
 */
@property (nonatomic, copy) NSString *title;
/**
 *  类型
 */
@property (nonatomic, copy) NSString *type;
/**
 *  选中状态
 */
@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic, copy) BtnClickBlock block;
/**
 *  初始化
 *
 *  @param frame      frame
 *  @param dataArray 数据源数组
 *  @param title      标题
 *
 *  @return self
 */
- (instancetype)initWithFrame:(CGRect)frame dataArray:(NSMutableArray *)dataArray title:(NSString *)title type:(NSString *)type selectArray:(NSMutableArray *)selectArray clickBlock:(BtnClickBlock)block;

@end
