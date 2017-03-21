//
//  NSString+Time.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/14.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "NSString+Time.h"
#import "NSDate+Extensions.h"

@implementation NSString (Time)

- (NSString *)timeChangeHHmm {
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *someDay = [formatter dateFromString:self];
    
    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    
    [outputFormatter setLocale:[NSLocale currentLocale]];
    
    [outputFormatter setDateFormat:@"HH:mm"];
    
    NSString *str= [outputFormatter stringFromDate:someDay];
    return str;
}
- (NSString *)rollCallDetailTimeChangeHHmm {
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *someDay = [formatter dateFromString:self];
    
    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    
    [outputFormatter setLocale:[NSLocale currentLocale]];
    
    [outputFormatter setDateFormat:@"HH:mm"];
    
    NSString *str= [outputFormatter stringFromDate:someDay];
    return str;
}
- (NSString *)timeChangeYMdHHmm {
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *someDay = [formatter dateFromString:self];
    
    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    
    [outputFormatter setLocale:[NSLocale currentLocale]];
    
    [outputFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *str= [outputFormatter stringFromDate:someDay];
    return str;
}
- (NSString *)VdtimeChange {
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *someDay = [formatter dateFromString:self];
    
    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    
    [outputFormatter setLocale:[NSLocale currentLocale]];
    
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *str= [outputFormatter stringFromDate:someDay];
    return str;
}
- (NSString *)timeChaneTodayOrYesterdayOrOther {

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *someDay = [formatter dateFromString:self];
    
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyyMMdd"];
    
    NSString *currentDay = [formatter1 stringFromDate:[NSDate date]];//当前年月日
    NSString *theDay = [formatter1 stringFromDate:someDay];
    
    if ([currentDay integerValue] - [theDay integerValue] == 0) {//当天
     return @"今天";
    }else if ([currentDay integerValue] - [theDay integerValue] == 1) {//昨天
    return @"昨天";
    }
    
    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    
    [outputFormatter setLocale:[NSLocale currentLocale]];
    
    [outputFormatter setDateFormat:@"dd日"];
    
    NSString *str= [outputFormatter stringFromDate:someDay];
    
    return str;
}
- (NSString *)timeChaneForWorkList {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *someDay = [formatter dateFromString:self];
    
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyyMMdd"];
    
    NSString *currentDay = [formatter1 stringFromDate:[NSDate date]];//当前年月日
    NSString *theDay = [formatter1 stringFromDate:someDay];
    
    
    NSDateFormatter *outputFormatterToday= [[NSDateFormatter alloc] init];
    
    [outputFormatterToday setLocale:[NSLocale currentLocale]];
    
    [outputFormatterToday setDateFormat:@"HH:mm"];
    
    if ([currentDay integerValue] - [theDay integerValue] == 0) {//当天
        return [outputFormatterToday stringFromDate:someDay];
    }else if ([currentDay integerValue] - [theDay integerValue] == 1) {//昨天
        return [NSString stringWithFormat:@"昨天 %@",[outputFormatterToday stringFromDate:someDay]];
    }
    
    NSDateFormatter *outputFormatter= [[NSDateFormatter alloc] init];
    
    [outputFormatter setLocale:[NSLocale currentLocale]];
    
    [outputFormatter setDateFormat:@"MM-dd HH:mm"];
    
    NSString *str= [outputFormatter stringFromDate:someDay];
    
    return str;
}
-(NSString *)getMMSSFromSS {
    
    NSInteger seconds = [self integerValue];
    
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%ld",seconds/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@分钟%@秒",str_minute,str_second];
    
    NSLog(@"format_time : %@",format_time);
    
    return format_time;
    
}


-(NSString *)timeChage {
    
    NSString *str = [self substringWithRange:NSMakeRange(10, 3)];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 如果是真机调试，转换这种欧美时间，需要设置locale
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [fmt setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *createDate=[formatter dateFromString:self];
    // 当前时间
    NSDate *now = [NSDate date];
    // 日历对象（方便比较两个日期之间的差距）
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // NSCalendarUnit枚举代表想获得哪些差值
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 计算两个日期之间的差值
    // NSDateComponents *cmps = [calendar components:unit fromDate:createDate toDate:now options:0];
    if ([createDate isThisYear]) {
        if ([createDate isYesterday]) {
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:createDate];
        }else if ([createDate isToday]){
            if ([str intValue]>=12) {
                fmt.dateFormat=@"下午 HH:mm";
                NSString *timeStr=[fmt stringFromDate:createDate];
                return timeStr;
            }else{
                fmt.dateFormat=@"上午 HH:mm";
                NSString *timeStr=[fmt stringFromDate:createDate];
                return timeStr;
            }
        }else{
            
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:createDate];
        }
    }else{
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:createDate];
    }
}


-(NSString *)AnnoationtimeChage {
    
    NSString *str = [self substringWithRange:NSMakeRange(10, 3)];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 如果是真机调试，转换这种欧美时间，需要设置locale
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [fmt setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *createDate=[formatter dateFromString:self];
    // 当前时间
    NSDate *now = [NSDate date];
    // 日历对象（方便比较两个日期之间的差距）
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // NSCalendarUnit枚举代表想获得哪些差值
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 计算两个日期之间的差值
    // NSDateComponents *cmps = [calendar components:unit fromDate:createDate toDate:now options:0];
    if ([createDate isThisYear]) {
        if ([createDate isYesterday]) {
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:createDate];
        }else if ([createDate isToday]){
            if ([str intValue]>=12) {
                fmt.dateFormat=@"下午 HH:mm";
                NSString *timeStr=[fmt stringFromDate:createDate];
                return timeStr;
            }else{
                fmt.dateFormat=@"上午 HH:mm";
                NSString *timeStr=[fmt stringFromDate:createDate];
                return timeStr;
            }
        }else{
            
            fmt.dateFormat = @"MM月dd日 HH:mm";
            return [fmt stringFromDate:createDate];
        }
    }else{
        fmt.dateFormat = @"yyyy年MM月dd日 HH:mm";
        return [fmt stringFromDate:createDate];
    }
}


@end
