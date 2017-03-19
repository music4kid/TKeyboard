//
//  EAdapter.h
//  PIXY
//
//  Created by gao feng on 16/5/7.
//  Copyright © 2016年 music4kid. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EAdapterDelegate <NSObject>

@optional
- (void)didSelectCellData:(id)cellData;
- (void)deleteCellData:(id)cellData;
- (void)willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

@end


@protocol EAdapterScrollDelegate <NSObject>

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView ;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView ;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView;

@end

@protocol EAdapterPullUpDelegate <NSObject>

- (void)beginToRefresh;

@end
@interface EAdapter : NSObject<UITableViewDataSource, UITableViewDelegate>
{
    
}

@property (nonatomic, weak)     id<EAdapterDelegate>                    adapterDelegate;
@property (nonatomic, weak)     id<EAdapterScrollDelegate>              adapterScrollDelegate;
@property (nonatomic, weak)     id<EAdapterPullUpDelegate>              adapterPullUpDelegate;

- (float)getTableContentHeight;
- (void)refreshCellByData:(id)data tableView:(UITableView*)tableView;

- (NSMutableArray*)getAdapterArray;
- (void)setAdapterArray:(NSArray*)arr;


@end
