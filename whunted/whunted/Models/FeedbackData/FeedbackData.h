//
//  FeedbackData.h
//  whunted
//
//  Created by thomas nguyen on 30/7/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AppConstant.h"

@interface FeedbackData : NSObject

@property (nonatomic, strong)   NSString            *feedbackID;
@property (nonatomic, strong)   NSString            *writerID;
@property (nonatomic, strong)   NSString            *receiverID;
@property (nonatomic)           BOOL                isWriterTheBuyer;
@property (nonatomic)           FeedbackRatingType  rating;
@property (nonatomic, strong)   NSString            *comment;
@property (nonatomic, strong)   NSDate              *createdDate;
@property (nonatomic, strong)   NSDate              *updatedDate;

- (id)          initWithPFObject: (PFObject *) obj;

- (PFObject *)  pfObjectFromFeedbackData;

@end
