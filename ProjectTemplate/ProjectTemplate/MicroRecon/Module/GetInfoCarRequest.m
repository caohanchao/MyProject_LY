//
//  GetInfoCarRequest.m
//  ProjectTemplate
//
//  Created by caohanchao on 2016/12/5.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "GetInfoCarRequest.h"


@implementation GetInfoCarRequest

+ (nonnull NSString *)removeSpaceAndNewline:(nonnull NSString *)str
{
    NSString *temp = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    temp = [temp stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return temp;
}


+ (void)getCarIntoWithDict:(nonnull NSDictionary *)info success:(nonnull void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(nonnull void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock {
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    NSString *toTime = info[@"toTime"];
    NSString *formTime = info[@"formTime"];
    NSString *carNumber = [self removeSpaceAndNewline:info[@"carNumber"]];
    
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    toTime = [NSString stringWithFormat:@"%@:00",toTime];
    formTime = [NSString stringWithFormat:@"%@:00",formTime];
    
    NSString *url = [NSString stringWithFormat:GetInfoCarUrl,carNumber,formTime,toTime,alarm];
  //  url = @"http://113.57.174.98:13201/fire/getcarinfo?hphm=鄂ARQ150&totime=2017-03-04 14:00:36&fromtime=2017-03-03 00:00:00&alarm=021336";
//    NSString *url =  http://220.249.118.115:13201/fire/getcarinfo?hphm=鄂A73NP3&fromtime=2016-11-29 17:37:00&totime=2016-12-06 17:37:00
    
    
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    
    NSDictionary *param = [[NSDictionary alloc] init];
    
    [[HttpsManager sharedManager] cancelAllOperations];
    
    [[HttpsManager sharedManager] get:url parameters:param progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable response) {
        successBlock(task,response);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(task,error);
    }];

}

+ (nonnull NSArray *)configurationCellWithModel:(nonnull VdResultModel *)model {
    
    LKXXModel *lkxxModel = [[[model.sbxx firstObject] lkxx] firstObject];
    NSString *kkbh = [[LZXHelper isNullToString:lkxxModel.kkmc] isEqualToString:@""] ? @"未知" : [LZXHelper isNullToString:lkxxModel.kkmc];
    NSString *sbbh = [[LZXHelper isNullToString:model.cdbh] isEqualToString:@""] ? @"未知" : [LZXHelper isNullToString:model.cdbh];
    NSString *xsfx = [[LZXHelper isNullToString:model.hpys] isEqualToString:@""] ? @"未知" : [LZXHelper isNullToString:model.hpys];
    NSString *clsd = [[LZXHelper isNullToString:model.csys] isEqualToString:@""] ? @"未知" : [LZXHelper isNullToString:model.csys];
    NSString *xszt = [[LZXHelper isNullToString:model.cllx] isEqualToString:@""] ? @"未知" : [LZXHelper isNullToString:model.cllx];
    NSString *cdbh = [[LZXHelper isNullToString:model.xszt] isEqualToString:@""] ? @"未知" : [LZXHelper isNullToString:model.xszt];
    
    return  @[kkbh,sbbh,xsfx,clsd,xszt,cdbh];
    
}

+ (nonnull NSString *)cutTimeForHourMinment:(nonnull NSString *)time  {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [dateFormatter dateFromString:time];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:timeDate];
    
    NSString *year = [NSString stringWithFormat:@"%ld",(long)[comps year]];
    NSString *month = [NSString stringWithFormat:@"%ld",(long)[comps month]];
    NSString *day = [NSString stringWithFormat:@"%ld",(long)[comps day]];
    
    return [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    
}
//比较两个日期的大小  日期格式为2016-08-14 08：46
+ (NSInteger)compareDate:(nonnull NSString*)aDate withDate:(nonnull NSString*)bDate {
    NSInteger aa;
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *dta = [[NSDate alloc] init];
    NSDate *dtb = [[NSDate alloc] init];
    
    dta = [dateformater dateFromString:aDate];
    dtb = [dateformater dateFromString:bDate];
    NSComparisonResult result = [dta compare:dtb];
    if (result == NSOrderedSame)
    {
        //        相等  aa=0
        aa = 0;
    }else if (result == NSOrderedAscending)
    {
        //bDate比aDate大
        aa=1;
    }else if (result == NSOrderedDescending)
    {
        //bDate比aDate小
        aa=-1;
        
    }
    
    return aa;
}

+ (BOOL)isInOneWeekCompareWithStartTime:(nonnull NSString *)startTime WithEndTime:(nonnull NSString *)endTime Formatter:(NSDateFormatter *)formatter {
    
    //后来的时间
    NSDate *endDate = [formatter dateFromString:endTime];
    //之前的时间
    NSDate *startDate =[formatter dateFromString:startTime];
    
    NSTimeInterval timeInterval = [endDate timeIntervalSinceDate:startDate];
    
//    long long sec = [[NSNumber numberWithDouble:timeInterval] longLongValue];
    
    double week = timeInterval/60/60/24/7;
    
    if (week > 1 || week < -1)
    {
        return YES;
    }
    else
    {
        return NO;
    }

    
}
@end
