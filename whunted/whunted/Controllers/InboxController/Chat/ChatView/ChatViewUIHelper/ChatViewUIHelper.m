//
//  ChatViewUIHelper.m
//  whunted
//
//  Created by thomas nguyen on 1/12/15.
//  Copyright © 2015 Whunted. All rights reserved.
//

#import "ChatViewUIHelper.h"
#import "AppConstant.h"
#import "Utilities.h"

@implementation ChatViewUIHelper


#pragma mark - Top Functional Buttons

//---------------------------------------------------------------------------------------------------------------------------
+ (UIView *) addBackgroundForTopButtonsToViewController:(UIViewController *)viewController
//---------------------------------------------------------------------------------------------------------------------------
{
    CGFloat statusAndNavigationBarHeight = viewController.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0, statusAndNavigationBarHeight, WINSIZE.width, FLAT_BUTTON_HEIGHT + 10)];
    [background setBackgroundColor:GRAY_COLOR_WITH_WHITE_COLOR_2];
    [background setAlpha:0.98];
    [viewController.view addSubview:background];
    
    return background;
}

//---------------------------------------------------------------------------------------------------------------------------
+ (JTImageButton *) addMakingOfferButtonToView:(UIView *)backgroundView
//---------------------------------------------------------------------------------------------------------------------------
{
    JTImageButton *makingOfferButton = [[JTImageButton alloc] initWithFrame:CGRectMake(WINSIZE.width * 0.1, 5, WINSIZE.width * 0.8, FLAT_BUTTON_HEIGHT)];
    [makingOfferButton createTitle:NSLocalizedString(@"Make Offer", nil) withIcon:nil font:[UIFont fontWithName:SEMIBOLD_FONT_NAME size:15] iconOffsetY:0];
    makingOfferButton.cornerRadius = 6.0;
    makingOfferButton.borderColor = FLAT_FRESH_RED_COLOR;
    makingOfferButton.bgColor = FLAT_BLUR_RED_COLOR;
    makingOfferButton.titleColor = [UIColor whiteColor];
    [backgroundView addSubview:makingOfferButton];
    
    return makingOfferButton;
}

//---------------------------------------------------------------------------------------------------------------------------
+ (JTImageButton *) addMakingAnotherOfferButtonToView:(UIView *)backgroundView currentOffer: (TransactionData *) currOffer
//---------------------------------------------------------------------------------------------------------------------------
{
    JTImageButton *makingAnotherOfferButton = [[JTImageButton alloc] initWithFrame:CGRectMake(WINSIZE.width * 0.025, 5, WINSIZE.width * 0.43, FLAT_BUTTON_HEIGHT)];
    if ([Utilities amITheBuyer:currOffer])
        [makingAnotherOfferButton createTitle:NSLocalizedString(@"Make another offer buyer", nil) withIcon:nil font:[UIFont fontWithName:SEMIBOLD_FONT_NAME size:15] iconOffsetY:0];
    else
        [makingAnotherOfferButton createTitle:NSLocalizedString(@"Make another offer seller", nil) withIcon:nil font:[UIFont fontWithName:REGULAR_FONT_NAME size:15] iconOffsetY:0];
    
    makingAnotherOfferButton.cornerRadius = 6.0;
    makingAnotherOfferButton.borderColor = FLAT_BLUE_COLOR;
    makingAnotherOfferButton.bgColor = FLAT_BLUE_COLOR;
    makingAnotherOfferButton.titleColor = [UIColor whiteColor];
    [backgroundView addSubview:makingAnotherOfferButton];
    
    return makingAnotherOfferButton;
}

//---------------------------------------------------------------------------------------------------------------------------
+ (JTImageButton *) addEditingOfferButtonToView:(UIView *)backgroundView
//---------------------------------------------------------------------------------------------------------------------------
{
    JTImageButton *edittingOfferButton = [[JTImageButton alloc] initWithFrame:CGRectMake(WINSIZE.width * 0.05, 5, WINSIZE.width * 0.425, FLAT_BUTTON_HEIGHT)];
    [edittingOfferButton createTitle:NSLocalizedString(@"Edit Offer", nil) withIcon:nil font:[UIFont fontWithName:SEMIBOLD_FONT_NAME size:15] iconOffsetY:0];
    edittingOfferButton.cornerRadius = 6.0;
    edittingOfferButton.borderColor = FLAT_BLUE_COLOR;
    edittingOfferButton.bgColor = FLAT_BLUE_COLOR;
    edittingOfferButton.titleColor = [UIColor whiteColor];
    [backgroundView addSubview:edittingOfferButton];
    
    return edittingOfferButton;
}

