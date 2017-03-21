//
//  ZEBEmotionsKeyboardView.m
//  GIF_Keyboard_Demo
//
//  Created by ZEB on 17/2/20.
//  Copyright © 2016年 ZEB. All rights reserved.
//

#import "ZEBEmotionsKeyboardViewModel.h"
#import "YYImage.h"
#import "Emoji.h"
#import "EmojiEmoticons.h"
#import "EmojiMapSymbols.h"
#import "EmojiPictographs.h"
#import "EmojiTransport.h"
#import "NSString+Property.h"

NSString * const ZEBEmojiTypePeopleKey  = @"ZEBEmojiTypePeopleKey";
NSString * const ZEBEmojiTypeNatureKey  = @"ZEBEmojiTypeNatureKey";
NSString * const ZEBEmojiTypeObjectsKey = @"ZEBEmojiTypeObjectsKey";
NSString * const ZEBEmojiTypePlacesKey  = @"ZEBEmojiTypePlacesKey";

@implementation ZEBEmotionsKeyboardViewModel

#pragma mark - GIF

/**
 *  获取本地gif所有文件
 *
 *  @return
 */
+ (NSArray *)getAllGifs
{
    NSMutableArray *gifNames = [NSMutableArray array];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"emojipolice" ofType:@"plist"];
    NSArray *plistArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
    
    NSInteger count = plistArray.count;
    //本地png...
    for (int i=0; i<count; i++)
    {
        NSDictionary *dict = plistArray[i];
        //获取本地gif文件名字
        NSString *gifFileName = dict[@"iconUrl"];
        gifFileName.name = dict[@"content"];
        UIImage *image = [YYImage imageNamed:gifFileName];
        
        if (image == nil)
        {
            break;
        }
        else
        {
            [gifNames addObject:gifFileName];
        }
    }
    
    return [gifNames copy];;
}
/**
 *  获取本地png所有文件
 *
 *  @return
 */
+ (NSArray *)getAllPNGs
{
    NSMutableArray *pngNames = [NSMutableArray array];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"emojinj" ofType:@"plist"];
    NSArray *plistArray = [[NSArray alloc] initWithContentsOfFile:plistPath];
    
    NSInteger count = plistArray.count;
    //本地png...
    for (int i=0; i<count; i++)
    {
        NSDictionary *dict = plistArray[i];
        //获取本地png文件名字
        NSString *pngFileName = dict[@"iconUrl"];
        
        UIImage *image = [YYImage imageNamed:pngFileName];
        
        if (image == nil)
        {
            break;
        }
        else
        {
            [pngNames addObject:pngFileName];
        }
    }
    
    return [pngNames copy];
}
/**
 *  获取单页gif数组
 *
 *  @param gifArray    所有gif
 *  @param singleCount 单页数量
 *  @param index       页码
 *
 *  @return
 */
+ (NSArray *)getGifEmotionsWithGifArray:(NSArray *)gifArray singleCount:(NSInteger)singleCount index:(NSInteger)index
{
    NSRange range;
    
    //第一页
    if (index == 0)
    {
        range = NSMakeRange(0, singleCount);
        
        //不够一页
        if ((singleCount) > (gifArray.count))
        {
            return gifArray;
        }
        
        return [gifArray subarrayWithRange:range];
    }
    //非首页
    else
    {
        range = NSMakeRange(index*singleCount, singleCount);
        
        //用下标比较，发现不足一页了，从指定位置截取到数组剩下的所有元素
        if ((index*singleCount+singleCount-1) > (gifArray.count-1))
        {
            return [gifArray subarrayWithRange:NSMakeRange(index*singleCount, gifArray.count-index*singleCount)];
        }
        
        return [gifArray subarrayWithRange:range];
    }
}
/**
 *  获取单页png数组
 *
 *  @param pngArray    所有png
 *  @param singleCount 单页数量
 *  @param index       页码
 *
 *  @return
 */
+ (NSArray *)getPngEmotionsWithGifArray:(NSArray *)pngArray singleCount:(NSInteger)singleCount index:(NSInteger)index
{
    NSRange range;
    
    //第一页
    if (index == 0)
    {
        range = NSMakeRange(0, singleCount);
        
        //不够一页
        if ((singleCount) > (pngArray.count))
        {
            return pngArray;
        }
        
        return [pngArray subarrayWithRange:range];
    }
    //非首页
    else
    {
        range = NSMakeRange(index*singleCount, singleCount);
        
        //用下标比较，发现不足一页了，从指定位置截取到数组剩下的所有元素
        if ((index*singleCount+singleCount-1) > (pngArray.count-1))
        {
            return [pngArray subarrayWithRange:NSMakeRange(index*singleCount, pngArray.count-index*singleCount)];
        }
        
        return [pngArray subarrayWithRange:range];
    }
}
#pragma mark - Emoji

