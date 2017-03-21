//
//  PicImageViewCollectionViewCell.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/1/17.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "PicImageViewCollectionViewCell.h"
#import "PicImageView.h"

@interface PicImageViewCollectionViewCell ()<PicImageViewDelegate>

@property (nonatomic, strong) PicImageView *picImageView;

@end

@implementation PicImageViewCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        [self createUI];
        
    }
    return self;
}
- (void)createUI {
    self.picImageView = [[PicImageView alloc] initWithFrame:self.bounds];
    self.picImageView.delhidden = YES;
    self.picImageView.delegate = self;
    [self.contentView addSubview:self.picImageView];
    
    
}
- (void)setPicImageUrl:(NSString *)picImageUrl {
    _picImageUrl = picImageUrl;
    self.picImageView.picUrl = _picImageUrl;
}
- (void)picImageView:(PicImageView *)view index:(NSInteger)index {
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    parm[@"index"] = [NSString stringWithFormat:@"%ld",self.index];
    parm[@"imageArr"] = self.imageArray;
    parm[@"picImageView"] = view;
    [LYRouter openURL:@"ly://MessageBoardViewControllershowPicimage" withUserInfo:parm completion:^(id result) {
        
    }];
}
@end
