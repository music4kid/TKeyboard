//
//  KeyboardAdapter.m
//  EasyTextForiOS
//
//  Created by gao feng on 2016/10/21.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import "KeyboardAdapter.h"
#import "AvailableServer.h"
#import "AvailabeServerCell.h"


@implementation KeyboardAdapter

- (UITableViewCell *)tableView:(UITableView *)tableView cellForData:(id)data
{
    if (self.getAdapterArray.count == 0) {
        return [UITableViewCell new];
    }

    AvailabeServerCell* cell = NULL;
    
    AvailableServer* server = data;
    NSString* cellIndentifier = @"AvailableServer";
    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"AvailabeServerCell" bundle:nil] forCellReuseIdentifier:cellIndentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    }
    [cell updateCell:server];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float cellHeight = 60;
    
    return cellHeight;
}


-(void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    AvailabeServerCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell onHighlighted:true];
}

-(void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    AvailabeServerCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell onHighlighted:false];
}

@end
