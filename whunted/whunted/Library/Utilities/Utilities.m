//
//  Utilities.m
//  whunted
//
//  Created by thomas nguyen on 13/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

+ (void) addBorderAndShadow: (UIView *) view
{
    // border radius
    [view.layer setCornerRadius:10.0f];
    [view clipsToBounds];
    
    // border
    [view.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [view.layer setBorderWidth:0.5f];
    
    // drop shadow
    [view.layer setShadowColor:[UIColor blackColor].CGColor];
    [view.layer setShadowOpacity:0.8];
    [view.layer setShadowRadius:3.0];
    [view.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
}

+ (void) setTopRoundedCorner:(UIView *)view
{
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                     byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight)
                                           cornerRadii:CGSizeMake(10.0f, 10.0f)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

+ (void) setBottomRoundedCorner: (UIView *) view
{
    UIBezierPath *maskPath;
    maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                     byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight)
                                           cornerRadii:CGSizeMake(10.0f, 10.0f)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

+ (UIImage *) resizeImage: (UIImage *) originalImage toSize: (CGSize) newSize
{
    CGFloat wRatio = newSize.width * 1.0 / originalImage.size.width;
    CGFloat hRatio = newSize.height * 1.0 / originalImage.size.height;
    CGFloat minRatio = MIN(wRatio, hRatio);
    CGFloat newWidth = originalImage.size.width * minRatio;
    CGFloat newHeight = originalImage.size.height * minRatio;
    
    CGRect rect = CGRectMake(0,0,newWidth,newHeight);
    UIGraphicsBeginImageContext( rect.size );
    [originalImage drawInRect:rect];
    UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImagePNGRepresentation(picture1);
    UIImage *newImage=[UIImage imageWithData:imageData];
    return newImage;
}

@end
