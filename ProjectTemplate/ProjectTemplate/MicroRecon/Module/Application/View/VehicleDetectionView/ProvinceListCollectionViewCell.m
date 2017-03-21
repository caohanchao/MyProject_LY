//
//  ProvinceListCollectionViewCell.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/3/13.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "ProvinceListCollectionViewCell.h"
#import "ProvinceListModel.h"

@interface ProvinceListCollectionViewCell ()

@property (nonatomic, strong) UIButton *provinceBtn;

@end

@implementation ProvinceListCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initall];
    }
    return self;
}
- (void)initall {
    
    self.provinceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.provinceBtn.frame = self.contentView.bounds;
    [self.provinceBtn setBackgroundImage:[LZXHelper buttonImageFromColor:CHCHexColor(@"12b7f5")] forState:UIControlStateHighlighted];
    [self.provinceBtn setBackgroundImage:[LZXHelper buttonImageFromColor:CHCHexColor(@"12b7f5")] forState:UIControlStateSelected];
    [self.provinceBtn setBackgroundImage:[LZXHelper buttonImageFromColor:CHCHexColor(@"ffffff")] forState:UIControlStateNormal];
    [self.provinceBtn setTitleColor:zBlackColor forState:UIControlStateNormal];
    [self.provinceBtn setTitleColor:zWhiteColor forState:UIControlStateSelected];
    self.provinceBtn.titleLabel.font = ZEBFont(14);
    self.provinceBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.provinceBtn.layer.borderColor = CHCHexColor(@"eeeeee").CGColor;
    self.provinceBtn.layer.borderWidth = 0.5;
    [self.provinceBtn addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.provinceBtn];
}

- (void)setModel:(ProvinceListModel *)model {
    _model = model;
    
    self.provinceBtn.selected = model.select;
    [self.provinceBtn setTitle:model.name forState:UIControlStateNormal];
    [self.provinceBtn setTitle:model.name forState:UIControlStateSelected];
}

- (void)choose:(UIButton *)btn {
    self.block(self,self.item);
}
@end
