//
//  ZEBEasyMacro.h
//  ZEBEasyMacro
//
//  Created by apple on 16/5/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#ifndef ZEBEasyMacro_h
#define ZEBEasyMacro_h

#define Prefix ZEB
/**
 *  字体
 *
 *  @param x 字体
 *
 *  @return 字体
 */
#define ZEBFont(x) [UIFont systemFontOfSize:x]
#define ZEBBoldFont(x) [UIFont boldSystemFontOfSize:x]

/**
 *  颜色
 *
 *  @param r red
 *  @param g green
 *  @param b blue
 *
 *  @return 颜色
 */
#define ZEBRGBColor(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define ZEBRGBAColor(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

#define ZEBRedColor [UIColor colorWithRed:251/255.0f green:86/255.0f blue:75/255.0f alpha:1]


#define ZEBRGB16Color(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

/**
 *  输出
 *
 *  @param ... 输出内容
 *
 *  @return 输出
 */
#ifdef DEBUG
#define ZEBLog(...) NSLog(__VA_ARGS__)
#else
#define ZEBLog(...)
#endif

#define ZEBPrint_CurrentMethod ZEBLog(@"%s",__FUNCTION__);
#define ZEBPrint_CurrentLine ZEBLog(@"%d",__LINE__);
#define ZEBPrint_CurrentClass ZEBLog(@"%s",__FILE__);
#define ZEBPrint_CurrentStack ZEBLog(@"%@",[NSThread callStackSymbols]);
#define ZEBPrint_CurrentPath ZEBLog(@"%s",__FILE__);
#define ZEBPrint_CurrentDetail ZEBLog(@"class==>%@, method==>%s, line==>%d",[self class],__FUNCTION__,__LINE__);


/**
 *  获取硬件信息
 *
 *  @param objectAtIndex:0] 获取硬件信息
 *
 *  @return 获取硬件信息
 */
#define ZEBSCREEN_W [UIScreen mainScreen].bounds.size.width
#define ZEBSCREEN_H [UIScreen mainScreen].bounds.size.height
#define ZEBCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
#define ZEBCurrentSystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]


/**
 *  适配
 *
 *  @param >.0 版本号
 *
 *  @return 适配
 */
#define ZEBiOS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define ZEBiOS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define ZEBiOS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define ZEBiOS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define ZEBiOS_9_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)

#define ZEBiPhone4_OR_4s    (ZEBSCREEN_H == 480)
#define ZEBiPhone5_OR_5c_OR_5s   (ZEBSCREEN_H == 568)
#define ZEBiPhone6_OR_6s   (ZEBSCREEN_H == 667)
#define ZEBiPhone6Plus_OR_6sPlus   (ZEBSCREEN_H == 736)
#define ZEBiPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

/**
 *  自身的弱指针
 *
 *  @param weakSelf 弱指针
 *
 *  @return 自身的弱指针
 */
#define WeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;

#define WeakSelf __weak typeof(self) weakSelf = self;
/**
 *  加载本地文件
 *
 *  @param file 文件名
 *  @param type 文件类型
 *
 *  @return 加载本地文件
 */
#define ZEBLoadImage(file,type) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:type]]
#define ZEBLoadArray(file,type) [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:type]]
#define ZEBLoadDict(file,type) [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:type]]

/**
 *  快速进入一个bundle的宏
 *
 *  @param bundleName bundle名
 *
 *  @return 快速进入一个bundle的宏
 */
#define ZEBBundle(bundleName) [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:(bundleName) withExtension:@"bundle"]]
/** 加载bundle内nib或图片*/
// 这里返回的是一个nib内的元素
/**
 *  返回的是一个nib内的元素
 *
 *  @param bundleName bundleName 
 *  @param nibName    nibName
 *  @param index      index
 *
 *  @return 返回的是一个nib内的元素
 */
#define ZEBLoadBundleNib(bundleName,nibName,index) [ZEBBundle(bundleName) loadNibNamed:(nibName) owner:nil options:nil][(index)];
// 这里返回的是包装后的图片名
/**
 *  返回的是包装后的图片名
 *
 *  @param bundleName bundleName
 *  @param iconName   iconName
 *
 *  @return 返回的是包装后的图片名
 */
