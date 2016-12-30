//
//  NearestImage.h
//  ProjectTemplate
//
//  Created by caohanchao on 16/9/28.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void (^TapImageViewBlock) ();

@interface NearestImage : UIImageView

@property(nonatomic,strong)UIImageView *img;//显示相册最近的一张图

//@property(nonatomic,copy)TapImageViewBlock tapImageBlock;


-(void)configureImage:(UIImage *)sendImage;

@end
