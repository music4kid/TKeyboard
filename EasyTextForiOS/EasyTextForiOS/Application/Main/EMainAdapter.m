//
//  EMainAdapter.m
//  EasyTextForiOS
//
//  Created by gao feng on 2016/10/28.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "EMainAdapter.h"
#import "SecionHeaderCell.h"
#import "CommonActionCell.h"
#import "MainEntry.h"
#import "EnableDeviceCell.h"

@implementation EMainAdapter

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainEntry* entry = [[self getAdapterArray] objectAtIndex:indexPath.row];
    int height = 50;
    
    if (entry.entryType == EntryTypeSectionHeader) {
        height = 40;
    }
    else if (entry.entryType == EntryTypeSectionEmpty) {
        height = 20;
    }
    else if (entry.entryType == EntryTypeKeyboardGuide ||
             entry.entryType == EntryTypeAboutUs ||
             entry.entryType == EntryTypeReview)
    {
        height = 50;
    }
    else if (entry.entryType == EntryTypeAvailableDevice)
    {
        height = 50;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForData:(id)data
{
    if (self.getAdapterArray.count == 0) {
        return [UITableViewCell new];
    }
    
    UITableViewCell* cell = NULL;
    
    MainEntry* entry = data;
    NSString* cellIndentifier = [NSString stringWithFormat:@"MainEntry_%d", (int)entry.entryType];
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        if (entry.entryType == EntryTypeSectionHeader) {
            [tableView registerNib:[UINib nibWithNibName:@"SecionHeaderCell" bundle:nil] forCellReuseIdentifier:cellIndentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        }
        else if (entry.entryType == EntryTypeKeyboardGuide ||
                 entry.entryType == EntryTypeAboutUs ||
                 entry.entryType == EntryTypeReview)
        {
            [tableView registerNib:[UINib nibWithNibName:@"CommonActionCell" bundle:nil] forCellReuseIdentifier:cellIndentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        }
        else if (entry.entryType == EntryTypeAvailableDevice)
        {
            [tableView registerNib:[UINib nibWithNibName:@"EnableDeviceCell" bundle:nil] forCellReuseIdentifier:cellIndentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        }
        else if (entry.entryType == EntryTypeSectionEmpty)
        {
            cell = [UITableViewCell new];
        }
    }
    
    BOOL isLast = false;
    if (entry.entryType == EntryTypeReview) {
        isLast = true;
    }
    if (entry == [self getAdapterArray].lastObject) {
        isLast = true;
    }
    
    if (entry.entryType == EntryTypeSectionHeader) {
        SecionHeaderCell* c = (SecionHeaderCell*)cell;
        [c updateWithEntry:entry];
    }
    else if (entry.entryType == EntryTypeKeyboardGuide ||
             entry.entryType == EntryTypeAboutUs ||
             entry.entryType == EntryTypeReview)
    {
        CommonActionCell* c = (CommonActionCell*)cell;
        [c updateWithEntry:entry isLast:isLast];
    }
    else if (entry.entryType == EntryTypeAvailableDevice)
    {
        EnableDeviceCell* c = (EnableDeviceCell*)cell;
        [c updateWithEntry:entry isLast:isLast];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}



@end
