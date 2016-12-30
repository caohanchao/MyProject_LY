//
//  DeviceSystemVersion.h
//  ProjectTemplate
//
//  Created by caohanchao on 16/9/29.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#ifndef DeviceSystemVersion_h
#define DeviceSystemVersion_h




#define IOS8 ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 9.0)

#define IOS9  ([[[UIDevice currentDevice] systemVersion] floatValue] > 8.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 10.0)

#define IOS8_10 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 && [[UIDevice currentDevice].systemVersion doubleValue] < 10.0

#define IOS10 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)


#endif /* DeviceSystemVersion_h */
