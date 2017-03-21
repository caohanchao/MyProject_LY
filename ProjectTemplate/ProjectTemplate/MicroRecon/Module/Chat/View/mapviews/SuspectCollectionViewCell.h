//
//  SuspectCollectionViewCell.h
//  ProjectTemplate
//
//  Created by caohanchao on 2017/1/16.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString *const SuspectCollectionViewCellID;

typedef void (^Suspect_CallBack) (UIImageView *imageView);

@interface SuspectCollectionViewCell : UICollectionViewCell

//@property (nonatomic,assign)BOOL isUserInteractionEnabled;

- (void)configWithData:(NSObject *)model callBackWithSuspect:(Suspect_CallBack)suspectCallBack;

@end
