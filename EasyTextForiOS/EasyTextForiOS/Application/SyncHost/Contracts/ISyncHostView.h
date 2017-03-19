//
//  ISyncHostView.h
//  PIXY
//
//  Created by gao feng on 16/4/27.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "EAdapter.h"
#ifndef ISyncHostView_h
#define ISyncHostView_h


@protocol ISyncHostView <NSObject>

- (void)buildSyncHostView:(EAdapter*)adapter;
- (void)reloadSyncHostView;

@end

#endif /* ISyncHostView_h */
