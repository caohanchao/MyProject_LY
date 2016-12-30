//
//  NSDate+Time.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/29.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <Foundation/Foundation.h>


#define D_MINUTE	60
#define D_HOUR		3600
#define D_DAY		86400
#define D_WEEK		604800
#define D_YEAR		31556926

@interface NSDate (Time)
/*标准时间日期描述*/
-(NSString *)formattedTime;
@end