/**
 *  获取本地所有支持的emoji表情
 *
 *  @return
 */
+ (NSDictionary *)getAllEmojiDict
{
    NSMutableDictionary *allEmojiDict = [NSMutableDictionary new];
    
    //人
    NSMutableArray *peopleArray = [NSMutableArray arrayWithObjects:
                                   
                                   [EmojiManager emojiWithCode:0x1f604],
                                   [EmojiManager emojiWithCode:0x1f603],
                                   [EmojiManager emojiWithCode:0x1f60a],
                                   [EmojiManager emojiWithCode:0x1f609],
                                   [EmojiManager emojiWithCode:0x1f60d],
                                   [EmojiManager emojiWithCode:0x1f618],
                                   [EmojiManager emojiWithCode:0x1f61a],
                                   [EmojiManager emojiWithCode:0x1f61c],
                                   [EmojiManager emojiWithCode:0x1f61d],
                                   [EmojiManager emojiWithCode:0x1f633],
                                   [EmojiManager emojiWithCode:0x1f601],
                                   [EmojiManager emojiWithCode:0x1f614],
                                   [EmojiManager emojiWithCode:0x1f60c],
                                   [EmojiManager emojiWithCode:0x1f61e],
                                   [EmojiManager emojiWithCode:0x1f623],
                                   [EmojiManager emojiWithCode:0x1f622],
                                   [EmojiManager emojiWithCode:0x1f602],
                                   [EmojiManager emojiWithCode:0x1f62d],
                                   [EmojiManager emojiWithCode:0x1f62a],
                                   [EmojiManager emojiWithCode:0x1f625],
                                   [EmojiManager emojiWithCode:0x1f630],
                                   [EmojiManager emojiWithCode:0x1f613],
                                   [EmojiManager emojiWithCode:0x1f628],
                                   [EmojiManager emojiWithCode:0x1f631],
                                   [EmojiManager emojiWithCode:0x1f621],
                                   [EmojiManager emojiWithCode:0x1f616],
                                   [EmojiManager emojiWithCode:0x1f637],
                                   [EmojiManager emojiWithCode:0x1f60e],
                                   [EmojiManager emojiWithCode:0x1f634],
                                   [EmojiManager emojiWithCode:0x1f632],
                                   [EmojiManager emojiWithCode:0x1f47f],
                                   [EmojiManager emojiWithCode:0x1f607],
                                   [EmojiManager emojiWithCode:0x1f60f],
                                   [EmojiManager emojiWithCode:0x1f47c],
                                   [EmojiManager emojiWithCode:0x1f47d],
//                                   [EmojiManager emojiWithCode:0x2728],
                                   [EmojiManager emojiWithCode:0x1f4a2],
                                   [EmojiManager emojiWithCode:0x1f4a6],
                                   [EmojiManager emojiWithCode:0x1f4a4],
                                   [EmojiManager emojiWithCode:0x1f44d],
                                   [EmojiManager emojiWithCode:0x1f44c],
//                                   [EmojiManager emojiWithCode:0x270a],
//                                   [EmojiManager emojiWithCode:0x270c],
                                   [EmojiManager emojiWithCode:0x1f64f],
                                   [EmojiManager emojiWithCode:0x1f44f],
                                   [EmojiManager emojiWithCode:0x1f4aa],
                                   [EmojiManager emojiWithCode:0x1f451],
                                   [EmojiManager emojiWithCode:0x1f302],
//                                   [EmojiManager emojiWithCode:0x2764],
                                   [EmojiManager emojiWithCode:0x1f494],
                                   [EmojiManager emojiWithCode:0x1f48b],
                                   [EmojiManager emojiWithCode:0x1f48d],
                                   [EmojiManager emojiWithCode:0x1f463],
                                   nil];
    
    [allEmojiDict setValue:peopleArray forKey:ZEBEmojiTypePeopleKey];
    
    //动物、植物
    NSMutableArray *natureArray = [NSMutableArray arrayWithObjects:
                                   [EmojiManager emojiWithCode:0x1f490],
                                   [EmojiManager emojiWithCode:0x1f338],
                                   [EmojiManager emojiWithCode:0x1f339],
//                                   [EmojiManager emojiWithCode:0x2b50],
                                   nil];
    
    [allEmojiDict setValue:natureArray forKey:ZEBEmojiTypeNatureKey];
    
    //事物
    NSMutableArray *objectsArray = [NSMutableArray arrayWithObjects:
                                    [EmojiManager emojiWithCode:0x1f47b],
                                    [EmojiManager emojiWithCode:0x1f381],
                                    [EmojiManager emojiWithCode:0x1f389],
                                    [EmojiManager emojiWithCode:0x1f388],
                                    [EmojiManager emojiWithCode:0x1f4e2],
                                    [EmojiManager emojiWithCode:0x1f3a4],
                                    [EmojiManager emojiWithCode:0x1f3b5],
                                    [EmojiManager emojiWithCode:0x1f3b6],
                                    [EmojiManager emojiWithCode:0x1f3ae],
                                    [EmojiManager emojiWithCode:0x1f37b],
                                    [EmojiManager emojiWithCode:0x1f382],
                                    [EmojiManager emojiWithCode:0x1f36d],
                                    nil];
    
    [allEmojiDict setValue:objectsArray forKey:ZEBEmojiTypeObjectsKey];
    
    //地点 (此类编码有问题，全部不识别，暂时舍弃)
    NSMutableArray *placesArray = [NSMutableArray arrayWithObjects:
                                   [EmojiManager emojiWithCode:0xe003],
                                   [EmojiManager emojiWithCode:0xe00e],
                                   [EmojiManager emojiWithCode:0xe010],
                                   [EmojiManager emojiWithCode:0xe011],
                                   [EmojiManager emojiWithCode:0xe022],
                                   [EmojiManager emojiWithCode:0xe023],
                                   [EmojiManager emojiWithCode:0xe030],
                                   [EmojiManager emojiWithCode:0xe032],
                                   [EmojiManager emojiWithCode:0xe034],
                                   [EmojiManager emojiWithCode:0xe03c],
                                   [EmojiManager emojiWithCode:0xe03e],
                                   [EmojiManager emojiWithCode:0xe04e],
                                   [EmojiManager emojiWithCode:0xe056],
                                   [EmojiManager emojiWithCode:0xe057],
                                   [EmojiManager emojiWithCode:0xe058],
                                   [EmojiManager emojiWithCode:0xe105],
                                   [EmojiManager emojiWithCode:0xe106],
                                   [EmojiManager emojiWithCode:0xe107],
                                   [EmojiManager emojiWithCode:0xe108],
                                   [EmojiManager emojiWithCode:0xe10c],
                                   [EmojiManager emojiWithCode:0xe10e],
                                   [EmojiManager emojiWithCode:0xe112],
                                   [EmojiManager emojiWithCode:0xe11a],
                                   [EmojiManager emojiWithCode:0xe11b],
                                   [EmojiManager emojiWithCode:0xe13c],
                                   [EmojiManager emojiWithCode:0xe142],
                                   [EmojiManager emojiWithCode:0xe14c],
                                   [EmojiManager emojiWithCode:0xe306],
                                   [EmojiManager emojiWithCode:0xe30c],
                                   [EmojiManager emojiWithCode:0xe310],
                                   [EmojiManager emojiWithCode:0xe312],
                                   [EmojiManager emojiWithCode:0xe326],
                                   [EmojiManager emojiWithCode:0xe32e],
                                   [EmojiManager emojiWithCode:0xe32f],
                                   [EmojiManager emojiWithCode:0xe331],
                                   [EmojiManager emojiWithCode:0xe334],
                                   [EmojiManager emojiWithCode:0xe34b],
                                   [EmojiManager emojiWithCode:0xe401],
                                   [EmojiManager emojiWithCode:0xe402],
                                   [EmojiManager emojiWithCode:0xe403],
                                   [EmojiManager emojiWithCode:0xe404],
                                   [EmojiManager emojiWithCode:0xe405],
                                   [EmojiManager emojiWithCode:0xe406],
                                   [EmojiManager emojiWithCode:0xe407],
                                   [EmojiManager emojiWithCode:0xe408],
                                   [EmojiManager emojiWithCode:0xe40b],
                                   [EmojiManager emojiWithCode:0xe40c],
                                   [EmojiManager emojiWithCode:0xe40d],
                                   [EmojiManager emojiWithCode:0xe40f],
                                   [EmojiManager emojiWithCode:0xe410],
                                   [EmojiManager emojiWithCode:0xe411],
                                   [EmojiManager emojiWithCode:0xe412],
                                   [EmojiManager emojiWithCode:0xe413],
                                   [EmojiManager emojiWithCode:0xe416],
                                   [EmojiManager emojiWithCode:0xe417],
                                   [EmojiManager emojiWithCode:0xe418],
                                   [EmojiManager emojiWithCode:0xe41d],
                                   [EmojiManager emojiWithCode:0xe41f],
                                   [EmojiManager emojiWithCode:0xe420],
                                   [EmojiManager emojiWithCode:0xe43c],
                                   [EmojiManager emojiWithCode:0xe513],
                                   nil];
    
    [allEmojiDict setValue:placesArray forKey:ZEBEmojiTypePlacesKey];
    
    return [allEmojiDict copy];
}
/**
 *  获取本地所有的emoji表情
 *
 *  @return emoji数组
 */
