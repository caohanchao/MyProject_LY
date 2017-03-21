//
//  XMNChatFileMessageCell.m
//  ProjectTemplate
//
//  Created by caohanchao on 2017/3/14.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "XMNChatFileMessageCell.h"
#import "UIImage+TYHSetting.h"
@interface XMNChatFileMessageCell ()

@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *fileTitle;
@property (nonatomic, strong) UILabel *fileSize;
@property (nonatomic, strong) UILabel *fileState;

@end

@implementation XMNChatFileMessageCell


- (void)updateConstraints {
    [super updateConstraints];
    
    self.messageContentV.backgroundColor = [UIColor whiteColor];
    if (self.messageOwner == XMNMessageOwnerSelf) {
        
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.messageContentV.mas_left).with.offset(10);
            make.top.equalTo(self.messageContentV.mas_top).with.offset(8);
            make.bottom.equalTo(self.messageContentV.mas_bottom).with.offset(-8);
            make.width.equalTo(@60);
            make.height.equalTo(@60);
        }];
        
        [self.fileTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.icon.mas_right).with.offset(8);
            make.top.equalTo(self.icon.mas_top);
            make.right.equalTo(self.messageContentV.mas_right).with.offset(-16);
            make.width.offset(150);

        }];
        
        [self.fileSize mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.icon.mas_right).with.offset(8);
            make.bottom.equalTo(self.icon.mas_bottom);
            make.width.offset(60);
            make.height.offset(10);
        }];
        [self.fileState mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.messageContentV.mas_right).offset(-16);
            make.left.equalTo(self.fileSize.mas_right).offset(10);
            make.height.offset(10);
            make.bottom.equalTo(self.icon.mas_bottom);
        }];
        
        
    }else {
        [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.messageContentV.mas_left).with.offset(16);
            make.top.equalTo(self.messageContentV.mas_top).with.offset(8);
            make.bottom.equalTo(self.messageContentV.mas_bottom).with.offset(-8);
            make.width.equalTo(@60);
            make.height.equalTo(@60);
        }];
        
        [self.fileTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.icon.mas_right).with.offset(8);
            make.top.equalTo(self.icon.mas_top);
            make.right.equalTo(self.messageContentV.mas_right).with.offset(-8);
            make.width.offset(150);
//            make.height.offset(30);
        }];
        
        [self.fileSize mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.icon.mas_right).with.offset(8);
            make.bottom.equalTo(self.icon.mas_bottom);
            make.width.offset(60);
            make.height.offset(10);
        }];
        
        [self.fileState mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.messageContentV.mas_right).offset(-8);
            make.left.equalTo(self.fileSize.mas_right).offset(10);
            make.height.offset(10);
            make.bottom.equalTo(self.icon.mas_bottom);
        }];
    
    }
    
    
//    self.messageContentV.backgroundColor = [UIColor whiteColor];
//    
//    if (self.messageOwner == XMNMessageOwnerSelf) {
//        [self.locationIV mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.right.equalTo(self.messageContentV.mas_right).with.offset(-5);
//            make.left.equalTo(self.messageContentV.mas_left).with.offset(0);
//            make.top.equalTo(self.messageContentV.mas_top).with.offset(35);
//            make.bottom.equalTo(self.messageContentV.mas_bottom).with.offset(0);
//            make.width.offset(220);
//            make.height.offset(100);
//        }];
//        
//        [self.locationAddressL mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.left.equalTo(self.messageContentV.mas_left).with.offset(2);
//            make.top.equalTo(self.messageContentV.mas_top).with.offset(10);
//            make.width.offset(220);
//            make.right.equalTo(self.messageContentV.mas_right).with.offset(-7);
//            
//        }];
//        
//    }else if (self.messageOwner == XMNMessageOwnerOther) {
//        
//        [self.locationIV mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.right.equalTo(self.messageContentV.mas_right).with.offset(0);
//            make.left.equalTo(self.messageContentV.mas_left).with.offset(5);
//            make.top.equalTo(self.messageContentV.mas_top).with.offset(35);
//            make.bottom.equalTo(self.messageContentV.mas_bottom).with.offset(0);
//            make.width.offset(220);
//            make.height.offset(100);
//        }];
//        
//        [self.locationAddressL mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//            make.left.equalTo(self.messageContentV.mas_left).with.offset(7);
//            make.top.equalTo(self.messageContentV.mas_top).with.offset(10);
//            make.width.offset(220);
//            make.right.equalTo(self.messageContentV.mas_right).with.offset(-2);
//            
//        }];
//        
//    }
    
}

