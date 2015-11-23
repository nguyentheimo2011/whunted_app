//
//  Utilities.h
//  whunted
//
//  Created by thomas nguyen on 13/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "TransactionData.h"
#import "AppConstant.h"

#import <Parse/Parse.h>


@interface Utilities : NSObject

//-----------------------------------------------------------------------------------------------------------------------------
#pragma mark - UI Image
//-----------------------------------------------------------------------------------------------------------------------------

+ (UIImage *)   resizeImage:    (UIImage *) originalImage toSize: (CGSize) newSize scalingProportionally: (BOOL) scalingProportionally;

+ (UIImage *)   imageFromColor: (UIColor *) color forSize:(CGSize)size withCornerRadius:(CGFloat)radius;

+ (UIImage *)   imageWithColor: (UIColor *)color;


//-----------------------------------------------------------------------------------------------------------------------------
#pragma mark - UI Size
//-----------------------------------------------------------------------------------------------------------------------------

+ (CGFloat)     getStatusBarHeight;

+ (CGFloat)     getHeightOfBottomTabBar: (UIViewController *) viewController;

+ (CGFloat)     getHeightOfNavigationAndStatusBars: (UIViewController *) viewController;

+ (CGFloat)     widthOfText: (NSString *) text withFont: (UIFont *) font andMaxWidth: (CGFloat) maxWidth;

+ (CGSize)      sizeOfFullCollectionCell;

+ (CGSize)      sizeOfSimplifiedCollectionCell;

+ (CGFloat)     getHeightOfKeyboard: (NSNotification *) notification;


//-----------------------------------------------------------------------------------------------------------------------------
#pragma mark - UI Customization
//-----------------------------------------------------------------------------------------------------------------------------

+ (void)        customizeTabBar;

+ (void)        customizeNavigationBar;

+ (void)        customizeBackButtonForViewController: (UIViewController *) controller withAction: (SEL) action;

+ (void)        customizeTitleLabel:    (NSString *) title      forViewController: (UIViewController *) viewController;

+ (void)        customizeHeaderFooterLabels;

+ (void)        addLeftPaddingToTextField: (UITextField *) textField;


//-----------------------------------------------------------------------------------------------------------------------------
#pragma mark - UI Progress Indicator
//-----------------------------------------------------------------------------------------------------------------------------

+ (void)        showStandardIndeterminateProgressIndicatorInView: (UIView *) view;

+ (void)        showSmallIndeterminateProgressIndicatorInView: (UIView *) view;

+ (void)        hideIndeterminateProgressIndicatorInView: (UIView *) view;


//-----------------------------------------------------------------------------------------------------------------------------
#pragma mark - UI Helpers
//-----------------------------------------------------------------------------------------------------------------------------

+ (void)        addBorderAndShadow:     (UIView *) view;

+ (void)        addShadowToView:        (UIView *) view;

+ (void)        addShadowToCollectionCell: (UICollectionViewCell *) cell;

+ (void)        addGradientToView:      (UIView *) view;

+ (void)        setTopRoundedCorner:    (UIView *) view;

+ (void)        setBottomRoundedCorner: (UIView *) view;

+ (void)        scrollToBottom: (UIScrollView *) scrollView;

+ (UIView *)    getSubviewOfView: (UIView *) parentView withTag: (NSInteger) tag;

+ (void)        displayErrorAlertViewWithMessage: (NSString *) message;


//-----------------------------------------------------------------------------------------------------------------------------
#pragma mark - Data Type Conversion
//-----------------------------------------------------------------------------------------------------------------------------

+ (BOOL)            booleanFromYesNoString:         (NSString *) string;

+ (BOOL)            booleanFrom01String:            (NSString *) string;

+ (NSString *)      stringFromBoolean:              (BOOL) boolean;

+ (NSString *)      stringFromChatMessageType:      (ChatMessageType) type;

+ (ChatMessageType) chatMessageTypeFromString:      (NSString *) type;

+ (float)           floatingNumFromDemandedPrice:   (NSString *) demandedPrice;


//------------------------------------------------------------------------------------------------------------------------------
#pragma mark -  Transaction Data
//------------------------------------------------------------------------------------------------------------------------------

+ (BOOL)        amITheBuyer: (TransactionData *) offerData;

+ (NSString *)  idOfDealerDealingWithMe: (TransactionData *) offerData;

+ (NSString *)  makingOfferMessageFromOfferedPrice: (NSString *) offeredPrice andDeliveryTime: (NSString *) deliveryTime;


//------------------------------------------------------------------------------------------------------------------------------
#pragma mark - Chat Data
//------------------------------------------------------------------------------------------------------------------------------

