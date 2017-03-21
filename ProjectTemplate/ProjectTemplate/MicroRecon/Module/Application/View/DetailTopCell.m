//
//  DetailTopCell.m
//  ProjectTemplate
//
//  Created by 李凯华 on 16/11/4.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "DetailTopCell.h"
#import "PostInfoModel.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define PraiseLeftMargin 12


@implementation DetailTopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)createUI
{
    _honourImg = [[UIImageView alloc]initWithFrame:CGRectMake(PraiseLeftMargin, 33/4, 31, 31)];
    _honourImg.image = [UIImage imageNamed:@"criclehonour"];
    [self.contentView addSubview:_honourImg];
    
    _honourLabel = [[UILabel alloc]initWithFrame:CGRectMake(PraiseLeftMargin+_honourImg.width/4-2, minY(_honourImg)+_honourImg.height/2+2, _honourImg.width/2+4, _honourImg.height/2-4)];
    _honourLabel.backgroundColor = [UIColor clearColor];
    _honourLabel.textColor = [UIColor whiteColor];
    _honourLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_honourLabel];
    
    _praiseScrollview = [[UIScrollView alloc]init];
    _praiseScrollview.pagingEnabled = NO;
    _praiseScrollview.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:_praiseScrollview];
    _praiseScrollview.userInteractionEnabled = NO;
     [self.contentView addGestureRecognizer:_praiseScrollview.panGestureRecognizer];
    
}

-(void)setPraiseAarray:(NSArray *)array
{
    _praiseAarray = array;
    
    [_praiseScrollview removeAllSubviews];
    
    if (_praiseAarray.count >0)
    {
        if (_praiseAarray.count>99)
        {
            _honourLabel.text = @"99＋";
            _honourLabel.font = [UIFont systemFontOfSize:8.0f];
        }
        else
        {
            _honourLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)_praiseAarray.count];
            _honourLabel.font = [UIFont systemFontOfSize:12.0f];
        }
        
        if (39*_praiseAarray.count>kScreenWidth-PraiseLeftMargin*2-31) {
             _praiseScrollview.frame = CGRectMake(maxX(_honourImg)+9, minY(_honourImg), kScreenWidth-PraiseLeftMargin*3-31, 31);
        }
        else
        {
             _praiseScrollview.frame = CGRectMake(maxX(_honourImg)+9, minY(_honourImg), 39*_praiseAarray.count, 31);
        }
        
         [_praiseScrollview setContentSize:CGSizeMake(39*_praiseAarray.count+5, 0)];
        
        
        for (int i =0; i<_praiseAarray.count; i++)
        {
            PostInfoModel * model = _praiseAarray [i];
            
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(39*i, 0, 31, 31)];
           // [imageView  imageGetCacheForAlarm:model.alarm forUrl:model.headpic];
             [imageView  sd_setImageWithURL:[NSURL URLWithString:model.headpic]];
            imageView.layer.masksToBounds = YES;
//            imageView.layer.cornerRadius = 31/2;
             imageView.layer.cornerRadius = 6;
            [_praiseScrollview addSubview:imageView];
        }
    }
    else
    {
        _honourLabel.text = @"0";
        _honourLabel.font = [UIFont systemFontOfSize:12.0f];
    }
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