//---------------------------------------------------------------------------------------------------------------------------
+ (JTImageButton *) addCancelingOfferButtonToView:(UIView *)backgroundView
//---------------------------------------------------------------------------------------------------------------------------
{
    JTImageButton *cancellingOfferButton = [[JTImageButton alloc] initWithFrame:CGRectMake(WINSIZE.width * 0.525, 5, WINSIZE.width * 0.425, FLAT_BUTTON_HEIGHT)];
    [cancellingOfferButton createTitle:NSLocalizedString(@"Cancel Offer", nil) withIcon:nil font:[UIFont fontWithName:SEMIBOLD_FONT_NAME size:15] iconOffsetY:0];
    cancellingOfferButton.cornerRadius = 6.0;
    cancellingOfferButton.borderColor = FLAT_GRAY_COLOR;
    cancellingOfferButton.bgColor = FLAT_GRAY_COLOR;
    cancellingOfferButton.titleColor = [UIColor whiteColor];
    [backgroundView addSubview:cancellingOfferButton];
    
    return cancellingOfferButton;
}

//---------------------------------------------------------------------------------------------------------------------------
+ (JTImageButton *) addAcceptingOfferButtonToView:(UIView *)backgroundView
//---------------------------------------------------------------------------------------------------------------------------
{
    JTImageButton *acceptingButton = [[JTImageButton alloc] initWithFrame:CGRectMake(WINSIZE.width * 0.715, 5, WINSIZE.width * 0.26, FLAT_BUTTON_HEIGHT)];
    [acceptingButton createTitle:NSLocalizedString(@"Accept", nil) withIcon:nil font:[UIFont fontWithName:SEMIBOLD_FONT_NAME size:15] iconOffsetY:0];
    acceptingButton.cornerRadius = 6.0;
    acceptingButton.borderColor = FLAT_BLUR_RED_COLOR;
    acceptingButton.bgColor = FLAT_BLUR_RED_COLOR;
    acceptingButton.titleColor = [UIColor whiteColor];
    [backgroundView addSubview:acceptingButton];
    
    return acceptingButton;
}

//---------------------------------------------------------------------------------------------------------------------------
+ (JTImageButton *) addDecliningOfferButtonToView:(UIView *)backgroundView
//---------------------------------------------------------------------------------------------------------------------------
{
    JTImageButton *decliningButton = [[JTImageButton alloc] initWithFrame:CGRectMake(WINSIZE.width * 0.48, 5, WINSIZE.width * 0.21, FLAT_BUTTON_HEIGHT)];
    [decliningButton createTitle:NSLocalizedString(@"Decline", nil) withIcon:nil font:[UIFont fontWithName:SEMIBOLD_FONT_NAME size:15] iconOffsetY:0];
    decliningButton.cornerRadius = 6.0;
    decliningButton.borderColor = FLAT_GRAY_COLOR;
    decliningButton.bgColor = FLAT_GRAY_COLOR;
    decliningButton.titleColor = [UIColor whiteColor];
    [backgroundView addSubview:decliningButton];
    
    return decliningButton;
}

//---------------------------------------------------------------------------------------------------------------------------
+ (JTImageButton *) addLeavingFeedbackButtonToView:(UIView *)backgroundView
//---------------------------------------------------------------------------------------------------------------------------
{
    JTImageButton *leavingFeedbackButton = [[JTImageButton alloc] initWithFrame:CGRectMake(WINSIZE.width * 0.1, 5, WINSIZE.width * 0.8, FLAT_BUTTON_HEIGHT)];
    [leavingFeedbackButton createTitle:NSLocalizedString(@"Leave Feedback", nil) withIcon:nil font:[UIFont fontWithName:SEMIBOLD_FONT_NAME size:15] iconOffsetY:0];
    leavingFeedbackButton.cornerRadius = 6.0;
    leavingFeedbackButton.borderColor = FLAT_GRAY_COLOR_LIGHTER;
    leavingFeedbackButton.bgColor = FLAT_GRAY_COLOR_LIGHTER;
    leavingFeedbackButton.titleColor = [UIColor whiteColor];
    [backgroundView addSubview:leavingFeedbackButton];
    
    return leavingFeedbackButton;
}

