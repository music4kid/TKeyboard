//
//  EViewController.h
//  PIXY
//
//  Created by gao feng on 16/4/26.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CDDContext.h"
#import "DBConst.h"

@interface EViewController : UIViewController

@property (nonatomic, strong) CDDContext*                 rootContext;


- (void)configMVP:(NSString*)name;


@end
