//
//  SelectPosition.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/9/5.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "SelectPosition.h"


static SelectPosition *seleteManager = nil;

@interface SelectPosition ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>


@property (nonatomic,strong)UITableView *tableView;

@property (nonatomic,strong)UIView *backGrandView;

@property (nonatomic,strong)NSArray *postsArray;

@property (nonatomic,strong)NSArray *postsNumsArray;
@end

@implementation SelectPosition


+(instancetype)sigle
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        seleteManager = [[SelectPosition alloc]init];
        
    });
    return seleteManager;
}
- (NSArray *)postsArray {

    if (_postsArray == nil) {
        _postsArray = @[@"支队长",@"政委",@"副支队",@"大队长",@"教导员",@"副大队",@"中队长",@"副中队",@"所长",@"副所",@"民警",@"协警"];
    }
    return _postsArray;
}
- (NSArray *)postsNumsArray {
    
    if (_postsNumsArray == nil) {
        _postsNumsArray = @[@"12",@"15",@"14",@"1",@"2",@"3",@"17",@"18",@"21",@"22",@"19",@"20"];
    }
    return _postsNumsArray;
}
-(UITableView *)tableView
{
    if (_tableView)
    {
        return _tableView;
    }
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.layer.cornerRadius = 8.0f;
    
    return _tableView;
}
-(UIView *)backGrandView
{
    if (_backGrandView)
    {
        return _backGrandView;
    }
    _backGrandView = [[UIView alloc]init];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    tap.delegate = self;
    [_backGrandView addGestureRecognizer:tap];
    
    return _backGrandView;
}
-(void)show
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.backGrandView.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.backGrandView addSubview:self.tableView];
    
    self.backGrandView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.4];
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    
    self.tableView.center = window.center;
    
    self.tableView.bounds = CGRectMake(0, 0, screenSize.width*0.8f, screenSize.height*0.6f);
    self.tableView.center = self.backGrandView.center;
    
    [window addSubview:self.backGrandView];
    
    [window bringSubviewToFront:self.backGrandView];
    [self showAnimation];
}
-(void)dismiss
{
    
    [self.tableView removeFromSuperview];
    [self.backGrandView removeFromSuperview];
    self.tableView = nil;
    self.backGrandView = nil;
}
#pragma mark animation
-(void)showAnimation
{
    self.tableView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.2 animations:^{
        
        self.tableView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        self.tableView.transform = CGAffineTransformMakeScale(1, 1);
    }];
}
-(void)dismissAnimation
{
    self.tableView.transform = CGAffineTransformMakeScale(1, 1);
    [UIView animateWithDuration:0.2 animations:^{
        
        self.tableView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        [self dismiss];
    }];
}

#pragma mark tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.postsArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
  
        cell.textLabel.text = self.postsArray[indexPath.row];
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if (_delegate && [_delegate respondsToSelector:@selector(selectThePosition:positionNum:)]) {
        [_delegate selectThePosition:self.postsArray[indexPath.row] positionNum:self.postsNumsArray[indexPath.row]];
    }
    [self dismissAnimation];
}
//添加手势
-(void)tap:(id)sender
{
    [self dismissAnimation];
    
}
//防止手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    // NSLog(@"%@", NSStringFromClass([touch.view class]));
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"])
    {
        return NO;
    }
    return  YES;
}

@end
