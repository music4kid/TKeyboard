//
//  EnableDeviceCell.m
//  TKeyboardForiOS
//
//  Created by gao feng on 2017/3/6.
//  Copyright © 2017年 music4kid. All rights reserved.
//

#import "EnableDeviceCell.h"

@interface EnableDeviceCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgDevice;
@property (weak, nonatomic) IBOutlet UILabel *lbDeviceName;
@property (weak, nonatomic) IBOutlet UIImageView *imgStatus;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@end

@implementation EnableDeviceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithEntry:(MainEntry*)entry  isLast:(BOOL)last{
    _lbDeviceName.text = entry.entryName;
    
    if (entry.deviceEnabled) {
        _imgStatus.image = [UIImage imageNamed:@"ic_enabled"];
    }
    else
    {
        _imgStatus.image = [UIImage imageNamed:@"ic_disabled"];
    }
    
    _bottomLine.hidden = last;
}

@end
