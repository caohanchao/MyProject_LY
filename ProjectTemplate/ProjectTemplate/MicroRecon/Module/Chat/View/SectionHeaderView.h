//
//  SectionHeaderView.h
//
//  Created by chc on 16/5/6.
//  Copyright (c) 2016年 chc. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ForwardBlock)();

@interface SectionHeaderView : UIView


@property(nonatomic,assign)BOOL isAppear;//是否展开

@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *numberLabel;

@property(nonatomic,copy)ForwardBlock block;

-(void)sectionIsAppear;

@end









