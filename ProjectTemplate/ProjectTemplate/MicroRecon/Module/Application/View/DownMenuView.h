//
//  DownMenuView.h
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/2.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DownMenuView;

@protocol JHDownMenuViewDelegate <NSObject>

- (void)jHDownMenuView:(DownMenuView *)view tag:(NSInteger)tag;

@end



@interface DownMenuView : UIView

@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, weak) id<JHDownMenuViewDelegate> delegate;
- (void)show;
- (void)dismiss;

@end
