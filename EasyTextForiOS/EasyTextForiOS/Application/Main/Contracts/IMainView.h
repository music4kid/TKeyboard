//
//  IMainView.h
//  PIXY
//
//  Created by gao feng on 16/4/27.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#ifndef IMainView_h
#define IMainView_h

@class EAdapter;

@protocol IMainView <NSObject>

- (void)buildMainView:(EAdapter*)adapter;
- (void)reloadMainView;

@end

#endif /* IMainView_h */
