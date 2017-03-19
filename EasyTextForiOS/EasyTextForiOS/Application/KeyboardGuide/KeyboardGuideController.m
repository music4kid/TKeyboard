//
//  KeyboardGuideController.m
//  EasyTextForiOS
//
//  Created by gao feng on 2016/10/28.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "KeyboardGuideController.h"

@interface KeyboardGuideController ()
@property (weak, nonatomic) IBOutlet UILabel *lbDetail;
@property (weak, nonatomic) IBOutlet UILabel *lbVersion;

@end

@implementation KeyboardGuideController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _lbDetail.text = NSLocalizedString(@"DetailedGuide", nil);
    
    NSString* appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    appVersion = [NSString stringWithFormat:@"Version %@", appVersion];
    _lbVersion.text = appVersion;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CGSize size = _scrollHolder.contentSize;
    size.height = 940;
    size.width = self.view.bounds.size.width;
    _scrollHolder.contentSize = size;
}
@end
