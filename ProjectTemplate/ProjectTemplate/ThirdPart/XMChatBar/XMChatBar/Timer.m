//
//  Timer.m
//  Timer_test
//
//  Created by zeb－Apple on 16/12/29.
//  Copyright © 2016年 zeb－Apple. All rights reserved.
//

#import "Timer.h"
#import "XMNChatMessageCell.h"

@interface Timer ()

@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) NSMutableArray *dataSource;
@property (nonatomic, weak) NSMutableDictionary * dic;
@end

@implementation Timer

+ (instancetype)sharedTimer {
    static Timer *timer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timer = [[self alloc] init];
    });
    return timer;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        //   [self createTimer];
    }
    return self;
}
/// 回传时间的变化
-(void)countDownWithZEBBlock:(void (^)())ZEBBlock{
    if (_timer==nil) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                ZEBBlock(); // 回传时间的变化
            });
        });
        dispatch_resume(_timer); // 启动定时器
    }
}
- (void)countDownWithTableView :(UITableView *)tableView dataSource:(NSMutableArray *)dataSource {
    
    self.tableView = tableView;
    //  [self.dataSource removeAllObjects];
    self.dataSource = dataSource;
    
    if (self.timer == nil) {
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(self.timer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSArray *arr = tableView.visibleCells; //取出屏幕可见ceLl
                NSMutableArray  *tempCells = [NSMutableArray arrayWithArray:arr];
                
                [tempCells enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    
                    if ([obj isKindOfClass:[XMNChatMessageCell class]]) {
                        XMNChatMessageCell *cell1 = (XMNChatMessageCell *)obj;
                        NSString *str = cell1.fireMessageTimeLabel.text;
                        NSInteger i = [str integerValue];
                        NSString *string = [NSString stringWithFormat:@"%ld",--i];
                        cell1.fireMessageTimeLabel.text = string;
                        
                        if ([string integerValue] == 0) {
                            *stop = YES;
                            if (*stop == YES) {
                                [tempCells removeObject:cell1];
                            }
                            NSDictionary * dict = self.dataSource[cell1.index];
                            ICometModel * model = [[[DBManager sharedManager]MessageDAO]selectMessageByQid:[dict[kXMNMessageConfigurationQIDKey]integerValue]];
                            
                            if (![[LZXHelper isNullToString:dict[kXMNMessageConfigurationTimerStrKey]] isEqualToString:@""]) {
                                if (cell1.index <self.dataSource.count) {
                                    [self.dataSource removeObjectAtIndex:cell1.index];
                                }
                                
                                [[[DBManager sharedManager]MessageDAO]updateMsgfireUserlist:model.msGid fire:@"READ"];
                                [[[DBManager sharedManager]MessageDAO]updateMsgTimeUserlist:model.msGid fire:@""];
                                
                                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cell1.index inSection:0];
                                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                                [tableView reloadData];
                            }
                            
                        }else {
                            //  dic = self.dataSource[cell1.index];
                            _dic = dataSource[cell1.index];
                            _dic[kXMNMessageConfigurationTimerStrKey] = string;
                            if (cell1.index <self.dataSource.count)
                            {
                                [self.dataSource replaceObjectAtIndex:cell1.index withObject:_dic];
                            }
                            
                            if ([string integerValue] >0)
                            {
                                ICometModel * model = [[[DBManager sharedManager]MessageDAO]selectMessageByQid:[_dic[kXMNMessageConfigurationQIDKey]integerValue]];
                                [[[DBManager sharedManager]MessageDAO]updateMsgTimeUserlist:model.msGid fire:string];
                            }
                            
                        }
                    }
                    
                    if (*stop) {
                        
                        NSLog(@"array is %@",tempCells);
                        
                    }
                    
                }];
                
            });
        });
        dispatch_resume(_timer); // 启动定时器
    }
    else
    {
        dispatch_source_set_event_handler(self.timer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSArray *arr = tableView.visibleCells; //取出屏幕可见ceLl
                NSMutableArray  *tempCells = [NSMutableArray arrayWithArray:arr];
                
                [tempCells enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    
                    if ([obj isKindOfClass:[XMNChatMessageCell class]]) {
                        XMNChatMessageCell *cell1 = (XMNChatMessageCell *)obj;
                        NSString *str = cell1.fireMessageTimeLabel.text;
                        NSInteger i = [str integerValue];
                        NSString *string = [NSString stringWithFormat:@"%ld",--i];
                        cell1.fireMessageTimeLabel.text = string;
                        
                        if ([string integerValue] == 0) {
                            *stop = YES;
                            if (*stop == YES) {
                                [tempCells removeObject:cell1];
                            }
                            NSDictionary * dict = self.dataSource[cell1.index];
                            ICometModel * model = [[[DBManager sharedManager]MessageDAO]selectMessageByQid:[dict[kXMNMessageConfigurationQIDKey]integerValue]];
                            
                            if (![[LZXHelper isNullToString:dict[kXMNMessageConfigurationTimerStrKey]] isEqualToString:@""]) {
                                if (cell1.index <self.dataSource.count) {
                                    [self.dataSource removeObjectAtIndex:cell1.index];
                                }
                                
                                [[[DBManager sharedManager]MessageDAO]updateMsgfireUserlist:model.msGid fire:@"READ"];
                                [[[DBManager sharedManager]MessageDAO]updateMsgTimeUserlist:model.msGid fire:@""];
                                
                                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cell1.index inSection:0];
                                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                                [tableView reloadData];
                            }
                            
                        }else {
                            //  dic = self.dataSource[cell1.index];
                            _dic = dataSource[cell1.index];
                            _dic[kXMNMessageConfigurationTimerStrKey] = string;
                            if (cell1.index <self.dataSource.count)
                            {
                                [self.dataSource replaceObjectAtIndex:cell1.index withObject:_dic];
                            }
                            if ([string integerValue] >0)
                            {
                                ICometModel * model = [[[DBManager sharedManager]MessageDAO]selectMessageByQid:[_dic[kXMNMessageConfigurationQIDKey]integerValue]];
                                [[[DBManager sharedManager]MessageDAO]updateMsgTimeUserlist:model.msGid fire:string];
                            }
                            
                        }
                    }
                    
                    if (*stop) {
                        
                        NSLog(@"array is %@",tempCells);
                        
                    }
                    
                }];
                
            });
        });
    }
    
}

- (void)stop
{
    if (_timer) {
        dispatch_cancel(self.timer);
        _timer = nil;
    }
}

- (void)dealloc {
    dispatch_cancel(self.timer);
    _timer = nil;
}
@end
