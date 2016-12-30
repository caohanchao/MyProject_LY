//
//  Common.m
//  LandscapeAssistant
//
//  Created by Shondring on 3/3/14.
//  Copyright (c) 2014 Shondring. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import "Common.h"
#import <CommonCrypto/CommonDigest.h>



//=====================================================================================================
// extension
//=====================================================================================================

@implementation NSArray (DataUtils)

- (id)objectAtIndex:(NSUInteger)index OfClass:(Class)class
{
    id result = nil;
	if (index < [self count]) {
		result = [self objectAtIndex:index];
		if (result && [result isKindOfClass:class]) {
			return result;
		}
	}
	return nil;
}

- (NSString *)stringAtIndex:(NSUInteger)index
{
    id result = [self objectAtIndex:index];
	if (result && [result isKindOfClass:[NSString class]]) {
		return result;
	}
	else if (result && [result isKindOfClass:[NSNumber class]]) {
		NSNumber *number = (NSNumber *)result;
		return [number stringValue];
	}
    return @"";
}

- (NSArray *)arrayAtIndex:(NSUInteger)index
{
    return [self objectAtIndex:index OfClass:[NSArray class]];
}

- (NSMutableArray *)mutableArrayAtIndex:(NSUInteger)index
{
    return [self objectAtIndex:index OfClass:[NSMutableArray class]];
}

- (NSDictionary *)dictionaryAtIndex:(NSUInteger)index
{
    return [self objectAtIndex:index OfClass:[NSDictionary class]];
}

- (NSMutableDictionary *)mutableDictionaryAtIndex:(NSUInteger)index
{
    return [self objectAtIndex:index OfClass:[NSMutableDictionary class]];
}

- (NSInteger)intAtIndex:(NSUInteger)index WithDefault:(NSInteger)nDefault
{
    id result = [self objectAtIndex:index];
    if ( result && [result isKindOfClass:[NSNumber class]] ) {
        return [(NSNumber *)result intValue];
    }
    else if ( result && [result isKindOfClass:[NSString class]] ) {
        return [(NSString *)result intValue];
    }
    
    return nDefault;
}

- (NSInteger)intAtIndex:(NSUInteger)index
{
    return [self intAtIndex:index WithDefault:0];
}

- (BOOL)boolAtIndex:(NSUInteger)index WithDefault:(BOOL)bDefault
{
    id result = [self objectAtIndex:index];
    if ( result && [result isKindOfClass:[NSNumber class]] ) {
        return [(NSNumber *)result boolValue];
    }
    else if ( result && [result isKindOfClass:[NSString class]] ) {
        return [(NSString *)result boolValue];
    }
    return bDefault;
}

- (BOOL)boolAtIndex:(NSUInteger)index
{
    return [self boolAtIndex:index WithDefault:NO];
}

- (CGFloat)floatAtIndex:(NSUInteger)index WithDefault:(CGFloat)nDefault
{
    id result = [self objectAtIndex:index];
    if ( result && [result isKindOfClass:[NSNumber class]] ) {
        return [(NSNumber *)result floatValue];
    }
    else if ( result && [result isKindOfClass:[NSString class]] ) {
        return [(NSString *)result floatValue];
    }
    
    return nDefault;
}

- (CGFloat)floatAtIndex:(NSUInteger)index
{
    return [self floatAtIndex:index WithDefault:0.0f];
}

@end


@implementation NSMutableArray (DataUtils)

-(void)safe_addObject:(id)object {
    if (object) {
        [self addObject:object];
    }
}

-(void)safe_insertObject:(id)object atIndex:(NSInteger)index {
    if (object) {
        [self insertObject:object atIndex:index];
    }
}

@end


@implementation NSDictionary (DataUtils)

- (id)objectForKey:(id)key OfClass:(Class)class
{
	id result = [self objectForKey:key];
	if (result && [result isKindOfClass:class] ) {
		return result;
	}
	return nil;
}

- (NSString *)stringForKey:(id)key
{
    id result = [self objectForKey:key];
	if (result && [result isKindOfClass:[NSString class]]) {
		return result;
	}
	else if (result && [result isKindOfClass:[NSNumber class]]) {
		NSNumber *number = (NSNumber *)result;
		return [number stringValue];
	}
    if (result && ![result isKindOfClass:[NSNull class]]) {
        NSLog(@"key为%@的值不是字符串,其类型为%@",key,NSStringFromClass([result class]));
    }
	return @"";
}

- (NSArray *)arrayForKey:(id)key
{
    return [self objectForKey:key OfClass:[NSArray class]];
}

