//
//  FeedbackReviewVC.h
//  whunted
//
//  Created by thomas nguyen on 30/7/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackReviewVC : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray       *feedbackList;

@property (nonatomic, strong) NSDictionary  *ratingDict;

@end
