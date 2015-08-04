//
//  FeedbackData.m
//  whunted
//
//  Created by thomas nguyen on 30/7/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "FeedbackData.h"
#import "Utilities.h"

@implementation FeedbackData

@synthesize feedbackID = _feedbackID;
@synthesize writerID = _writerID;
@synthesize receiverID = _receiverID;
@synthesize rating = _rating;
@synthesize comment = _comment;
@synthesize isWriterTheBuyer = _isWriterTheBuyer;
@synthesize createdDate = _createdDate;
@synthesize updatedDate = _updatedDate;

//--------------------------------------------------------------------------------------------------------------------------------
- (id) initWithPFObject:(PFObject *)obj
//--------------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    if (self) {
        _feedbackID = obj.objectId;
        _writerID = obj[PF_FEEDBACK_WRITER_ID];
        _receiverID = obj[PF_FEEDBACK_RECEIVER_ID];
        _rating = [self feedbackRatingFromString:obj[PF_FEEDBACK_RATING]];
        _comment = obj[PF_FEEDBACK_COMMENT];
        _isWriterTheBuyer = [Utilities booleanFromString:obj[PF_FEEDBACK_IS_WRITER_THE_BUYER]];
    }
    
    return self;
}

//--------------------------------------------------------------------------------------------------------------------------------
- (PFObject *) pfObjectFromFeedbackData
//--------------------------------------------------------------------------------------------------------------------------------
{
    PFObject *obj = [[PFObject alloc] initWithClassName:PF_FEEDBACK_DATA_CLASS];
    if ([_feedbackID length] > 0)
        obj.objectId = _feedbackID;
    obj[PF_FEEDBACK_WRITER_ID] = _writerID;
    obj[PF_FEEDBACK_RECEIVER_ID] = _receiverID;
    obj[PF_FEEDBACK_IS_WRITER_THE_BUYER] = [Utilities stringFromBoolean:_isWriterTheBuyer];
    obj[PF_FEEDBACK_RATING] = [self stringFromFeedbackRating:_rating];
    obj[PF_FEEDBACK_COMMENT] = _comment;
    
    return obj;
}

//--------------------------------------------------------------------------------------------------------------------------------
- (NSString *) stringFromFeedbackRating: (FeedbackRatingType) rating
//--------------------------------------------------------------------------------------------------------------------------------
{
    if (rating == FeedbackRatingPositive)
        return FEEDBACK_RATING_POSITIVE;
    else if (rating == FeedbackRatingNeutral)
        return FEEDBACK_RATING_NEUTRAL;
    else
        return FEEDBACK_RATING_NEGATIVE;
}

//--------------------------------------------------------------------------------------------------------------------------------
- (FeedbackRatingType) feedbackRatingFromString: (NSString *) rating
//--------------------------------------------------------------------------------------------------------------------------------
{
    if ([rating isEqualToString:FEEDBACK_RATING_POSITIVE])
        return FeedbackRatingPositive;
    else if ([rating isEqualToString:FEEDBACK_RATING_NEUTRAL])
        return FeedbackRatingNeutral;
    else
        return FeedbackRatingNegative;
}



@end
