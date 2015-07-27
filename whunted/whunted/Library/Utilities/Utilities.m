//
//  Utilities.m
//  whunted
//
//  Created by thomas nguyen on 13/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "Utilities.h"
#import "AppConstant.h"

@implementation Utilities

//------------------------------------------------------------------------------------------------------------------------------
+ (void) addBorderAndShadow: (UIView *) view
//------------------------------------------------------------------------------------------------------------------------------
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

//------------------------------------------------------------------------------------------------------------------------------
+ (void) setTopRoundedCorner:(UIView *)view
//------------------------------------------------------------------------------------------------------------------------------
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

//------------------------------------------------------------------------------------------------------------------------------
+ (void) setBottomRoundedCorner: (UIView *) view
//------------------------------------------------------------------------------------------------------------------------------
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

//------------------------------------------------------------------------------------------------------------------------------
+ (UIImage *) resizeImage: (UIImage *) originalImage toSize: (CGSize) newSize
//------------------------------------------------------------------------------------------------------------------------------s
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

//------------------------------------------------------------------------------------------------------------------------------
+ (void) addGradientToButton:(UIButton *)button
//------------------------------------------------------------------------------------------------------------------------------
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = button.layer.bounds;
    
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)[UIColor colorWithWhite:1.0f alpha:0.1f].CGColor,
                            (id)[UIColor colorWithWhite:0.4f alpha:0.5f].CGColor,
                            nil];
    
    gradientLayer.locations = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0.0f],
                               [NSNumber numberWithFloat:1.0f],
                               nil];
    
    gradientLayer.cornerRadius = button.layer.cornerRadius;
    [button.layer addSublayer:gradientLayer];
}

//------------------------------------------------------------------------------------------------------------------------------
+ (UIImage *)imageWithColor:(UIColor *)color
//------------------------------------------------------------------------------------------------------------------------------
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//------------------------------------------------------------------------------------------------------------------------------
+ (void) postNotification: (NSString *) notification
//------------------------------------------------------------------------------------------------------------------------------
{
    [[NSNotificationCenter defaultCenter] postNotificationName:notification object:nil];
}

//------------------------------------------------------------------------------------------------------------------------------
+ (BOOL) checkIfIsValidPrice: (NSString *) price
//------------------------------------------------------------------------------------------------------------------------------
{
    NSRange range = [price rangeOfString:DOT_CHARACTER];
    if (range.location == NSNotFound)
        return YES;
    else {
        NSString *subString = [price substringFromIndex:range.location + 1];
        if ([subString containsString:DOT_CHARACTER])
            return NO;
        else {
            if (range.location < [price length]-3)
                return NO;
            else
                return YES;
        }
    }
}

//------------------------------------------------------------------------------------------------------------------------------
+ (NSString *) formatPriceText: (NSString *) originalPrice
//------------------------------------------------------------------------------------------------------------------------------
{
    originalPrice = [originalPrice substringFromIndex:TAIWAN_CURRENCY.length];
    originalPrice = [originalPrice stringByReplacingOccurrencesOfString:COMMA_CHARACTER withString:@""];
    
    NSRange range = [originalPrice rangeOfString:DOT_CHARACTER];
    NSString *fractional;
    if (range.location == NSNotFound || range.location >= [originalPrice length])
        fractional = @"";
    else
        fractional = [originalPrice substringFromIndex:range.location];
    
    NSInteger integerPrice;
    if (range.location == NSNotFound || range.location >= [originalPrice length])
        integerPrice = [originalPrice integerValue];
    else
        integerPrice = [[originalPrice substringToIndex:range.location] integerValue];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSString *formattedIntegerPrice = [formatter stringFromNumber:[NSNumber numberWithInteger:integerPrice]];
    
    return [TAIWAN_CURRENCY stringByAppendingString:[formattedIntegerPrice stringByAppendingString:fractional]];
}

//------------------------------------------------------------------------------------------------------------------------------
+ (NSString *) getResultantStringFromText: (NSString *) originalText andRange: (NSRange) range andReplacementString: (NSString *) string
//------------------------------------------------------------------------------------------------------------------------------
{
    if (range.location == [originalText length]) {
        return [originalText stringByAppendingString:string];
    } else {
        if ([string length] == 0) { // User removes a character
            NSString *firstSubstring = [originalText substringToIndex:range.location];
            NSString *secondSubstring = [originalText substringFromIndex:range.location + 1];
            return [firstSubstring stringByAppendingString:secondSubstring];
        } else {
            NSString *firstSubstring = [originalText substringToIndex:range.location];
            NSString *secondSubstring = [originalText substringFromIndex:range.location + 1];
            return [[firstSubstring stringByAppendingString:string] stringByAppendingString:secondSubstring];
        }
    }
}

//------------------------------------------------------------------------------------------------------------------------------
+ (NSString *) removeLastDotCharacterIfNeeded:(NSString *)price
//------------------------------------------------------------------------------------------------------------------------------
{
    if ([price characterAtIndex:[price length]-1] == '.')
        return [price substringToIndex:[price length]-1];
    else
        return price;
}

//-------------------------------------------------------------------------------------------------------------------------------
+ (NSDate *) getRoundMinuteDateFromDate: (NSDate *) date
//-------------------------------------------------------------------------------------------------------------------------------
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
    return [calendar dateFromComponents:comps];
}

//-------------------------------------------------------------------------------------------------------------------------------
+ (CGFloat) getStatusBarHeight
//-------------------------------------------------------------------------------------------------------------------------------
{
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}

//------------------------------------------------------------------------------------------------------------------------------
+ (void) customizeTitleLabel: (NSString *) title forViewController: (UIViewController *) viewController
//------------------------------------------------------------------------------------------------------------------------------
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:16];
    titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = [NSString stringWithFormat:@"%@", title];
    [titleLabel sizeToFit];
    viewController.navigationItem.titleView = titleLabel;
}

//------------------------------------------------------------------------------------------------------------------------------
+ (CGFloat) widthOfText: (NSString *) text withFont: (UIFont *) font andMaxWidth: (CGFloat) maxWidth
//------------------------------------------------------------------------------------------------------------------------------
{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = font;
    [label sizeToFit];
    CGFloat currWidth = label.frame.size.width;
    
    if (currWidth >= maxWidth)
        return maxWidth;
    else
        return currWidth;
}

//------------------------------------------------------------------------------------------------------------------------------
+ (void) scrollToBottom:(UIScrollView *)scrollView
//------------------------------------------------------------------------------------------------------------------------------
{
    CGPoint bottomOffset = CGPointMake(0, scrollView.contentSize.height - scrollView.bounds.size.height);
    [scrollView setContentOffset:bottomOffset animated:YES];
}

//------------------------------------------------------------------------------------------------------------------------------
+ (NSString *) commonlyFormattedStringFromDate: (NSDate *) date
//------------------------------------------------------------------------------------------------------------------------------
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    return [formatter stringFromDate:date];
}

@end
