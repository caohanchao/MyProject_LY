//
//  NewFriendTableViewCell.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/18.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "NewFriendTableViewCell.h"
#import "FriendLogic.h"


#define LeftMargin 12
#define TopMargin  8

@implementation NewFriendTableViewCell {

    UIImageView *_txImageView;
    UILabel *_nameLabel;
    UILabel *_infoLabel;
    UILabel *_dataLabel;
    UILabel *_postnameL;
    UIButton *_agreeBtn;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {

    _txImageView = [[UIImageView alloc] initWithFrame:CGRectMake(LeftMargin, TopMargin, 40, 40)];
//    _txImageView.layer.cornerRadius = 20;
    _txImageView.layer.cornerRadius = 6;
    _txImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:_txImageView];
    
    _postnameL =[[UILabel alloc]initWithFrame:CGRectMake(maxX(_txImageView)+TopMargin, TopMargin, 50, 20)];
    _postnameL.textColor =[UIColor whiteColor];
    _postnameL.font = [UIFont systemFontOfSize:10];
    _postnameL.layer .cornerRadius = 4;
    _postnameL.layer.masksToBounds = YES;
   // [self.contentView addSubview:_postnameL];
    
//    _dataLabel =[[UILabel alloc]initWithFrame:CGRectMake(minX(_postnameL), maxY(_postnameL)+8, 100, 15)];
    _dataLabel =[[UILabel alloc]initWithFrame:CGRectMake(maxX(_txImageView)+TopMargin, maxY(_postnameL)+8, 100, 15)];
    _dataLabel.font = [UIFont systemFontOfSize:13];
    _dataLabel.backgroundColor = [UIColor whiteColor];
    _dataLabel.textColor =[UIColor lightGrayColor];
    _dataLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_dataLabel];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(maxX(_postnameL)+TopMargin, TopMargin, 100, 20)];
    _nameLabel.font = ZEBFont(15);
    _nameLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_nameLabel];
    
    _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width-100, TopMargin, 90, 40)];
    _infoLabel.textColor = [UIColor grayColor];
    _infoLabel.textAlignment = NSTextAlignmentRight;
    _infoLabel.text = @"等待验证";
    _infoLabel.font = ZEBFont(13);
    [self.contentView addSubview:_infoLabel];
    
    
    
    _agreeBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_Width-100, TopMargin, 90, 40)];
    [_agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_agreeBtn setTitle:@"加为好友" forState:UIControlStateNormal];
    [_agreeBtn addTarget:self action:@selector(agreeAction:) forControlEvents:UIControlEventTouchUpInside];
//    _agreeBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    _agreeBtn.backgroundColor = zBlueColor;
    _agreeBtn.titleLabel.font = ZEBFont(13);
    [self.contentView addSubview:_agreeBtn];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 56, kScreen_Width, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.94 alpha:1.00];
    [self.contentView addSubview:line];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Setter 

