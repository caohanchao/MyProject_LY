//
//  AboutLieYingController.h
//  ProjectTemplate
//
//  Created by 绿之云 on 16/9/8.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "AboutLieYingController.h"
#import "UIView+Extension.h"
#import "UIView+Layout.h"

#define AboutLY @"        “猎鹰”移动侦查平台是武汉市公安局视频侦查支队主持研发的互联网移动终端APP软件,是视频网与互联网沟通的桥梁。\n        “猎鹰”致力于建立横向覆盖多种警务，如侦查、对抗、巡控、安保、盘查等，纵向服务多类人群，如市、区、所警务及协勤人员的矩阵体系。\n        “猎鹰”通过安全边界，将视频网与互联网贯通。移动用户可使用“猎鹰”手机APP采集涉案的人脸、车牌、视频、点位等数据，直接上传至视频网各类业务平台。也可通过手机APP查看城市监控视频、人脸识别结果、车辆卡口信息、全局案件资料库等数据，运用“摇一摇”功能查看周边的视频点位、基站、警务人员等信息。\n        现阶段，“猎鹰”完成视频侦查、实时对抗模块。基于时间、空间、事件的SMT模型展现界面，实现建群建任务、点名签到、在线交流、图片采集、视频采集、人员定位、轨迹生成、卡口查询、人脸识别等功能。"
#define SEH 99

@interface AboutLieYingController ()<UIScrollViewDelegate>


@property (nonatomic, weak) UIScrollView *scroll;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation AboutLieYingController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"关于猎鹰";
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self createBgScrollView];
    
    NSString *imageStr=[NSString stringWithFormat:@"%@",@"logo"];
    UIImage *image=[UIImage imageNamed:imageStr];
    UIImageView *imageView=[[UIImageView alloc]init];
    imageView.image=image;
    imageView.frame=CGRectMake(kScreenWidth/2-55+12.5, 50, 110, 115);
    [_scrollView addSubview:imageView];
   
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2-40, maxY(imageView), 80, 20)];
    titleLabel.text = @"猎鹰";
    titleLabel.textColor = CHCHexColor(@"000000");
    titleLabel.font = ZEBFont(14);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_scrollView addSubview:titleLabel];
    
    CGFloat screenH = kScreenHeight;
    if (ZEBiPhone5_OR_5c_OR_5s) {
        screenH = kScreenHeight+SEH;
    }
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(20, maxY(titleLabel)+25, kScreenWidth-40, screenH-(maxY(titleLabel)+25)-40)];
    self.textView.showsVerticalScrollIndicator = NO;
    self.textView.showsHorizontalScrollIndicator = NO;
    self.textView.editable = NO;
    self.textView.attributedText = [LZXHelper setLineSpace:AboutLY lineSpace:3];
    self.textView.font = ZEBFont(13);
    self.textView.textColor = CHCHexColor(@"000000");
    [_scrollView addSubview:self.textView];

//    UILabel *label=[[UILabel alloc]init];
//    label.frame=CGRectMake(0,imageView.bottom+10, self.view.width, 20);
//    NSString *executableFile =[[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleNameKey];
//    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    label.font=ZEBFont(17);
//    label.text=[NSString stringWithFormat:@"%@ V%@",executableFile,version];
//    label.textColor=[UIColor grayColor];
//    label.textAlignment=NSTextAlignmentCenter;
//    [self.view addSubview:label];
//    
//    UILabel *companyLab=[[UILabel alloc]init];
//    companyLab.frame=CGRectMake(0,self.view.bottom-15-40, self.view.width, 15);
//    companyLab.font=ZEBFont(12);
//    companyLab.text=@"深圳绿之云公司 版权所有";
//    companyLab.textColor=[UIColor grayColor];
//    companyLab.textAlignment=NSTextAlignmentCenter;
//    [self.view addSubview:companyLab];
//    
//    UILabel *compyRight=[[UILabel alloc]init];
//    compyRight.numberOfLines=0;
//    compyRight.frame=CGRectMake(0,companyLab.bottom+5, self.view.width,30);
//    compyRight.font=ZEBFont(12);
//    compyRight.text=@"Copyright ©️ 2016-2017 Shenzhen Green Cloud Technology Co.,Ltd.";
//    compyRight.textColor=[UIColor grayColor];
//    compyRight.textAlignment=NSTextAlignmentCenter;
//    [self.view addSubview:compyRight];
//    self.imageArray=@[@"about_falcon_1",@"about_falcon_2",@"about_falcon_3",@"about_falcon_4"];
//    self.view.backgroundColor=[UIColor blackColor];
//    UIScrollView *scrol=[[UIScrollView alloc]init];
//    scrol.frame=self.view.bounds;
//    _scroll=scrol;
//    [self.view addSubview:scrol];
//    CGFloat scrolWidth=scrol.frame.size.width;
//    CGFloat scrolHeight=scrol.frame.size.height;
//    for (int i=0; i<self.imageArray.count; i++) {
//        UIImageView *imageView=[[UIImageView alloc]init];
//        NSString *imageStr=[NSString stringWithFormat:@"%@",_imageArray[i]];
//        UIImage *image=[UIImage imageNamed:imageStr];
//        CGFloat x=i*scrol.frame.size.width+5;
//        imageView.frame=CGRectMake(x,0, scrolWidth-10, scrolHeight);
//        imageView.image=image;
//        imageView.contentMode=UIViewContentModeTop;
//        [scrol addSubview:imageView];
//    }
//    //设置滚动范围
//    scrol.contentSize=CGSizeMake(self.imageArray.count*scrolWidth, 0);
//    scrol.bounces=NO;
//    scrol.pagingEnabled=YES;
//    //隐藏水平滚动条
//    scrol.showsHorizontalScrollIndicator=NO;
    
}
#pragma mark -
#pragma mark 创建底层ScrollView
- (void)createBgScrollView {
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.delegate = self;
    _scrollView.directionalLockEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
}
//解决UIScrollView不滚的问题
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if (ZEBiPhone5_OR_5c_OR_5s) {
     _scrollView.contentSize = CGSizeMake(kScreenWidth,kScreenHeight+SEH);
    }
}
@end
