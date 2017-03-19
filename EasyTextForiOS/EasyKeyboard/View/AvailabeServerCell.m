//
//  AvailabeServerCell.m
//  TKeyboardForiOS
//
//  Created by gao feng on 2017/3/10.
//  Copyright © 2017年 music4kid. All rights reserved.
//

#import "AvailabeServerCell.h"

@interface AvailabeServerCell ()
@property (weak, nonatomic) IBOutlet UIView *holder;
@property (weak, nonatomic) IBOutlet UIImageView *imgStatus;
@property (weak, nonatomic) IBOutlet UILabel *lbName;
@end

@implementation AvailabeServerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _holder.backgroundColor = [UIColor colorWithHex:0xdddddd];
    _holder.clipsToBounds = true;
    _holder.layer.cornerRadius = 10;
    _holder.layer.borderColor = [UIColor colorWithHex:0x222222].CGColor;
    _holder.layer.borderWidth = 2.0;
    
    self.lbName.backgroundColor = [UIColor clearColor];
    self.lbName.textColor = [UIColor colorWithHex:0x222222];
    self.lbName.font = [UIFont systemFontOfSize:18.0f];
    self.lbName.textAlignment = NSTextAlignmentLeft;
    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
}

- (void)updateCell:(AvailableServer*)server {
    
    _lbName.text = server.serverName;
    
    if (server.status == ServerStatusConnected) {
        _imgStatus.image = [UIImage imageNamed:@"connected"];
    }
    else
    {
        _imgStatus.image = [UIImage imageNamed:@"bluetooth"];
    }
}

- (void)onHighlighted:(BOOL)highlighted {
    if (highlighted) {
        _holder.backgroundColor = [UIColor colorWithHex:0xaaaaaa];
    }
    else
    {
        _holder.backgroundColor = [UIColor colorWithHex:0xdddddd];
    }
}


@end
