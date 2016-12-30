//
//  TreeTableViewController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/13.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "TreeTableViewController.h"
#import "GetorgbyregisterBaseModel.h"
#import "GetorgbyregisterModel.h"
#import "Node.h"
#import "TreeTableView.h"

@interface TreeTableViewController ()<TreeTableCellDelegate> {
    
}


@property (nonatomic, strong) NSMutableArray *tempArray;
@property (nonatomic, assign) NSInteger location;
@property (nonatomic, assign) NSInteger tempDepth;
@property (nonatomic, copy) NSString *org;
@property (nonatomic, copy) NSString *orgId;
@end

@implementation TreeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"选择部门";
    self.view.backgroundColor = [UIColor whiteColor];
    [self createRightBarBtn];
    [self httpGetorgbyregister];
}
- (NSMutableArray *)tempArray {
    if (_tempArray == nil) {
        _tempArray = [NSMutableArray array];
    }
    return _tempArray;
}
- (void)createRightBarBtn {
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 50, 35);
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = ZEBFont(15);
    [button addTarget:self action:@selector(rightBtnG:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightBar;
    
}

- (void)selectCell {
    
    if ([self.org isEqualToString:@""]) {
        [self showHint:@"未选择任何单位"];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
    if (self.delegate &&[self.delegate respondsToSelector:@selector(selectUnit:orgStr:orgID:)]) {
        [_delegate selectUnit:self orgStr:self.org orgID:self.orgId];
    }
}

- (void)rightBtnG:(UIButton *)btn {
    
    if ([self.org isEqualToString:@""]) {
        [self showHint:@"未选择任何单位"];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
    if (self.delegate &&[self.delegate respondsToSelector:@selector(selectUnit:orgStr:orgID:)]) {
        [_delegate selectUnit:self orgStr:self.org orgID:self.orgId];
    }
    
//    if (_delegate && [_delegate respondsToSelector:@selector(selectOrgByRegister:orgStr:orgID:)]) {
//        [_delegate selectOrgByRegister:self orgStr:self.org orgID:self.orgId];
//    }
}
- (void)httpGetorgbyregister {
    
    [self showloadingName:@"正在加载"];
    [HYBNetworking getWithUrl:GetorgbyregisterUrl refreshCache:YES success:^(id response) {
        
        GetorgbyregisterBaseModel *baseModel = [GetorgbyregisterBaseModel getInfoWithData:response];
        
        [self.tempArray addObjectsFromArray:baseModel.results];
        [self configData:baseModel.results];
        [self hideHud];
    } fail:^(NSError *error) {
        
    }];
}
- (void)configData:(NSMutableArray *)array {
    
    NSMutableArray *dataArray = [NSMutableArray array];
    
    GetorgbyregisterModel *basemodel = [[GetorgbyregisterModel alloc] initWithParentId:@"003" Id:@"0" name:@"武汉市公安局" parent_id:@"-1"];
    
    [array insertObject:basemodel atIndex:0];
    [self.tempArray insertObject:basemodel atIndex:0];
    for (GetorgbyregisterModel *model in array) {
        
        [self getDepth:model depth:0];
        ZEBLog(@"%@--------%ld",model.name,self.tempDepth);
        if ([model.Id isEqualToString:@"0"]) {
            Node *node = [[Node alloc] initWithParentId:[model.parent_id integerValue] nodeId:[model.Id integerValue] name:model.name depth:self.tempDepth expand:YES];
            [dataArray addObject:node];
        }else {
            Node *node = [[Node alloc] initWithParentId:[model.parent_id integerValue] nodeId:[model.Id integerValue] name:model.name depth:self.tempDepth expand:NO];
            [dataArray addObject:node];
        }
        
    }
    
//    TreeTableView *tableview = [[TreeTableView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-64) withData:dataArray];
//    tableview.treeTableCellDelegate = self;
    
    TreeTableView *tableview = [[TreeTableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 300) withData:dataArray];
    tableview.treeTableCellDelegate = self;
    tableview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tableview];
}
- (void)getDepth:(GetorgbyregisterModel *)model depth:(NSInteger)depth {
    
    for (int i = 0; i < self.tempArray.count; i++) {
        GetorgbyregisterModel *model1 = self.tempArray[i];
        if ([model.parent_id isEqualToString:model1.Id]) {
            self.location = i;
            depth ++;
            break;
        }
    }
    GetorgbyregisterModel *model1 = self.tempArray[self.location];
    if (![model1.Id isEqualToString:@"0"]) {
        [self getDepth:model1 depth:depth];
    }else {
        self.tempDepth = depth;
        
    }
}
#pragma mark - TreeTableCellDelegate
-(void)cellClick:(Node *)node{
    self.org = node.name;
    self.orgId = [NSString stringWithFormat:@"%d",node.nodeId];
    NSLog(@"%@",node.name);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
