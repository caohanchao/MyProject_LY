//
//  SectionHeaderView.m
//
//  Created by chc on 16/5/6.
//  Copyright (c) 2016年 chc. All rights reserved.
//

#import "SectionHeaderView.h"

@interface SectionHeaderView()

@property(nonatomic,assign)BOOL isChange;



@property(nonatomic,strong)UIImageView *imgView;


@end

@implementation SectionHeaderView





- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        /******/
        self.imgView = [[UIImageView alloc] init];
        self.imgView.image = [UIImage imageNamed:@"rightarrow"];
        [self addSubview:self.imgView];
        
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.offset = (10);
            make.left.offset = (10);
            make.bottom.offset =(-10);
            make.width.equalTo(self.imgView.mas_height).with.offset(0);
            
        }];
        
        /*****/
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:17];
        
        [self addSubview:self.titleLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.offset = (10);
            make.left.equalTo(self.imgView.mas_right).with.offset(30);
            make.width.offset = (100);
            make.bottom.offset =(-10);
            
        }];
        
        
        
        /******/
        self.numberLabel = [[UILabel alloc] init];
        self.numberLabel.textAlignment = NSTextAlignmentRight;
        self.numberLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.numberLabel];
        
        [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.mas_right).with.offset(-10);
            make.top.offset = (10);
            make.bottom.offset =(-10);
            make.width.offset =(50);
        }];
        
    }
    return self;
}

//点击头部视图，响应
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self sectionIsAppear];
}

-(void)sectionIsAppear
{
    
    //1.让状态在展开和收缩之间切换
    self.isAppear = !self.isAppear;
    
    //改变view的transfrom， M_PI =  180°
    
    [UIView animateWithDuration:0.01 animations:^{
        
        if (_isChange ==YES)
        {
            self.imgView.transform = CGAffineTransformRotate(self.imgView.transform,-M_PI_2 );
            _isChange = NO;
        }
        else
        {
            self.imgView.transform = CGAffineTransformRotate(self.imgView.transform,M_PI_2 );
            _isChange =YES;
        }
    }];
    
    
    //2.刷新tableView
    self.block();
}

@end