+ (NSArray *)getAllEmojis
{
//    NSMutableArray *emojis = [NSMutableArray new];
//    for (NSArray *array in [ZEBEmotionsKeyboardViewModel getAllEmojiDict].allValues)
//    {
//        if (array.count > 0)
//        {
//            emojis = [[emojis arrayByAddingObjectsFromArray:array] copy];
//        }
//    }
    NSMutableArray *array = [NSMutableArray new];
    [array addObjectsFromArray:[EmojiEmoticons allEmoticons]];
    [array addObjectsFromArray:[EmojiMapSymbols allMapSymbols]];
//    [array addObjectsFromArray:[EmojiPictographs allPictographs]];
//    [array addObjectsFromArray:[EmojiTransport allTransport]];
    
    return array;
}
/**
 *  获取单页emoji数组
 *
 *  @param emojiArray  所有emoji
 *  @param singleCount 单页数量
 *  @param index       页码
 *
 *  @return
 */
+ (NSArray *)getEmojiEmotionsWithEmojiArray:(NSArray *)emojiArray singleCount:(NSInteger)singleCount index:(NSInteger)index
{
    NSRange range;
    
    //第一页
    if (index == 0)
    {
        range = NSMakeRange(0, singleCount);
        
        //不够一页
        if ((singleCount) > (emojiArray.count))
        {
            return emojiArray;
        }
        
        return [emojiArray subarrayWithRange:range];
    }
    //非首页
    else
    {
        range = NSMakeRange(index*singleCount, singleCount);
        
        //用下标比较，发现不足一页了，从指定位置截取到数组剩下的所有元素
        if ((index*singleCount+singleCount-1) > (emojiArray.count-1))
        {
            return [emojiArray subarrayWithRange:NSMakeRange(index*singleCount, emojiArray.count-index*singleCount)];
        }
        
        return [emojiArray subarrayWithRange:range];
    }
}
/**
 *  根据emoji类型获取对应的表情
 *
 *  @param type
 *
 *  @return
 */
