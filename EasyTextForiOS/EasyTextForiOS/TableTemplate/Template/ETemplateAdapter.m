//
//  ETemplateAdapter.m
//  EasyTextForiOS
//
//  Created by gao feng on 2016/10/28.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "ETemplateAdapter.h"

@implementation ETemplateAdapter

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int height = 20;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForEntry:(id)data
{
    if (self.getAdapterArray.count == 0) {
        return [UITableViewCell new];
    }
    
    UITableViewCell* cell = NULL;
    
    NSString* cellIndentifier = [NSString stringWithFormat:@"MainEntry_%d", (int)0];
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
//        if (entry.entryType == EntryTypeSectionHeader) {
//            [tableView registerNib:[UINib nibWithNibName:@"SecionHeaderCell" bundle:nil] forCellReuseIdentifier:cellIndentifier];
//            cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
//        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}



@end
