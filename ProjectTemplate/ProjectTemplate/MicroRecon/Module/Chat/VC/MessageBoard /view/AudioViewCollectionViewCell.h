//
//  AudioViewCollectionViewCell.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/1/17.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AudioViewCollectionViewCell : UICollectionViewCell


@property (nonatomic, copy) NSString *audioUrl;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger row;
@end
