//
//  GroupDesHeaderView.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/24.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "GroupDesHeaderView.h"
#import "GroupMemberModel.h"
#import "UIButton+Layout.h"
#import "UIButton+EnlargeEdge.h"

#define btnHeight 50
#define TopMargin 15

#define TopViewHeight 152 //152


@interface GroupDesHeaderView ()


@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;
@end

@implementation GroupDesHeaderView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView {

    static NSString *ID = @"header";
    GroupDesHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        header = [[GroupDesHeaderView alloc] initWithReuseIdentifier:ID];
    
       
    }
    return header;

}

/**
*  在这个初始化方法中,MJHeaderView的frame\bounds没有值
*/
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        UIView *view = [[UIView alloc] initWithFrame:self.bounds];
        view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.backgroundView = view;
        
    }
    return self;
}
- (void)createView {

    
    CGFloat margin = 70;
    CGFloat leftMargin = 40;
    CGFloat topMargin = 20;
    CGFloat widthh = (kScreenWidth-leftMargin*2 - margin*3)/4;
    CGFloat heightt = widthh;
    CGFloat labelHeight = 40;
    CGFloat topviewHeight = topMargin+(heightt+labelHeight)*2;
    
    _topView.frame = CGRectMake(0, 0, kScreenWidth, topviewHeight);
    
    [self addSubview:self.topView];
    
    
    NSInteger memberCount = self.dataArray.count + 2;
    if (memberCount > ShowMemberCount) {
        memberCount = ShowMemberCount;
    }
    NSInteger count;
    if (memberCount%5 == 0) {
        count = memberCount/5;
    }else {
        count = memberCount/5 + 1;
    }
     CGFloat height = (btnHeight + TopMargin + 15)*count + 60;
    
    self.bottomView.frame =  CGRectMake(0, maxY(_topView)+17, kScreenWidth, height+0.5);
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.bottomView];
    
    
}
- (void)addTopButton {
    
    
    //解决复用问题
    for (UIView *view in [self.topView subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
    }
    
    NSArray *imageArray = [NSArray array];
    NSArray *imageSelectArray = [NSArray array];
    NSArray *titleArray = [NSArray array];
    if ([self.type isEqualToString:@"0"]) {
        imageArray = @[@"gonggao",@"wenjian",@"quntupian",@"icon_blogosphere",@"qunjilu",@"gongzuolist",@"biaoqian",@"more1"];
        imageSelectArray = @[@"gonggao_sellect",@"wenjian_sellect",@"quntupian_sellect",@"icon_blogosphere_click",@"qunjilu_sellect",@"gongzuolist_sellect",@"biaoqian_sellect",@"more1_sellect"];
        titleArray = @[@"群公告",@"群文件",@"群图片",@"集合圈",@"群记录",@"工作表",@"标签",@"更多"];
    }else {
        imageArray = @[@"gonggao",@"wenjian",@"quntupian",@"icon_blogosphere",@"more1"];
        imageSelectArray = @[@"gonggao_sellect",@"wenjian_sellect",@"quntupian_sellect",@"icon_blogosphere_click",@"more1_sellect"];
        titleArray = @[@"群公告",@"群文件",@"群图片",@"集合圈",@"更多"];
    }
    
    CGFloat margin = 70;
    CGFloat leftMargin = 40;
    CGFloat topMargin = 20;
    CGFloat widthh = (kScreenWidth-leftMargin*2 - margin*3)/4;
    CGFloat heightt = widthh;
    CGFloat labelHeight = 40;
    for (int i = 0;i < imageArray.count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(leftMargin+(widthh+margin)*(i%4), topMargin+(heightt+labelHeight)*(i/4), widthh, heightt);
        [btn setEnlargeEdgeWithTop:15 right:30 bottom:15 left:30];
        btn.backgroundColor = [UIColor whiteColor];
        //[btn setTitle:titleArray[i] forState:UIControlStateNormal];
        //[btn setTitleColor:[UIColor grayColor]];
        UIImage *image = [UIImage imageNamed:imageArray[i]];
        UIImage *selectImage = [UIImage imageNamed:imageSelectArray[i]];
        if (i == 5) {
            btn.userInteractionEnabled = YES;
            btn.selected = YES;
        }else {
            btn.userInteractionEnabled = NO;
        }
        [btn setImage:image forState:UIControlStateNormal];
        [btn setImage:selectImage forState:UIControlStateSelected];
        btn.tag = 100000+i;
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 15)];
        titleLabel.center = CGPointMake(midX(btn), maxY(btn)+20);
        titleLabel.text = titleArray[i];
        titleLabel.textColor = [UIColor grayColor];
        titleLabel.font = ZEBFont(10);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.topView addSubview:titleLabel];
        [self.topView addSubview:btn];
    }
    
}
- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    [self createView];
    [self createUI];
    [self addTopButton];
    
}
- (void)createUI {
//解决复用问题
    for (UIView *view in [self.bottomView subviews]) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:[UILabel class]]) {
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
        
    }
    NSInteger count = self.dataArray.count + 2;
    if (count > ShowMemberCount) {
        count = ShowMemberCount;
    }
    
    CGFloat margin = (kScreen_Width - 5*btnHeight)/6;
    
    UIButton *btnclick = [UIButton buttonWithType:UIButtonTypeCustom];
    btnclick.frame =CGRectMake(0, 0, self.bottomView.bounds.size.width, 40);
    [btnclick addTarget:self action:@selector(groupMemberClick) forControlEvents:UIControlEventTouchUpInside];
    

    [btnclick setTitleColor:[UIColor blackColor]];
