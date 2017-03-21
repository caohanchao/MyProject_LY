//
//  SqureCell.m
//  ProjectTemplate
//
//  Created by 戴小斌 on 2016/10/19.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "SqureCell.h"
#import "UserAllModel.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define LeftMargin 12
#define TopMargin 12
#define IntervalMargin 9 //间隔

#define identityFont 8//职位字号
#define nameFont 14//名字
#define fromFont 12 //部门
#define timeFont 12//时间
#define textFont 14//内容
#define positionFont 12 //位置
#define numFont 12//数量
#define titFont 16//顶部标题

@implementation SqureCell

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
    //self.iconImage.backgroundColor = [UIColor redColor];
    [self.contentView addSubview: self.iconImage];
    
    //
    self.iconImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.iconImageBtn.frame = self.iconImage.frame;
   // self.iconImageBtn.backgroundColor = [UIColor blueColor];
    [self.iconImageBtn addTarget:self action:@selector(iconImageClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.iconImageBtn];
    
    
    //职位
    
    self.identitylabel = [[UILabel alloc] init];
    self.identitylabel .textColor = CHCHexColor(@"ffffff");
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
    
    //
    self.userInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
   // self.userInfoBtn.backgroundColor = [UIColor blueColor];
    [self.userInfoBtn addTarget:self action:@selector(userInfoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.userInfoBtn];
    
    //时间
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel .textColor = CHCHexColor(@"a6a6a6");
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel .font = [UIFont systemFontOfSize:timeFont];
    [self.contentView addSubview:self.timeLabel ];

    //内容
    self.contentLabel = [[UILabel alloc] init];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel .textColor = [UIColor blackColor];
    self.contentLabel .font = [UIFont systemFontOfSize:textFont];
    [self.contentView addSubview:self.contentLabel ];
    
    
    //图片区
    self.imageScrollview = [[UIScrollView alloc]init];
    self.imageScrollview.pagingEnabled = NO;
    self.imageScrollview.showsHorizontalScrollIndicator = NO;
   // self.imageScrollview.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:self.imageScrollview];
    
    self.positionImg = [[UIImageView alloc]init];
    self.positionImg.image = [UIImage imageNamed:@"criclePosition"];
    [self.contentView addSubview:self.positionImg];
    
    //位置
    self.positionLabel = [[UILabel alloc] init];
    self.positionLabel .textColor = [UIColor grayColor];
    self.positionLabel .font = [UIFont systemFontOfSize:positionFont];
    [self.contentView addSubview:self.positionLabel ];
    
    //评论按钮
    self.commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.commentBtn setImage:[UIImage imageNamed:@"criclecomment"] forState:UIControlStateNormal];
    //[self.commentBtn setTitle:@"0" forState:UIControlStateNormal];
    [self.commentBtn setTitleColor:CHCHexColor(@"808080")];
    [self.commentBtn setTitleFont:FontNameSymbol size:numFont];
    [self.commentBtn addTarget:self action:@selector(commentBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.commentBtn];
    
    //点赞按钮
    self.praiseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //[self.praiseBtn setTitle:@"0" forState:UIControlStateNormal];
    [self.praiseBtn setTitleColor:CHCHexColor(@"808080")];
    [self.praiseBtn setTitleFont:FontNameSymbol size:numFont];
    [self.praiseBtn addTarget:self action:@selector(praiseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.praiseBtn];
    
    
    //分割
    self.allLineLabel = [[UILabel alloc] init];
    self.allLineLabel .backgroundColor = CHCHexColor(@"f7f7f8");
    [self.contentView addSubview:self.allLineLabel ];
    
    //分割
    self.LineLabel = [[UILabel alloc] init];
    self.LineLabel .backgroundColor = CHCHexColor(@"e5e5e6");
    [self.contentView addSubview:self.LineLabel ];
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

//点赞
-(void)praiseBtnClick:(UIButton*)btn
{
    if (_delegate && [_delegate respondsToSelector:@selector(postPraise:)]) {
        [_delegate postPraise:self];
    }
}

//评论
-(void)commentBtnClick:(UIButton*)btn
{
    if (self.commentBlock) {
        self.commentBlock();
    }
}

-(void)setModel:(PostListModel *)model
{
    _model = model;
    
    UserAllModel *userModel = [[[DBManager sharedManager] personnelInformationSQ] selectDepartmentmemberlistById:_model.alarm];
    
    UnitListModel *uModel = [[[DBManager sharedManager] DepartmentlistSQ] selectDepartmentlistById:userModel.RE_department];
    NSString *DE_type = uModel.DE_type;
    
    NSString*string = _model.picture;
    
    _imageArray = [string componentsSeparatedByString:@","];
    
    
    //设置动态大小
    CGFloat timeLabWidth;
    CGFloat nameLabWidth;
    CGFloat fromLabWidth;
    CGFloat positionLabWidth;
    CGFloat contentHight;
    CGFloat postLabWidth;
    CGFloat imageScrollViewWidth;
   
    //转化时间
    NSString * timeStr = [self timeChange:[NSString stringWithFormat:@"%@",_model.pushtime]];
    
    timeStr = [timeStr timeChage];
    
    timeLabWidth = [LZXHelper textWidthFromTextString:timeStr height:12 fontSize:timeFont];
    nameLabWidth = [LZXHelper textWidthFromTextString:_model.publishname height:15 fontSize:nameFont];
    fromLabWidth = [LZXHelper textWidthFromTextString:_model.department height:15 fontSize:fromFont];
    if ([[LZXHelper isNullToString:_model.position] isEqualToString:@""]) {
        positionLabWidth = [LZXHelper textWidthFromTextString:@"暂无位置信息" height:20 fontSize:positionFont];
    }
    else
    {
        positionLabWidth = [LZXHelper textWidthFromTextString:_model.position height:20 fontSize:positionFont];
    }
    contentHight = [LZXHelper textHeightFromTextString:model.text width: screenWidth() - LeftMargin*2 fontSize:textFont];
    
//    if ([[LZXHelper isNullToString:DE_type]isEqualToString:@""])
//    {
//         postLabWidth = [LZXHelper textWidthFromTextString:@"武汉市公安局" height:18 fontSize:identityFont];
//    }
//    else
//    {
//         postLabWidth = [LZXHelper textWidthFromTextString:userModel.RE_post height:18 fontSize:identityFont];
//    }
    postLabWidth = 0;
    
    imageScrollViewWidth = 88*_imageArray.count+12*(_imageArray.count-1);
    if (imageScrollViewWidth>screenWidth() - LeftMargin*2)
    {
        imageScrollViewWidth = screenWidth() - LeftMargin*2;
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
    _nameLabel.frame = CGRectMake(maxX(self.identitylabel), minY(self.identitylabel), nameLabWidth, 15);
    
    _fromLabel.frame = CGRectMake(minX(self.identitylabel), maxY(self.identitylabel)+6, fromLabWidth, 15);
    
    
    if ([[LZXHelper isNullToString:_model.text] isEqualToString:@""]) {
        contentHight = 0;
    }
    _contentLabel.frame = CGRectMake(LeftMargin, maxY(self.iconImage)+IntervalMargin+3, screenWidth() - LeftMargin*2 , contentHight);
    
    if (model.picture.length >0 )
    {
        _imageScrollview.frame = CGRectMake(LeftMargin, maxY(self.contentLabel)+IntervalMargin,imageScrollViewWidth , 88);
         _positionImg.frame = CGRectMake(LeftMargin, maxY(self.imageScrollview)+18, 15, 15);
        _positionLabel.frame = CGRectMake(LeftMargin+17, maxY(self.imageScrollview)+16, positionLabWidth , 20);
    }
    else
    {
        _imageScrollview.frame = CGRectMake(LeftMargin, maxY(self.contentLabel)+IntervalMargin, imageScrollViewWidth, 0);
        _positionImg.frame = CGRectMake(LeftMargin, maxY(self.imageScrollview)+18, 15, 15);
        _positionLabel.frame = CGRectMake(LeftMargin+17, maxY(self.imageScrollview)+16, positionLabWidth , 20);
    }
    
    [self.imageScrollview setContentSize:CGSizeMake(100*_imageArray.count, 0)];

    _commentBtn.frame =  CGRectMake(screenWidth()-LeftMargin-40, maxY(_imageScrollview)+12, 40, 28);
    _commentBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
    _commentBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    
    _praiseBtn.frame = CGRectMake(minX(self.commentBtn)- 50,minY(self.commentBtn) , 40, 28);
    _praiseBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
    _praiseBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0);
    if ([_model.ispraise isEqualToString:@"0"])
    {
         [_praiseBtn setImage:[UIImage imageNamed:@"criclepraise"] forState:UIControlStateNormal];
    }
    else
    {
         [_praiseBtn setImage:[UIImage imageNamed:@"criclepraisep"] forState:UIControlStateNormal];
    }
    
    
   _userInfoBtn.frame = CGRectMake(minX(self.identitylabel), minY(self.identitylabel), self.identitylabel.width+self.nameLabel.width+5, self.identitylabel.height+self.fromLabel.height);
    
//    [self.imageScrollview setContentSize:CGSizeMake(100*_imageArray.count, 0)];
//    
//    if (![self.postDetail isEqualToString:@"postDetail"])
//    {
//        for (int i =0; i<_imageArray.count; i++)
//        {
//            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100*i, 0, 88, 88)];
//            [imageView sd_setImageWithURL:[NSURL URLWithString:_imageArray[i]] placeholderImage:[UIImage imageNamed:@"whiteplaceholder"]];
//            imageView.contentMode=UIViewContentModeScaleToFill;
//            [self.imageScrollview addSubview:imageView];
//        }
//    }
    
    _allLineLabel.frame = CGRectMake(0, maxY(_praiseBtn)+5, screenWidth(), 12);
    
   // _LineLabel.frame = CGRectMake(0, height(self.frame)-0.5, screenWidth(), 0.5);
    _LineLabel.frame = CGRectMake(0, maxY(_praiseBtn)+3, screenWidth(), 1);
    _nameLabel.text = _model.publishname;
    _fromLabel.text = _model.department;
    _timeLabel.text = timeStr;
    
    if ([[LZXHelper isNullToString:_model.position] isEqualToString:@""])
    {
        _positionLabel.text = @"暂无位置信息";
    }
    else
    {
        if ([_model.position containsString:@"(null)"]) {
            NSString *string1 = _model.position;
            NSString *string2 = @"(null)";
            NSRange range = [string1 rangeOfString:string2];
            int location = range.location;
            int leight = range.length;
            NSString *addressString = [string1 substringToIndex:range.location];
            _positionLabel.text = addressString;
        }
        else
        {
            _positionLabel.text = _model.position;
        }
    }
    
    _contentLabel.text = _model.text;
  //  [_iconImage  imageGetCacheForAlarm:_model.alarm forUrl:_model.headpic];
    [_iconImage  sd_setImageWithURL:[NSURL URLWithString:_model.headpic]];
    
    if (![[LZXHelper isNullToString:_model.praisenum] isEqualToString:@""])
    {
        if ([_model.praisenum integerValue]<0)
        {
            [_praiseBtn setTitle:@"0" forState:UIControlStateNormal];
        }
        else
        {
            [_praiseBtn setTitle:_model.praisenum forState:UIControlStateNormal];
        }
    }
    else
    {
        [_praiseBtn setTitle:@"0" forState:UIControlStateNormal];
    }
    
    if (![[LZXHelper isNullToString:_model.comment] isEqualToString:@""])
    {
        if ([_model.comment integerValue]<0)
        {
             [_commentBtn setTitle:@"0" forState:UIControlStateNormal];
        }
        else
        {
            [_commentBtn setTitle:_model.comment forState:UIControlStateNormal];
        }
    }
    else
    {
         [_commentBtn setTitle:@"0" forState:UIControlStateNormal];
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
