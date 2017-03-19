//
//  MainEntry.h
//  EasyTextForiOS
//
//  Created by gao feng on 2016/10/28.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "EAdapter.h"

typedef enum : NSUInteger {
    EntryTypeSectionHeader,
    EntryTypeSectionEmpty,
    EntryTypeKeyboardGuide,
    EntryTypeAboutUs,
    EntryTypeReview,
    EntryTypeAvailableDevice,
    EntryTypeChooseSyncHost
} EntryType;

@interface MainEntry : EAdapter

@property (nonatomic, strong) NSString*                 entryName;
@property (nonatomic, assign) EntryType                 entryType;


@property (nonatomic, assign) BOOL                      deviceEnabled;


- (instancetype)initWithEntryType:(EntryType)entryType entryName:(NSString *)entryName;

@end