- (NSMutableArray *)mutableArrayForKey:(id)key
{
    return [self objectForKey:key OfClass:[NSMutableArray class]];
}

- (NSDictionary *)dictionaryForKey:(id)key
{
    return [self objectForKey:key OfClass:[NSDictionary class]];
}

- (NSMutableDictionary *)mutableDictionaryForKey:(id)key
{
    return [self objectForKey:key OfClass:[NSMutableDictionary class]];
}

- (NSInteger)intForKey:(id)key WithDefault:(NSInteger)nDefault
{
    id result = [self objectForKey:key];
    if ( result && [result isKindOfClass:[NSNumber class]] ) {
        return [(NSNumber *)result integerValue];
    }
    else if ( result && [result isKindOfClass:[NSString class]] ) {
        return [(NSString *)result integerValue];
    }
    
    return nDefault;
}

- (NSInteger)intForKey:(id)key
{
    return [self intForKey:key WithDefault:0];
}

- (long long)longForKey:(id)key WithDefault:(NSInteger)nDefault
{
    id result = [self objectForKey:key];
    if ( result && [result isKindOfClass:[NSNumber class]] ) {
        return [(NSNumber *)result longLongValue];
    }
    else if ( result && [result isKindOfClass:[NSString class]] ) {
        return [(NSString *)result longLongValue];
    }
    
    return nDefault;
}

- (long long)longForKey:(id)key
{
    return [self longForKey:key WithDefault:0];
}

- (BOOL)boolForKey:(id)key WithDefault:(BOOL)bDefault
{
    id result = [self objectForKey:key];
    if ( result && [result isKindOfClass:[NSNumber class]] ) {
        return [(NSNumber *)result boolValue];
    }
    else if ( result && [result isKindOfClass:[NSString class]] ) {
        return [(NSString *)result boolValue];
    }
    return bDefault;
}

- (BOOL)boolForkey:(id)key
{
    return [self boolForKey:key WithDefault:NO];
}

- (CGFloat)floatForkey:(id)key WithDefault:(CGFloat)nDefault
{
    id result = [self objectForKey:key];
    if ( result && [result isKindOfClass:[NSNumber class]] ) {
        return [(NSNumber *)result floatValue];
    }
    else if ( result && [result isKindOfClass:[NSString class]] ) {
        return [(NSString *)result floatValue];
    }
    
    return nDefault;
}

- (CGFloat)floatForkey:(id)key
{
    return [self floatForkey:key WithDefault:0.0f];
}

- (double)doubleForkey:(id)key WithDefault:(CGFloat)nDefault
{
    id result = [self objectForKey:key];
    if ( result && [result isKindOfClass:[NSNumber class]] ) {
        return [(NSNumber *)result doubleValue];
    }
    else if ( result && [result isKindOfClass:[NSString class]] ) {
        return [(NSString *)result doubleValue];
    }
    
    return nDefault;
}

- (double)doubleForkey:(id)key
{
    return [self doubleForkey:key WithDefault:0.0f];
}

@end


@implementation NSMutableDictionary (DataUtils)

- (void)safe_setObject:(id)object forKey:(id<NSCopying>)key
{
    if (key) {
        if (object == nil) {
            [self removeObjectForKey:key];
        }
        else {
            [self setObject:object forKey:key];
        }
    }
}

@end


@implementation NSSet (DataUtils)

@end


@implementation NSDate (DateUtils)

+ (NSString *)currentStringForFormat:(NSString *)format
{
    NSDate *dateNow = [NSDate date];
    
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    
    [formatter setTimeZone:timeZone];
    
    [formatter setDateFormat : format];
    
    return [formatter stringFromDate:dateNow];
}

- (NSString *)stringForFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    
    [formatter setTimeZone:timeZone];
    
    [formatter setDateFormat : format];
    
    return [formatter stringFromDate:self];
}

