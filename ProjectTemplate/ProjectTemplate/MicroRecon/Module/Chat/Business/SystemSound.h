//
//  SystemSound.h
//  ProjectTemplate
//
//  Created by caohanchao on 16/10/8.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SystemSound : NSObject

+ (nonnull instancetype)sharedManager;


- (void)start;

@end
