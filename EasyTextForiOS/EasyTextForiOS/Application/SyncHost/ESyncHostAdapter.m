//
//  ESyncHostAdapter.m
//  EasyTextForiOS
//
//  Created by gao feng on 2016/10/28.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "ESyncHostAdapter.h"
#import "SyncHostCell.h"

@implementation ESyncHostAdapter

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int height = 40;
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForData:(id)data
{
    if (self.getAdapterArray.count == 0) {
        return [UITableViewCell new];
    }
    
    SyncHostCell* cell = nil;
    NSString* cellIndentifier = [NSString stringWithFormat:@"SyncHostCell"];
    cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"SyncHostCell" bundle:nil] forCellReuseIdentifier:cellIndentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    }
    [cell updateDisplayName:data];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}



@end
