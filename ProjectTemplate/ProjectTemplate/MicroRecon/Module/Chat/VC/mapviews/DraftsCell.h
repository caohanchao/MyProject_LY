//
//  DraftsCell.h
//  ProjectTemplate
//
//  Created by caohanchao on 16/10/27.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuspectlistModel.h"
#import "WorkAllTempModel.h"
#import "GetPathModel.h"

typedef enum {
    markType,
    TrajectoryType
} DraftsCellType;

typedef void (^DraftsUploadClick) (id model,DraftsCellType type);

@interface DraftsCell : UITableViewCell

@property(nonatomic,copy)WorkAllTempModel *model;

@property(nonatomic,copy)GetPathModel *pModel;

@property(nonatomic,copy)DraftsUploadClick draftsUploadClick;
@property (nonatomic, weak) id tempModel;
@property(nonatomic)DraftsCellType type;

- (void)configureWithCell:(id)model;

@end
