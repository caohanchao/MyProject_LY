//
//  SysUpdataTableViewCell.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/18.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "SysUpdataTableViewCell.h"
#import "NSDate+Extensions.h"

#define LeftMargin 15

@implementation SysUpdataTableViewCell {

    UILabel *_versionLabel;
    UILabel *_timeLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)createUI {
    _versionLabel = [[UILabel alloc] init];
    _versionLabel.font = ZEBFont(15);
    [self.contentView addSubview:_versionLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = ZEBFont(13);
    _timeLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_timeLabel];
    
    
    [_versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(LeftMargin);
        make.top.equalTo(self.mas_top);
        make.width.lessThanOrEqualTo(@195);
        make.height.mas_equalTo(self);
    }];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-LeftMargin);
        make.top.equalTo(self.mas_top);
        make.width.lessThanOrEqualTo(@95);
        make.height.mas_equalTo(self);
    }];
}
- (void)setTime:(NSString *)time {
    _time = time;
    [self reloadCell];
}
- (void)reloadCell {
    _versionLabel.text = _version;
    _timeLabel.text = [self timeChage:_time];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(NSString *)timeChage:(NSString *)time{
    
    NSString *str=[time substringWithRange:NSMakeRange(10, 3)];
    
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 如果是真机调试，转换这种欧美时间，需要设置locale
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    [fmt setDateFormat:@"EEE MMM dd HH:mm:ss Z yyyy"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *createDate=[formatter dateFromString:time];
    // 当前时间
    NSDate *now = [NSDate date];
    
    // 日历对象（方便比较两个日期之间的差距）
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // NSCalendarUnit枚举代表想获得哪些差值
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 计算两个日期之间的差值
    //NSDateComponents *cmps = [calendar components:unit fromDate:createDate toDate:now options:0];
    
    if ([createDate isThisYear]) {
        if ([createDate isYesterday]) {
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:createDate];
        }else if ([createDate isToday]){
            if ([str intValue]>=12) {
                fmt.dateFormat=@"下午 HH:mm";
                NSString *timeStr=[fmt stringFromDate:createDate];
                return timeStr;
            }else{
                fmt.dateFormat=@"上午 HH:mm";
                NSString *timeStr=[fmt stringFromDate:createDate];
                return timeStr;
            }
            
        }else{
            
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:createDate];
            
        }
    }else{
        
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:createDate];
        
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
