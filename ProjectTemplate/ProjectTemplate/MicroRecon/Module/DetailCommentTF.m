//
//  DetailCommentTF.m
//  ProjectTemplate
//
//  Created by 李凯华 on 16/12/7.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "DetailCommentTF.h"

@implementation DetailCommentTF

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (void)drawPlaceholderInRect:(CGRect)rect
{
    [self.placeholder drawInRect:CGRectMake(0, 5, screenWidth()/3, 15) withAttributes:@{
                                                                                        NSForegroundColorAttributeName : CHCHexColor(@"a6a6a6"),
                                                                                        NSFontAttributeName : [UIFont systemFontOfSize:12]
                                                                                        }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
