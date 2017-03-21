//
//  LKHTimePickerView.m
//  ProjectTemplate
//
//  Created by 李凯华 on 17/2/14.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "LKHTimePickerView.h"
#define screenWith  [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

@interface LKHTimePickerView()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSInteger yearRange;
    NSInteger dayRange;
    NSInteger startYear;
    NSInteger selectedYear;
    NSInteger selectedMonth;
    NSInteger selectedDay;
    NSInteger selectedHour;
    NSInteger selectedMinute;
    NSInteger selectedSecond;
    NSCalendar *calendar;
    
    
    //左边退出按钮
    UIButton *cancelButton;
    //右边的确定按钮
    UIButton *chooseButton;
    
}

@property (nonatomic, copy) NSArray *provinces;//请假类型
@property (nonatomic, copy) NSArray *selectedArray;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic,strong) NSString *string;
@end

@implementation LKHTimePickerView

- (id)init {
    if (self = [super init]) {
        // self.bounds = CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, 200);
        // self.pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, 180)];
        self.pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, 180)];
        self.pickerView.backgroundColor = [UIColor clearColor]
        ;
        self.pickerView.dataSource=self;
        self.pickerView.delegate=self;
        [self addSubview:self.pickerView];
        //盛放按钮的View
        UIView *upVeiw = [[UIView alloc]initWithFrame:CGRectMake(-2, 0, [UIScreen mainScreen].bounds.size.width+4, 40)];
        upVeiw.backgroundColor = [UIColor whiteColor];
        [self addSubview:upVeiw];
        
        UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 39.5,[UIScreen mainScreen].bounds.size.width , 0.5)];
        lineLabel.backgroundColor = [UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1.0f];
        [upVeiw addSubview:lineLabel];
        
        //左边的取消按钮
        cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(12, 0, 40, 40);
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        cancelButton.backgroundColor = [UIColor clearColor];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [cancelButton setTitleColor:CHCHexColor(@"007EFF") forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(hiddenPickerView) forControlEvents:UIControlEventTouchUpInside];
        [upVeiw addSubview:cancelButton];
        
        //右边的确定按钮
        chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        chooseButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 50, 0, 40, 40);
        [chooseButton setTitle:@"确定" forState:UIControlStateNormal];
        chooseButton.backgroundColor = [UIColor clearColor];
        chooseButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [chooseButton setTitleColor:CHCHexColor(@"007EFF") forState:UIControlStateNormal];
        [chooseButton addTarget:self action:@selector(hiddenPickerViewRight) forControlEvents:UIControlEventTouchUpInside];
        [upVeiw addSubview:chooseButton];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.5)];
        line.backgroundColor = [UIColor colorWithRed:234/255.0f green:234/255.0f blue:234/255.0f alpha:1.0f];
        [upVeiw addSubview:line];
        
        
        NSCalendar *calendar0 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        // NSInteger unitFlags =  NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
        NSInteger unitFlags =  NSHourCalendarUnit | NSMinuteCalendarUnit;
        comps = [calendar0 components:unitFlags fromDate:[NSDate date]];
        NSInteger year=[comps year];
        
//        startYear=year-15;
//        yearRange=30;
//        selectedYear=2000;
//        selectedMonth=1;
//        selectedDay=1;
//        selectedHour=0;
//        selectedMinute=0;
    //    dayRange=[self isAllDay:startYear andMonth:1];
        //        startYear=year-15;
        //        yearRange=30;
        //        selectedYear=2000;
        //        selectedMonth=1;
        //        selectedDay=1;
        //        selectedHour=0;
        //        selectedMinute=0;
        [self hiddenPickerView];
    }
    return self;
}

#pragma mark --
#pragma mark -- UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}


//确定每一列返回的东西
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
//        case 0:
//        {
//            return yearRange;
//        }
//            break;
//        case 1:
//        {
//            return 12;
//        }
//            break;
//        case 2:
//        {
//            return dayRange;
//        }
//            break;
        case 0:
        {
            return 24;
        }
            break;
        case 1:
        {
            return 60;
        }
            break;
            
        default:
            break;
    }
    return 0;
}

#pragma mark -- UIPickerViewDelegate
//默认时间的处理
-(void)setCurDate:(NSDate *)curDate
{
    //获取当前时间
    NSCalendar *calendar0 = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
 //   NSInteger unitFlags =  NSHourCalendarUnit | NSMinuteCalendarUnit;
    comps = [calendar0 components:unitFlags fromDate:curDate];
//    NSInteger year=[comps year];
//    NSInteger month=[comps month];
//    NSInteger day=[comps day];
    NSInteger hour=[comps hour];
    NSInteger minute=[comps minute];
    
//    selectedYear=year;
//    selectedMonth=month;
//    selectedDay=day;
    selectedHour=hour;
    selectedMinute=minute;
    
 //   dayRange=[self isAllDay:year andMonth:month];
    
//    [self.pickerView selectRow:year-startYear inComponent:0 animated:true];
//    [self.pickerView selectRow:month-1 inComponent:1 animated:true];
//    [self.pickerView selectRow:day-1 inComponent:2 animated:true];
    [self.pickerView selectRow:hour inComponent:0 animated:true];
    [self.pickerView selectRow:minute inComponent:1 animated:true];
    
    [self.pickerView reloadAllComponents];
}


