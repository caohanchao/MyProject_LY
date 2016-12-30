//
//  HonourTableViewCell.m
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/7.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "HonourTableViewCell.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define LeftMargin 27/2
#define TopMargin 7
#define IntervalMargin 12 //间隔

#define identityFont 8//职位字号
#define nameFont 14//名字
#define fromFont 12 //部门
#define timeFont 12//时间

@implementation HonourTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    
    //头像
    self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(LeftMargin, TopMargin, 36, 36)];
    self.iconImage.layer.cornerRadius = 18;
    self.iconImage.layer.masksToBounds = YES;
    //self.iconImage.backgroundColor = [UIColor redColor];
    [self.contentView addSubview: self.iconImage];
    
    
    //职位
    self.identityImg = [[UIImageView alloc] init];
    [self.contentView addSubview: self.identityImg];
    
    self.identitylabel = [[UILabel alloc] init];
    self.identitylabel .textColor = [UIColor whiteColor];
    self.identitylabel .font = [UIFont systemFontOfSize:identityFont];
    self.identitylabel.textAlignment = NSTextAlignmentCenter;
    self.identitylabel.layer.masksToBounds = YES;
    self.identitylabel.layer.cornerRadius = 3;
    [self.contentView addSubview:self.identitylabel ];
    
    
    //姓名
    self.nameLabel = [[UILabel alloc] init];
    self.nameLabel .textColor = [UIColor blackColor];
    self.nameLabel .font = [UIFont systemFontOfSize:nameFont];
    [self.contentView addSubview:self.nameLabel ];
    
    //部门
    self.fromLabel = [[UILabel alloc] init];
    self.fromLabel .textColor = CHCHexColor(@"808080");
    self.fromLabel .font = [UIFont systemFontOfSize:fromFont];
    [self.contentView addSubview:self.fromLabel ];

    
    //时间
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel .textColor = CHCHexColor(@"a6a6a6");
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel .font = [UIFont systemFontOfSize:timeFont];
    [self.contentView addSubview:self.timeLabel ];
    
    
}

-(void)setModel:(PostInfoModel *)model
{
    _model = model;
    
    UserAllModel *userModel = [[[DBManager sharedManager] personnelInformationSQ] selectDepartmentmemberlistById:_model.alarm];

    UnitListModel *uModel = [[[DBManager sharedManager] DepartmentlistSQ] selectDepartmentlistById:userModel.RE_department];
    NSString *DE_type = uModel.DE_type;
    
    //设置动态大小
    CGFloat timeLabWidth;
    CGFloat nameLabWidth;
    CGFloat fromLabWidth;
    CGFloat positionLabWidth;
    CGFloat contentHight;
    CGFloat postLabWidth;
    
    //转化时间
    NSString * timeStr = [self timeChange:[NSString stringWithFormat:@"%@",_model.time]];
    timeStr = [timeStr timeChage];
    
    timeLabWidth = [LZXHelper textWidthFromTextString:timeStr height:12 fontSize:timeFont];
    nameLabWidth = [LZXHelper textWidthFromTextString:_model.name height:15 fontSize:nameFont];
    fromLabWidth = [LZXHelper textWidthFromTextString:_model.department height:15 fontSize:fromFont];
    
    if ([[LZXHelper isNullToString:DE_type]isEqualToString:@""])
    {
        postLabWidth = [LZXHelper textWidthFromTextString:@"武汉市公安局" height:18 fontSize:identityFont];
    }
    else
    {
        postLabWidth = [LZXHelper textWidthFromTextString:userModel.RE_post height:18 fontSize:identityFont];
    }
    
    
    if (fromLabWidth > kScreenWidth - LeftMargin*3 - _iconImage.width)
    {
        fromLabWidth = kScreenWidth - LeftMargin*3 - _iconImage.width;
    }
    
    if (positionLabWidth > kScreenWidth - 110-LeftMargin*2)
    {
        positionLabWidth =  kScreenWidth - 110-LeftMargin*2;
    }
    
    if (postLabWidth>0)
    {
        postLabWidth = postLabWidth+10;
    }
    _identitylabel.frame = CGRectMake(maxX(self.iconImage)+IntervalMargin, minY(self.iconImage), postLabWidth, 15);
    _identitylabel.text = userModel.RE_post;
    
    if ([[LZXHelper isNullToString:DE_type] isEqualToString:@""])
    {
        _identitylabel.layer.backgroundColor = [[UIColor colorWithHexString:@"#96b0fb"]CGColor];
        
        _identitylabel.text = [NSString stringWithFormat:@" 武汉市公安局 "];
    }
    else
    {
        if ([DE_type isEqualToString:@"0"]) {//0警察公务组织紫，1技术支持绿
            _identitylabel.layer.backgroundColor = [[UIColor colorWithHexString:@"#96b0fb"]CGColor];
            
        }else if ([DE_type isEqualToString:@"1"]) {
            _identitylabel.layer.backgroundColor = [[UIColor colorWithHexString:@"#6cd9a3"]CGColor];
        }
    }
    
    _timeLabel.frame = CGRectMake(screenWidth()-LeftMargin-timeLabWidth-10, minY(self.identitylabel), timeLabWidth+10, 12);
    
    _nameLabel.frame = CGRectMake(maxX(self.identitylabel)+4, minY(self.identitylabel), nameLabWidth, 15);
    
    _fromLabel.frame = CGRectMake(minX(self.identitylabel), maxY(self.identitylabel)+6, fromLabWidth, 15);
    
    _nameLabel.text = _model.name;
    _fromLabel.text = _model.department;
    _timeLabel.text = timeStr;
   // [_iconImage  imageGetCacheForAlarm:_model.alarm forUrl:_model.headpic];
    [_iconImage  sd_setImageWithURL:[NSURL URLWithString:_model.headpic]];
}


//时间戳转化时间
-(NSString*)timeChange:(NSString*)string
{
    NSTimeInterval time=[string doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *currentDay = [dateFormatter stringFromDate:detaildate];//返回的年月日
    
    return currentDay;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
