//
//  UtHeaderView.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/17.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "UtHeaderView.h"


@interface UtHeaderView ()

@property (nonatomic, weak) UILabel *countView;
@property (nonatomic, weak) UIButton *nameView;

@end

@implementation UtHeaderView


+ (instancetype)headerViewWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"header";
    UtHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        header = [[UtHeaderView alloc] initWithReuseIdentifier:ID];
    }
    return header;
}

/**
 *  在这个初始化方法中,MJHeaderView的frame\bounds没有值
 */
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        //添加子控件
        //1. 添加按钮
        UIButton *nameView = [UIButton buttonWithType:UIButtonTypeCustom];
        nameView.backgroundColor =[UIColor whiteColor];
        //背景图片
//        [nameView setBackgroundImage:[UIImage imageNamed:@"buddy_header_bg"] forState:UIControlStateNormal];
//        [nameView setBackgroundImage:[UIImage imageNamed:@"buddy_header_bg_highlighted"] forState:UIControlStateHighlighted];
        
        //设置按钮内部的左边的箭头图片
        [nameView setImage:[UIImage imageNamed:@"buddy_header_arrow"] forState:UIControlStateNormal];
        [nameView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        //设置按钮的内容左对齐
        nameView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //设置按钮的内边距
        nameView.titleEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);

        nameView.contentEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 0);

        [nameView addTarget:self action:@selector(nameViewClick) forControlEvents:UIControlEventTouchUpInside];
        
        //设置按钮内部的imageView的内容模式居中
        nameView.imageView.contentMode = UIViewContentModeCenter;
        //超出边框的内容不需要裁剪
        nameView.imageView.clipsToBounds = NO;
        
        [self.contentView addSubview:nameView];
        self.nameView = nameView;
        
        
        //2. 添加好友数
//        UILabel *countView = [[UILabel alloc] init];
//        countView.textAlignment = NSTextAlignmentCenter;
//        countView.textColor = [UIColor grayColor];
//        [self.contentView addSubview:countView];
//        self.countView = countView;
    }
    return self;
}

/**
 *  监听组名按钮的点击
 */
- (void)nameViewClick {
    
    //1. 修改数组模型的标记（状态取反）
    self.opend = !self.isOpend;
    
    //    NSLog(@"======= %@",self.group.name);
    
    
    //刷新表格
    if ([self.delegate respondsToSelector:@selector(headerViewDidClickedNameView:isOpen:)]) {
        
        [self.delegate headerViewDidClickedNameView:self isOpen:self.opend];
    }
    //
    //    if (self.group.isOpend) {
    //        self.nameView.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    //    }else {
    //        self.nameView.imageView.transform = CGAffineTransformMakeRotation(0);
    //    }
}

///**
// *  当一个控件被添加到父控件中就会调用
// */
- (void)didMoveToSuperview {
    
    if (self.isOpend) {
        self.nameView.imageView.transform = CGAffineTransformMakeRotation(0);
    }else {
        self.nameView.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
}

/**
 *  当一个控件的frame发生改变的时候就会调用
 *
 *  一般在这里布局内部的子控件(设置子控件的frame)
 */
- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    //设置按钮的frame
    self.nameView.frame = self.bounds;
    
    //设置好友数的frame
    CGFloat countY = 0;
    CGFloat countH = self.frame.size.height;
    CGFloat countW = 150;
    CGFloat countX = self.frame.size.width - 10 - countW;
    self.countView.frame = CGRectMake(countX, countY, countW, countH);
    
}
- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    
    //1. 设置按钮文字（组名）
    [self.nameView setTitle:titleStr forState:UIControlStateNormal];
    self.nameView.titleLabel.font = [UIFont systemFontOfSize:16];
    
//    //2. 设置好友数（在线数/ 总数）
//    self.countView.text = [NSString stringWithFormat:@"%d/%ld",group.online, group.friends.count];
    //3. 重新设置左边箭头的状态
    [self didMoveToSuperview];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
