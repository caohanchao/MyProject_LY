//
//  ZEBSearchTextField.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/3/13.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "ZEBSearchTextField.h"

#define leftmargin 35
#define rightmargin 10



@implementation ZEBSearchTextField


// 控制placeHolder的位置，左右缩20，但是光标位置不变
/*
 -(CGRect)placeholderRectForBounds:(CGRect)bounds
 {
 CGRect inset = CGRectMake(bounds.origin.x+100, bounds.origin.y, bounds.size.width -10, bounds.size.height);//更好理解些
 return inset;
 }
 */

// 修改文本展示区域，一般跟editingRectForBounds一起重写
- (CGRect)textRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+leftmargin, bounds.origin.y, bounds.size.width-rightmargin, bounds.size.height);//更好理解些
    return inset;
}

// 重写来编辑区域，可以改变光标起始位置，以及光标最右到什么地方，placeHolder的位置也会改变
-(CGRect)editingRectForBounds:(CGRect)bounds
{
    CGRect inset = CGRectMake(bounds.origin.x+leftmargin, bounds.origin.y, bounds.size.width-rightmargin, bounds.size.height);//更好理解些
    return inset;
}
// 修改光标宽度 长度
- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    CGRect originalRect = [super caretRectForPosition:position];
    
    originalRect.size.height = self.font.lineHeight+2;
   // originalRect.size.width = 1;
    
    return originalRect;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
