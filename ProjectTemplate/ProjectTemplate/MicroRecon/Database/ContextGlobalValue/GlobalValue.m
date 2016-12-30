//
//  GlobalValue.m
//  NewProject
//
//  Created by Jomper on 16/4/25.
//  Copyright © 2016年 Jomper. All rights reserved.
//

#import "GlobalValue.h"

@implementation GlobalValue

+ (nonnull instancetype)sharedManager
{
    static GlobalValue *sharedData = nil;    
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        sharedData = [self new];
    });
    return sharedData;
}

@end
