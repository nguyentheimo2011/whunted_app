//
//  CityViewController.h
//  whunted
//
//  Created by thomas nguyen on 31/8/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CityViewController;

//------------------------------------------------------------------------------------------------------------------------------
@protocol CityViewDelegate <NSObject>
//------------------------------------------------------------------------------------------------------------------------------

- (void) cityView: (CityViewController *) controller didSpecifyLocation: (NSString *) location;

@end

//------------------------------------------------------------------------------------------------------------------------------
@interface CityViewController : UIViewController <UITextFieldDelegate,
//------------------------------------------------------------------------------------------------------------------------------
                                                  UITableViewDataSource,
                                                  UITableViewDelegate,
                                                  UIAlertViewDelegate>

@property (nonatomic, weak) id<CityViewDelegate>    delegate;

@property (nonatomic, strong)   NSString        *viewTitle;
@property (nonatomic, strong)   NSString        *labelText;
@property (nonatomic, strong)   NSString        *currentLocation;
@property (nonatomic)           NSInteger       tag;
@property (nonatomic)           BOOL            viewControllerIsPresented;
@property (nonatomic)           BOOL            usedForFiltering;

@end
