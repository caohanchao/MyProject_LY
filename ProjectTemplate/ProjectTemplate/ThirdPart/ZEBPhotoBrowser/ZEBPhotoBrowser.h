//
//  ZEBPhotoBrowser.h
//  ZEBPhotoBrowser
//
//  Created by zeb－Apple on 17/1/5.
//  Copyright © 2017年 zeb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWProgressView.h"

@class Photo;

typedef void(^ __nullable DismissBlock)(UIImage * __nullable image, NSInteger index);
typedef void(^ __nullable LongPressBlock)(UIImage * __nullable image, Photo * __nullable photo);
typedef void(^ __nullable ImageDownLoadCompleteBlock)(UIImage * __nullable image);

@interface ZEBPhotoBrowser : UIView

/*
 * @param imageView    点击的imageView
 * @param URLStrings   加载的网络图片的urlString 
 [{originalUrl:@"",thumbnailUrl:@"",size:@""},{originalUrl:@"",thumbnailUrl:@"",size:@""}]
 * @param index        点击的图片在所有要展示图片中的位置
 * @param coverView    添加自身的父视图
 */

+ (nonnull instancetype)showFromImageView:(nullable UIImageView *)imageView withURLStrings:(nullable NSArray *)dataArray atIndex:(NSInteger)index coverView:(nullable UIView *)coverView;

/*
 * @param imageView    点击的imageView
 * @param withImages   加载的本地图片
 * @param index        点击的图片在所有要展示图片中的位置
 * @param coverView    添加自身的父视图
 */

+ (nonnull instancetype)showFromImageView:(nullable UIImageView *)imageView withImages:(nullable NSArray *)images atIndex:(NSInteger)index coverView:(nullable UIView *)coverView;

/*
 * @param imageView    点击的imageView
 * @param URLStrings   加载的网络图片的urlString
 [{originalUrl:@"",thumbnailUrl:@"",size:@""},{originalUrl:@"",thumbnailUrl:@"",size:@""}]
 * @param image        占位图片
 * @param index        点击的图片在所有要展示图片中的位置
 * @param coverView    添加的自身的父视图
 * @param dismiss      photoBrowser消失的回调
 */
//+ (nonnull instancetype)showFromImageView:(nullable UIImageView *)imageView withURLStrings:(nullable NSArray *)dataArray placeholderImage:(nullable UIImage *)image atIndex:(NSInteger)index dismiss:(DismissBlock)block;
+ (nonnull instancetype)showFromImageView:(nullable UIImageView *)imageView withURLStrings:(nullable NSArray *)dataArray placeholderImage:(nullable UIImage *)image atIndex:(NSInteger)index coverView:(nullable UIView *)coverView dismiss:(DismissBlock)block;
/*
 * @param imageView    点击的imageView
 * @param withImages   加载的本地图片
 * @param image        占位图片
 * @param index        点击的图片在所有要展示图片中的位置
 * @param coverView    添加自身的父视图
 * @param dismiss      photoBrowser消失的回调
 */
+ (nonnull instancetype)showFromImageView:(nullable UIImageView *)imageView withImages:(nullable NSArray *)images atIndex:(NSInteger)index  coverView:(nullable UIView *)coverView dismiss:(DismissBlock)block;

- (void)disMissBrowser ;

@property (nonatomic, strong, nullable) UIImage *placeholderImage;
@property (nonatomic, copy) LongPressBlock longPressBlock;
@property (nonatomic, copy) ImageDownLoadCompleteBlock downLoadCompleteBlock;

@property (nonatomic, strong, nullable) UIView *coverView;

@property (nonatomic, strong, nullable) UILabel *timeLabel;

@property (nonatomic, strong, nullable) HWProgressView *progressView;

@property (nonatomic, copy, nullable) NSString *timeStr;

@property (nonatomic, assign) BOOL isFire;

@end
