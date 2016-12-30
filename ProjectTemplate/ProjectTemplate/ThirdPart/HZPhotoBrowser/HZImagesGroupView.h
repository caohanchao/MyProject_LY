//
//  HZImagesGroupView.h
//  photoBrowser
//
//  Created by huangzhenyu on 15/6/23.
//  Copyright (c) 2015年 eamon. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol HZImagesGroupViewDelegate <NSObject>
//
//- (void)pushToForwardVCWith:(NSString*)imageUrl;
//
//@end


@interface HZImagesGroupView : UIView
@property (nonatomic, strong) NSArray *photoItemArray;

@property (nonatomic, strong) NSString *tempStr;

@property (nonatomic, copy) NSString * imageUrl;
/**
 是否支持长按
 */
@property (nonatomic, assign) BOOL longPress;


@end
