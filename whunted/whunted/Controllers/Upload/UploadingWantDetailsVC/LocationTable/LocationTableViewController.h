//
//  LocationTableViewController.h
//  whunted
//
//  Created by thomas nguyen on 18/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LocationTableViewController;

//------------------------------------------------------------------------------------------------------------------------------
@protocol LocationTableViewControllerDelegate <NSObject>
//------------------------------------------------------------------------------------------------------------------------------

- (void) locationTableViewController: (LocationTableViewController *) controller didSelectLocation: (NSString *) location;

@end

//------------------------------------------------------------------------------------------------------------------------------
@interface LocationTableViewController : UITableViewController
//------------------------------------------------------------------------------------------------------------------------------

@property (nonatomic, weak) id<LocationTableViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *location;

@end
