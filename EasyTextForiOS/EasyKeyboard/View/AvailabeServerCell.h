//
//  AvailabeServerCell.h
//  TKeyboardForiOS
//
//  Created by gao feng on 2017/3/10.
//  Copyright © 2017年 music4kid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AvailableServer.h"


@interface AvailabeServerCell : UITableViewCell


- (void)updateCell:(AvailableServer*)server;

- (void)onHighlighted:(BOOL)highlighted;

@end
