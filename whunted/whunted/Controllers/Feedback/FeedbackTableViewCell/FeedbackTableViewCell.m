//
//  FeedbackTableViewCell.m
//  whunted
//
//  Created by thomas nguyen on 30/7/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "FeedbackTableViewCell.h"
#import "AppConstant.h"

@implementation FeedbackTableViewCell
{
    UIImageView     *_userProfilePicture;
}

@synthesize cellHeight = _cellHeight;

//-------------------------------------------------------------------------------------------------------------------------------
- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//-------------------------------------------------------------------------------------------------------------------------------
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self addUserProfilePicture];
    }
    
    return self;
}

#pragma mark - UI Handlers

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addUserProfilePicture
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kPictureLeftMargin = 10.0f;
    CGFloat const kPictureTopMargin = 10.0f;
    CGFloat const kPictureWidth = 40.0f;
    
    _userProfilePicture = [[UIImageView alloc] initWithFrame:CGRectMake(kPictureLeftMargin, kPictureTopMargin, kPictureWidth, kPictureWidth)];
    _userProfilePicture.layer.cornerRadius = kPictureWidth / 2.0;
    _userProfilePicture.backgroundColor = MAIN_BLUE_COLOR;
    [self addSubview:_userProfilePicture];
    
    _cellHeight = kPictureWidth + 2 * kPictureTopMargin;
}

@end
