//
//  NSString+Time.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/14.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Time)

- (NSString *)timeChangeHHmm;
- (NSString *)rollCallDetailTimeChangeHHmm;
- (NSString *)timeChaneTodayOrYesterdayOrOther;
- (NSString *)timeChaneForWorkList;
-(NSString *)getMMSSFromSS;
-(NSString *)timeChage;
-(NSString *)AnnoationtimeChage;
- (NSString *)VdtimeChange;
- (NSString *)timeChangeYMdHHmm;
@end