- (void)setModel:(NewFriendModel *)model {
    _model = model;
    _nameLabel.text = _model.name;
    
    if ([@"isactive" isEqualToString:_model.nf_isactive]) {
        _infoLabel.text = @"等待验证";
        _infoLabel.hidden = NO;
        _agreeBtn.hidden = YES;
    } else if ([@"notactive" isEqualToString:_model.nf_isactive]) {
        _infoLabel.hidden = YES;
        _agreeBtn.hidden = NO;
    } else {
        _infoLabel.text = @"已添加";
        _infoLabel.hidden = NO;
        _agreeBtn.hidden = YES;
    }

   // [_txImageView sd_setImageWithURL:[NSURL URLWithString:_model.headpic] placeholderImage:[UIImage imageNamed:@"ph_s"]];
    [_txImageView imageGetCacheForAlarm:model.nf_fid forUrl:_model.headpic];
    NSString *dataStr;
    CGFloat dataLabWidth;
    if ([_model.nf_data isEqualToString:@""])
    {
        dataStr = @"请求添加您为好友";
        [_dataLabel setText:dataStr];
    }else
    {
        dataStr = _model.nf_data;
        [_dataLabel setText:dataStr];
    }
    dataLabWidth = [LZXHelper textWidthFromTextString:dataStr height:20 fontSize:13];
    _dataLabel.frame = CGRectMake(minX(_postnameL), maxY(_postnameL)+8, dataLabWidth+10, 15);
    
    [self reload];
 

    
}
-(void)reload
{
    
    UserAllModel *userModel = [[[DBManager sharedManager] personnelInformationSQ] selectDepartmentmemberlistById:_model.nf_fid];
    UnitListModel *uModel = [[[DBManager sharedManager] DepartmentlistSQ] selectDepartmentlistById:userModel.RE_department];
    NSString *DE_type = uModel.DE_type;
    NSString *DE_name = [LZXHelper isNullToString:uModel.DE_name];
    NSString *str =  [NSString stringWithFormat:@" %@ ",DE_name];
    
    CGFloat width =_postnameL.frame.size.width;
    
    if ([[LZXHelper isNullToString:DE_type] isEqualToString:@""]) {
        _postnameL.backgroundColor = [UIColor colorWithHexString:@"#96b0fb"];
        
        _postnameL.text = [NSString stringWithFormat:@" 武汉市公安局 "];
        width = [LZXHelper textWidthFromTextString:_postnameL.text height:20 fontSize:10];
//        _postnameL.frame = CGRectMake(maxX(_txImageView)+TopMargin, TopMargin,width+5, 20);
        
    }else {
        if ([DE_type isEqualToString:@"0"]) {//0警察公务组织紫，1技术支持绿
            _postnameL.backgroundColor = [UIColor colorWithHexString:@"#96b0fb"];
            _postnameL.text = [NSString stringWithFormat:@" %@ ",DE_name];
            width = [LZXHelper textWidthFromTextString:_postnameL.text height:20 fontSize:10];
//            _postnameL.frame = CGRectMake(maxX(_txImageView)+TopMargin, TopMargin, width+5, 20);
            
        }else if ([DE_type isEqualToString:@"1"]) {
            _postnameL.backgroundColor = [UIColor colorWithHexString:@"#6cd9a3"];
            _postnameL.text = [NSString stringWithFormat:@" %@ ",DE_name];
            width = [LZXHelper textWidthFromTextString:_postnameL.text height:20 fontSize:10];
           
        }
        
    }
    if (width > 70) {
        width = 70 ;
    }
     _postnameL.frame = CGRectMake(maxX(_txImageView)+TopMargin, TopMargin, width+5, 20);
    _postnameL.textAlignment =NSTextAlignmentCenter;
//    _nameLabel.frame = CGRectMake(maxX(_postnameL)+TopMargin, TopMargin, 100, 20);
    _nameLabel.frame = CGRectMake(maxX(_txImageView)+TopMargin, TopMargin, 100, 20);
}

#pragma mark - Action 

- (void)agreeAction:(UIButton *)btn {
    //NSLog(@"logicAgreeFriend - agreeAction");
    
    [[FriendLogic sharedManager] logicAgreeFriend:self.model.nf_fid progress:^(NSProgress * _Nonnull progress) {
     
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable reponse) {
        [_agreeBtn setTitle:@"添加成功" forState:UIControlStateNormal];
        [_agreeBtn setBackgroundColor:[UIColor whiteColor]];
        [_agreeBtn setTitleColor:[UIColor grayColor]];
        _agreeBtn.userInteractionEnabled = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:RefreshFriendsNotification object:nil];
       // NSLog(@"logicAgreeFriend - success");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [_agreeBtn setBackgroundColor:[UIColor whiteColor]];
        [_agreeBtn setTitleColor:[UIColor grayColor]];
        [_agreeBtn setTitle:@"添加失败" forState:UIControlStateNormal];
        _agreeBtn.userInteractionEnabled = NO;
    }];
}

@end
