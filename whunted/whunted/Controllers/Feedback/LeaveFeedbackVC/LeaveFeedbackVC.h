//
//  LeaveFeedbackVC.h
//  whunted
//
//  Created by thomas nguyen on 29/7/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FeedbackData.h"
#import "TransactionData.h"

@interface LeaveFeedbackVC : UITableViewController <UITextViewDelegate>

@property (nonatomic, strong) TransactionData   *offerData;

@property (nonatomic, strong) FeedbackData      *feedbackData;

@property (nonatomic, strong) NSString          *receiverUsername;

- (id) initWithOfferData: (TransactionData *) offerData;

@end
