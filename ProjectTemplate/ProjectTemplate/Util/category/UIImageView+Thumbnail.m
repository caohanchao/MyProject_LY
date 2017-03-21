//
//  UIImageView+Thumbnail.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/1/13.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "UIImageView+Thumbnail.h"
#import <ImageIO/ImageIO.h>


@implementation UIImageView (Thumbnail)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL origionSel = @selector(setImage:);
        SEL swizzlingSel = @selector(bq_setImage:);
        Method origionMethod = class_getInstanceMethod(class, origionSel);
        Method swizzlingMethod = class_getInstanceMethod(class, swizzlingSel);
        
        BOOL hasAdded = class_addMethod(class, origionSel, method_getImplementation(swizzlingMethod), method_getTypeEncoding(swizzlingMethod));
        
        if (hasAdded) {
            class_replaceMethod(class, swizzlingSel, method_getImplementation(origionMethod), method_getTypeEncoding(origionMethod));
        } else {
            method_exchangeImplementations(origionMethod, swizzlingMethod);
        }
    });
}

- (void)bq_setImage:(UIImage *)image {
    CGFloat maxImageWH = 1080;
    if (image.size.width > maxImageWH || image.size.height > maxImageWH) {
        
    }
    [self bq_setImage:image];
}

- (void)setPlaceholder:(UIImage *)placeholder {
    objc_setAssociatedObject(self, @selector(placeholder), placeholder, OBJC_ASSOCIATION_RETAIN);
}

- (UIImage *)placeholder {
    return objc_getAssociatedObject(self, _cmd);
}


CGImageRef MyCreateThumbnailImageFromData (NSData *data, int imageSize)
{
    CGImageRef        myThumbnailImage = NULL;
    CGImageSourceRef  myImageSource;
    CFDictionaryRef   myOptions = NULL;
    CFStringRef       myKeys[3];
    CFTypeRef         myValues[3];
    CFNumberRef       thumbnailSize;
    
    // Create an image source from NSData; no options.
    myImageSource = CGImageSourceCreateWithData((CFDataRef)data,
                                                NULL);
    // Make sure the image source exists before continuing.
    if (myImageSource == NULL){
        fprintf(stderr, "Image source is NULL.");
        return  NULL;
    }
    
    // Package the integer as a  CFNumber object. Using CFTypes allows you
    // to more easily create the options dictionary later.
    thumbnailSize = CFNumberCreate(NULL, kCFNumberIntType, &imageSize);
    
    // Set up the thumbnail options.
    myKeys[0] = kCGImageSourceCreateThumbnailWithTransform;
    myValues[0] = (CFTypeRef)kCFBooleanTrue;
    myKeys[1] = kCGImageSourceCreateThumbnailFromImageIfAbsent;
    myValues[1] = (CFTypeRef)kCFBooleanTrue;
    myKeys[2] = kCGImageSourceThumbnailMaxPixelSize;
    myValues[2] = (CFTypeRef)thumbnailSize;
    
    // 就是这里，numValues应该是3，不是2。＝＝
    myOptions = CFDictionaryCreate(NULL, (const void **) myKeys,
                                   (const void **) myValues, 3,
                                   &kCFTypeDictionaryKeyCallBacks,
                                   & kCFTypeDictionaryValueCallBacks);
    
    // Create the thumbnail image using the specified options.
    myThumbnailImage = CGImageSourceCreateThumbnailAtIndex(myImageSource,
                                                           0,
                                                           myOptions);
    // Release the options dictionary and the image source
    // when you no longer need them.
    CFRelease(thumbnailSize);
    CFRelease(myOptions);
    CFRelease(myImageSource);
    
    // Make sure the thumbnail image exists before continuing.
    if (myThumbnailImage == NULL){
        fprintf(stderr, "Thumbnail image not created from image source.");
        return NULL;
    }
    
    return myThumbnailImage;
}


@end