+ (NSString *)  generateChatGroupIDFromItemID: (NSString *) itemID user1: (PFUser *) user1 user2: (PFUser *) user2;


//------------------------------------------------------------------------------------------------------------------------------
#pragma mark - NSString Helper
//------------------------------------------------------------------------------------------------------------------------------

+ (BOOL)        consistedOnlyOfDigits: (NSString *) string;


//------------------------------------------------------------------------------------------------------------------------------
#pragma mark - Mutiple Languages Support
//------------------------------------------------------------------------------------------------------------------------------

+ (NSString *)  getSynonymOfWord: (NSString *) word;

+ (NSString *)  getCurrentLanguage;

+ (BOOL)        isCurrLanguageTraditionalChinese;

+ (NSString *)  shortFormOfCurrLanguage;


//-----------------------------------------------------------------------------------------------------------------------------
#pragma mark - Whunt Details Helpers
//-----------------------------------------------------------------------------------------------------------------------------

+ (NSString *)  getResultantStringFromText: (NSString *) originalText andRange: (NSRange) range andReplacementString: (NSString *) string;

+ (BOOL)        checkIfIsValidPrice:    (NSString *) price;

+ (NSString *)  formatPriceText:        (NSString *) originalPrice;

+ (NSString *)  getCountryFromAddress:  (NSString *) address;

+ (NSString *)  getCityFromAddress:     (NSString *) address;

+ (NSString *)  getUsernameFromEmail:   (NSString *) email;

+ (NSString *)  removeLastDotCharacterIfNeeded: (NSString *) price;

+ (NSString *)  formattedPriceFromNumber: (NSNumber *) number;

+ (NSNumber *)  numberFromFormattedPrice: (NSString *) formattedPrice;


//------------------------------------------------------------------------------------------------------------------------------
#pragma mark - Notification
//------------------------------------------------------------------------------------------------------------------------------

+ (void)        postNotification: (NSString *) notification;


//------------------------------------------------------------------------------------------------------------------------------
#pragma mark - Parse Backend
//------------------------------------------------------------------------------------------------------------------------------

+ (void)        getUserWithID: (NSString *) userID imageNeeded: (BOOL) imageNeeded andRunBlock: (FetchedUserHandler) handler;

+ (void)        retrieveProfileImageForUser: (PFUser *) user andRunBlock: (ImageHandler) handler;

+ (void)        retrieveUserInfoByUserID: (NSString *) userID andRunBlock: (UserHandler) handler;


//------------------------------------------------------------------------------------------------------------------------------
#pragma mark - Google Analytics
//------------------------------------------------------------------------------------------------------------------------------

+ (void)        sendScreenNameToGoogleAnalyticsTracker: (NSString *) screenName;

+ (void)        sendEventToGoogleAnalyticsTrackerWithEventCategory: (NSString *) category action: (NSString *) action label: (NSString *) label value: (NSNumber*) value;

+ (void)        sendLoadingTimeToGoogleAnalyticsTrackerWithCategory: (NSString *) category interval: (NSNumber *) loadTime name: (NSString *) name label: (NSString *) label;

+ (void)        sendExceptionInfoToGoogleAnalyticsTrackerWithDescription: (NSString *) description fatal: (NSNumber *) fatal;


//------------------------------------------------------------------------------------------------------------------------------
#pragma mark - Log
//------------------------------------------------------------------------------------------------------------------------------

+ (void)        logOutMessage: (NSString *) message;


//------------------------------------------------------------------------------------------------------------------------------
#pragma mark - Error Handlers
//------------------------------------------------------------------------------------------------------------------------------

+ (void)        displayErrorAlertView;

+ (void)        handleError: (NSError *) error;


//------------------------------------------------------------------------------------------------------------------------------
#pragma mark - Data Validation
//------------------------------------------------------------------------------------------------------------------------------

+ (BOOL)        isEmailValid: (NSString *) email;


//------------------------------------------------------------------------------------------------------------------------------
#pragma mark - Date Handlers
//------------------------------------------------------------------------------------------------------------------------------

+ (NSDate *)    getRoundMinuteDateFromDate:         (NSDate *) date;

+ (NSString *)  commonlyFormattedStringFromDate:    (NSDate *) date;

// commonly formatted string example 20/8/2015
+ (NSDate *)    dateFromCommonlyFormattedString:    (NSString *) string;

// US date style example 8/20/2015
+ (NSDate *)    dateFromUSStyledString:             (NSString *) string;

// timestamp examples: 3s, 15m, 4h, 6d, 234w
+ (NSString *)  timestampStringFromDate:            (NSDate *) date;

// long timestamp examples: 1 second, 3 seconds, 1 minute, 15 minutes
+ (NSString *)  longTimestampStringFromDate:        (NSDate *) date;


@end
