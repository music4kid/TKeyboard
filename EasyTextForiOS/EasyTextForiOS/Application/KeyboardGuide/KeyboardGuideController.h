//
//  KeyboardGuideController.h
//  EasyTextForiOS
//
//  Created by gao feng on 2016/10/28.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyboardGuideController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollHolder;

@property (weak, nonatomic) IBOutlet UILabel *lbHowTo;
@property (weak, nonatomic) IBOutlet UILabel *lbStep1;
@property (weak, nonatomic) IBOutlet UIImageView *imgStep1;
@property (weak, nonatomic) IBOutlet UILabel *lbStep2;
@property (weak, nonatomic) IBOutlet UIImageView *imgStep2;
@property (weak, nonatomic) IBOutlet UILabel *lbStep3;
@property (weak, nonatomic) IBOutlet UIImageView *imgStep3;

@end
