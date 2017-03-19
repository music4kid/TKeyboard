//
//  SyncHostCell.m
//  EasyTextForiOS
//
//  Created by gao feng on 2016/10/30.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "SyncHostCell.h"
#import "MCManager.h"
#import "ESharedUserDefault.h"

@implementation SyncHostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateDisplayName:(NSString*)name {
	_lbName.text = name;
    
    _imgSelect.hidden = true;
    NSString* chosenHost = [[ESharedUserDefault sharedInstance] getSyncHost];
    if ([chosenHost isEqualToString:name]) {
        _imgSelect.hidden = false;
    }
}



@end
