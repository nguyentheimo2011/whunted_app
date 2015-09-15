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

@class LeaveFeedbackVC;

//----------------------------------------------------------------------------------------------------------------------------
@protocol LeaveFeedbackViewDelegate <NSObject>
//----------------------------------------------------------------------------------------------------------------------------

- (void) leaveFeedBackViewController: (UIViewController *) controller didCompleteGivingFeedBack: (FeedbackData *) feedbackData;

@end

//----------------------------------------------------------------------------------------------------------------------------
@interface LeaveFeedbackVC : UITableViewController <UITextViewDelegate>
//----------------------------------------------------------------------------------------------------------------------------

@property (nonatomic, weak)     id<LeaveFeedbackViewDelegate>   delegate;

@property (nonatomic, strong)   TransactionData       *offerData;
@property (nonatomic, strong)   FeedbackData          *feedbackData;
@property (nonatomic, strong)   NSString              *receiverUsername;

- (id) initWithOfferData: (TransactionData *) offerData;

@end
