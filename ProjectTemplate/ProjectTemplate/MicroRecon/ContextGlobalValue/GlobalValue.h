//
//  GlobalValue.h
//  NewProject
//
//  Created by Jomper on 16/4/25.
//  Copyright © 2016年 Jomper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalValue : NSObject

+ (nonnull instancetype)sharedManager;

@property (nonnull,nonatomic,strong) NSString *amapKey;

@property (nonnull,nonatomic,strong) NSString *apiDomain;

@end