#define ZEBBundleImgName(bundleName,iconName) (iconName)?[[NSString stringWithFormat:@"%@.bundle/",((bundleName))] stringByAppendingString:(iconName)]:(iconName)

/** 裁切图片的宏*/
/**
 *  裁切图片的宏
 *
 *  @param image 需要裁剪的图片
 *
 *  @return 裁切图片的宏
 */
#define MTBStretchImg(image) [(image) stretchableImageWithLeftCapWidth:(image.size.width/3.0) topCapHeight:image.size.height/3.0]?:[UIImage new]
#define MTBStretchImgCustom(image,w,h) [(image) stretchableImageWithLeftCapWidth:(image.size.width*(w)) topCapHeight:image.size.height*(h)]?:[UIImage new]

/** 多线程GCD*/
/**
 *  多线程GCD
 *
 *  @param block block
 *
 *  @return block
 */
#define ZEBGlobalGCD(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define ZEBMainGCD(block) dispatch_async(dispatch_get_main_queue(),block)

/** 数据存储*/
/**
 *  数据存储
 *
 *  @param NSCachesDirectory NSCachesDirectory description
 *  @param NSUserDomainMask  NSUserDomainMask description
 *  @param YES               YES description
 *
 *  @return 数据存储
 */
#define kZEBUserDefaults [NSUserDefaults standardUserDefaults]
#define kZEBCacheDir [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
#define kZEBDocumentDir [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define kZEBTempDir NSTemporaryDirectory()

/** 非空block，把block和参数都写好，如果block不为空才执行*/
/**
 *  非空block，把block和参数都写好，如果block不为空才执行
 *
 *  @param block
 *  @param ...
 *
 *  @return 非空block，把block和参数都写好，如果block不为空才执行
 */
#define ZEBNotNilBlock(block, ...) if (block) { block(__VA_ARGS__); };

/** 获取相机权限状态（一般是直接用下面两个 拒绝或同意）*/
/**
 *  获取相机权限状态
 *
 *  @param ZEBCameraStatus 相机状态
 *
 *  @return 获取相机权限状态
 */
#define ZEBCameraStatus [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]
#define ZEBCameraDenied ((ZEBCameraStatus == AVAuthorizationStatusRestricted)||(ZEBCameraStatus == AVAuthorizationStatusDenied))
#define ZEBCameraAllowed (!ZEBCameraDenyed)

/** 定位权限*/
/**
 *  定位权限
 *
 *  @return 定位权限
 */
#define ZEBLocationStatus [CLLocationManager authorizationStatus];
#define ZEBLocationAllowed ([CLLocationManager locationServicesEnabled] && !((status == kCLAuthorizationStatusDenied) || (status == kCLAuthorizationStatusRestricted)))
#define ZEBLocationDenied (!ZEBLocationAllowed)

/** 消息推送权限*/
/**
 *  消息推送权限
 *
 *  @param floatValue]>.0f 版本号
 *
 *  @return 消息推送权限
 */
#define ZEBPushClose (([[UIDevice currentDevice].systemVersion floatValue]>=8.0f)?(UIUserNotificationTypeNone == [[UIApplication sharedApplication] currentUserNotificationSettings].types):(UIRemoteNotificationTypeNone == [[UIApplication sharedApplication] enabledRemoteNotificationTypes]))
#define ZEBPushOpen (!ZEBPushClose)

/** 直接跳到系统内本App的设置页面*/
/**
 *  直接跳到系统内本App的设置页面
 *
 *  @return 直接跳到系统内本App的设置页面
 */
#define ZEBGoToApplicationSettingPage [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
/**
 *  判断是否为iPhone UI
 *
 *  @param UI_USER_INTERFACE_IDIOM 判断是否为iPhone UI
 *
 *  @return 判断是否为iPhone UI
 */
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

/**
 *  判断是否为iPad UI
 *
 *  @param  判断是否为iPad UI
 *
 *  @return 判断是否为iPad UI
 */
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

/**
 *  判断是否为ipod touch
 *
 *  @param touch"] 判断是否为ipod touch
 *
 *  @return 判断是否为ipod touch
 */
#define IS_IPOD ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"])

#define nsStrIphone @"iPhone"
#define nsStrIpod  @"iPod"
#define nsStrIpad  @"iPad"


#define CheckVersion @"version"
#endif /* ZEBEasyMacro_h */
