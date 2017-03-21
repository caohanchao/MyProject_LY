//
//  SuspectCollectionViewCell.m
//  ProjectTemplate
//
//  Created by caohanchao on 2017/1/16.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

NSString *const SuspectCollectionViewCellID = @"SuspectCollectionViewCellID";

#import "SuspectCollectionViewCell.h"
@interface SuspectCollectionViewCell()

@property(nonatomic,strong)UIImageView *iconImage;
@property(nonatomic,strong)UILabel *label;

@property (nonatomic,copy)Suspect_CallBack suspectCallBack;

@end
@implementation SuspectCollectionViewCell

- (UIImageView *)iconImage {
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc] init];
        _iconImage.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [_iconImage addGestureRecognizer:tap];
        
    }
    return _iconImage;
}

- (UILabel *)label {
    if (!_label) {
        _label = [CHCUI createLabelWithbackGroundColor:[UIColor whiteColor] textAlignment:1 font:[UIFont systemFontOfSize:12] textColor:[UIColor blackColor] text:@""];
//        _label.backgroundColor = [UIColor whiteColor];
    }
    return _label;
}

//- (void)setIsUserInteractionEnabled:(BOOL)isUserInteractionEnabled {
//    _isUserInteractionEnabled = isUserInteractionEnabled;
////    _iconImage.userInteractionEnabled = _isUserInteractionEnabled;
//}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
        
    }
    return self;
}

- (void)tapAction:(UITapGestureRecognizer *)gestureRecognizer {
    
    UIImageView *imageView = gestureRecognizer.view;
    self.suspectCallBack (imageView);
}

- (void)configWithData:(NSObject *)model callBackWithSuspect:(Suspect_CallBack)suspectCallBack {
    if ([model isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = model;
        self.label.text = dict[@"name"];
        self.iconImage.image = [UIImage imageNamed:dict[@"picture"]];
    }
    
    self.suspectCallBack = suspectCallBack;
}

- (void)initUI {
    
    [self.contentView addSubview:self.iconImage];
    [self.contentView addSubview:self.label];
    
//    self.iconImage.userInteractionEnabled = YES;
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.mas_equalTo(self.contentView);
        make.height.equalTo(self.iconImage.mas_width);
    }];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(0);
        make.top.mas_equalTo(self.iconImage.mas_bottom).offset(10);
    }];
    
}

@end
