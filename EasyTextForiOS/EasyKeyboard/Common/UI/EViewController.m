//
//  EViewController.m
//  PIXY
//
//  Created by gao feng on 16/4/26.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "EViewController.h"
#import "UIImageEX.h"

@interface EViewController ()
@property (nonatomic, strong) NSMutableDictionary*                 eventMap;
@property (nonatomic, assign) BOOL mvpEnabled;
@end

@implementation EViewController
- (void)configMVP:(NSString*)name
{
    self.mvpEnabled = true;
    
    self.rootContext = [[CDDContext alloc] init]; //strong
    self.context = self.rootContext; //weak
    
    //presentor
    Class presenterClass = NSClassFromString([NSString stringWithFormat:@"E%@Presenter", name]);
    if (presenterClass != NULL) {
        self.context.presenter = [presenterClass new];
        self.context.presenter.context = self.context;
    }
    
    //interactor
    Class interactorClass = NSClassFromString([NSString stringWithFormat:@"E%@Interactor", name]);
    if (interactorClass != NULL) {
        self.context.interactor = [interactorClass new];
        self.context.interactor.context = self.context;
    }
    
    //view
    Class viewClass = NSClassFromString([NSString stringWithFormat:@"E%@View", name]);
    if (viewClass != NULL) {
        self.context.view = [viewClass new];
        self.context.view.context = self.context;
    }
    
    //build relation
    self.context.presenter.view = self.context.view;
    self.context.presenter.baseController = self;
    
    self.context.interactor.baseController = self;
    
    self.context.view.presenter = self.context.presenter;
    self.context.view.interactor = self.context.interactor;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    if (self.mvpEnabled) {
        self.context.view.frame = self.view.bounds;
        self.view = self.context.view;
    }
    
    [self setNeedsStatusBarAppearanceUpdate];
    [self configTheme];
    
    CCLog(@"\n\nDid Load ViewController: %@\n\n", [self class]);
}

- (void)dealloc
{
    CCLog(@"\n\nReleasing ViewController: %@\n\n", [self class]);
    
    [Notif removeObserver:self];
}


- (void)configTheme
{
#ifdef iOSMainProject
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHex:0x2a2a2a] size:CGSizeMake(1, 64)]
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:[UIColor colorWithHex:0x2a2a2a] size:CGSizeMake(1, 0.5)]];
    
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      UITextAttributeTextColor:[UIColor whiteColor],
                                                                      UITextAttributeTextShadowColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0],
                                                                      UITextAttributeFont:[UIFont boldSystemFontOfSize:17],
                                                                      }];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
#endif
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}




@end
