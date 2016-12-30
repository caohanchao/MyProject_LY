//
//  ZEBVoiceView.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/11/7.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "ZEBVoiceView.h"


@interface ZEBVoiceView () {
    CGPoint _tempPoint;
    NSInteger _endState;
}
@end

@implementation ZEBVoiceView

- (instancetype)initWithFrame:(CGRect)frame startBlock:(startRecordVoiceBlock)startBlock cancelBlock:(cancelRecordVoiceBlock)cancelBlock confimBlock:(confirmRecordVoiceBlock)confimBlock updateCancelBlock:(updateCancelRecordVoiceBlock)updateCancelBlock updateContinueBlock:(updateContinueRecordVoiceBlock)updateContinueBlock {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.startBlock = startBlock;
        self.cancelBlock = cancelBlock;
        self.confimBlock = confimBlock;
        self.updateCancelBlock = updateCancelBlock;
        self.updateContinueBlock = updateContinueBlock;
        self.userInteractionEnabled = YES;
        
        UILongPressGestureRecognizer *presss = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:presss];
    
    }
    return self;
}


- (void)longPress:(UILongPressGestureRecognizer *)press {
    switch (press.state) {
        case UIGestureRecognizerStateBegan : {
            NSLog(@"began");
            _endState = 1;
            self.startBlock(self);
            break;
        }
        case UIGestureRecognizerStateChanged: {
            NSLog(@"change;");
            
            CGPoint point = [press locationInView:self];
            if (self.isNoContains) {
                if (point.y < _tempPoint.y - 10) {
                    _endState = 0;
                    self.updateCancelBlock(self);
                    if (!CGPointEqualToPoint(point, _tempPoint) && point.y < _tempPoint.y - 8) {
                        _tempPoint = point;
                    }
                } else if (point.y > _tempPoint.y + 10) {
                    _endState = 1;
                    self.updateContinueBlock(self);
                    
                    if (!CGPointEqualToPoint(point, _tempPoint) && point.y > _tempPoint.y + 8) {
                        _tempPoint = point;
                    }
                }
            }else {
                if (CGRectContainsPoint(self.frame, point)) {
                    _endState = 1;
                    self.updateContinueBlock(self);
                }else {
                    _endState = 0;
                    self.updateCancelBlock(self);
                }
            }
            ZEBLog(@"%@", NSStringFromCGPoint(point));
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled: {
            NSLog(@"cancel, end");
            [self endPress];
            break;
        }
        case UIGestureRecognizerStateFailed: {
            NSLog(@"failed");
            break;
        }
        default: {
            break;
        }
    }
}
- (void)endPress {
    switch (_endState) {
        case 0: {
            NSLog(@"取消发送");
            self.cancelBlock(self);
            break;
        }
        case 1: {
            NSLog(@"发送");
            self.confimBlock(self);
            break;
        }
        default:
            break;
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
