//
//  AvailableServer.h
//  EasyTextForiOS
//
//  Created by gao feng on 2016/10/21.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ServerStatusNormal,
    ServerStatusConnected,
} ServerStatus;


@interface AvailableServer : NSObject

@property (nonatomic, strong) NSString*                 serverName;
@property (nonatomic, assign) ServerStatus              status;
@property (nonatomic, assign) BOOL                      contentSynced;
@property (nonatomic, assign) BOOL                      autoConnected;

@end
