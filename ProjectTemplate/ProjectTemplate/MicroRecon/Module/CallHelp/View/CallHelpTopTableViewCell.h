//
//  CallHelpTopTableViewCell.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/26.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallHelpTopTableViewCell : UITableViewCell


//@property (nonatomic, weak) UIImage *image;

@property (strong, nonatomic) NSArray *userArr;

@property (assign, nonatomic) NSInteger row;
@property (nonatomic, copy) void(^userImageBlock)();
@end
