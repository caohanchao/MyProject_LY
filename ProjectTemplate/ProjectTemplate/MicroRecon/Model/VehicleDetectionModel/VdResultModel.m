//
//  VdResultModel.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/2.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "VdResultModel.h"

@implementation VdResultModel




+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    

    return @{
             @"hpzl" : @"hpzl",
             @"sbxx"        : @"sbxx",
             @"jgsj"        : @"jgsj",
             @"cllx"        : @"cllx",
             @"gctx"        : @"gctx",
             @"cdbh"        : @"cdbh",
             @"hpys"        : @"hpys",
             @"hphm"        : @"hphm",
             @"csys"        : @"csys",
             @"kkbh"        : @"kkbh",
             @"xsfx"        : @"xsfx",
             @"clsd"        : @"clsd",
             @"sbbh"        : @"sbbh",
             @"xszt"        : @"xszt",
             @"clxxbh"        : @"clxxbh"
             };
    

}

+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    
    if ([key isEqualToString:@"sbxx"]) {
        return [MTLJSONAdapter arrayTransformerWithModelClass:SBXXModel.class];
    }
    return nil;
}


@end

@implementation SBXXModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {

    return @{
             @"latitude" : @"latitude",
             @"longitude"        : @"longitude",
             @"kkbh"        : @"kkbh",
             @"deviceName"        : @"deviceName",
             @"lkxx"        : @"lkxx"
             };
};



+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    
    if ([key isEqualToString:@"lkxx"]) {
        return [MTLJSONAdapter arrayTransformerWithModelClass:LKXXModel.class];
    }
    return nil;
}

@end


@implementation LKXXModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {

    return @{
             @"kkwd" : @"kkwd",
             @"kkjd"        : @"kkjd",
             @"kkmc"        : @"kkmc"
             
             };
};


@end

