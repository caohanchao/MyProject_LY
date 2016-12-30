//
//  NearestImage.m
//  ProjectTemplate
//
//  Created by caohanchao on 16/9/28.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "NearestImage.h"

@interface NearestImage ()


@property(nonatomic,strong)UILabel *lab;
@end


@implementation NearestImage



-(UILabel *)lab
{

    if (!_lab) {
        _lab = [[UILabel alloc] init];
        _lab.font = [UIFont systemFontOfSize:10.0f];
        _lab.textColor = [UIColor lightGrayColor];
        _lab.textAlignment = NSTextAlignmentCenter;
        _lab.numberOfLines = 2;
        _lab.text = @"你可能要发送的照片";
        _lab.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _lab;

}

-(UIImageView *)img
{
    if (!_img) {
        _img = [[UIImageView alloc]init];
        _img.userInteractionEnabled = YES;
        _img.contentMode = UIViewContentModeScaleAspectFill;
        _img.layer.masksToBounds = YES;
       // _img.backgroundColor =[UIColor redColor];
//        _img.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _img;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup
{
    self.userInteractionEnabled = YES;
    [self addSubview:self.img];
    [self addSubview:self.lab];
    
    [self.lab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).with.offset(4);
        make.left.equalTo(self.mas_left).with.offset(4);
        make.right.equalTo(self.mas_right).with.offset(-4);
        
    }];
    
    [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(28, 4, 4, 4));
    }];
    
}


-(void)configureImage:(UIImage *)sendImage
{
    self.img.image = sendImage;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
