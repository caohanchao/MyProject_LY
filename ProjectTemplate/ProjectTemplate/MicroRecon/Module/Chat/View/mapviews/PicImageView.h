//
//  PicImageView.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/11/1.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>


@class PicImageView;

@protocol PicImageViewDelegate <NSObject>

@optional
- (void)picImageView:(PicImageView *)view index:(NSInteger)index;
- (void)picImageView:(PicImageView *)view deleteImageIndex:(NSInteger)index;
@end

@interface PicImageView : UIView

@property (nonatomic, weak) id<PicImageViewDelegate> delegate;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, assign) BOOL delhidden;

- (instancetype)initWithFrame:(CGRect)frame pic:(NSString *)pic;
@end
