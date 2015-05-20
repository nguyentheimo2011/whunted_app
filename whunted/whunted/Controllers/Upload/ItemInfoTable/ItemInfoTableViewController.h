//
//  ItemInfoTableViewController.h
//  whunted
//
//  Created by thomas nguyen on 18/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemInfoTableViewController;

@protocol ItemInfoTableViewControllerDelegate <NSObject>

- (void) itemInfoTableViewController: (ItemInfoTableViewController *) controller didPressDone: (NSDictionary *) itemInfo;

@end

@interface ItemInfoTableViewController : UITableViewController

- (id) initWithItemInfoDict: (NSDictionary *) infoDict;

@property (nonatomic, weak) id<ItemInfoTableViewControllerDelegate> delegate;

@end