+ (NSArray *)getEmojiEmotionsWithEmojiType:(ZEBEmojiType)type
{
    NSDictionary *allEmotionsDict = [ZEBEmotionsKeyboardViewModel getAllEmojiDict];
    NSArray *array = [NSArray array];
    
    switch (type) {
        case ZEBEmojiTypePeople:
        {
             array = [allEmotionsDict valueForKey:ZEBEmojiTypePeopleKey];
        }
            break;
        case ZEBEmojiTypeNature:
        {
           array = [allEmotionsDict valueForKey:ZEBEmojiTypeNatureKey];
        }
            break;
        case ZEBEmojiTypeObjects:
        {
            array = [allEmotionsDict valueForKey:ZEBEmojiTypeObjectsKey];
        }
            break;
        case ZEBEmojiTypePlaces:
        {
            array = [allEmotionsDict valueForKey:ZEBEmojiTypePlacesKey];
        }
            break;
        default:
            break;
    }
    
    return array;
}

#pragma mark - PNG

/**
 *  获取所有的png表情
 *
 *  @return png数组
 */
+ (NSArray *)getAllPngs
{
    NSMutableArray *pngs = [NSMutableArray new];
    
    return [pngs copy];
}



@end




/********************************* Emoji表情管理工具 ***********************************/

@implementation EmojiManager

+ (NSString *)emojiWithCode:(int)code
{
    int sym = EMOJI_CODE_TO_SYMBOL(code);
    return [[NSString alloc] initWithBytes:&sym length:sizeof(sym) encoding:NSUTF8StringEncoding];
}

/**
 *  获取iOS默认支持的所有emoji表情
 *
 *  @return
 */
+ (NSArray *)defaultAllEmoticons;
{
    NSMutableArray *array = [NSMutableArray new];
    
    for (int i=0x1F600; i<=0x1F64F; i++)
    {
        if (i < 0x1F641 || i > 0x1F644)
        {
            NSString *emoji = [EmojiManager emojiWithCode:i];
            [array addObject:emoji];
        }
    }
    
    return array;
}

@end