//    btnclick.titleLabel.font = [UIFont systemFontOfSize:15];
    
    CGPoint center = btnclick.center;
    
    UILabel *lab = [UILabel new];
    lab.text = @"全部群成员";
    lab.font = [UIFont systemFontOfSize:14];
    lab.frame =CGRectMake(12 ,5, 120, 30);
    
    [btnclick addSubview:lab];
    
    
    UIImageView *img =[UIImageView initWithImage:[UIImage imageNamed:@"go_right"] frame:CGRectMake(btnclick.frame.size.width - 10 - 12, 12.5, 10, 15)];
//    lab.center.y = btnclick.center.y;
    [btnclick addSubview:img];
    
    [self.bottomView addSubview:btnclick];
    
    
    for (int i = 0; i < count; i++) {
       
        
            UIImageView *btn = [[UIImageView alloc] initWithCornerRadiusAdvance:5.f rectCornerType:UIRectCornerAllCorners];
            btn.frame = CGRectMake(margin + (btnHeight+margin)*(i%5), 45+TopMargin + (btnHeight +TopMargin + 15)*(i/5), btnHeight, btnHeight);
            UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(minX(btn), maxY(btn), width(btn.frame), 15)];
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = btnHeight/2;
            btn.contentMode = UIViewContentModeScaleAspectFill;
            btn.userInteractionEnabled = YES;
        
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClick:)];
        
            [btn addGestureRecognizer:tap];
        
            btn.tag = 10000+i;
        
        
        if (i == count - 2) {
            [btn setImage:[UIImage imageNamed:@"addGM"]];
            
            nameLabel.text = @"邀请";
            nameLabel.textColor = [UIColor colorWithRed:0.11 green:0.65 blue:0.90 alpha:1.00];
            nameLabel.font = ZEBFont(10);
            nameLabel.textAlignment = NSTextAlignmentCenter;
            [self.bottomView addSubview:nameLabel];

            
        }else if (i == count-1) {
            [btn setImage:[UIImage imageNamed:@"deleteGM"]];
            nameLabel.text = @"删除";
            nameLabel.textColor =[UIColor colorWithRed:0.98 green:0.61 blue:0.59 alpha:1.00];
            nameLabel.font = ZEBFont(10);
            nameLabel.textAlignment = NSTextAlignmentCenter;
            [self.bottomView addSubview:nameLabel];
        
        }else {
            if (i >= self.dataArray.count) {
                i = self.dataArray.count-1;
            }
            GroupMemberModel *model = self.dataArray[i];

            
           // [btn sd_setImageWithURL:[NSURL URLWithString:model.headpic] placeholderImage:[UIImage imageNamed:@"ph_s"]];
            [btn imageGetCacheForAlarm:model.ME_uid forUrl:model.headpic];
        


            nameLabel.text = model.ME_nickname;
            nameLabel.font = ZEBFont(10);
            nameLabel.textColor = [UIColor colorWithHexString:@"#808080"];
            nameLabel.textAlignment = NSTextAlignmentCenter;
            [self.bottomView addSubview:nameLabel];
        }
            [self.bottomView addSubview:btn];
        
    }
}
- (void)groupMemberClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(groupDesHeaderViewAllMember:)])
    {
        [_delegate groupDesHeaderViewAllMember:self];
    }

}

- (void)btnClick:(UITapGestureRecognizer *)recognizer {

    NSInteger tag = [recognizer view].tag - 10000;
    
    NSInteger count = self.dataArray.count + 2;
    
    
    if (count > ShowMemberCount) {
        count = ShowMemberCount;
    }
    if (tag == count - 2) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(groupDesHeaderViewAddMember:)]) {
            [_delegate groupDesHeaderViewAddMember:self];
        }
        
    }else if (tag == count - 1) {
        
        if (_delegate && [_delegate respondsToSelector:@selector(groupDesHeaderViewDeleteMember:)]) {
            [_delegate groupDesHeaderViewDeleteMember:self];
        }
    }else {
        
    if (_delegate && [_delegate respondsToSelector:@selector(groupDesHeaderView:gMemberModel:)]) {
        [_delegate groupDesHeaderView:self gMemberModel:self.dataArray[tag]];
    }

    }
}
- (void)click:(UIButton *)btn {

    if (_delegate && [_delegate respondsToSelector:@selector(groupDesHeaderView:type:)]) {
        [_delegate groupDesHeaderView:self type:btn.tag-100000];
    }
}
- (UIView *)topView {
    if (_topView == nil) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}
- (UIView *)bottomView {

    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] init];
    }
    return _bottomView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
