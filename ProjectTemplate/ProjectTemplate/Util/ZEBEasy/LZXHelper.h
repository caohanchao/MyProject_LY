//
//  LZXHelper.h
//  Connotation
//
//  Created by LZXuan on 14-12-20.
//  Copyright (c) 2014年 LZXuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class AFSecurityPolicy;

typedef enum :NSInteger {
    kCameraMoveDirectionNone,
    kCameraMoveDirectionUp,
    kCameraMoveDirectionDown,
    kCameraMoveDirectionRight,
    kCameraMoveDirectionLeft
} CameraMoveDirection;

@interface LZXHelper : NSObject



// 过滤字符串中的空格,回车
+(NSString *)stringReplaceFromString:(NSString *)string;

//把一个秒字符串 转化为真正的本地时间
//@"1419055200" -> 转化 日期字符串
+ (NSString *)dateStringFromNumberTimer:(NSString *)timerStr;
//根据字符串内容的多少  在固定宽度 下计算出实际的行高
+ (CGFloat)textHeightFromTextString:(NSString *)text width:(CGFloat)textWidth fontSize:(CGFloat)size;
//动态 计算宽度
//根据字符串的实际内容的多少 在固定的行高和字体的大小，动态的计算出实际的宽度
+ (CGFloat)textWidthFromTextString:(NSString *)text height:(CGFloat)textHeight fontSize:(CGFloat)size;
//获取 当前设备版本
+ (double)getCurrentIOS;
//获取当前设备屏幕的大小
+ (CGSize)getScreenSize;

//获得当前系统时间到指定时间的时间差字符串,传入目标时间字符串和格式
+(NSString*)stringNowToDate:(NSString*)toDate formater:(NSString*)formatStr;
//调整label行间距
+ (NSMutableAttributedString *)setLineSpace:(NSString *)labelText lineSpace:(float)lineSpace;
//获取 一个文件 在沙盒沙盒Library/Caches/ 目录下的路径
+ (NSString *)getFullPathWithFile:(NSString *)urlName;
//检测 缓存文件 是否超时
+ (BOOL)isTimeOutWithFile:(NSString *)filePath timeOut:(double)timeOut;
//字符串转字典
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
//判断字符串是否为中文字符
+ (BOOL)isChinese:(NSString *)chinaStr;

+ (BOOL)validatePassWord:(NSString *)password;

+ (BOOL) isManOrWomanWithValidateIdentityCard:(NSString *)idCard;

+ (BOOL) validateIdentityCard: (NSString *)identityCard;
//银行卡
+ (BOOL) validateBankCardNumber: (NSString *)bankCardNumber;
//银行卡后四位
+ (BOOL) validateBankCardLastNumber: (NSString *)bankCardNumber;
//判断固话号码
+(BOOL)isTelephoneNumber:(NSString *)teleNum;
// 正则判断手机号码地址格式
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
//邮箱
+ (BOOL) validateEmail:(NSString *)email;
//判断帐号是否为字符或数字
+(BOOL)validateAccountNum:(NSString *)accountNum;
//ios 判断textFiled中输入的字符是不是数字
+ (BOOL)isPureInt:(NSString*)string;
//设置label字体不同颜色
+ (NSMutableAttributedString *)updageBanlence:(NSString *)tmpStr color:(UIColor *)color location:(NSInteger)location;
//通过颜色来生成一个纯色图片
+ (UIImage *)buttonImageFromColor:(UIColor *)color;
//查找设备属于哪种设备
+ (BOOL)checkDevice:(NSString*)name;

//查找当前设备的机型
+ (NSString*)deviceString;

//检查版本

//今天星期几
+ (NSDateComponents *)formattedDateDescritionComponents;

//判断文件是否已经在沙盒中已经存在？
+ (BOOL) isFileExist:(NSString *)fileName;
//判断url文件是否已经在沙盒中已经存在？
+ (BOOL) isUrlExist:(NSURL *)url;
//NSString字符串 判空处理
+ (NSString *)isNullToString:(id)string;
//把多个json字符串转为一个json字符串
+ (NSString *)objArrayToJSON:(NSArray *)array;
//把字典转为一个json字符串
+ (NSString *)dictionaryToJson:(NSDictionary *)dic ;

+ (NSString *)toJSONString: (id) data ;

//生成唯一ID
+ (NSString *)createCUID;
//判断pan手势方向
+ (CameraMoveDirection)commitTranslation:(CGPoint)translation;
+ (CameraMoveDirection)tableviewTranslation:(CGPoint)translation;
//返回灰度图片
+ (UIImage*) convertImageToGreyScale:(UIImage*) image;
#pragma mark -
#pragma mark 返回label
+ (UILabel *)getLabelFont:(UIFont *)font textColor:(UIColor *)color;

+ (NSString *)stringWithUIImage:(UIImage *)image;

+ (UIImage *)Base64StrToUIImage:(NSString *)str;
// 获取当前时间
+ (NSString *)getNowTime;
//支持https
+ (AFSecurityPolicy *)customSecurityPolicy;
@end





