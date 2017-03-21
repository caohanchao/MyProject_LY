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
    s = [s transferredMeaningWithEnter];
   ZEBLog(@"返回结果:%@", s);
    
    NSData *data = [s dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                       options:NSJSONReadingMutableContainers error:nil];
    
    
    ICometModel *model;
    if ([self isCMD_1AndMTYPE_D:dict]) {
        model = [self requestDictionary:dict];
        return model;
    }

    //将JSON数据和Model的属性进行绑定
    model = [MTLJSONAdapter modelOfClass:[ICometModel class]
                                   fromJSONDictionary:dict
                                   error:nil];
    return model;
    
}

+ (BOOL)isCMD_1AndMTYPE_D:(NSDictionary *)dictionary{
    
    NSString *contentKey = @"content";
    NSString *messagekey = @"MSG";
    NSString *cmdKey = @"CMD";
    NSString *dataKey = @"DATA";
    NSString *mtypeKey = @"MTYPE";
    
    NSDictionary *contentDict = dictionary[contentKey];
    //content字典 包含 MSG 字段   &&  MSG字典 包含 DATA 字段
    if ([contentDict isEqual:@""]) {
        return NO;
    }
    
    if ([[contentDict allKeys] containsObject:messagekey] && [[contentDict[messagekey] allKeys] containsObject:dataKey] ) {
        if ([contentDict[messagekey][mtypeKey] isEqualToString:@"D"] && [contentDict[cmdKey] isEqualToString:@"1"]){
            return YES;
        }
        else {
            return NO;
        }
    }
    else {
        return NO;
    }
}

+ (ICometModel *)requestDictionary:(NSDictionary *)dictionary {
    NSString *contentKey = @"content";
    NSString *messagekey = @"MSG";
    NSString *cmdKey = @"CMD";
    NSString *dataKey = @"DATA";
    NSString *mtypeKey = @"MTYPE";
    
    NSDictionary *contentDict = dictionary[contentKey];
    
    if ([[contentDict allKeys] containsObject:messagekey] && [[contentDict[messagekey] allKeys] containsObject:dataKey] ) {
        if ([contentDict[messagekey][mtypeKey] isEqualToString:@"D"] && [contentDict[cmdKey] isEqualToString:@"1"]) {

            ICometModel *model = [ICometModel new];
            
            model.cname = dictionary[@"cname"];
            model.myType = dictionary[@"type"];
            model.seq = [dictionary[@"seq"] integerValue];
            
            model.sid = contentDict[@"SID"];
            model.rid = contentDict[@"RID"];
            model.qid = [contentDict[@"QID"] integerValue];
            model.cmd = contentDict[@"CMD"];
            model.msGid = contentDict[@"MSGID"];
            model.type = contentDict[@"TYPE"];
            model.atAlarm = contentDict[@"ATALARM"];
            model.headpic = contentDict[@"HEADPIC"];
            model.beginTime = contentDict[@"TIME"];
            model.sname = contentDict[@"SNAME"];
            model.cuid = contentDict[@"CUID"];
            

            if ([[contentDict allKeys] containsObject:@"GPS"] && [[contentDict[@"GPS"] allKeys] containsObject:@"W"]) {
                model.latitude = contentDict[@"GPS"][@"W"];
            }
            if ([[contentDict allKeys] containsObject:@"GPS"] && [[contentDict[@"GPS"] allKeys] containsObject:@"H"]) {
                model.longitude = contentDict[@"GPS"][@"H"];
            }
            
            if ([[contentDict[messagekey] allKeys] containsObject:@"FIRE"]) {
                model.FIRE = contentDict[messagekey][@"FIRE"];
            }
            if ([[contentDict[messagekey] allKeys] containsObject:@"DE_type"]) {
                model.DE_type = contentDict[messagekey][@"DE_type"];
            }
            if ([[contentDict[messagekey] allKeys] containsObject:@"MTYPE"]) {
                model.mtype = contentDict[messagekey][@"MTYPE"];
            }
            
            if ([[contentDict[messagekey] allKeys] containsObject:@"DE_name"]) {
                model.DE_name = contentDict[messagekey][@"DE_name"];
            }
            
            if ([[contentDict[messagekey] allKeys] containsObject:@"VIDEOPIC"]) {
                model.videopic = contentDict[messagekey][@"VIDEOPIC"];
            }
            if ([[contentDict[messagekey] allKeys] containsObject:@"VOICETIME"]) {
                model.voicetime = contentDict[messagekey][@"VOICETIME"];
            }
            
            if ([[contentDict[messagekey] allKeys] containsObject:@"SUSPECT_S_DATA"]) {
                model.suspectSDataModel = contentDict[messagekey][@"SUSPECT_S_DATA"];
            }
            if ([[contentDict[messagekey] allKeys] containsObject:@"TASK_N_DATA"]) {
                model.taskNDataModel = contentDict[messagekey][@"TASK_N_DATA"];
            }
            if ([[contentDict[messagekey] allKeys] containsObject:@"TASK_T_DATA"]) {
                model.taskTDataModel = contentDict[messagekey][@"TASK_T_DATA"];
            }
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:contentDict[messagekey][@"DATA"] options:NSJSONWritingPrettyPrinted error:nil];
            model.data = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            return model;
            
        }else {
            return nil;
        }
        
    }else {
        return nil;
    }
    
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
