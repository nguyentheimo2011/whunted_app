//
//  FeedbackTableViewCell.h
//  whunted
//
//  Created by thomas nguyen on 30/7/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FeedbackData.h"

//----------------------------------------------------------------------------------------------------------------------------
@interface FeedbackTableViewCell : UITableViewCell
//----------------------------------------------------------------------------------------------------------------------------

@property (nonatomic)           NSInteger       cellHeight;
@property (nonatomic, strong)   FeedbackData    *feedbackData;

@end
