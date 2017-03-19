//
//  SyncHostCell.h
//  EasyTextForiOS
//
//  Created by gao feng on 2016/10/30.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SyncHostCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel*                 lbName;
@property (nonatomic, strong) IBOutlet UIImageView*             imgSelect;


- (void)updateDisplayName:(NSString*)name;

@end
