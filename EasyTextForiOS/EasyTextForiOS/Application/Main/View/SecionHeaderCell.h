//
//  SecionHeaderCell.h
//  EasyTextForiOS
//
//  Created by gao feng on 2016/10/28.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainEntry.h"

@interface SecionHeaderCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel*                 lbName;


- (void)updateWithEntry:(MainEntry*)entry;

@end
