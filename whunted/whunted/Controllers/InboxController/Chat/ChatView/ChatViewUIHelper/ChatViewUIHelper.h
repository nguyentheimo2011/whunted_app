//
//  ChatViewUIHelper.h
//  whunted
//
//  Created by thomas nguyen on 1/12/15.
//  Copyright © 2015 Whunted. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import <JTImageButton.h>

#import "TransactionData.h"

//---------------------------------------------------------------------------------------------------------------------------
@interface ChatViewUIHelper : NSObject
//---------------------------------------------------------------------------------------------------------------------------

#pragma mark - Top Functional Buttons

+ (UIView *)        addBackgroundForTopButtonsToViewController: (UIViewController *) viewController;

+ (JTImageButton *) addMakingOfferButtonToView: (UIView *) backgroundView;

+ (JTImageButton *) addMakingAnotherOfferButtonToView: (UIView *) backgroundView currentOffer: (TransactionData *) currOffer;

+ (JTImageButton *) addEditingOfferButtonToView: (UIView *) backgroundView;

+ (JTImageButton *) addCancelingOfferButtonToView: (UIView *) backgroundView;

+ (JTImageButton *) addAcceptingOfferButtonToView: (UIView *) backgroundView;

+ (JTImageButton *) addDecliningOfferButtonToView: (UIView *) backgroundView;

+ (JTImageButton *) addLeavingFeedbackButtonToView: (UIView *) backgroundView;

+ (void)            adjustVisibilityOfTopFunctionalButtonsStartWithMakingOfferButton: (JTImageButton *) makingOfferButton makingAnotherOfferButton: (JTImageButton *) makingAnotherOfferButton editingOfferButton: (JTImageButton *) editingOfferButton cancelingOfferButton: (JTImageButton *) cancelingOfferButton acceptingOfferButton: (JTImageButton *) acceptingButton decliningButton: (JTImageButton *) decliningButton leavingFeedbackButton: (JTImageButton *) leavingFeedbackButton currentOffer: (TransactionData *) currOffer;


#pragma mark - LoadEarlierMessages Button

+ (UIView *)        addBackgroundForLoadEarlierMessagesButtonToView: (UIView *) view;

@end
