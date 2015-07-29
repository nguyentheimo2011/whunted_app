//
//  Utilities.h
//  whunted
//
//  Created by thomas nguyen on 13/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

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
+ (CGFloat)     widthOfText: (NSString *) text withFont: (UIFont *) font andMaxWidth: (CGFloat) maxWidth;
//------------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------------------------------------
+ (void)        scrollToBottom: (UIScrollView *) scrollView;
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
+ (NSArray *) extractCountry: (NSString *) location;
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
+ (NSString *) commonlyFormattedStringFromDate: (NSDate *) date;
//------------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------------------------------------
+ (NSDate *) dateFromCommonlyFormattedString: (NSString *) string;
//------------------------------------------------------------------------------------------------------------------------------


@end
