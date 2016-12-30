//
//  UnitNextViewController.h
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/17.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UnitNextViewController : UIViewController {
    
    UITableView *_tableView;
}

@property (nonatomic, strong) NSMutableArray *tempArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *nextArray;
@property (nonatomic, strong) NSMutableArray *nextUserArray;
@property (nonatomic, strong) NSMutableDictionary *dic;

@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, strong) NSMutableArray *arr;
@property (nonatomic, strong) NSMutableArray *nextUserArr;
@property (nonatomic, strong) NSMutableArray *departArray;
@property (nonatomic, strong) NSMutableArray *userArray;

- (void)sortDateArray:(UnitListModel *)model;

@end
