//
//  ENavigationController.m
//  PIXY
//
//  Created by gao feng on 16/5/12.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "ENavigationController.h"
#import "AppConfig.h"

@implementation ENavigationController

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{    
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController* ctrl = [super popViewControllerAnimated:animated];
    
    return ctrl;
}

@end
