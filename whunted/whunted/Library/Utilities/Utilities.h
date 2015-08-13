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

#pragma mark - UI

//------------------------------------------------------------------------------------------------------------------------------
+ (void)        addBorderAndShadow: (UIView *) view;
//------------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------------------------------------
+ (void)        setTopRoundedCorner: (UIView *) view;
//------------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------------------------------------
+ (void)        setBottomRoundedCorner: (UIView *) view;
//------------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------------------------------------
+ (UIImage *)   resizeImage: (UIImage *) originalImage toSize: (CGSize) newSize;
//------------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------------------------------------
+ (void)        addGradientToButton: (UIButton *) button;
//------------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------------------------------------
+ (UIImage *)   imageFromColor:(UIColor *)color forSize:(CGSize)size withCornerRadius:(CGFloat)radius;
//------------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------------------------------------
+ (UIImage *)   imageWithColor:(UIColor *)color;
//------------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------------------------------------
+ (CGFloat)     getStatusBarHeight;
//------------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------------------------------------
+ (void)        customizeTitleLabel: (NSString *) title forViewController: (UIViewController *) viewController;
//------------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------------------------------------
+ (void)        customizeHeaderFooterLabels;
//------------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------------------------------------
+ (void)        customizeTabBar;
//------------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------------------------------------
+ (void)        customizeNavigationBar;
//------------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------------------------------------
+ (CGFloat)     widthOfText: (NSString *) text withFont: (UIFont *) font andMaxWidth: (CGFloat) maxWidth;
//------------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------------------------------------
+ (void)        scrollToBottom: (UIScrollView *) scrollView;
//------------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------------------------------------
+ (CGFloat)     getHeightOfNavigationAndStatusBars: (UIViewController *) viewController;
//------------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------------------------------------
+ (CGFloat)     getHeightOfBottomTabBar: (UIViewController *) viewController;
//------------------------------------------------------------------------------------------------------------------------------

#pragma mark - Data Handler

//------------------------------------------------------------------------------------------------------------------------------
+ (NSString *)  getResultantStringFromText: (NSString *) originalText andRange: (NSRange) range andReplacementString: (NSString *) string;
//------------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------------------------------------
+ (BOOL)        checkIfIsValidPrice: (NSString *) price;
//------------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------------------------------------
+ (NSString *)  formatPriceText: (NSString *) originalPrice;
//------------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------------------------------------
+ (NSString *)  removeLastDotCharacterIfNeeded: (NSString *) price;
//------------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------------------------------------
+ (NSArray *)   extractCountry: (NSString *) location;
//------------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------------------------------------
+ (NSString *)  stringFromBoolean: (BOOL) boolean;
//------------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------------------------------------
+ (BOOL)        booleanFromString: (NSString *) string;
//------------------------------------------------------------------------------------------------------------------------------

#pragma mark - Notification

//------------------------------------------------------------------------------------------------------------------------------
+ (void)        postNotification: (NSString *) notification;
//------------------------------------------------------------------------------------------------------------------------------

#pragma mark - Date Handlers

//------------------------------------------------------------------------------------------------------------------------------
+ (NSDate *)    getRoundMinuteDateFromDate: (NSDate *) date;
//------------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------------------------------------
+ (NSString *)  commonlyFormattedStringFromDate: (NSDate *) date;
//------------------------------------------------------------------------------------------------------------------------------

// commonly formatted string example 20/8/2015
//------------------------------------------------------------------------------------------------------------------------------
+ (NSDate *)    dateFromCommonlyFormattedString: (NSString *) string;
//------------------------------------------------------------------------------------------------------------------------------

// timestamp examples: 3s, 15m, 4h, 6d, 234w
//------------------------------------------------------------------------------------------------------------------------------
+ (NSString *)  timestampStringFromDate: (NSDate *) date;
//------------------------------------------------------------------------------------------------------------------------------

// long timestamp examples: 1 second, 3 seconds, 1 minute, 15 minutes
//------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------
+ (NSString *)  longTimestampStringFromDate: (NSDate *) date;
//------------------------------------------------------------------------------------------------------------------------------

#pragma mark - Parse Backend

//------------------------------------------------------------------------------------------------------------------------------
+ (void) getUserWithID: (NSString *) userID andRunBlock: (FetchedUserHandler) handler;
//------------------------------------------------------------------------------------------------------------------------------

#pragma mark - Data Specifics

//------------------------------------------------------------------------------------------------------------------------------
+ (BOOL) amITheBuyer: (OfferData *) offerData;
//------------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------------------------------------
+ (NSString *) idOfDealerDealingWithMe: (OfferData *) offerData;
//------------------------------------------------------------------------------------------------------------------------------


@end
