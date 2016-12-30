//
//  ShakeAnnotationView.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/14.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "ShakeAnnotationView.h"
#import "ShakeAnnotation.h"

@interface ShakeAnnotationView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation ShakeAnnotationView



- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = zClearColor;
     
        self.image = [UIImage imageNamed:@"shakeAnnotation_no"];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width(self.frame), height(self.frame)-4)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = ZEBFont(12);
        self.titleLabel.textColor = zWhiteColor;
        [self addSubview:self.titleLabel];
        
    }
    
    return self;
}


- (void)setSelected:(BOOL)selected {
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (self.selected == selected) {
        return;
    }
    
    if (selected) {
        self.image = [UIImage imageNamed:@"shakeAnnotation_se"];
    }
    else {

        self.image = [UIImage imageNamed:@"shakeAnnotation_no"];
    }
    
    [super setSelected:selected animated:animated];
}
- (void)setAannotation:(ShakeAnnotation *)aannotation {
    _aannotation = aannotation;
    if (_aannotation.index+1 >= 100) {
        self.titleLabel.font = ZEBFont(10);
    }else {
        self.titleLabel.font = ZEBFont(12);
    }
    self.titleLabel.text = [NSString stringWithFormat:@"%ld",_aannotation.index+1];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
