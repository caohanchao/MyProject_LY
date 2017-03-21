//
//  MeCell.m
//  WWeChat
//
//  Created by WzxJiang on 16/6/28.
//  Copyright © 2016年 WzxJiang. All rights reserved.
//

#import "MeCell.h"
#import "UIButton+EnlargeEdge.h"

@implementation MeCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.avaterImgView.layer.cornerRadius=30;
    self.avaterImgView.layer.cornerRadius=6;
    self.avaterImgView.layer.masksToBounds=YES;
    self.avaterImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.show2Code setEnlargeEdge:15];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (IBAction)show2Code:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(showTCode:)]) {
        [_delegate showTCode:self];
    }
}

@end
