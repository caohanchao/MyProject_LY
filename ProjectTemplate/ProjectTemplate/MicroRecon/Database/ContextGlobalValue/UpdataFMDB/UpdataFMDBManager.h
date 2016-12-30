//
//  UpdataFMDBManager.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/11/7.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdataFMDBManager : NSObject

+(UpdataFMDBManager*) sharedInstance;
- (void)updataFMDB;
@end
