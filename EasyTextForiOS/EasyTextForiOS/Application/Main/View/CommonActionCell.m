//
//  CommonActionCell.m
//  EasyTextForiOS
//
//  Created by gao feng on 2016/10/28.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "CommonActionCell.h"

@interface CommonActionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@end

@implementation CommonActionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithEntry:(MainEntry*)entry isLast:(BOOL)last {
    _lbName.text = entry.entryName;
    
    if (entry.entryType == EntryTypeAboutUs) {
        _imgIcon.image = [UIImage imageNamed:@"about"];
    }
    else if (entry.entryType == EntryTypeKeyboardGuide) {
        _imgIcon.image = [UIImage imageNamed:@"guide"];
    }
    else if (entry.entryType == EntryTypeReview) {
        _imgIcon.image = [UIImage imageNamed:@"star"];
    }
    
    _bottomLine.hidden = last;
}



@end
