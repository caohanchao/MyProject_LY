//
//  SelectPosition.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/5.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SelectPositionDelegate <NSObject>

- (void)selectThePosition:(NSString *)position positionNum:(NSString *)positionNum;

@end

@interface SelectPosition : NSObject


@property (nonatomic,strong)NSArray *positionArray; //数据源数组
@property (nonatomic, weak) id<SelectPositionDelegate> delegate;

+(instancetype)sigle;

-(void)show;

-(void)dismiss;

@end
