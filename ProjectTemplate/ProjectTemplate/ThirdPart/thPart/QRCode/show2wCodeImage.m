//
//  show2wCodeImage.m
//  WCLDConsulting
//
//  Created by apple on 16/2/27.
//  Copyright © 2016年 Shondring. All rights reserved.
//

#import "show2wCodeImage.h"
#import "QRCodeGenerator.h"

#define  LeftView 10.0f
#define  TopToView 10.0f

@interface show2wCodeImage()

@property (nonatomic,strong) NSArray *selectData;
@property (nonatomic,copy) void(^action)(NSInteger index);
@property (nonatomic,strong) NSArray * imagesData;
@property (nonatomic,strong) NSMutableArray * seleFlag;


@property (nonatomic, assign) NSInteger seleTag;
@property (nonatomic, assign) NSInteger MasonayY;

@property (nonatomic, weak)UIView * view2w;

@property (nonatomic, weak) UIButton * btn;


@end

show2wCodeImage * backgroundView;

@implementation show2wCodeImage




- (instancetype)init{
    if (self = [super init]) {
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}


+ (void)addPellTableViewSelectWithWindowFrame:(CGRect)frame
                                   selectData:(NSArray *)selectData
                                     MasonayY:(NSInteger)MasonayY
                                       action:(void(^)(NSInteger index))action animated:(BOOL)animate selectdidFlag:(NSInteger)seleFlag

{
    if (backgroundView != nil) {
        [show2wCodeImage hiden];
    }
    UIWindow *win = [[[UIApplication sharedApplication] windows] firstObject];
    
    backgroundView = [[show2wCodeImage alloc] initWithFrame:win.bounds];
    backgroundView.action = action;
    
    backgroundView.selectData = selectData;
    backgroundView.MasonayY = MasonayY;
    
    backgroundView.seleTag = seleFlag;
    //backgroundView.seleFlag = [NSMutableArray arrayWithArray:seleFlag];
    
    backgroundView.backgroundColor = [UIColor colorWithHue:0
                                                saturation:0
                                                brightness:0 alpha:1];
    [win addSubview:backgroundView];
    
    // TAB
    
    UIView * whitebgView = [[UIView alloc]init];
    backgroundView.view2w = whitebgView;
    whitebgView.backgroundColor = [UIColor whiteColor];
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    
    
    UIButton * show2w = [[UIButton alloc]init];
    backgroundView.btn = show2w;
    show2w.adjustsImageWhenHighlighted = NO;
    
    [show2w addTarget:self action:@selector(tapBackgroundClick) forControlEvents:UIControlEventTouchUpInside];
   
    UIImage *image = [ZEBCache myCodeCacheAlarm:alarm];
    [show2w setImage:image forState:UIControlStateNormal];
      
    [win addSubview:whitebgView];
    [whitebgView addSubview:show2w];
    
    
    [whitebgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kScreen_Width - 100, kScreen_Width - 100));
        
    }];
    
    [show2w mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackgroundClick)];
    [backgroundView addGestureRecognizer:tap];
    backgroundView.action = action;
    backgroundView.selectData = selectData;
    //    tableView.layer.anchorPoint = CGPointMake(100, 64);
    
    
    if (animate == YES) {
        backgroundView.alpha = 0;
        //        tableView.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 80, 70, frame.size.width, 40 * selectData.count);
        [UIView animateWithDuration:0.3 animations:^{
            backgroundView.alpha = 0.1;
            //tableView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            
        }];
    }
    
    
    // mas适配
    

    
    
}
+ (void)tapBackgroundClick
{
    [show2wCodeImage hiden];
}
+ (void)hiden
{
    if (backgroundView != nil) {
        
        [UIView animateWithDuration:0.3 animations:^{
            //            UIWindow * win = [[[UIApplication sharedApplication] windows] firstObject];
            //            tableView.frame = CGRectMake(win.bounds.size.width - 35 , 64, 0, 0);
            //tableView.transform = CGAffineTransformMakeScale(0.000001, 0.0001);
            
        } completion:^(BOOL finished) {
            
            [backgroundView removeFromSuperview];
            
            [backgroundView.view2w removeFromSuperview];
            [backgroundView.btn removeFromSuperview];
            
            backgroundView.view2w = nil;
            backgroundView.btn  = nil;
            backgroundView = nil;
        }];
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
