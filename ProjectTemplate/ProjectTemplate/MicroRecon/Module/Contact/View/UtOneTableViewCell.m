//
//  UtOneTableViewCell.m
//  ProjectTemplate
//
//  Created by zeb－Apple on 16/8/17.
//  Copyright © 2016年 Jomper Studio. All rights reserved.
//

#import "UtOneTableViewCell.h"

@implementation UtOneTableViewCell



+ (instancetype)cellWithTableView:(UITableView *)tableView {
    
    static NSString *ID = @"friend";
    UtOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UtOneTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        
    }
    return cell;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.font = ContactFont;
    }
    return self;
}

- (void)setFriendData:(UnitListModel *)friendData {
    
    _friendData = friendData;
    
    self.textLabel.text = friendData.DE_name;
    
    
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
