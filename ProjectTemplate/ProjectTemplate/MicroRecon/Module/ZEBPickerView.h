//
//  CuiPickerView.h
//  CXB
//
//  Created by xutai on 16/4/15.
//  Copyright © 2016年 xutai. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol ZEBPickViewDelegate <NSObject>

-(void)didFinishPickView:(NSString*)date;
//-(void)pickerviewbuttonclick:(UIButton *)sender;


@end


@interface ZEBPickerView : UIView
@property (nonatomic, copy) NSString *province;
@property(nonatomic,strong)NSDate*curDate;
@property (nonatomic,strong)UIResponder *myResponder;
@property(nonatomic,strong)id<ZEBPickViewDelegate>delegate;
- (void)showInView:(UIView *)view;
- (void)hiddenPickerView;
@end

