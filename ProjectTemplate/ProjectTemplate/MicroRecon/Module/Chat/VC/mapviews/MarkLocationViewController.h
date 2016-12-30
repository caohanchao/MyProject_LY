//
//  MarkLocationViewController.h
//  ProjectTemplate
//
//  Created by caohanchao on 16/10/26.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "XMLocationController.h"

typedef void (^LocationBlock)(NSMutableDictionary *param);

@interface MarkLocationViewController : XMLocationController

@property(nonatomic,copy)LocationBlock locationBlock;

@end
