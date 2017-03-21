//
//  CreateGroupController.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/22.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "MyQRCodeView.h"
#import "UIView+Layout.h"

#import "QRCodeGenerator.h"

#define QRViewMargin 20

@implementation MyQRCodeView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setupContentView];
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.layer.cornerRadius = 10;
    }
    return self;
}

- (void)setupContentView {
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(QRViewMargin, QRViewMargin, 60, 60)];
   
    icon.layer.cornerRadius = 10;
    icon.clipsToBounds = YES;
    icon.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:icon];
    self.icon = icon;
    
    UILabel *name = [[UILabel alloc] init];
   
    name.left = CGRectGetMaxX(icon.frame) + 10;
    name.width = 100;
    name.height = 30;
    name.top = icon.top;
    name.font = ZEBFont(18);
    name.textColor = [UIColor blackColor];
    [self addSubview:name];
    self.name = name;
    
    UILabel *address = [[UILabel alloc] init];
    
    address.top = CGRectGetMaxY(name.frame);
    address.width = 200;
    address.height = 30;
    address.left = name.left;
    
    address.textColor = [UIColor lightGrayColor];
    [self addSubview:address];
    self.address = address;
  
    
    UIImageView *qrImg = [[UIImageView alloc] init];
    qrImg.top = CGRectGetMaxY(icon.frame) + 10;
    qrImg.left = QRViewMargin;
    qrImg.width = self.width - QRViewMargin * 2;
    qrImg.height = qrImg.width;
    qrImg.layer.borderColor = [UIColor lightGrayColor].CGColor;
    qrImg.layer.borderWidth = 0.5;
    qrImg.layer.cornerRadius = 10;
    qrImg.clipsToBounds = YES;
    [self addSubview:qrImg];
    self.qrImg = qrImg;
     _qrImg.contentMode = UIViewContentModeScaleAspectFit;
    
//#warning ---正式时可以把字符串换成自己的个人主页url等...
//    qrImg.image = [QRCodeGenerator qrImageForString:@"https://www.baidu.com" imageSize:self.width - QRViewMargin * 4];
    
    UIImageView *appIcon = [[UIImageView alloc] init];
    //appIcon.image = [UIImage imageNamed:@"1"];
    appIcon.x = self.width * 0.5 - 25;
    appIcon.y = qrImg.y + qrImg.height * 0.5 - 25;
    appIcon.width = 50;
    appIcon.height = 50;
    appIcon.layer.cornerRadius = 25;
    appIcon.clipsToBounds = YES;
    
    [self addSubview:appIcon];
    
    self.appIcon = appIcon;
    
    
//    UILabel *tipLabel = [[UILabel alloc] init];
//    tipLabel.left = 0;
//    tipLabel.top = CGRectGetMaxY(qrImg.frame) + 10;
//    tipLabel.width = self.width;
//    tipLabel.height = 30;
//    tipLabel.textColor = [UIColor lightGrayColor];
//    tipLabel.font = [UIFont systemFontOfSize:14];
//    
//    [self addSubview:tipLabel];
//    tipLabel.textAlignment = NSTextAlignmentCenter;
}
/**
 *  个人详情
 *
 *  @param nameStr 群详情
 */
- (void)setNameStr:(NSString *)nameStr {
    _nameStr = nameStr;
    [self reloadDataUser];
}
/**
 *  群详情
 *
 *  @param gModel 群详情
 */
- (void)setGModel:(GroupDesModel *)gModel {

    _gModel = gModel;
    [self reloadDataGroup];
}

- (void)reloadDataGroup {
    
    NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
    

    if ([ZEBCache groupCodeFileExistsAtGid:_gModel.gid]) {
        _qrImg.image = [ZEBCache groupCodeCacheGid:_gModel.gid];
    }
    else {
        NSString *type = @"2";
        NSString *qrStr =  [NSString stringWithFormat:@"{\"type\":\"%@\",\"gid\":\"%@\",\"gname\":\"%@\",\"gtype\":\"%@\",\"alarm\":\"%@\"}",type,_gModel.gid,_gModel.gname,_gModel.gtype,alarm];
        _qrImg.image = [QRCodeGenerator qrImageForString:qrStr imageSize:self.width - QRViewMargin*4];
        
        [ZEBCache groupCodeCacheImage:_qrImg.image gid:_gModel.gid];
    }
    
    NSString *imageStr = @"";
    switch ([_gModel.gtype integerValue]) {
        case 0:
            // imageStr = @"group_zhencha";
            imageStr = @"G_zhencha";
            break;
        case 1:
            // imageStr = @"group_qunliao";
            imageStr = @"G_zudui";
            break;
        case 2:
            // imageStr = @"group_anbao";
            imageStr = @"G_pancha";
            break;
        case 3:
            //imageStr = @"group_xunkong";
            imageStr = @"G_xunkong";
            break;
        case 4:
            //  imageStr = @"group_sos";
            imageStr = @"G_zengyuan";
            break;
        case 5:
            imageStr = @"G_duikang";
            break;
            
        default:
            break;
    }
    
    _icon.image = [UIImage imageNamed:imageStr];
    
    _name.text = _gModel.gname;
    
    _name.frame = CGRectMake(maxX(_icon)+10, QRViewMargin + 15, 150, 30);
}

- (void)reloadDataUser {

    
        NSString *alarm = [[NSUserDefaults standardUserDefaults] objectForKey:@"alarm"];
        
        
        if ([ZEBCache myCodeFileExistsAtAlarm:alarm]) {
            _qrImg.image = [ZEBCache myCodeCacheAlarm:alarm];
        }else {
            NSString *type = @"1";
            NSString *qrStr =  [NSString stringWithFormat:@"{\"key\":\"%@\",\"type\":\"%@\"}",alarm,type];
            _qrImg.image = [QRCodeGenerator qrImageForString:qrStr imageSize:self.width - QRViewMargin * 4];
            [ZEBCache nyCodeCacheImage:_qrImg.image alarm:alarm];
        }
        
        [_icon sd_setImageWithURL:[NSURL URLWithString:_iconStr] placeholderImage:nil];
        //[_appIcon sd_setImageWithURL:[NSURL URLWithString:_iconStr] placeholderImage:nil];
        _address.text = [NSString stringWithFormat:@"警号：%@",[[NSUserDefaults standardUserDefaults] objectForKey:UIUseralarm]];
        _name.text = _nameStr;
    }
        


    
    

@end
