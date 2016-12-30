//
//  OnlineAPIKey.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/20.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#ifndef OnlineAPIKey_h
#define OnlineAPIKey_h
/* 使用高德API，请注册Key，注册地址：http://lbs.amap.com/console/key
 */
const static NSString *APIKey = @"ffdadcb74c7f15822381f4942ac0744b";
const static NSString *WebAPIKey = @"bd2e6bcf8479ed6598c063ea9710c939";
const static NSString *TableID = @"";

#ifdef DEBUG// bugtags KEY
const static NSString *BugtagsKey = @"76cd35b9982c8f83e2bd9acec94b9539";
#else
const static NSString *BugtagsKey = @"c03d9b37a574595e52b09be53121af18";
#endif


#endif /* OnlineAPIKey_h */
