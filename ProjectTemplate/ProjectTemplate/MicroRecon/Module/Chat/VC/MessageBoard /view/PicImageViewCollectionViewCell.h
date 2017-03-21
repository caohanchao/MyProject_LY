//
//  PicImageViewCollectionViewCell.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/1/17.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicImageViewCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) NSString *picImageUrl;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) NSMutableArray *imageArray;

@end
