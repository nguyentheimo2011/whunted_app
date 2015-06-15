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

+ (void) addBorderAndShadow: (UIView *) view;
+ (void) setTopRoundedCorner: (UIView *) view;
+ (void) setBottomRoundedCorner: (UIView *) view;
+ (UIImage *) resizeImage: (UIImage *) originalImage toSize: (CGSize) newSize;
+ (void) addGradientToButton: (UIButton *) button;
+ (UIImage *)imageWithColor:(UIColor *)color;

@end
