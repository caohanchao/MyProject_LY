//
//  MessageBoardTableViewCell.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/1/16.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "MessageBoardTableViewCell.h"
#import "AudioViewCollectionViewCell.h"
#import "VideoViewCollectionViewCell.h"
#import "PicImageViewCollectionViewCell.h"
#import "MessageBoardListModel.h"
#import "UIImageView+CornerRadius.h"

// 注意const的位置
static NSString *const Audio = @"AudioViewCollectionViewCell";
static NSString *const Video = @"VideoViewCollectionViewCell";
static NSString *const PicImage = @"PicImageViewCollectionViewCell";

#define postFont 10
#define nameFont 12
#define timeFont 10
#define contentFont 14

#define headpicWidth 40

#define videosId  @"videosId"
#define picturesId    @"picturesId"
#define audiosId  @"audiosId"

@interface MessageBoardTableViewCell ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIImageView *headpicImageView;
@property (nonatomic, strong) UILabel *postLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *line;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableDictionary *dict;
@end

@implementation MessageBoardTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, kScreenWidth, 0);
        self.backgroundColor = zWhiteColor;
        [self initView];
        [self settingAutoLayout];
    }
    return self;
}
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableDictionary *)dict {
    if (!_dict) {
        _dict = [NSMutableDictionary dictionary];
    }
    return _dict;
}
- (void)initView {
    self.headpicImageView = [[UIImageView alloc] initWithCornerRadiusAdvance:headpicWidth/2 rectCornerType:UIRectCornerAllCorners];
    
    self.postLabel = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentCenter font:ZEBFont(postFont) textColor:zWhiteColor text:@""];
    self.postLabel.layer.masksToBounds = YES;
    self.postLabel.layer.cornerRadius = 3;
    
    self.nameLabel = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentLeft font:ZEBFont(nameFont) textColor:zBlackColor text:@""];
    
    self.timeLabel = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentRight font:ZEBFont(timeFont) textColor:zGrayColor text:@""];
    
    self.contentLabel = [CHCUI createLabelWithbackGroundColor:nil textAlignment:NSTextAlignmentLeft font:ZEBFont(contentFont) textColor:zBlackColor text:@""];
   
    
    
    CGFloat leftMargin = 12;
    CGFloat centerMargin = 15;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    self.collectionView.delegate=self;
    self.collectionView.dataSource=self;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.backgroundColor = zWhiteColor;
    [self.collectionView registerClass:[AudioViewCollectionViewCell class] forCellWithReuseIdentifier:Audio];
    [self.collectionView registerClass:[VideoViewCollectionViewCell class] forCellWithReuseIdentifier:Video];
    [self.collectionView registerClass:[PicImageViewCollectionViewCell class] forCellWithReuseIdentifier:PicImage];
    
    self.line = [[UILabel alloc] init];
    self.line.backgroundColor = LineColor;
    
    [self.contentView addSubview:self.headpicImageView];
    [self.contentView addSubview:self.postLabel];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.collectionView];
    [self.contentView addSubview:self.line];

}
- (void)settingAutoLayout {

    CGFloat topMargin = 10;
    CGFloat leftMargin = 10;
    CGFloat centerMargin = 5;
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.top.bottom.mas_equalTo(self);
    }];
    
    [self.headpicImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(leftMargin);
        make.top.equalTo(self.contentView.mas_top).offset(topMargin);
        make.size.mas_equalTo(CGSizeMake(headpicWidth, headpicWidth));
    }];
    [self.postLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headpicImageView.mas_right).offset(centerMargin);
        make.centerY.equalTo(self.headpicImageView);
        make.height.equalTo(@15);
        make.width.mas_lessThanOrEqualTo(80);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.postLabel.mas_right).offset(centerMargin);
        make.centerY.equalTo(self.headpicImageView);
        make.height.equalTo(@20);
        make.width.mas_lessThanOrEqualTo(150);
    }];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-leftMargin);
        make.centerY.equalTo(self.headpicImageView);
        make.height.equalTo(@40);
        make.width.mas_lessThanOrEqualTo(200);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(leftMargin);
        make.right.equalTo(self.contentView.mas_right).offset(-leftMargin);
        make.top.equalTo(self.headpicImageView.mas_bottom).offset(4*centerMargin);
      //  make.bottom.equalTo(self.contentView.mas_bottom).offset(-topMargin);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.contentLabel.mas_bottom).offset(2*centerMargin);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-topMargin);
       
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-0.5);
        make.height.equalTo(@0.5);
    }];
    
  
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.collectionView.frame = CGRectMake(0, maxY(self.contentLabel), kScreenWidth, 150);
}
- (void)setModel:(MessageBoardListModel *)model {
    _model = model;
    
    [self reloadCell];
}
- (void)reloadCell {
    [self.headpicImageView imageGetCacheForAlarm:_model.alarm forUrl:_model.head_pic];
    
    UserAllModel *allModel = [[[DBManager sharedManager] personnelInformationSQ] selectDepartmentmemberlistById:_model.alarm];
    UnitListModel *uModel = [[[DBManager sharedManager] DepartmentlistSQ] selectDepartmentlistById:allModel.RE_department];
    NSString *DE_type = uModel.DE_type;
    NSString *DE_name = [LZXHelper isNullToString:uModel.DE_name];
    NSString *str =  [NSString stringWithFormat:@" %@ ",DE_name];
    
    
    if ([[LZXHelper isNullToString:DE_type] isEqualToString:@""]) {
        self.postLabel.layer.backgroundColor = [UIColor colorWithHexString:@"#96b0fb"].CGColor;
        
        self.postLabel.text = [NSString stringWithFormat:@" 武汉市公安局 "];
        
        
    }else {
        if ([DE_type isEqualToString:@"0"]) {//0警察公务组织紫，1技术支持绿
            self.postLabel.layer.backgroundColor = [UIColor colorWithHexString:@"#96b0fb"].CGColor;
            self.postLabel.text = [NSString stringWithFormat:@"  %@  ",self.model.position];
            
        }else if ([DE_type isEqualToString:@"1"]) {
            self.postLabel.layer.backgroundColor = [UIColor colorWithHexString:@"#6cd9a3"].CGColor;
            self.postLabel.text = [NSString stringWithFormat:@"  %@  ",self.model.position];
        }
    }
        
    self.postLabel.text = _model.position;
    self.nameLabel.text = _model.name;
    self.timeLabel.text = [_model.record_time timeChage];
    self.contentLabel.text = _model.content;
    
    [self.dict removeAllObjects];
    [self.dataArray removeAllObjects];
    if (![_model.audio isEqualToString:@" "] && ![_model.audio isEqualToString:@""]) {
        NSArray *audios = [_model.audio componentsSeparatedByString:@","];
        [self.dict setObject:audios forKey:audiosId];
        [self.dataArray addObject:audiosId];
    }
    
    if (![_model.picture isEqualToString:@" "] && ![_model.picture isEqualToString:@""]) {
        NSArray *pictures = [_model.picture componentsSeparatedByString:@","];
        [self.dict setObject:pictures forKey:picturesId];
        [self.dataArray addObject:picturesId];
    }
   
    if (![_model.video isEqualToString:@" "] && ![_model.video isEqualToString:@""]) {
        NSArray *videos = [_model.video componentsSeparatedByString:@","];
        [self.dict setObject:videos forKey:videosId];
        [self.dataArray addObject:videosId];
    }

    [self.collectionView reloadData];
}

