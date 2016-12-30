//
//  Common.h
//  LandscapeAssistant
//
//  Created by Shondring on 3/3/14.
//  Copyright (c) 2014 Shondring. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


//=====================================================================================================
// define
//=====================================================================================================

#import "comdef.h"

//=====================================================================================================
// typedef
//=====================================================================================================

typedef NS_ENUM(NSInteger, StockType) {
    StockTypeBBS = 2,
    StockTypeNews = 3,
    StockTypeNotice = 4,
};

//=====================================================================================================
// extension
//=====================================================================================================

@interface NSArray (DataUtils)

- (id)objectAtIndex:(NSUInteger)index OfClass:(Class)ofclass;

- (NSString *)stringAtIndex:(NSUInteger)index;

- (NSArray *)arrayAtIndex:(NSUInteger)index;

- (NSMutableArray *)mutableArrayAtIndex:(NSUInteger)index;

- (NSDictionary *)dictionaryAtIndex:(NSUInteger)index;

- (NSMutableDictionary *)mutableDictionaryAtIndex:(NSUInteger)index;

- (NSInteger)intAtIndex:(NSUInteger)index WithDefault:(NSInteger)nDefault;

- (NSInteger)intAtIndex:(NSUInteger)index;

- (BOOL)boolAtIndex:(NSUInteger)index WithDefault:(BOOL)bDefault;

- (BOOL)boolAtIndex:(NSUInteger)index;

- (CGFloat)floatAtIndex:(NSUInteger)index WithDefault:(CGFloat)nDefault;

- (CGFloat)floatAtIndex:(NSUInteger)index;

@end

@interface NSMutableArray (DataUtils)

-(void)safe_addObject:(id)object;

-(void)safe_insertObject:(id)object atIndex:(NSInteger)index;

@end


@interface NSDictionary (DataUtils)

- (id)objectForKey:(id)key OfClass:(Class)ofclass;

- (NSString *)stringForKey:(id)key;

- (NSArray *)arrayForKey:(id)key;

- (NSMutableArray *)mutableArrayForKey:(id)key;

- (NSDictionary *)dictionaryForKey:(id)key;

- (NSMutableDictionary *)mutableDictionaryForKey:(id)key;

- (NSInteger)intForKey:(id)key WithDefault:(NSInteger)nDefault;

- (NSInteger)intForKey:(id)key;

- (long long)longForKey:(id)key WithDefault:(NSInteger)nDefault;

- (long long)longForKey:(id)key;

- (BOOL)boolForKey:(id)key WithDefault:(BOOL)bDefault;

- (BOOL)boolForkey:(id)key;

- (CGFloat)floatForkey:(id)key WithDefault:(CGFloat)nDefault;

- (CGFloat)floatForkey:(id)key;

- (double)doubleForkey:(id)key WithDefault:(CGFloat)nDefault;

- (double)doubleForkey:(id)key;

@end

@interface NSMutableDictionary (DataUtils)

- (void)safe_setObject:(id)object forKey:(id<NSCopying>)key;

@end

@interface NSSet (DataUtils)

@end


@interface NSDate (DateUtils)

+ (NSString *)currentStringForFormat:(NSString *)format;
- (NSString *)stringForFormat:(NSString *)format;
- (BOOL)isSameDayWith:(NSDate *)date;
- (BOOL)isToday;
- (BOOL)isYesterday;
- (NSString *)formateString;

@end


@interface NSString (DateUtils)

- (NSDate *)dateForFormat:(NSString *)format;
- (BOOL)isTodayForFormat:(NSString *)format;
- (BOOL)isYesterdayForFormat:(NSString *)format;
- (BOOL)isDigit;
- (BOOL)isMobilePhoneNumber;

- (NSString *) md5String;

- (NSString *) sha1:(NSString *)input;


@end


@interface UIImage (ImageUtils)

+ (UIImage *)imageForName:(NSString *)name;
+ (UIImage *)imageBriefNamed:(NSString *)briefName;
- (UIImage *)scaleImage:(CGFloat)scale;
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
- (UIImage *)scaledToSize:(CGSize)newSize;;

@end

@interface UIColor (ColorUtils)

+ (UIColor *)showyColor;
+ (UIColor *)backgroundColor;
+ (UIColor *)separatorColor;
+ (UIColor *)colorWithIntRed:(int)a green:(int)b blue:(int)c;
+ (UIColor *)colorWithHex:(int)hexColor;
+ (UIColor *)colorWithHex:(int)hexColor alpha:(CGFloat)alpha;

@end

//@interface UIFont (FontUtils)
//
//+ (UIFont *)systemFontOfSize:(CGFloat)fontSize;
//
//@end

@interface UIView (UIViewUtils)

- (CGPoint)subOffset;
- (CGPoint)frameOffset;
- (CGFloat)verticalOffset;
- (CGFloat)horizontalOffset;

@end

@interface UINavigationBar (CustomNavigationBar)

- (void)remould;
- (void)drawRect:(CGRect)rect;

@end

@interface UITabBar (CustomTabBar)

- (void)remould;

@end

@interface UIToolbar (CustomToolBar)

- (void)remould;

@end

//=====================================================================================================
// common
//=====================================================================================================

@interface Common : NSObject

+ (NSString *)uniqueString;

@end
