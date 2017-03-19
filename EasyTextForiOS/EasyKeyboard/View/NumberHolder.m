//
//  NumberHolder.m
//  TKeyboardForiOS
//
//  Created by gao feng on 2017/3/15.
//  Copyright © 2017年 music4kid. All rights reserved.
//

#import "NumberHolder.h"
#import "UIImageEX.h"

@interface NumberModel ()
@property (nonatomic, assign) NumberKeyType        keyType;
@property (nonatomic, strong) NSString*            keyName;
@end

@implementation NumberModel
- (instancetype)initWithKeyName:(NSString *)keyName keyType:(NumberKeyType)keyType
{
    self = [super init];
    if (!self) return nil;
    
	self.keyName = keyName;
	self.keyType = keyType;
    
    return self;
}
@end

@interface NumberHolder ()
@property (nonatomic, strong) NSMutableArray*                 keys;

@end

@implementation NumberHolder

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self buildNumberKeyboard];
}

- (void)buildNumberKeyboard
{
    self.keys = @[].mutableCopy;
    NSMutableArray* keys = self.keys;
    NumberModel* m = nil;
    
    m = [[NumberModel alloc] initWithKeyName:@"1" keyType:NumberKey1];
    [keys addObject:m];
    m = [[NumberModel alloc] initWithKeyName:@"2" keyType:NumberKey2];
    [keys addObject:m];
    m = [[NumberModel alloc] initWithKeyName:@"3" keyType:NumberKey3];
    [keys addObject:m];
    m = [[NumberModel alloc] initWithKeyName:NSLocalizedString(@"txtDelete", nil) keyType:NumberKeyDelete];
    [keys addObject:m];
    m = [[NumberModel alloc] initWithKeyName:@"4" keyType:NumberKey4];
    [keys addObject:m];
    m = [[NumberModel alloc] initWithKeyName:@"5" keyType:NumberKey5];
    [keys addObject:m];
    m = [[NumberModel alloc] initWithKeyName:@"6" keyType:NumberKey6];
    [keys addObject:m];
    m = [[NumberModel alloc] initWithKeyName:@"." keyType:NumberKeyPeriod];
    [keys addObject:m];
    m = [[NumberModel alloc] initWithKeyName:@"7" keyType:NumberKey7];
    [keys addObject:m];
    m = [[NumberModel alloc] initWithKeyName:@"8" keyType:NumberKey8];
    [keys addObject:m];
    m = [[NumberModel alloc] initWithKeyName:@"9" keyType:NumberKey9];
    [keys addObject:m];
    m = [[NumberModel alloc] initWithKeyName:@"0" keyType:NumberKey0];
    [keys addObject:m];
    
    int gap = 10;
    int keyPerLine = 4;
    int height = (150 - 4*gap)/3;
    int width = (SCREEN_WIDTH - 5*gap)/keyPerLine;
    int marginX = gap;
    int marginY = gap;
    
    
    UIImage* normalBg = [UIImage imageWithColor:[UIColor colorWithHex:0xdddddd] size:CGSizeMake(2, 2)];
    UIImage* pressedBg = [UIImage imageWithColor:[UIColor colorWithHex:0xaaaaaa] size:CGSizeMake(2, 2)];
    for (int i = 0; i < keys.count; i ++) {
        NumberModel* k = keys[i];
        
        UIButton *btn = [UIButton new];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setTitle:k.keyName forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHex:0x333333] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(numberClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [self addSubview:btn];
        btn.frame = CGRectMake(marginX, marginY, width, height);
        
        btn.backgroundColor = [UIColor clearColor];
        btn.clipsToBounds = true;
        btn.layer.cornerRadius = 10;
        btn.layer.borderColor = [UIColor colorWithHex:0x222222].CGColor;
        btn.layer.borderWidth = 2.0;
        
        [btn setBackgroundImage:normalBg forState:UIControlStateNormal];
        [btn setBackgroundImage:pressedBg forState:UIControlStateHighlighted];
        
        marginX += (width + gap);
        if ((i+1)%keyPerLine == 0) {
            marginX = gap;
            marginY += (height + gap);
        }
    }
}

- (void)numberClick:(id)sender
{
    UIButton* btn = (UIButton*)sender;
    NSInteger index = btn.tag;
    NumberModel* m = _keys[index];
    
    if (m.keyType == NumberKeyDelete) {
        if (self.delegate) {
            [_delegate onNumberDeleteClick];
        }
    }
    else
    {
        if (self.delegate) {
            [_delegate onNumberInput:m.keyName];
        }
    }
    
}

@end
