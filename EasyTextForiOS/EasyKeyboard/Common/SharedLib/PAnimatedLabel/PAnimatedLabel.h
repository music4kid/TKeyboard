//
//  PAnimatedLabel.h
//  EasyTextForiOS
//
//  Created by gao feng on 2016/10/26.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PAnimatedLabel : UILabel

- (void)showText:(NSString*)text;
- (void)showText:(NSString*)text autoHide:(BOOL)hide;

@end
