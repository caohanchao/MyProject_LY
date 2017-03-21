//
//  ProvinceListCollectionViewCell.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/3/13.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProvinceListModel,ProvinceListCollectionViewCell;

typedef void(^cellChooseProvinceBlock)(ProvinceListCollectionViewCell *cell, NSInteger item);

@interface ProvinceListCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) ProvinceListModel *model;

@property (nonatomic, copy) cellChooseProvinceBlock block;
@property (nonatomic, assign) NSInteger item;



@end
