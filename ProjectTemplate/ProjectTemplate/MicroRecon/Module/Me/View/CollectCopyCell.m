//
//  CollectCopyCell.m
//  WCLDConsulting
//
//  Created by apple on 16/4/26.
//  Copyright © 2016年 Shondring. All rights reserved.
//

#import "CollectCopyCell.h"

@implementation CollectCopyCell {
    UILabel *_label;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.frame = CGRectMake(0, 0, kScreen_Width, 0);
        [self createUI];
    }
    return self;
}
- (void)createUI {

    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 40)];
    _label.font = [UIFont systemFontOfSize:15];
    _label.textColor = [UIColor darkGrayColor];
    _label.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_label];
    
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, kScreen_Width, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    line.alpha = 0.25;
    [self.contentView addSubview:line];
    
}
- (void)setString:(NSString *)string {
    _string = string;
    [_label setText:self.string];
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