//---------------------------------------------------------------------------------------------------------------------------
+ (void) adjustVisibilityOfTopFunctionalButtonsStartWithMakingOfferButton:(JTImageButton *)makingOfferButton makingAnotherOfferButton:(JTImageButton *)makingAnotherOfferButton editingOfferButton:(JTImageButton *)editingOfferButton cancelingOfferButton:(JTImageButton *)cancelingOfferButton acceptingOfferButton:(JTImageButton *)acceptingButton decliningButton:(JTImageButton *)decliningButton leavingFeedbackButton: (JTImageButton *) leavingFeedbackButton currentOffer: (TransactionData *) currOffer
//---------------------------------------------------------------------------------------------------------------------------
{
    if (currOffer.initiatorID.length > 0)
    {
        // an offer has been made
        if ([currOffer.transactionStatus isEqualToString:TRANSACTION_STATUS_ACCEPTED])
        {
            // the offer was accepted
            [makingOfferButton setHidden:YES];
            
            [leavingFeedbackButton setHidden:NO];
            
            [makingAnotherOfferButton setHidden:YES];
            [decliningButton setHidden:YES];
            [acceptingButton setHidden:YES];
            
            [editingOfferButton setHidden:YES];
            [cancelingOfferButton setHidden:YES];
        }
        else if ([currOffer.transactionStatus isEqualToString:TRANSACTION_STATUS_ONGOING])
        {
            if ([currOffer.initiatorID isEqualToString:[PFUser currentUser].objectId])
            {
                // the offer was made by me
                [makingOfferButton setHidden:YES];
                
                [leavingFeedbackButton setHidden:YES];
                
                [makingAnotherOfferButton setHidden:YES];
                [decliningButton setHidden:YES];
                [acceptingButton setHidden:YES];
                
                [editingOfferButton setHidden:NO];
                [cancelingOfferButton setHidden:NO];
            }
            else
            {
                // the offer was made by the other person
                [makingOfferButton setHidden:YES];
                
                [leavingFeedbackButton setHidden:YES];
                
                [makingAnotherOfferButton setHidden:NO];
                [decliningButton setHidden:NO];
                [acceptingButton setHidden:NO];
                
                [editingOfferButton setHidden:YES];
                [cancelingOfferButton setHidden:YES];
            }
        }
        else if ([currOffer.transactionStatus isEqualToString:TRANSACTION_STATUS_CANCELLED] || [currOffer.transactionStatus isEqualToString:TRANSACTION_STATUS_DECLINED])
        {
            // the offer has been cancelled or declined
            [makingOfferButton setHidden:NO];
            
            [leavingFeedbackButton setHidden:YES];
            
            [makingAnotherOfferButton setHidden:YES];
            [decliningButton setHidden:YES];
            [acceptingButton setHidden:YES];
            
            [editingOfferButton setHidden:YES];
            [cancelingOfferButton setHidden:YES];
        }
    }
    else
    {
        // No one has made any offers yet
        [makingOfferButton setHidden:NO];
        
        [leavingFeedbackButton setHidden:YES];
        
        [makingAnotherOfferButton setHidden:YES];
        [decliningButton setHidden:YES];
        [acceptingButton setHidden:YES];
        
        [editingOfferButton setHidden:YES];
        [cancelingOfferButton setHidden:YES];
    }
}


#pragma mark - LoadEarlierMessages

//---------------------------------------------------------------------------------------------------------------------------
+ (UIView *) addBackgroundForLoadEarlierMessagesButtonToView:(UIView *)view
//---------------------------------------------------------------------------------------------------------------------------
{
    CGFloat width   =   36.0f;
    CGFloat height  =   36.0f;
    CGFloat xPosition = (WINSIZE.width - width) / 2;
    CGFloat yPosition = 0;
    
    UIView *loadingEarlierMessagesBackground = [[UIView alloc] initWithFrame:CGRectMake(xPosition, yPosition, width, height)];
    loadingEarlierMessagesBackground.layer.cornerRadius = 8.0f;
    loadingEarlierMessagesBackground.layer.masksToBounds = YES;
    [view addSubview:loadingEarlierMessagesBackground];
    
    return loadingEarlierMessagesBackground;
}

@end
