//
//  PhotosCollectionViewCell.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/1/19.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "PhotosCollectionViewCell.h"

@interface PhotosCollectionViewCell()

@property (strong, nonatomic) UIImageView *posterView;

@property (nonatomic,copy)Photos_CallBack PhotosCallBack;

@end

NSString *const PhotosCollectionViewCellID = @"PhotosCollectionViewCellID";

@implementation PhotosCollectionViewCell


- (UIImageView *)posterView {
    if (!_posterView) {
        _posterView = [UIImageView new];
        _posterView.contentMode = UIViewContentModeScaleAspectFill;
        _posterView.clipsToBounds = YES;
        //        [self.contentView addSubview:_posterView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectImageAction:)];
        [_posterView addGestureRecognizer:tap];
        
        
    }
    return _posterView;
}

//- (void)setIsUserInteractionEnabled:(BOOL)isUserInteractionEnabled {
//    _isUserInteractionEnabled = isUserInteractionEnabled;
////    _posterView.userInteractionEnabled = _isUserInteractionEnabled;
//}

- (void)configureCellWithData:(id)data withCallBack:(Photos_CallBack)callBack {
    NSString *name = data;
    _posterView.image = [UIImage imageNamed:name];
    
    self.PhotosCallBack = callBack;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _posterView.image = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    
    return self;
}

- (void)setupViews {
    if (_posterView) {
        return;
    }
    
    self.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    [self.contentView addSubview:self.posterView];
    //    self.posterView.userInteractionEnabled = YES;
    [self.posterView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    
}

- (void)selectImageAction:(UITapGestureRecognizer *)gestureRecognizer {
    
    UIImageView *imageView =gestureRecognizer.view;
    self.PhotosCallBack(imageView);
}



@end
