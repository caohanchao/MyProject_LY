//
//  WorkDesRightTableViewCell.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/10/14.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "WorkDesRightTableViewCell.h"
#import "ChatBusiness.h"
#import "IDMPhotoBrowser.h"
#import "ZEBIdentify2Code.h"
#import "XMNAVAudioPlayer.h"
#import "AudioView.h"
#import "VideoView.h"

#define TopMargin 10
#define leftMargin 5

@interface WorkDesRightTableViewCell ()<XMNAVAudioPlayerDelegate, AudioViewDelegate, VideoViewDelegate>


@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) IDMPhotoBrowser *browser;
@property (nonatomic, strong) NSMutableArray *videoArray;
@property (nonatomic, strong) NSMutableArray *pictureArray;
@property (nonatomic, strong) NSMutableArray *audioArray;
@end

@implementation WorkDesRightTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier widthModel:(WorkAllTempModel *)model {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.model = model;
        self.frame = CGRectMake(0, 0, kScreenWidth-100, 0);
        [XMNAVAudioPlayer sharePlayer].delegate = self;
        [self createUI];
        [self addImageView];
    }
    return self;
}

- (NSMutableArray *)videoArray {

    if (_videoArray == nil) {
        _videoArray = [NSMutableArray array];
    }
    return _videoArray;
}
- (NSMutableArray *)pictureArray {
    if (_pictureArray == nil) {
        _pictureArray = [NSMutableArray array];
    }
    return _pictureArray;
}
- (NSMutableArray *)audioArray {
    if (_audioArray == nil) {
        _audioArray= [NSMutableArray array];
    }
    return _audioArray;
}
- (void)createUI {

    self.titleLabel = [LZXHelper getLabelFont:ZEBFont(16) textColor:[UIColor blackColor]];
    self.titleLabel.text = self.model.title;
    self.contentLabel = [LZXHelper getLabelFont:ZEBFont(15) textColor:[UIColor grayColor]];
    self.contentLabel.text = self.model.content;
    self.contentLabel.numberOfLines = 3;
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(TopMargin);
        make.left.equalTo(self.mas_left).offset(leftMargin);
        make.height.equalTo(@30);
        make.width.mas_lessThanOrEqualTo(width(self.frame)-2*leftMargin);
    }];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(TopMargin);
        make.left.equalTo(self.titleLabel.mas_left);
        make.width.mas_lessThanOrEqualTo(width(self.frame)-2*leftMargin);
    }];
}
- (void)addImageView {

   ZEBLog(@"string------%@--------%@----------%@",self.model.picture,self.model.video,self.model.audio);
    if (![self.model.picture isEqualToString:@" "] && ![self.model.picture isEqualToString:@""]) {
        NSArray *pictures = [self.model.picture componentsSeparatedByString:@","];
        [self.pictureArray addObjectsFromArray:pictures];
    }
    if (![self.model.video isEqualToString:@" "] && ![self.model.video isEqualToString:@""]) {
        NSArray *videos = [self.model.video componentsSeparatedByString:@","];
        [self.videoArray addObjectsFromArray:videos];
    }
    if (![self.model.audio isEqualToString:@" "] && ![self.model.audio isEqualToString:@""]) {
        NSArray *audios = [self.model.audio componentsSeparatedByString:@","];
        [self.audioArray addObjectsFromArray:audios];
    }
   
    ZEBLog(@"------%@--------%@----------%@",self.pictureArray,self.videoArray,self.audioArray);
    
    NSInteger picCount = self.pictureArray.count;
    NSInteger videoCount = self.videoArray.count;
    NSInteger audioCount = self.audioArray.count;
    CGFloat leftM = 5;
    CGFloat centerM = 10;
    
    CGFloat topHeight = [LZXHelper textHeightFromTextString:self.model.content width:kScreenWidth-100-2*leftMargin fontSize:15] + 30 + 3*TopMargin;
    
    CGFloat btnW = (width(self.frame)-2*leftM-3*centerM)/4;
    CGFloat audioBtnW = kScreenWidth-100-10;
    CGFloat audioBtnH = 50;
    
    
        for (int i = 0; i < picCount; i++) {
            NSString *pic = self.pictureArray[i];
            if ([pic hasPrefix:@"http"]) {
            UIButton *picBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            picBtn.frame = CGRectMake(leftM+(btnW+centerM)*(i%4), topHeight+(btnW + centerM)*(i/4), btnW, btnW);
            
            [picBtn sd_setImageWithURL:[NSURL URLWithString:pic] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_loading_image"]];
            
            picBtn.contentMode = UIViewContentModeScaleAspectFill;
            picBtn.tag = 1000+i;
            [picBtn addTarget:self action:@selector(showPic:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:picBtn];
            }
        }
    if (picCount != 0 ) {
        if (picCount%4 == 0) {
            topHeight = topHeight + (btnW + centerM)*(picCount/4);
        }else {
            topHeight = topHeight + (btnW + centerM)*(picCount/4 + 1);
        }
      
    }
    for (int i = 0; i < videoCount; i++) {
        NSString *video = self.videoArray[i];
        if ([video hasPrefix:@"http"]) {
        VideoView *videoBtn = [[VideoView alloc] initWithFrame:CGRectMake(leftM+(btnW+centerM)*(i%4), topHeight+(btnW + centerM)*(i/4), btnW, btnW) widthVideoUrl:video];
        videoBtn.contentMode = UIViewContentModeScaleAspectFill;
        videoBtn.tag = 10000+i;
            videoBtn.delegate = self;
        //videoBtn.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:videoBtn];
        }
        
    }
    if (videoCount != 0) {
        if (videoCount%4 == 0) {
            topHeight = topHeight + (btnW + centerM)*(videoCount/4);
        }else {
            topHeight = topHeight + (btnW + centerM)*(videoCount/4 + 1);
        }
      
    }
    for (int i = 0; i < audioCount; i++) {
        NSString *audio = self.audioArray[i];
        AudioView *audioBtn = [[AudioView alloc] initWithFrame:CGRectMake(leftM, topHeight+(audioBtnH+centerM)*i, audioBtnW, audioBtnH)];
        audioBtn.audioStr = self.audioArray[i];
        audioBtn.index = 100000 + i;
        audioBtn.tag = 100000 + i;
        audioBtn.delegate = self;
        //audioBtn.backgroundColor = [UIColor blueColor];
        [self.contentView addSubview:audioBtn];
    }
    
}
//展示图片
- (void)showPic:(UIButton *)btn {

    NSInteger tag = btn.tag - 1000;
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    
    userInfo[@"index"] = [NSString stringWithFormat:@"%ld",tag];
    userInfo[@"photos"] = self.pictureArray;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showImagesNotification" object:nil userInfo:userInfo];
}
//播放视频
- (void)videoView:(VideoView *)view index:(NSInteger)index {
    NSInteger tag = view.tag - 10000;
    
    NSString *videoUrl = self.videoArray[tag];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"playVideoNotification" object:videoUrl];
}
//播放语音
- (void)audioViewPlayAudio:(AudioView *)view index:(NSInteger)index audio:(NSURL *)url {
    
    
    NSInteger tag = index - 100000;
    
    [[XMNAVAudioPlayer sharePlayer] playAudioWithURLString:[url absoluteString] atIndex:tag];
     
}

- (void)audioPlayerStateDidChanged:(XMNVoiceMessageState)audioPlayerState forIndex:(NSUInteger)index {
    
    AudioView *audioBtn = (AudioView *)[self.contentView viewWithTag:index+100000];
    dispatch_async(dispatch_get_main_queue(), ^{
        [audioBtn setVoiceMessageState:audioPlayerState];
    });
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
