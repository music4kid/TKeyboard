//
//  ITemplateView.h
//  PIXY
//
//  Created by gao feng on 16/4/27.
//  Copyright © 2016年 instanza. All rights reserved.
//

#import "EAdapter.h"
#ifndef ITemplateView_h
#define ITemplateView_h


@protocol ITemplateView <NSObject>

- (void)buildTemplateView:(EAdapter*)adapter;
- (void)reloadTemplateView;

@end

#endif /* ITemplateView_h */
