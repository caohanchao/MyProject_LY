//
//  ChatMapTopTableViewCell.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/18.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "ChatMapTopTableViewCell.h"
#import "ChatMapModel.h"
#import "GroupMemberModel.h"


@interface ChatMapTopTableViewCell () {

    UIImageView *_imageView;
}

@end

@implementation ChatMapTopTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)createUI {
//    _imageView = [[UIImageView alloc] initWithCornerRadiusAdvance:32/2 rectCornerType:UIRectCornerAllCorners];
    
     _imageView = [[UIImageView alloc] initWithCornerRadiusAdvance:6 rectCornerType:UIRectCornerAllCorners];
    _imageView.frame = CGRectMake(0, 0, 32, 32);
   _imageView.contentMode = UIViewContentModeScaleAspectFill;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [_imageView addGestureRecognizer:tap];
    _imageView.userInteractionEnabled = YES;
    [self.contentView addSubview:_imageView];

}

- (void)setModel:(id)model {

    _model = model;
    
    if ([_model isKindOfClass:[GroupMemberModel class]]) {
        
        GroupMemberModel *gModel = _model;
        _imageView.image = [LZXHelper convertImageToGreyScale:[ZEBCache imageCacheAlarm:gModel.ME_uid]];
        
    }else if ([_model isKindOfClass:[ChatMapModel class]]) {
        
        ChatMapModel *model = _model;
        if ([ZEBCache imageFileExistsAtAlarm:model.alarm]) {
            
            if ([model.status integerValue] == NOTONLINE) {
                _imageView.image = [LZXHelper convertImageToGreyScale:[ZEBCache imageCacheAlarm:model.alarm]];
            }else {
                _imageView.image = [ZEBCache imageCacheAlarm:model.alarm];
            }
        }else {
            _imageView.image = [UIImage imageNamed:@"ph_s"];
        }
    }

}

- (void)tap:(UITapGestureRecognizer *)recognizer {
    if (_delegate && [_delegate respondsToSelector:@selector(chatMapTopTableViewCell:index:)]) {
        [_delegate chatMapTopTableViewCell:self index:_index];
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
