//
//  CommualHeaderView.h
//  ProjectTemplate
//
//  Created by 戴小斌 on 2016/10/19.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HMSegmentedControl;

@interface CommualHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet HMSegmentedControl *segCtrl;

@property (nonatomic, assign) BOOL canNotResponseTapTouchEvent;
@end