- (UILabel *)fileState {
    if (!_fileState) {
        _fileState = [[UILabel alloc] init];
        _fileState.textColor = [UIColor grayColor];
        _fileState.font = [UIFont systemFontOfSize:10.0f];
        _fileState.numberOfLines = 0;
        _fileState.backgroundColor =[UIColor whiteColor];
        _fileState.textAlignment = NSTextAlignmentRight;
        _fileState.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _fileState;
}

- (UILabel *)fileTitle {
    if (!_fileTitle) {
        _fileTitle = [[UILabel alloc] init];
        _fileTitle.textColor = [UIColor blackColor];
        _fileTitle.font = [UIFont systemFontOfSize:14.0f];
        _fileTitle.numberOfLines = 2;
        _fileTitle.backgroundColor =[UIColor whiteColor];
        _fileTitle.textAlignment = NSTextAlignmentLeft;
        _fileTitle.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _fileTitle;
}

- (UILabel *)fileSize {
    if (!_fileSize) {
        _fileSize = [[UILabel alloc] init];
        _fileSize.textColor = [UIColor grayColor];
        _fileSize.font = [UIFont systemFontOfSize:10.0f];
        _fileSize.numberOfLines = 0;
        _fileSize.backgroundColor =[UIColor whiteColor];
        _fileSize.textAlignment = NSTextAlignmentLeft;
        _fileSize.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _fileSize;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
    }
    return _icon;
}

#pragma mark - Setters

- (void)setUploadProgress:(CGFloat)uploadProgress {
    
    //通知主线程刷新
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setMessageSendState:XMNMessageSendStateSending];
        
//        [self.messageProgressView setFrame:CGRectMake(0, 0, self.messageImageView.bounds.size.width, self.messageImageView.bounds.size.height * (1 - uploadProgress))];
//        [self.messageProgressLabel setText:[NSString stringWithFormat:@"%.0f%%",uploadProgress * 100]];
    });
    
}

- (void)configureCellWithData:(id)data {
    [super configureCellWithData:data];
    
    NSString *message = data[kXMNMessageConfigurationFileKey];
    
    if ([message isKindOfClass:[CJFileObjModel class]]) {
        self.icon.image = [UIImage imageWithFileName:data[kXMNMessageConfigurationTextKey]];
        self.fileTitle.text = data[kXMNMessageConfigurationTextKey];
        self.fileSize.text = data[kXMNMessageConfigurationFileSizeKey];
    }else {
        
        if ([message rangeOfString:@"fileurl"].location != NSNotFound && [message rangeOfString:@"filesize"].location != NSNotFound ) {
            
            message = [message stringByReplacingOccurrencesOfString:@"\\\"" withString:@"\""];
            message = [message stringByReplacingOccurrencesOfString:@"\"{" withString:@"{"];
            message = [message stringByReplacingOccurrencesOfString:@"}\"" withString:@"}"];
            message = [message stringByReplacingOccurrencesOfString:@"\\\\/" withString:@"/"];
            NSData *jsondata = [message dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsondata
                                                                 options:NSJSONReadingMutableContainers error:nil];
            self.icon.image = [UIImage imageWithFileName:dict[@"filename"]];
            self.fileTitle.text = dict[@"filename"];
            self.fileSize.text = dict[@"filesize"];
            
            
        }
    }
    

    if (self.messageOwner == XMNMessageOwnerSelf) {
        self.fileState.text = @"已发送";
    }else {
        self.downloadState = [data[kXMNMessageConfigurationFileStateKey] integerValue];

    }
    
}

- (void)setDownloadState:(NSInteger)downloadState {
    _downloadState = downloadState;
    if (_downloadState == 0) {
        self.fileState.text = @"未下载";
    } else if(_downloadState == 1){
        self.fileState.text = @"正在下载";
    } else {
        self.fileState.text = @"已下载";
    }
}

- (void)setup {
    
    [self.messageContentV addSubview:self.icon];
    [self.messageContentV addSubview:self.fileTitle];
    [self.messageContentV addSubview:self.fileSize];
    [self.messageContentV addSubview:self.fileState];
    [super setup];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
