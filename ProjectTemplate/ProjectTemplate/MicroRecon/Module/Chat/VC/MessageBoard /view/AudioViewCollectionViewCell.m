//
//  AudioViewCollectionViewCell.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 17/1/17.
//  Copyright © 2017年 Jomper Studio. All rights reserved.
//

#import "AudioViewCollectionViewCell.h"
#import "AudioView.h"

@interface AudioViewCollectionViewCell ()<AudioViewDelegate>

@property (nonatomic, strong) AudioView *audioView;

@end

@implementation AudioViewCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        [self createUI];
        
    }
    return self;
}
- (void)createUI {
    self.audioView = [[AudioView alloc] initWithFrame:self.bounds];
    self.audioView.delhidden = YES;
    self.audioView.delegate = self;
    [self.contentView addSubview:self.audioView];
    
    
}
- (void)setAudioUrl:(NSString *)audioUrl {
    _audioUrl = audioUrl;
    _audioView.audioStr = _audioUrl;
}
- (void)setRow:(NSInteger)row {
    _row = row;
    self.audioView.tag = [[NSString stringWithFormat:@"%ld%ld",self.row,self.index] integerValue] + 100000;
}
- (void)audioViewPlayAudio:(AudioView *)view index:(NSInteger)index audio:(NSURL *)url {
    NSMutableDictionary *parm = [NSMutableDictionary dictionary];
    parm[@"index"] = [NSString stringWithFormat:@"%ld%ld",self.row,self.index];
    parm[@"audioUrl"] = url;
    
    [LYRouter openURL:@"ly://MessageBoardViewControllerplayAudio" withUserInfo:parm completion:^(id result) {
        
    }];
}
@end
