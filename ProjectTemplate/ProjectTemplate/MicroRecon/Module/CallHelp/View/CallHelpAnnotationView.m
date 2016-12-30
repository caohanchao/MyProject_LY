//
//  CallHelpAnnotationView.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/12/26.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "CallHelpAnnotationView.h"
#import "PulsingHaloLayer.h"

@interface CallHelpAnnotationView ()
@property (nonatomic, strong) PulsingHaloLayer *pulsingHaloLayer;
@end

@implementation CallHelpAnnotationView

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.frame = CGRectMake(0, 0, 27, 27);
        self.image = [UIImage imageNamed:@"callhelp_userlocation"];
        [self addPulsingHaloLayer];
        [self dissmissPulsingHaloLayer];
    }
    
    return self;
}
- (void)showPulsingHaloLayer {
    [self.pulsingHaloLayer setHidden:NO];
}
- (void)dissmissPulsingHaloLayer {
    [self.pulsingHaloLayer setHidden:YES];
}
- (void)addPulsingHaloLayer {
    self.pulsingHaloLayer.position = self.center;
    [self.layer insertSublayer:self.pulsingHaloLayer below:self.layer];
}
- (void)removePulsingHaloLayer {
    [self.pulsingHaloLayer removeFromSuperlayer];
}
- (PulsingHaloLayer *)pulsingHaloLayer {
    if (!_pulsingHaloLayer) {
        _pulsingHaloLayer = [PulsingHaloLayer layer];
        _pulsingHaloLayer.radius = 150;
        _pulsingHaloLayer.color = CHCHexColor(@"ee4444");
    }
    return _pulsingHaloLayer;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
