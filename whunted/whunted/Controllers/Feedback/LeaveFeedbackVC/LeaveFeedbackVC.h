//
//  LeaveFeedbackVC.h
//  whunted
//
//  Created by thomas nguyen on 29/7/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OfferData.h"

@interface LeaveFeedbackVC : UITableViewController <UITextViewDelegate>

@property (nonatomic, strong) OfferData *offerData;

@property (nonatomic, strong) NSString  *receiverUsername;

- (id) initWithOfferData: (OfferData *) offerData;

@end