- (BOOL)isSameDayWith:(NSDate *)date
{
    
    NSDate *todayZero = [[date stringForFormat:@"yyyy-MM-dd"] dateForFormat:@"yyyy-MM-dd"];
    NSDate *tomorrowZero = [[[NSDate dateWithTimeInterval:24*60*60 sinceDate:date] stringForFormat:@"yyyy-MM-dd"] dateForFormat:@"yyyy-MM-dd"];
    if ([self compare:todayZero] == NSOrderedDescending && [self compare:tomorrowZero] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}

- (BOOL)isToday
{
    return [self isSameDayWith:[NSDate date]];
}

- (BOOL)isYesterday
{
    return [self isSameDayWith:[NSDate dateWithTimeInterval:-24*60*60 sinceDate:[NSDate date]]];
}

//-(BOOL)isDuringWithBegin:(NSData *)beginDate 
//{
//    
//}

- (NSString *)formateString
{
    if ([self isToday]) {
        return [self stringForFormat:@"h:mm"];
    }else if([self isYesterday]){
        return @"昨天";
    }else{
        return [self stringForFormat:@"M月d日"];
    }
}

@end


@implementation NSString (DateUtils)

- (NSDate *)dateForFormat:(NSString *)format
{
    NSDateFormatter *formatter=[[[NSDateFormatter alloc] init] autorelease];
    
    [formatter setDateFormat:format];
    
    return [formatter dateFromString:self];
}

- (BOOL)isTodayForFormat:(NSString *)format
{
    return [[self dateForFormat:format] isToday];
}

- (BOOL)isYesterdayForFormat:(NSString *)format
{
    return [[self dateForFormat:format] isYesterday];
}

- (BOOL)isDigit{
    if ([self length] == 0) {
        return NO;
    }
    NSString *trimed = [self stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if ([trimed length] == 0) {
        return YES;
    }
    return NO;
}

- (BOOL)isMobilePhoneNumber
{
    if ([self isDigit] && self.length == 11) {
        return YES;
    }
    return NO;
}

- (NSString *) md5String
{
    const char* character = [self UTF8String];
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(character, strlen(character), result);
    
    NSMutableString *md5String = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [md5String appendFormat:@"%02x",result[i]];
    }
    
    return md5String;
}


//然后直接使用下面的方法就可以了
//sha1加密方式
- (NSString *) sha1:(NSString *)input
{
    //const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    //NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (unsigned int)data.length, digest);
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    
    return output;
}

@end


@implementation UIImage (ImageUtils)

+ (UIImage *)imageForName:(NSString *)name
{
    NSString * trimName = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (trimName == nil || [trimName length] == 0) {
        return nil;
    }
    NSString *type = @"png";
    if ([[trimName pathExtension] length] > 0) {
        type = [trimName pathExtension];
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:[trimName stringByDeletingPathExtension] ofType:type];
    return [UIImage imageWithContentsOfFile:path];
}

+ (UIImage *)imageBriefNamed:(NSString *)briefName
{
    NSString * trimName = [briefName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (trimName == nil || [trimName length] == 0) {
        return nil;
    }
    NSString *fullName = [NSString stringWithFormat:@"S0_%@",briefName];
    return [self imageForName:fullName];
}




- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)scaleImage:(CGFloat)scale
{
//    CGSize newSize = CGSizeMake(self.size.width * scale, self.size.height * scale);
//    
//    // Create a graphics image context
//    UIGraphicsBeginImageContext(newSize);
//    
//    // Tell the old image to draw in this new context, with the desired
//    // new size
//    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
//    
//    // Get the new image from the context
//    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    // End the context
//    UIGraphicsEndImageContext();
//    
//    // Return the new image.
//    return newImage;
    
    CGSize imageSize = [self size];
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = width * scale;
    CGFloat targetHeight = height * scale;
    
    return [self scaledToSize:CGSizeMake(targetWidth, targetHeight)];
}

- (UIImage *)scaledToSize:(CGSize)newSize;
{
    CGFloat targetWidth = newSize.width;
    CGFloat targetHeight = newSize.height;
    if (self.imageOrientation == UIImageOrientationUp || self.imageOrientation == UIImageOrientationDown) {
        targetWidth = newSize.width;
        targetHeight = newSize.height;
    }else{
        targetWidth =  newSize.height;
        targetHeight = newSize.width;
    }
    
    CGImageRef imageRef = [self CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    CGContextRef bitmap;
    
    if (self.imageOrientation == UIImageOrientationUp || self.imageOrientation == UIImageOrientationDown) {
        bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), 4 * targetWidth, colorSpaceInfo, bitmapInfo);
        
    } else {
        bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), 4 * targetHeight, colorSpaceInfo, bitmapInfo);
        
    }
    
    if (self.imageOrientation == UIImageOrientationLeft) {
        CGContextRotateCTM (bitmap, M_PI_2); // + 90 degrees
        CGContextTranslateCTM (bitmap, 0, -targetHeight);
        
    } else if (self.imageOrientation == UIImageOrientationRight) {
        CGContextRotateCTM (bitmap, -M_PI_2); // - 90 degrees
        CGContextTranslateCTM (bitmap, -targetWidth, 0);
        
    } else if (self.imageOrientation == UIImageOrientationUp) {
        // NOTHING
    } else if (self.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
        CGContextRotateCTM (bitmap, -M_PI); // - 180 degrees
    }
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, targetWidth, targetHeight), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    
    CGContextRelease(bitmap);
    CGImageRelease(ref);
    
    return newImage;
}

