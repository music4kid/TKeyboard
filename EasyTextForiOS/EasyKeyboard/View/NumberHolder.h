//
//  NumberHolder.h
//  TKeyboardForiOS
//
//  Created by gao feng on 2017/3/15.
//  Copyright © 2017年 music4kid. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    NumberKey1,
    NumberKey2,
    NumberKey3,
    NumberKey4,
    NumberKey5,
    NumberKey6,
    NumberKey7,
    NumberKey8,
    NumberKey9,
    NumberKey0,
    NumberKeyDelete,
    NumberKeyPeriod
} NumberKeyType;

@protocol NumberHolderDelegate <NSObject>

- (void)onNumberInput:(NSString*)txt;
- (void)onNumberDeleteClick;

@end

@interface NumberModel : NSObject

- (instancetype)initWithKeyName:(NSString *)keyName keyType:(NumberKeyType)keyType;

@end

@interface NumberHolder : UIView

@property (nonatomic, weak) id<NumberHolderDelegate>    delegate;

@end
