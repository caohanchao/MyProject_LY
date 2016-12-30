//
//  show2wCodeImage.h
//  WCLDConsulting
//
//  Created by apple on 16/2/27.
//  Copyright © 2016年 Shondring. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface show2wCodeImage : UIView

+ (void)addPellTableViewSelectWithWindowFrame:(CGRect)frame
                                   selectData:(NSArray *)selectData
                                     MasonayY:(NSInteger)MasonayY
                                       action:(void(^)(NSInteger index))action animated:(BOOL)animate selectdidFlag:(NSInteger)seleFlag;

@end