#pragma mark -
#pragma mark uicollectionviewdelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSString *key = self.dataArray[section];
    NSArray *array = self.dict[key];
    return array.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * key = self.dataArray[indexPath.section];
    NSArray * array = self.dict[key];
    
    if ([key isEqualToString:audiosId]) {
        AudioViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Audio forIndexPath:indexPath];
        cell.audioUrl = array[indexPath.item];
        cell.index = indexPath.item;
        cell.row = self.row;
        return cell;
    }else if ([key isEqualToString:picturesId]) {
        PicImageViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PicImage forIndexPath:indexPath];
        cell.picImageUrl = array[indexPath.item];
        cell.index = indexPath.item;
        cell.imageArray = array.mutableCopy;
        return cell;
    }else if ([key isEqualToString:videosId]) {
        VideoViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:Video forIndexPath:indexPath];
        cell.videoUrl = array[indexPath.item];
        return cell;
    }
    
    return [[UICollectionViewCell alloc] init];
}

//设置item的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // collectionview高度需要自己计算
    CGFloat picleftM = 12;
    CGFloat piccenterM = 12;
    
    CGFloat audioLeftM = 12;
    CGFloat audioCenterM = 12;
    
    CGFloat btnW = (kScreenWidth-3*piccenterM-2*picleftM)/4;
    CGFloat audioBtnW = (kScreenWidth-3*audioCenterM-2*audioLeftM)/4;
    CGFloat audioBtnH = 26;
    
    
    NSString * key = self.dataArray[indexPath.section];
    NSArray * array = self.dict[key];
    
    if ([key isEqualToString:audiosId]) {
        return CGSizeMake(audioBtnW, audioBtnH);
    }else if ([key isEqualToString:picturesId]) {
        return CGSizeMake(btnW, btnW);
    }else if ([key isEqualToString:videosId]) {
        return CGSizeMake(btnW, btnW);
    }
    
    return CGSizeMake(0, 0);
}
//设置垂直间距,默认的垂直和水平间距都是10
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 12;
}
//设置水平间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 6;
}

//四周的边距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(6, 12, 6, 12);
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
