//
//  ViewController.h
//  SampleVideoRecorder
//
//  Created by 郑胜 on 16/8/2.
//  Copyright © 2016年 郑胜. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VideoRecorderViewControllerDelegate <NSObject>
- (void)failVideoRecord;
- (void)cancelVideoRecord;
- (void)beginVideoRecord;
- (void)endVideoRecord:(NSURL *)assetURL;
@end

@interface VideoRecorderViewController : UIViewController

@property (nonatomic, weak) id<VideoRecorderViewControllerDelegate> delegate;

@end

