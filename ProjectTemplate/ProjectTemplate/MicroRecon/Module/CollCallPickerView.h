//
//  CollCallPickerView.h
//  ProjectTemplate
//
//  Created by 李凯华 on 17/2/14.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CollCallPickerView;

@protocol CollCallPickerViewDelegate <NSObject>

-(void)didFinishPickView:(NSString*)date;
//-(void)pickerviewbuttonclick:(UIButton *)sender;


@end


@interface CollCallPickerView : UIView
@property (nonatomic, copy) NSString *province;
@property(nonatomic,strong)NSDate*curDate;
@property (nonatomic,strong)UIResponder *myResponder;
@property(nonatomic,weak)id<CollCallPickerViewDelegate>delegate;
- (void)showInView:(UIView *)view;
- (void)hiddenPickerView;
@end
