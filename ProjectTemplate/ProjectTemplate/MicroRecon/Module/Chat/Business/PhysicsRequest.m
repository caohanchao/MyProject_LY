//
//  PhysicsRequest.m
//  ProjectTemplate
//
//  Created by caohanchao on 2016/12/20.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "PhysicsRequest.h"

@implementation PhysicsRequest

//+ (void)postPhysicsWithAlarm:(nonnull NSString *)alarm WithGid:(nonnull NSString *)gid WithWorkID:(NSString *)workId success:(nonnull void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(nonnull void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock {
//    
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    param[@"action"] = @"gettrail";
//    param[@"alarm"] = alarm;
//    param[@"gid"] = gid;
//    param[@"token"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
//    param[@"task_id"] = workId;
//    
//    [[HttpsManager sharedManager] post:GetTrail_URL parameters:param progress:^(NSProgress * _Nonnull progress) {
//        
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
//        successBlock(task,reponse);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failureBlock(task,error);
//    }];
//
//}

+ (void)postUploadPhysicsWithParam:(nonnull NSDictionary *)param success:(nonnull void(^)(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse))successBlock failure:(nonnull void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureBlock {
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"action"]     = @"saveroute";
    dict[@"alarm"]      = param[@"alarm"];
    dict[@"gid"]        = param[@"gid"];
    dict[@"token"]      = param[@"token"];
    dict[@"task_id"]    = param[@"task_id"];
    dict[@"end_posi"]   = param[@"end_posi"];
    dict[@"start_posi"] = param[@"start_posi"];
    dict[@"route_title"] = param[@"route_title"];
    dict[@"type"]       = param[@"type"];                 //type: 0走线   1走访   2追踪
    dict[@"start_time"] = param[@"start_time"];
    dict[@"end_time"]   = param[@"end_time"];
    dict[@"describetion"] = param[@"describetion"];
    dict[@"end_latitude"] = param[@"end_latitude"];
    dict[@"end_longitude"] = param[@"end_longitude"];
    dict[@"start_latitude"] = param[@"start_latitude"];
    dict[@"start_longitude"] = param[@"start_longitude"];
    dict[@"location_list"] = param[@"location_list"];  //点位json
    
    
//    ["{
//     "type" : "1",
//     "angle" : "0.0",
//     "longitude" : "114.24596951",
//     "latitude" : "30.59893772",
//     "time" : "2016-12-22 02:24:10"
//     }","{
//         "type" : "0",
//         "angle" : "0.0",
//         "longitude" : "114.24602865",
//         "latitude" : "30.59894775",
//         "time" : "2016-12-22 02:24:13"
//     }","{
//         "type" : "0",
//         "angle" : "0.0",
//         "longitude" : "114.24599826",
//         "latitude" : "30.59897732",
//         "time" : "2016-12-22 02:24:19"
//     }","{
//         "type" : "0",
//         "angle" : "0.0",
//         "longitude" : "114.24597412",
//         "latitude" : "30.59901123",
//         "time" : "2016-12-22 02:24:25"
//     }","{
//         "type" : "0",
//         "angle" : "0.0",
//         "longitude" : "114.24599311",
//         "latitude" : "30.59898275",
//         "time" : "2016-12-22 02:24:31"
//     }","{
//         "type" : "2",
//         "angle" : "0.0",
//         "longitude" : "114.24599311",
//         "latitude" : "30.59898275",
//         "time" : "2016-12-22 02:24:35"
//     }"]

    [[HttpsManager sharedManager] post:SaveRoute_URL parameters:dict progress:^(NSProgress * _Nonnull progress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
        successBlock(task,reponse);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(task,error);
    }];
}

@end
