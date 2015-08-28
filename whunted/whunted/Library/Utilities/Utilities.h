//
//  Utilities.h
//  whunted
//
//  Created by thomas nguyen on 13/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "OfferData.h"
#import "AppConstant.h"

#import <Parse/Parse.h>


@interface Utilities : NSObject

//-----------------------------------------------------------------------------------------------------------------------------
#pragma mark - UI Image
//-----------------------------------------------------------------------------------------------------------------------------

+ (UIImage *)   resizeImage:            (UIImage *) originalImage   toSize: (CGSize) newSize;

+ (UIImage *)   imageFromColor:         (UIColor *) color       forSize:(CGSize)size    withCornerRadius:(CGFloat)radius;

+ (UIImage *)   imageWithColor:         (UIColor *)color;


//-----------------------------------------------------------------------------------------------------------------------------
#pragma mark - UI Size
//-----------------------------------------------------------------------------------------------------------------------------

+ (CGFloat)     getStatusBarHeight;

+ (CGFloat)     getHeightOfBottomTabBar: (UIViewController *) viewController;

+ (CGFloat)     getHeightOfNavigationAndStatusBars: (UIViewController *) viewController;

+ (CGFloat)     widthOfText: (NSString *) text withFont: (UIFont *) font andMaxWidth: (CGFloat) maxWidth;


//-----------------------------------------------------------------------------------------------------------------------------
#pragma mark - UI Customization
//-----------------------------------------------------------------------------------------------------------------------------

+ (void)        customizeTabBar;

+ (void)        customizeNavigationBar;

+ (void)        customizeBackButtonForViewController: (UIViewController *) controller withAction: (SEL) action;

+ (void)        customizeTitleLabel:    (NSString *) title      forViewController: (UIViewController *) viewController;

+ (void)        customizeHeaderFooterLabels;


//-----------------------------------------------------------------------------------------------------------------------------
#pragma mark - UI Helpers
//-----------------------------------------------------------------------------------------------------------------------------

+ (void)        addBorderAndShadow:     (UIView *) view;

+ (void)        addGradientToButton:    (UIButton *) button;

+ (void)        setTopRoundedCorner:    (UIView *) view;

+ (void)        setBottomRoundedCorner: (UIView *) view;

+ (void)        scrollToBottom: (UIScrollView *) scrollView;


//-----------------------------------------------------------------------------------------------------------------------------
#pragma mark - Data Type Conversion
//-----------------------------------------------------------------------------------------------------------------------------

+ (BOOL)            booleanFromString:          (NSString *) string;

+ (NSString *)      stringFromBoolean:          (BOOL) boolean;

+ (NSString *)      stringFromChatMessageType:  (ChatMessageType) type;

+ (ChatMessageType) chatMessageTypeFromString:  (NSString *) type;


//-----------------------------------------------------------------------------------------------------------------------------
#pragma mark - Whunt Details Helpers
//-----------------------------------------------------------------------------------------------------------------------------

+ (NSString *)  getResultantStringFromText: (NSString *) originalText andRange: (NSRange) range andReplacementString: (NSString *) string;

+ (BOOL)        checkIfIsValidPrice:    (NSString *) price;

+ (NSString *)  formatPriceText:        (NSString *) originalPrice;

+ (NSArray *)   extractCountry:         (NSString *) location;

+ (NSString *)  removeLastDotCharacterIfNeeded: (NSString *) price;


//------------------------------------------------------------------------------------------------------------------------------
#pragma mark - Notification
//------------------------------------------------------------------------------------------------------------------------------

+ (void)        postNotification: (NSString *) notification;


//------------------------------------------------------------------------------------------------------------------------------
#pragma mark - Date Handlers
//------------------------------------------------------------------------------------------------------------------------------

+ (NSDate *)    getRoundMinuteDateFromDate:         (NSDate *) date;

+ (NSString *)  commonlyFormattedStringFromDate:    (NSDate *) date;

    // commonly formatted string example 20/8/2015
+ (NSDate *)    dateFromCommonlyFormattedString:    (NSString *) string;

    // timestamp examples: 3s, 15m, 4h, 6d, 234w
+ (NSString *)  timestampStringFromDate:            (NSDate *) date;

    // long timestamp examples: 1 second, 3 seconds, 1 minute, 15 minutes
+ (NSString *)  longTimestampStringFromDate:        (NSDate *) date;


//------------------------------------------------------------------------------------------------------------------------------
#pragma mark - Parse Backend
//------------------------------------------------------------------------------------------------------------------------------

+ (void) getUserWithID: (NSString *) userID andRunBlock: (FetchedUserHandler) handler;


//------------------------------------------------------------------------------------------------------------------------------
#pragma mark -  Transaction Data
//------------------------------------------------------------------------------------------------------------------------------

+ (BOOL)        amITheBuyer: (OfferData *) offerData;

+ (NSString *)  idOfDealerDealingWithMe: (OfferData *) offerData;

+ (NSString *)  makingOfferMessageFromOfferedPrice: (NSString *) offeredPrice andDeliveryTime: (NSString *) deliveryTime;

@end
