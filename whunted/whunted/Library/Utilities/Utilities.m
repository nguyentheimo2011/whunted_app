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


#pragma mark - UI Handlers

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

//-------------------------------------------------------------------------------------------------------------------------------
+ (UIImage *)imageFromColor:(UIColor *)color forSize:(CGSize)size withCornerRadius:(CGFloat)radius
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContext(size);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
    // Draw your image
    [image drawInRect:rect];
    
    // Get the image, here setting the UIImageView image
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    return image;
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
    titleLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:BIG_FONT_SIZE];
    titleLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = [NSString stringWithFormat:@"%@", title];
    [titleLabel sizeToFit];
    viewController.navigationItem.titleView = titleLabel;
}

//------------------------------------------------------------------------------------------------------------------------------
+ (void) customizeHeaderFooterLabels
//------------------------------------------------------------------------------------------------------------------------------
{
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:17]];
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setTextColor:TEXT_COLOR_DARK_GRAY];
}

//------------------------------------------------------------------------------------------------------------------------------
+ (void) customizeTabBar
//------------------------------------------------------------------------------------------------------------------------------
{
    // set the text color for selected state
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:REGULAR_FONT_NAME size:13], NSForegroundColorAttributeName : MAIN_BLUE_COLOR} forState:UIControlStateSelected];
    // set the text color for unselected state
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:REGULAR_FONT_NAME size:13], NSForegroundColorAttributeName : [UIColor grayColor]} forState:UIControlStateNormal];
    
    // set the selected icon color
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setSelectedImageTintColor:MAIN_BLUE_COLOR];
    // remove the shadow
    [[UITabBar appearance] setShadowImage:nil];
}

//------------------------------------------------------------------------------------------------------------------------------
+ (void) customizeNavigationBar
//------------------------------------------------------------------------------------------------------------------------------
{
    [[UINavigationBar appearance] setBarTintColor:MAIN_BLUE_COLOR];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
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
+ (void) customizeItemBarButton
//------------------------------------------------------------------------------------------------------------------------------
{
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSFontAttributeName : DEFAULT_FONT} forState:UIControlStateNormal];
}

//------------------------------------------------------------------------------------------------------------------------------
+ (CGFloat) getHeightOfNavigationAndStatusBars: (UIViewController *) viewController
//------------------------------------------------------------------------------------------------------------------------------
{
    return viewController.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
}

//------------------------------------------------------------------------------------------------------------------------------
+ (CGFloat) getHeightOfBottomTabBar:(UIViewController *)viewController
//------------------------------------------------------------------------------------------------------------------------------
{
    return viewController.tabBarController.tabBar.frame.size.height;
}

#pragma mark - Notification Handlers

//------------------------------------------------------------------------------------------------------------------------------
+ (void) postNotification: (NSString *) notification
//------------------------------------------------------------------------------------------------------------------------------
{
    [[NSNotificationCenter defaultCenter] postNotificationName:notification object:nil];
}

#pragma mark - Data Handlers

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

//------------------------------------------------------------------------------------------------------------------------------
+ (NSArray *) extractCountry: (NSString *) location
//------------------------------------------------------------------------------------------------------------------------------
{
    NSRange commaSignRange = [location rangeOfString:@"," options:NSBackwardsSearch];
    NSString *specificAddress;
    NSString *country;
    
    if (commaSignRange.location >= location.length)
    {
        specificAddress = @"";
        country = location;
    } else {
        specificAddress = [location substringToIndex:commaSignRange.location];
        country = [location substringFromIndex:commaSignRange.location + 1];
    }
    
    return [NSArray arrayWithObjects:specificAddress, country, nil];
}

#pragma mark - Date Handlers

//------------------------------------------------------------------------------------------------------------------------------
+ (NSDate *) dateFromCommonlyFormattedString: (NSString *) string;
//------------------------------------------------------------------------------------------------------------------------------
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    return [formatter dateFromString:string];
}

//-------------------------------------------------------------------------------------------------------------------------------
+ (NSDate *) getRoundMinuteDateFromDate: (NSDate *) date
//-------------------------------------------------------------------------------------------------------------------------------
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
    return [calendar dateFromComponents:comps];
}

//------------------------------------------------------------------------------------------------------------------------------
+ (NSString *) commonlyFormattedStringFromDate: (NSDate *) date
//------------------------------------------------------------------------------------------------------------------------------
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    return [formatter stringFromDate:date];
}

//------------------------------------------------------------------------------------------------------------------------------
+ (NSString *) timestampStringFromDate:(NSDate *)date
//------------------------------------------------------------------------------------------------------------------------------
{
    NSDate *now = [NSDate date];
    NSTimeInterval timeInterval = [now timeIntervalSinceDate:date];
    
    if (timeInterval < NUM_OF_SECONDS_IN_A_MINUTE) {
        NSInteger numOfSecs = (NSInteger) timeInterval;
        NSString *timestamp = [NSString stringWithFormat:@"%ld%@", (long) numOfSecs, NSLocalizedString(@"s", nil)];
        return timestamp;
    } else if (timeInterval < NUM_OF_SECONDS_IN_AN_HOUR) {
        NSInteger numOfMins = (NSInteger) (timeInterval / NUM_OF_SECONDS_IN_A_MINUTE);
        NSString *timestamp = [NSString stringWithFormat:@"%ld%@", (long) numOfMins, NSLocalizedString(@"m", nil)];
        return timestamp;
    } else if (timeInterval < NUM_OF_SECONDS_IN_A_DAY) {
        NSInteger numOfHours = (NSInteger) (timeInterval / NUM_OF_SECONDS_IN_AN_HOUR);
        NSString *timestamp = [NSString stringWithFormat:@"%ld%@", (long) numOfHours, NSLocalizedString(@"h", nil)];
        return timestamp;
    } else if (timeInterval < NUM_OF_SECONDS_IN_A_WEEK) {
        NSInteger numOfDays = (NSInteger) (timeInterval / NUM_OF_SECONDS_IN_A_DAY);
        NSString *timestamp = [NSString stringWithFormat:@"%ld%@", (long) numOfDays, NSLocalizedString(@"d", nil)];
        return timestamp;
    } else {
        NSInteger numOfWeeks = (NSInteger) (timeInterval / NUM_OF_SECONDS_IN_A_WEEK);
        NSString *timestamp = [NSString stringWithFormat:@"%ld%@", (long) numOfWeeks, NSLocalizedString(@"w", nil)];
        return timestamp;
    }
    
    return @"";
}

@end