-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake(screenWith*component/6.0, 0,screenWith/6.0, 30)];
    label.font=[UIFont systemFontOfSize:15.0];
    label.tag=component*100+row;
    label.textAlignment=NSTextAlignmentCenter;
    switch (component) {
//        case 0:
//        {
//            label.frame=CGRectMake(5, 0,screenWith/4.0, 30);
//            label.text=[NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
//        }
//            break;
//        case 1:
//        {
//            label.frame=CGRectMake(screenWith/4.0, 0, screenWith/8.0, 30);
//            label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
//        }
//            break;
//        case 2:
//        {
//            label.frame=CGRectMake(screenWith*3/8, 0, screenWith/8.0, 30);
//            label.text=[NSString stringWithFormat:@"%ld日",(long)row+1];
//        }
//            break;
        case 0:
        {
            label.textAlignment=NSTextAlignmentRight;
            label.text=[NSString stringWithFormat:@"%ld时",(long)row];
        }
            break;
        case 1:
        {
            label.textAlignment=NSTextAlignmentRight;
            label.text=[NSString stringWithFormat:@"%ld分",(long)row];
        }
            break;
//        case 2:
//        {
//            label.textAlignment=NSTextAlignmentRight;
//            label.frame=CGRectMake(screenWith*component/6.0, 0, screenWith/6.0-5, 30);
//            label.text=[NSString stringWithFormat:@"%ld秒",(long)row];
//        }
//            break;
            
        default:
            break;
    }
    return label;
}

// 监听picker的滑动
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
//        case 0:
//        {
//            selectedYear=startYear + row;
//            dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
//            [self.pickerView reloadComponent:2];
//        }
//            break;
//        case 1:
//        {
//            selectedMonth=row+1;
//            dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
//            [self.pickerView reloadComponent:2];
//        }
//            break;
//        case 2:
//        {
//            selectedDay=row+1;
//        }
//            break;
        case 0:
        {
            selectedHour=row;
        }
            break;
        case 1:
        {
            selectedMinute=row;
        }
            break;
            
        default:
            break;
    }
    
//    _string =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld:%.2ld",selectedYear,selectedMonth,selectedDay,selectedHour,selectedMinute];
      _string =[NSString stringWithFormat:@"%.2ld:%.2ld",selectedHour,selectedMinute];
}



#pragma mark -- show and hidden
- (void)showInView:(UIView *)view {
    
    [UIView animateWithDuration:0.25f animations:^{
        self.frame = CGRectMake(0, view.frame.size.height-200, view.frame.size.width, 200);
        // self.backgroundColor = [UIColor redColor];
    } completion:^(BOOL finished) {
        //self.frame = CGRectMake(0, view.frame.size.height-200, view.frame.size.width, 200);
    }];
}


//隐藏View
//取消的隐藏
- (void)hiddenPickerView
{
    [UIView animateWithDuration:0.25f animations:^{
        self.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        // self.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }];
    
    [self.myResponder resignFirstResponder];
}

//确认的隐藏
-(void)hiddenPickerViewRight
{
    [UIView animateWithDuration:0.25f animations:^{
        self.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        // self.frame = CGRectMake(0, self.frame.origin.y + self.frame.size.height, self.frame.size.width, self.frame.size.height);
    }];
    if ([self.delegate respondsToSelector:@selector(didFinishPickView:)]) {
        
//        _string =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld:%.2ld",selectedYear,selectedMonth,selectedDay,selectedHour,selectedMinute];
        _string =[NSString stringWithFormat:@"%.2ld:%.2ld",selectedHour,selectedMinute];
        [self.delegate timeDidFinishPickView:_string];
    }
    
    [self.myResponder resignFirstResponder];
    
}


#pragma mark -- setter getter
- (NSArray *)provinces {
    if (!_provinces) {
        self.provinces = [@[] mutableCopy];
    }
    return _provinces;
}

- (NSArray *)selectedArray {
    if (!_selectedArray) {
        self.selectedArray = [@[] mutableCopy];
    }
    return _selectedArray;
}




//-(NSInteger)isAllDay:(NSInteger)year andMonth:(NSInteger)month
//{
//    int day=0;
//    switch(month)
//    {
//        case 1:
//        case 3:
//        case 5:
//        case 7:
//        case 8:
//        case 10:
//        case 12:
//            day=31;
//            break;
//        case 4:
//        case 6:
//        case 9:
//        case 11:
//            day=30;
//            break;
//        case 2:
//        {
//            if(((year%4==0)&&(year%100!=0))||(year%400==0))
//            {
//                day=29;
//                break;
//            }
//            else
//            {
//                day=28;
//                break;
//            }
//        }
//        default:
//            break;
//    }
//    return day;
//}

@end
