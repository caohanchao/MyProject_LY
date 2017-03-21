//
//  PhotosCollectionViewCell.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/1/19.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^Photos_CallBack)(UIImageView *imageView);


FOUNDATION_EXPORT NSString *const PhotosCollectionViewCellID;

@interface PhotosCollectionViewCell : UICollectionViewCell

- (void)configureCellWithData:(id)data withCallBack:(Photos_CallBack)callBack;

@end