@end

@implementation UIColor (ColorUtils)

+ (UIColor *)showyColor
{
    return [UIColor colorWithHex:0x76b0a6 alpha:1.0f];
}

+ (UIColor *)backgroundColor
{
    return [UIColor colorWithHex:0xe7e7e7 alpha:1.0f];
}

+ (UIColor *)separatorColor
{
    return [UIColor colorWithHex:0xe7e7e7 alpha:1.0f];
}

+ (UIColor *)colorWithIntRed:(int)a green:(int)b blue:(int)c
{
    return [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1];
}

+ (UIColor *)colorWithHex:(int)hexColor
{
    return [UIColor colorWithHex:hexColor alpha:1.0f];
}

+ (UIColor *)colorWithHex:(int)hexColor alpha:(CGFloat)alpha
{
    CGFloat red = ((hexColor & 0x0FF0000)>>16)/255.0;
	CGFloat green = ((hexColor & 0x0FF00)>>8)/255.0;
    CGFloat blue = (hexColor & 0xFF)/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end

//@implementation UIFont (FontUtils)
//
//+ (UIFont *)systemFontOfSize:(CGFloat)fontSize
//{
//    return [UIFont fontWithName:@"Microsoft YaHei" size:fontSize];
//}
//
//@end

@implementation UIView (UIViewUtils)

- (CGPoint)subOffset
{
    CGPoint result = CGPointMake(0.0f, 0.0f);
    UIView *lastSubView = [[self subviews] lastObject];
    if (lastSubView) {
        result = CGPointMake(lastSubView.frame.origin.x + lastSubView.frame.size.width, lastSubView.frame.origin.y + lastSubView.frame.size.height);
    }
    return result;
}

- (CGPoint)frameOffset
{
    return CGPointMake(self.frame.origin.x + self.frame.size.width, self.frame.origin.y + self.frame.size.height);
}

- (CGFloat)verticalOffset
{
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)horizontalOffset
{
    return self.frame.origin.x + self.frame.size.width;
}

@end

@implementation UINavigationBar (CustomNavigationBar)

- (void)remould
{
    if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self setBackgroundImage:[[UIImage imageBriefNamed:@"CM_bg_navbar"] stretchableImageWithLeftCapWidth:13 topCapHeight:22] forBarMetrics:UIBarMetricsDefault];
    }
    if ([self respondsToSelector:@selector(setTitleTextAttributes:)]) {
        [[UINavigationBar appearance] setTitleTextAttributes:@{UITextAttributeTextColor: [UIColor whiteColor]}];
    }
}

- (void)drawRect:(CGRect)rect {
    UIImage *barImage = [[UIImage imageBriefNamed:@"CM_bg_navbar"] stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    [barImage drawInRect:rect];
}

@end

#define CSMImageTag 10

@implementation UITabBar (CustomTabBar)

- (void)remould
{
    if ([self respondsToSelector:@selector(setBackgroundImage:)])
    {
        [self setBackgroundImage:[[UIImage imageBriefNamed:@"menuBg.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:24]];
    }
    else
    {
        UIImageView *imageView = (UIImageView *)[self viewWithTag:CSMImageTag];
        if (imageView == nil)
        {
            imageView = [[[UIImageView alloc] initWithImage:[[UIImage imageBriefNamed:@"menuBg.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:24]] autorelease];
            [imageView setTag:CSMImageTag];
            [self insertSubview:imageView atIndex:0];
        }
    }
}

@end

@implementation UIToolbar (CustomToolBar)

- (void)remould
{
    if ([self respondsToSelector:@selector(setBackgroundImage:forToolbarPosition:barMetrics:)])
    {
        [self setBackgroundImage:[[UIImage imageBriefNamed:@"com_navbar_bg"] stretchableImageWithLeftCapWidth:13 topCapHeight:22] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    }
}

- (void)drawRect:(CGRect)rect {
    UIImage *barImage = [[UIImage imageBriefNamed:@"com_navbar_bg"] stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    [barImage drawInRect:rect];
}

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self remould];
    }
    return self;
}

@end

//=====================================================================================================
// common
//=====================================================================================================

@implementation Common

+ (NSString *)uniqueString
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return [(NSString *)string autorelease];
}

@end
