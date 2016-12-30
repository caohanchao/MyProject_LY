//
//  ICometModel.m
//  ProjectTemplate
//
//  Created by 郑胜 on 16/7/16.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "ICometModel.h"
#import "NSDate+Extensions.h"

@implementation ICometModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"sid"       : @"content.SID",
             @"rid"       : @"content.RID",
             @"qid"       : @"content.QID",
             @"cmd"       : @"content.CMD",
             @"msGid"     : @"content.MSGID",
             @"type"      : @"content.TYPE",
             @"atAlarm"   : @"content.ATALARM",
             @"headpic"   : @"content.HEADPIC",
             @"beginTime" : @"content.TIME",
             @"sname"     : @"content.SNAME",
             @"cname"     : @"cname",
             @"myType"    : @"type",
             @"seq"       : @"seq",
             @"FIRE"       : @"content.MSG.FIRE",
             @"latitude"  : @"content.GPS.W",
             @"longitude" : @"content.GPS.H",
             @"data"      : @"content.MSG.DATA",
             @"mtype"     : @"content.MSG.MTYPE",
             @"DE_type"   : @"content.MSG.DE_type",
             @"DE_name"   : @"content.MSG.DE_name",
             @"videopic"  : @"content.MSG.VIDEOPIC",
             @"voicetime" : @"content.MSG.VOICETIME",
             @"cuid"      : @"content.CUID",
             @"suspectSDataModel" : @"content.MSG.SUSPECT_S_DATA",
             @"taskNDataModel" : @"content.MSG.TASK_N_DATA",
             @"taskTDataModel" : @"content.MSG.TASK_T_DATA"
    };
}

+ (instancetype)iCometModelWithBytes:(const void *)cst length:(NSUInteger)length {
    NSString* s = [[NSString alloc] initWithBytes:cst length:length encoding:NSUTF8StringEncoding];
   
    if (!s) {
        return nil;
    }
    //查找全部匹配的，并替换
    s = [s stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
    s = [s stringByReplacingOccurrencesOfString:@"\"{" withString:@"{"];
    s = [s stringByReplacingOccurrencesOfString:@"}\"" withString:@"}"];
    s = [s stringByReplacingOccurrencesOfString:@"\\\\/" withString:@"/"];

   ZEBLog(@"返回结果:%@", s);
    
    NSData *data = [s dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                       options:NSJSONReadingMutableContainers error:nil];
    

    //将JSON数据和Model的属性进行绑定
    ICometModel *model = [MTLJSONAdapter modelOfClass:[ICometModel class]
                                   fromJSONDictionary:dict
                                                error:nil];

    return model;
    
}


- (BOOL) isUpdateOnChatList:(nonnull ICometModel *) model {
    if ([@"G" isEqualToString:model.type]) {
        return [self.rid isEqualToString:model.rid];
    }
    
    return ([self.sid isEqualToString:model.sid]
            && [self.rid isEqualToString:model.rid])
            || ([self.sid isEqualToString:model.rid]
                && [self.rid isEqualToString:model.sid]);
}



//-(NSString *)time{
//    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
//    // 如果是真机调试，转换这种欧美时间，需要设置locale
//    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
//    
//    // 设置日期格式（声明字符串里面每个数字和单词的含义）
//    // E:星期几
//    // M:月份
//    // d:几号(这个月的第几天)
//    // H:24小时制的小时
//    // m:分钟
//    // s:秒
//    // y:年
//    [fmt setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
//    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//    NSDate *createDate=[formatter dateFromString:_time];
//    
////    NSDate *createDate=[NSDate dateWithTimeIntervalSince1970:[date timeIntervalSince1970]];
//    
//    // 当前时间
//    NSDate *now = [NSDate date];
//    
//    // 日历对象（方便比较两个日期之间的差距）
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    // NSCalendarUnit枚举代表想获得哪些差值
//    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
//    // 计算两个日期之间的差值
//    NSDateComponents *cmps = [calendar components:unit fromDate:createDate toDate:now options:0];
//    
//    if ([createDate isThisYear]) {
//        if ([createDate isYesterday]) {
//            fmt.dateFormat = @"MM-dd HH:mm";
//            return [fmt stringFromDate:createDate];
//        }else if ([createDate isToday]){
//        
//            fmt.dateFormat = @"MM-dd HH:mm";
//            return [fmt stringFromDate:createDate];
//        }else{
//        
//            fmt.dateFormat = @"MM-dd HH:mm";
//            return [fmt stringFromDate:createDate];
//
//        }
//    }else{
//    
//        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
//        return [fmt stringFromDate:createDate];
//
//    }
//    
//}
//

@end
