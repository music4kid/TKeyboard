//
//  MainEntry.m
//  EasyTextForiOS
//
//  Created by gao feng on 2016/10/28.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "MainEntry.h"

@implementation MainEntry

- (instancetype)initWithEntryType:(EntryType)entryType entryName:(NSString *)entryName
{
    self = [super init];
    if (self == nil) {
        return nil;
    }
	self.entryType = entryType;
	self.entryName = entryName;
    
    return self;
}


@end
