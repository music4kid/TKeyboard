//
//  EnableDeviceCell.h
//  TKeyboardForiOS
//
//  Created by gao feng on 2017/3/6.
//  Copyright © 2017年 music4kid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainEntry.h"

@interface EnableDeviceCell : UITableViewCell

- (void)updateWithEntry:(MainEntry*)entry isLast:(BOOL)last;

@end
