//
//  CDDContext.h
//  CDDDemo
//
//  Created by gao feng on 16/2/3.
//  Copyright © 2016年 gao feng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+CDD.h"

@class CDDContext;
@class CDDView;

@interface CDDPresenter : NSObject
@property (nonatomic, weak) UIViewController*           baseController;
@property (nonatomic, weak) CDDView*                    view;
@property (nonatomic, weak) id                          adapter; //for tableview adapter

@end

@interface CDDInteractor : NSObject
@property (nonatomic, weak) UIViewController*           baseController;
@end


@interface CDDView : UIView
@property (nonatomic, weak) CDDPresenter*               presenter;
@property (nonatomic, weak) CDDInteractor*              interactor;
@end



//Context bridges everything automatically, no need to pass it around manually
@interface CDDContext : NSObject

@property (nonatomic, strong) CDDPresenter*           presenter;
@property (nonatomic, strong) CDDInteractor*          interactor;
@property (nonatomic, strong) CDDView*                view; //view holds strong reference back to context

@end
