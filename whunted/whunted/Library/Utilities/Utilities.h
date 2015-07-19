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

+ (void)        addBorderAndShadow: (UIView *) view;
+ (void)        setTopRoundedCorner: (UIView *) view;
+ (void)        setBottomRoundedCorner: (UIView *) view;
+ (UIImage *)   resizeImage: (UIImage *) originalImage toSize: (CGSize) newSize;
+ (void)        addGradientToButton: (UIButton *) button;
+ (UIImage *)   imageWithColor:(UIColor *)color;

+ (void)        postNotification: (NSString *) notification;

+ (NSString *)  getResultantStringFromText: (NSString *) originalText andRange: (NSRange) range andReplacementString: (NSString *) string;
+ (BOOL)        checkIfIsValidPrice: (NSString *) price;
+ (NSString *)  formatPriceText: (NSString *) originalPrice;
+ (NSString *)  removeLastDotCharacterIfNeeded: (NSString *) price;

+ (NSDate *)    getRoundMinuteDateFromDate: (NSDate *) date;
+ (CGFloat)     getStatusBarHeight;

//------------------------------------------------------------------------------------------------------------------------------
+ (void)        customizeTitleLabel: (NSString *) title forViewController: (UIViewController *) viewController;
//------------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------------------------------------
+ (CGFloat)        widthOfText: (NSString *) text withFont: (UIFont *) font andMaxWidth: (CGFloat) maxWidth;
//------------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------------------------------------
+ (void)            scrollToBottom: (UIScrollView *) scrollView;
//------------------------------------------------------------------------------------------------------------------------------

@end
