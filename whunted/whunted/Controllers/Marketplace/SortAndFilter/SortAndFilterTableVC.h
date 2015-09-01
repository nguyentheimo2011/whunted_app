//
//  SortAndFilterTableVC.h
//  whunted
//
//  Created by thomas nguyen on 26/8/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CityViewController.h"

@class SortAndFilterTableVC;

//------------------------------------------------------------------------------------------------------------------------------
@protocol SortAndFilterTableViewDelegate <NSObject>
//------------------------------------------------------------------------------------------------------------------------------

- (void) sortAndFilterTableView: (SortAndFilterTableVC *) controller didCompleteChoosingSortingCriterion: (NSString *) criterion;

@end


//------------------------------------------------------------------------------------------------------------------------------
@interface SortAndFilterTableVC : UITableViewController <UITextFieldDelegate, CityViewDelegate>
//------------------------------------------------------------------------------------------------------------------------------

@property (nonatomic, strong)   id<SortAndFilterTableViewDelegate>  delegate;

@property (nonatomic, strong)   NSString        *sortingCriterion;

@property (nonatomic, strong)   NSString        *buyerLocationFilter;

@end
