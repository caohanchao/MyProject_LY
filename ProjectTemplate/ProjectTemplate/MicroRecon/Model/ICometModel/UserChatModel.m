//
//  UserChatModel.m
//  ProjectTemplate
//
//  Created by 绿之云 on 16/9/7.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "UserChatModel.h"



@implementation UserChatModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"resultcode"    : @"resultcode",
             @"resultmessage" : @"resultmessage",
             @"results"        : @"response"
             };
}

+ (NSValueTransformer *)resultsJSONTransformer {
    
    return [MTLJSONAdapter arrayTransformerWithModelClass:chatModel.class];
    
}

+ (nonnull instancetype) UserChatWithData:(nonnull NSData *)data {
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingMutableContainers error:nil];
    
    NSLog(@"%@",dict);
    //将JSON数据和Model的属性进行绑定
    UserChatModel *model = [MTLJSONAdapter modelOfClass:[UserChatModel class]
                                          fromJSONDictionary:dict
                                                       error:nil];
    
    return model;
}

@end

@implementation chatModel

+(NSDictionary *)JSONKeyPathsByPropertyKey{

    return @{
             @"SID"     :@"SID",
             @"RID"     :@"RID",
             @"HEADPIC"     :@"HEADPIC",
             @"TYPE"        :@"TYPE",
             @"CMD"     :@"CMD",
             @"ATALARM" :@"ATALARM",
             @"MSGID"       :@"MSGID",
             @"beginTime"        :@"TIME",
             @"SNAME"       :@"SNAME",
             @"GPS"       :@"GPS",
             @"QID"       :@"QID",
             @"MSG"        :@"MSG",
//             @"FIRE"        :@"FIRE"
             };


}

@end

@implementation  GPSModel


+(NSDictionary *)JSONKeyPathsByPropertyKey{
    
    return @{
             @"H"     :@"H",
             @"W"     :@"W"
             };
    
    
}

+(NSValueTransformer *)JSONTransformerForKey:(NSString *)key {

   
    return nil;
}

@end

@implementation  MSGModel


+(NSDictionary *)JSONKeyPathsByPropertyKey{
    
    return @{
             @"DATA"     :@"DATA",
             @"VIDEOPIC"     :@"VIDEOPIC",
             @"MTYPE"     :@"MTYPE",
             @"FIRE"        :@"FIRE",
             @"VOICETIME"     :@"VOICETIME",
             @"suspectSDataModel" :@"SUSPECT_S_DATA",
             @"taskNDataModel" :@"TASK_N_DATA",
             @"taskTDataModel" :@"TASK_T_DATA",
             @"taskFDataModel" :@"TASK_F_DATA"
             };
    
    
}



@end
