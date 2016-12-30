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
    
    NSString *toTime = info[@"toTime"];
    NSString *formTime = info[@"formTime"];
    NSString *carNumber = [self removeSpaceAndNewline:info[@"carNumber"]];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    toTime = [NSString stringWithFormat:@"%@:00",toTime];
    formTime = [NSString stringWithFormat:@"%@:00",formTime];
    
    NSString *url = [NSString stringWithFormat:GetInfoCarUrl,carNumber,toTime,formTime];
    
//    NSString *url =  @"http://220.249.118.115:13201/fire/getcarinfo?hphm=鄂AHN580&totime=2016-11-30 14:00:36&fromtime=2016-11-30 00:00:00";
    
    
    
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
    
    NSString *kkbh = model.kkbh;
    NSString *sbbh = model.sbbh;
    NSString *xsfx = model.xsfx;
    NSString *clsd = model.clsd;
    NSString *xszt = model.xszt;
    NSString *cdbh = model.cdbh;
    
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
