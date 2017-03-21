//
//  CommentTableViewCell.m
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/8.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "CommentTableViewCell.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define LeftMargin 12
#define TopMargin 12
#define IntervalMargin 12 //间隔

#define identityFont 8//职位字号
#define nameFont 14//名字
#define fromFont 12 //部门
#define timeFont 12//时间
#define textFont 14//内容

@implementation CommentTableViewCell

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
//    self.iconImage.layer.cornerRadius = 18;
     self.iconImage.layer.cornerRadius = 6;
    self.iconImage.layer.masksToBounds = YES;
    [self.contentView addSubview: self.iconImage];
    
    self.iconImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.iconImageBtn.frame = self.iconImage.frame;
    // self.iconImageBtn.backgroundColor = [UIColor blueColor];
    [self.iconImageBtn addTarget:self action:@selector(iconImageClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.iconImageBtn];
    
    self.userInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    // self.userInfoBtn.backgroundColor = [UIColor blueColor];
    [self.userInfoBtn addTarget:self action:@selector(userInfoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.userInfoBtn];
    
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
    self.fromLabel .textColor =CHCHexColor(@"808080");
    self.fromLabel .font = [UIFont systemFontOfSize:fromFont];
    [self.contentView addSubview:self.fromLabel ];
    
    
    //时间
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel .textColor =CHCHexColor(@"a6a6a6");
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel .font = [UIFont systemFontOfSize:timeFont];
    [self.contentView addSubview:self.timeLabel ];
    
    
    //内容contentLabel
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel .textColor = CHCHexColor(@"000000");
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
    self.contentLabel .font = [UIFont systemFontOfSize:textFont];
    self.contentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.contentLabel ];
    
}

-(void)setModel:(CommentModel *)model
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
    NSString * timeStr = [self timeChange:[NSString stringWithFormat:@"%@",_model.pushtime]];
    timeStr = [timeStr timeChage];
    
    timeLabWidth = [LZXHelper textWidthFromTextString:timeStr height:12 fontSize:timeFont];
    nameLabWidth = [LZXHelper textWidthFromTextString:_model.name height:15 fontSize:nameFont];
    fromLabWidth = [LZXHelper textWidthFromTextString:_model.department height:15 fontSize:fromFont];
    contentHight = [LZXHelper textHeightFromTextString:_model.content width: screenWidth() - LeftMargin*2 fontSize:textFont];
    
//    if ([[LZXHelper isNullToString:DE_type]isEqualToString:@""])
//    {
//        postLabWidth = [LZXHelper textWidthFromTextString:@"武汉市公安局" height:18 fontSize:identityFont];
//    }
//    else
//    {
//        postLabWidth = [LZXHelper textWidthFromTextString:userModel.RE_post height:18 fontSize:identityFont];
//    }
    postLabWidth = 0;
    
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
    
    _nameLabel.frame = CGRectMake(maxX(self.identitylabel), minY(self.identitylabel), nameLabWidth, 15);
    
    _fromLabel.frame = CGRectMake(minX(self.identitylabel), maxY(self.identitylabel)+6, fromLabWidth, 15);
    
     _contentLabel.frame = CGRectMake(LeftMargin, maxY(self.iconImage)+10, screenWidth() - LeftMargin*2 , contentHight);
    
    _userInfoBtn.frame = CGRectMake(minX(self.identitylabel), minY(self.identitylabel), self.identitylabel.width+self.nameLabel.width+5, self.identitylabel.height+self.fromLabel.height);
    
    _nameLabel.text = _model.name;
    _fromLabel.text = _model.department;
    _timeLabel.text = timeStr;
   // [_iconImage  imageGetCacheForAlarm:_model.alarm forUrl:_model.headpic];
     [_iconImage  sd_setImageWithURL:[NSURL URLWithString:_model.headpic]];
    _contentLabel.text = _model.content;
    
}
//点击头像进入个人主页
-(void)iconImageClick:(UIButton*)btn
{
    if (self.userInfoBlock){
        self.userInfoBlock();
    }
}

//点击姓名区域进入个人主页
-(void)userInfoBtnClick:(UIButton*)btn
{
    if (self.userInfoBlock) {
        self.userInfoBlock();
    }
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
