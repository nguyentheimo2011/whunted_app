//
//  CategoryTableViewController.h
//  whunted
//
//  Created by thomas nguyen on 18/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CategoryTableViewController;

//------------------------------------------------------------------------------------------------------------------------------
@protocol CategoryTableViewControllerDelegate <NSObject>
//------------------------------------------------------------------------------------------------------------------------------

- (void) categoryTableViewController: (CategoryTableViewController *) controller didSelectCategory: (NSString *) category;

@end

//------------------------------------------------------------------------------------------------------------------------------
@interface CategoryTableViewController : UITableViewController
//------------------------------------------------------------------------------------------------------------------------------

@property (nonatomic, weak) id<CategoryTableViewControllerDelegate> delegte;
@property (nonatomic, strong) NSString *category;

@end
