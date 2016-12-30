//
//  CallHelpTopTableViewCell.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/26.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "CallHelpTopTableViewCell.h"

@interface CallHelpTopTableViewCell () {
    
    UIImageView *_imageView;
}

@end

@implementation CallHelpTopTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}
- (void)createUI {
    _imageView = [[UIImageView alloc] initWithCornerRadiusAdvance:32/2 rectCornerType:UIRectCornerAllCorners];
    _imageView.frame = CGRectMake(0, 0, 32, 32);
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [_imageView addGestureRecognizer:tap];
    _imageView.userInteractionEnabled = YES;
    [self.contentView addSubview:_imageView];
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    [_imageView imageGetCacheForAlarm:alarm forUrl:nil];
    
}
- (void)setImage:(UIImage *)image {
    _image = image;
    _imageView.image = _image;

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
