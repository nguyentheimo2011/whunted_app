//
//  Utilities.m
//  whunted
//
//  Created by thomas nguyen on 13/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "Utilities.h"
#import <Google/Analytics.h>
#import <MRProgress.h>

@implementation Utilities


#pragma mark - UI Image

//------------------------------------------------------------------------------------------------------------------------------
+ (UIImage *) resizeImage: (UIImage *) originalImage toSize: (CGSize) newSize scalingProportionally: (BOOL) scalingProportionally
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat newWidth;
    CGFloat newHeight;
    
    if (scalingProportionally)
    {
        CGFloat wRatio = newSize.width * 1.0 / originalImage.size.width;
        CGFloat hRatio = newSize.height * 1.0 / originalImage.size.height;
        CGFloat minRatio = MIN(wRatio, hRatio);
        
        if (minRatio >= 1)
            return originalImage;
        
        newWidth = originalImage.size.width * minRatio;
        newHeight = originalImage.size.height * minRatio;
    }
    else
    {
        newWidth    =   newSize.width;
        newHeight   =   newSize.height;
    }
    
    CGRect rect = CGRectMake(0,0,newWidth,newHeight);
    UIGraphicsBeginImageContext( rect.size );
    [originalImage drawInRect:rect];
    UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImageJPEGRepresentation(picture1, 0.5);
    UIImage *newImage=[UIImage imageWithData:imageData];
    return newImage;
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


#pragma mark - UI Size

//-------------------------------------------------------------------------------------------------------------------------------
+ (CGFloat) getStatusBarHeight
//-------------------------------------------------------------------------------------------------------------------------------
{
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}

//------------------------------------------------------------------------------------------------------------------------------
+ (CGFloat) getHeightOfBottomTabBar:(UIViewController *)viewController
//------------------------------------------------------------------------------------------------------------------------------
{
    return viewController.tabBarController.tabBar.frame.size.height;
}

//------------------------------------------------------------------------------------------------------------------------------
+ (CGFloat) getHeightOfNavigationAndStatusBars: (UIViewController *) viewController
//------------------------------------------------------------------------------------------------------------------------------
{
    return viewController.navigationController.navigationBar.frame.size.height + [[UIApplication sharedApplication] statusBarFrame].size.height;
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
+ (CGSize) sizeOfFullCollectionCell
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kCellWidth    =   WINSIZE.width/2 - 12.0f;
    CGFloat const kCellHeight   =   kCellWidth + 90.0f;
    
    return CGSizeMake(kCellWidth, kCellHeight);
}

//------------------------------------------------------------------------------------------------------------------------------
+ (CGSize) sizeOfSimplifiedCollectionCell
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kCellWidth    =   WINSIZE.width/2 - 12.0f;
    CGFloat const kCellHeight   =   kCellWidth + 65.0f;
    
    return CGSizeMake(kCellWidth, kCellHeight);
}

//-----------------------------------------------------------------------------------------------------------------------------
+ (CGFloat) getHeightOfKeyboard:(NSNotification *)notification
//-----------------------------------------------------------------------------------------------------------------------------
{
    NSValue *value = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    return [value CGRectValue].size.height;
}


#pragma mark - UI Customization

//------------------------------------------------------------------------------------------------------------------------------
+ (void) customizeTabBar
//------------------------------------------------------------------------------------------------------------------------------
{
    [[UITabBar appearance] setBackgroundImage:[Utilities imageWithColor:[[UIColor whiteColor] colorWithAlphaComponent:0.9f]]];
    
    // set the text color for selected state
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:REGULAR_FONT_NAME size:12], NSForegroundColorAttributeName : MAIN_BLUE_COLOR} forState:UIControlStateSelected];
    // set the text color for unselected state
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:REGULAR_FONT_NAME size:12], NSForegroundColorAttributeName : [UIColor grayColor]} forState:UIControlStateNormal];
    
    // set the selected icon color
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setSelectedImageTintColor:MAIN_BLUE_COLOR];
    
    [[UITabBar appearance] setShadowImage:[Utilities imageWithColor:[UIColor whiteColor]]];
}

//------------------------------------------------------------------------------------------------------------------------------
+ (void) customizeNavigationBar
//------------------------------------------------------------------------------------------------------------------------------
{
    [[UINavigationBar appearance] setBarTintColor:MAIN_BLUE_COLOR];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}

//------------------------------------------------------------------------------------------------------------------------------
+ (void) customizeBackButtonForViewController:(UIViewController *)controller withAction:(SEL)action
//------------------------------------------------------------------------------------------------------------------------------
{
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = -11.0f;
    
    controller.navigationItem.leftBarButtonItems = @[spacer, [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back_icon.png"] style:UIBarButtonItemStylePlain target:controller action:action]];
}

//------------------------------------------------------------------------------------------------------------------------------
+ (void) customizeTitleLabel: (NSString *) title forViewController: (UIViewController *) viewController
//------------------------------------------------------------------------------------------------------------------------------
{
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:BOLD_FONT_NAME size:DEFAULT_FONT_SIZE];
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
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE]];
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setTextColor:TEXT_COLOR_DARK_GRAY];
}

//------------------------------------------------------------------------------------------------------------------------------
+ (void) addLeftPaddingToTextField:(UITextField *)textField
//------------------------------------------------------------------------------------------------------------------------------
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10.0f, textField.frame.size.height)];
    textField.leftView = paddingView;
    textField.leftViewMode = UITextFieldViewModeAlways;
}


#pragma mark - UI Progress Indicator

//------------------------------------------------------------------------------------------------------------------------------
+ (void) showStandardIndeterminateProgressIndicatorInView:(UIView *)view
//------------------------------------------------------------------------------------------------------------------------------
{
    [MRProgressOverlayView showOverlayAddedTo:view title:@"" mode:MRProgressOverlayViewModeIndeterminate animated:YES];
}

//------------------------------------------------------------------------------------------------------------------------------
+ (void) showSmallIndeterminateProgressIndicatorInView:(UIView *)view
//------------------------------------------------------------------------------------------------------------------------------
{
    [MRProgressOverlayView showOverlayAddedTo:view title:@"" mode:MRProgressOverlayViewModeIndeterminateSmall animated:YES];
}

//------------------------------------------------------------------------------------------------------------------------------
+ (void) hideIndeterminateProgressIndicatorInView:(UIView *)view
//------------------------------------------------------------------------------------------------------------------------------
{
    [MRProgressOverlayView dismissOverlayForView:view animated:YES];
}


#pragma mark - UI Helpers

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
+ (void) addShadowToView:(UIView *)view
//------------------------------------------------------------------------------------------------------------------------------
{
    view.layer.masksToBounds = NO;
    view.layer.shadowOffset = CGSizeMake(-1, 1);
    view.layer.shadowRadius = 2;
    view.layer.shadowOpacity = 0.25;
}

//------------------------------------------------------------------------------------------------------------------------------
+ (void) addShadowToCollectionCell:(UICollectionViewCell *)cell
//------------------------------------------------------------------------------------------------------------------------------
{
    cell.layer.masksToBounds = NO;
    cell.layer.shadowOffset = CGSizeMake(-1, 1);
    cell.layer.shadowRadius = 1.5;
    cell.layer.shadowOpacity = 0.1;
}

//------------------------------------------------------------------------------------------------------------------------------
+ (void) addGradientToView:(UIView *) view
//------------------------------------------------------------------------------------------------------------------------------
{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.layer.bounds;
    
    gradientLayer.colors = [NSArray arrayWithObjects:
                            (id)[UIColor colorWithWhite:1.0f alpha:0.1f].CGColor,
                            (id)[UIColor colorWithWhite:0.9f alpha:0.9f].CGColor,
                            nil];
    
    gradientLayer.locations = [NSArray arrayWithObjects:
                               [NSNumber numberWithFloat:0.0f],
                               [NSNumber numberWithFloat:1.0f],
                               nil];
    
    gradientLayer.cornerRadius = view.layer.cornerRadius;
    [view.layer addSublayer:gradientLayer];
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
+ (void) scrollToBottom:(UIScrollView *)scrollView
//------------------------------------------------------------------------------------------------------------------------------
{
    CGPoint bottomOffset = CGPointMake(0, scrollView.contentSize.height - scrollView.bounds.size.height);
    [scrollView setContentOffset:bottomOffset animated:YES];
}

//------------------------------------------------------------------------------------------------------------------------------
+ (UIView *) getSubviewOfView:(UIView *)parentView withTag:(NSInteger)tag
//------------------------------------------------------------------------------------------------------------------------------
{
    for (UIView *view in [parentView subviews])
    {
        if (view.tag == tag)
            return view;
    }
    
    return nil;
}

//------------------------------------------------------------------------------------------------------------------------------
+ (void) displayErrorAlertViewWithMessage:(NSString *)message
//------------------------------------------------------------------------------------------------------------------------------
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Oops!", nil) message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    [alertView show];
}


#pragma mark - Data Type Conversion

//------------------------------------------------------------------------------------------------------------------------------
+ (BOOL) booleanFromYesNoString:(NSString *)string
//------------------------------------------------------------------------------------------------------------------------------
{
    if ([string isEqualToString:STRING_OF_YES])
        return YES;
    else
        return NO;
}

//------------------------------------------------------------------------------------------------------------------------------
+ (BOOL) booleanFrom01String:(NSString *)string
//------------------------------------------------------------------------------------------------------------------------------
{
    if ([string isEqualToString:@"0"])
        return NO;
    else
        return YES;
}

//------------------------------------------------------------------------------------------------------------------------------
+ (NSString *)  stringFromBoolean: (BOOL) boolean
//------------------------------------------------------------------------------------------------------------------------------
{
    if (boolean)
        return STRING_OF_YES;
    else
        return STRING_OF_NO;
}

//------------------------------------------------------------------------------------------------------------------------------
+ (NSString *) stringFromChatMessageType:(ChatMessageType)type
//------------------------------------------------------------------------------------------------------------------------------
{
    if (type == ChatMessageTypeNone)
        return @"ChatMessageTypeNone";
    else if (type == ChatMessageTypeAcceptingOffer)
        return @"ChatMessageTypeAcceptingOffer";
    else if (type == ChatMessageTypeCancellingOffer)
        return @"ChatMessageTypeCancellingOffer";
    else if (type == ChatMessageTypeDecliningOffer)
        return @"ChatMessageTypeDecliningOffer";
    else if (type == ChatMessageTypeMakingOffer)
        return @"ChatMessageTypeMakingOffer";
    else if (type == ChatMessageTypeNormal)
        return @"ChatMessageTypeNormal";
    else if (type == ChatMessageTypeLeavingFeeback)
        return @"ChatMessageTypeLeavingFeeback";
    else
        return @"";
}

//------------------------------------------------------------------------------------------------------------------------------
+ (ChatMessageType) chatMessageTypeFromString:(NSString *)type
//------------------------------------------------------------------------------------------------------------------------------
{
    if ([type isEqualToString:@"ChatMessageTypeNone"])
        return ChatMessageTypeNone;
    else if ([type isEqualToString:@"ChatMessageTypeAcceptingOffer"])
        return ChatMessageTypeAcceptingOffer;
    else if ([type isEqualToString:@"ChatMessageTypeCancellingOffer"])
        return ChatMessageTypeCancellingOffer;
    else if ([type isEqualToString:@"ChatMessageTypeDecliningOffer"])
        return ChatMessageTypeDecliningOffer;
    else if ([type isEqualToString:@"ChatMessageTypeMakingOffer"])
        return ChatMessageTypeMakingOffer;
    else if ([type isEqualToString:@"ChatMessageTypeNormal"])
        return ChatMessageTypeNormal;
    else if ([type isEqualToString:@"ChatMessageTypeLeavingFeeback"])
        return ChatMessageTypeLeavingFeeback;
    else
        return ChatMessageTypeNone;
}

//------------------------------------------------------------------------------------------------------------------------------
+ (float) floatingNumFromDemandedPrice:(NSString *)demandedPrice
//------------------------------------------------------------------------------------------------------------------------------
{
    NSString *reducedString = [demandedPrice stringByReplacingOccurrencesOfString:PROPER_TAIWAN_CURRENCY withString:@""];
    reducedString = [reducedString stringByReplacingOccurrencesOfString:@" " withString:@""];
    reducedString = [reducedString stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    return [reducedString floatValue];
}


#pragma mark -  Transaction Data

//------------------------------------------------------------------------------------------------------------------------------
+ (BOOL) amITheBuyer:(TransactionData *) offerData
//------------------------------------------------------------------------------------------------------------------------------
{
    if ([[PFUser currentUser].objectId isEqualToString:offerData.buyerID])
        return YES;
    else
        return NO;
}

//------------------------------------------------------------------------------------------------------------------------------
+ (NSString *) idOfDealerDealingWithMe: (TransactionData *) offerData
//------------------------------------------------------------------------------------------------------------------------------
{
    if ([[PFUser currentUser].objectId isEqualToString:offerData.buyerID])
        return offerData.sellerID;
    else
        return offerData.buyerID;
}

//------------------------------------------------------------------------------------------------------------------------------
+ (NSString *)  makingOfferMessageFromOfferedPrice: (NSString *) offeredPrice deliveryTime: (NSString *) deliveryTime shippingFeeIncluded: (BOOL) shippingFeeIncluded
//------------------------------------------------------------------------------------------------------------------------------
{
    NSString *message = @"";
    NSString *string1 = NSLocalizedString(@"Made An Offer", nil);
    NSString *string2 = NSLocalizedString(@"Deliver in", nil);
    NSString *day     = NSLocalizedString(@"dayString", nil);
    NSString *days    = NSLocalizedString(@"daysString", nil);
    
    NSString *shippingFeeOption = NSLocalizedString(@"Shipping is included", nil);
    if (!shippingFeeIncluded)
        shippingFeeOption = NSLocalizedString(@"Shipping is not included", nil);
        
    
    if ([deliveryTime integerValue] <= 1)
        message = [NSString stringWithFormat:@"%@\n  %@  \n%@ \n%@ %@ %@", string1, offeredPrice, shippingFeeOption, string2, deliveryTime, day];
    else
        message = [NSString stringWithFormat:@"%@\n  %@  \n%@ \n%@ %@ %@", string1, offeredPrice, shippingFeeOption, string2, deliveryTime, days];
    
    return message;
}


#pragma mark - Chat Data

//------------------------------------------------------------------------------------------------------------------------------
+ (NSString *) generateChatGroupIDFromItemID:(NSString *)itemID user1:(PFUser *)user1 user2:(PFUser *)user2
//------------------------------------------------------------------------------------------------------------------------------
{
    NSString *id1 = user1.objectId;
    NSString *id2 = user2.objectId;
    
    NSString *groupId = ([id1 compare:id2] < 0) ? [NSString stringWithFormat:@"%@%@%@", itemID, id1, id2] : [NSString stringWithFormat:@"%@%@%@", itemID, id2, id1];
    
    return groupId;
}


#pragma mark - NSString Helper

//------------------------------------------------------------------------------------------------------------------------------
+ (BOOL) consistedOnlyOfDigits:(NSString *)string
//------------------------------------------------------------------------------------------------------------------------------
{
    NSCharacterSet *notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([string rangeOfCharacterFromSet:notDigits].location == NSNotFound)
        return YES;
    else
        return NO;
}


#pragma mark - Mutiple Languages Support

//------------------------------------------------------------------------------------------------------------------------------
+ (NSString *) getSynonymOfWord:(NSString *)word
//------------------------------------------------------------------------------------------------------------------------------
{
    NSArray *englishCategories = @[ITEM_CATEGORY_LUXURY_FASHION, ITEM_CATEGORY_POPULAR_BRANDS, ITEM_CATEGORY_BEAUTY_PRODUCTS, ITEM_CATEGORY_CLOTHING_APPARELS, ITEM_CATEGORY_SHOES_BAG_ACCESSORIES, ITEM_CATEGORY_3C_PRODUCTS, ITEM_CATEGORY_ART_DESIGN, ITEM_CATEGORY_HOME_ACCESSORIES, ITEM_CATEGORY_HOME_FURNITURE, ITEM_CATEGORY_PET_SUPPLIES, ITEM_CATEGORY_GAMES, ITEM_CATEGORY_TOYS, ITEM_CATEGORY_BOOKS_MAGAZINES, ITEM_CATEGORY_VIDEO_PRODUCTION_EQUIPMENT, ITEM_CATEGORY_MUSICAL_INSTRUMENTS, ITEM_CATEGORY_SPORTS_EQUIPMENT, ITEM_CATEGORY_PROFESSIONAL_SERVICES, ITEM_CATEGORY_TICKETS_AND_VOUCHERS, ITEM_CATEGORY_CUSTOMIZED_PRODUCTS, ITEM_CATEGORY_RENTING, ITEM_CATEGORY_OTHERS];
    
    NSArray *chineseCategories = @[ITEM_CHINESE_CATEGORY_LUXURY_FASHION, ITEM_CHINESE_CATEGORY_POPULAR_BRANDS, ITEM_CHINESE_CATEGORY_BEAUTY_PRODUCTS, ITEM_CHINESE_CATEGORY_CLOTHING_APPARELS, ITEM_CHINESE_CATEGORY_SHOES_BAG_ACCESSORIES, ITEM_CHINESE_CATEGORY_3C_PRODUCTS, ITEM_CHINESE_CATEGORY_ART_DESIGN, ITEM_CHINESE_CATEGORY_HOME_ACCESSORIES, ITEM_CHINESE_CATEGORY_HOME_FURNITURE, ITEM_CHINESE_CATEGORY_PET_SUPPLIES, ITEM_CHINESE_CATEGORY_GAMES, ITEM_CHINESE_CATEGORY_TOYS, ITEM_CHINESE_CATEGORY_BOOKS_MAGAZINES, ITEM_CHINESE_CATEGORY_VIDEO_PRODUCTION_EQUIPMENT, ITEM_CHINESE_CATEGORY_MUSICAL_INSTRUMENTS, ITEM_CHINESE_CATEGORY_SPORTS_EQUIPMENT, ITEM_CHINESE_CATEGORY_PROFESSIONAL_SERVICES, ITEM_CHINESE_CATEGORY_TICKETS_AND_VOUCHERS, ITEM_CHINESE_CATEGORY_CUSTOMIZED_PRODUCTS, ITEM_CHINESE_CATEGORY_RENTING, ITEM_CHINESE_CATEGORY_OTHERS];
    
    if ([englishCategories containsObject:word])
    {
        NSInteger index = [englishCategories indexOfObject:word];
        return chineseCategories[index];
    }
    
    if ([chineseCategories containsObject:word])
    {
        NSInteger index = [chineseCategories indexOfObject:word];
        return englishCategories[index];
    }
    
    return nil;
}

//------------------------------------------------------------------------------------------------------------------------------
+ (NSString *) getCurrentLanguage
//------------------------------------------------------------------------------------------------------------------------------
{
    return [[NSLocale preferredLanguages] objectAtIndex:0];
}

//------------------------------------------------------------------------------------------------------------------------------
+ (BOOL) isCurrLanguageTraditionalChinese
//------------------------------------------------------------------------------------------------------------------------------
{
    NSString *currLang = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([currLang containsString:LANGUAGE_TRADITIONAL_CHINESE])
        return YES;
    else
        return NO;
}

//------------------------------------------------------------------------------------------------------------------------------
+ (NSString *) shortFormOfCurrLanguage
//------------------------------------------------------------------------------------------------------------------------------
{
    NSString *currLang = [[NSLocale preferredLanguages] objectAtIndex:0];
    if ([currLang containsString:LANGUAGE_TRADITIONAL_CHINESE])
        return LANGUAGE_TRADITIONAL_CHINESE;
    else if ([currLang containsString:LANGUAGE_ENGLISH])
        return LANGUAGE_ENGLISH;
    else
        return currLang;
}


#pragma mark - Whunt Details Helpers

//------------------------------------------------------------------------------------------------------------------------------
+ (NSString *) getResultantStringFromText: (NSString *) originalText andRange: (NSRange) range andReplacementString: (NSString *) string
//------------------------------------------------------------------------------------------------------------------------------
{
    if (range.location == [originalText length])
    {
        return [originalText stringByAppendingString:string];
    }
    else
    {
        if ([string length] == 0)
        { // User removes a character
            NSString *firstSubstring = [originalText substringToIndex:range.location];
            NSString *secondSubstring = [originalText substringFromIndex:range.location + 1];
            return [firstSubstring stringByAppendingString:secondSubstring];
        }
        else
        {
            NSString *firstSubstring = [originalText substringToIndex:range.location];
            NSString *secondSubstring = [originalText substringFromIndex:range.location + 1];
            return [[firstSubstring stringByAppendingString:string] stringByAppendingString:secondSubstring];
        }
    }
}

//------------------------------------------------------------------------------------------------------------------------------
+ (BOOL) checkIfIsValidPrice: (NSString *) price
//------------------------------------------------------------------------------------------------------------------------------
{
    NSRange range = [price rangeOfString:DOT_CHARACTER];
    if (range.location == NSNotFound)
        return (price.length <= MAX_NUM_OF_CHARACTERS_FOR_PRICE);
    else
    {
        NSString *subString = [price substringFromIndex:range.location + 1];
        if ([subString containsString:DOT_CHARACTER])
            return NO;
        else
        {
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
+ (NSString *) getCountryFromAddress:(NSString *)address
//------------------------------------------------------------------------------------------------------------------------------
{
    NSRange commaSignRange = [address rangeOfString:@"," options:NSBackwardsSearch];
    
    if (commaSignRange.location >= address.length)
        return address;
    else
    {
        return [[address substringFromIndex:commaSignRange.location + 1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }
}

//------------------------------------------------------------------------------------------------------------------------------
+ (NSString *) getCityFromAddress:(NSString *)address
//------------------------------------------------------------------------------------------------------------------------------
{
    NSRange commaSignRange = [address rangeOfString:@"," options:NSBackwardsSearch];
    
    if (commaSignRange.location >= address.length)
        return @"";
    else
        return [address substringToIndex:commaSignRange.location];
}

//------------------------------------------------------------------------------------------------------------------------------
+ (NSString *) getUsernameFromEmail:(NSString *)email
//------------------------------------------------------------------------------------------------------------------------------
{
    NSRange atCharRange = [email rangeOfString:@"@"];
    NSString *username = [email substringToIndex:atCharRange.location];
    return username;
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
+ (NSString *) formattedPriceFromNumber:(NSNumber *)number
//------------------------------------------------------------------------------------------------------------------------------
{
    NSString *originalPrice = [number stringValue];
    
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
+ (NSNumber *) numberFromFormattedPrice:(NSString *)formattedPrice
//------------------------------------------------------------------------------------------------------------------------------
{
    NSString *simplifiedPrice = [formattedPrice substringFromIndex:TAIWAN_CURRENCY.length];
    simplifiedPrice = [simplifiedPrice stringByReplacingOccurrencesOfString:COMMA_CHARACTER withString:@""];
    
    NSNumberFormatter *format = [[NSNumberFormatter alloc] init];
    format.numberStyle = NSNumberFormatterDecimalStyle;
    return [format numberFromString:simplifiedPrice];
}


#pragma mark - Notification

//------------------------------------------------------------------------------------------------------------------------------
+ (void) postNotification: (NSString *) notification
//------------------------------------------------------------------------------------------------------------------------------
{
    [[NSNotificationCenter defaultCenter] postNotificationName:notification object:nil];
}


#pragma mark - Parse Backend

//------------------------------------------------------------------------------------------------------------------------------
+ (void) getUserWithID: (NSString *) userID imageNeeded: (BOOL) imageNeeded andRunBlock: (FetchedUserHandler) handler
//------------------------------------------------------------------------------------------------------------------------------
{
    PFQuery *query = [PFQuery queryWithClassName:PF_USER_CLASS_NAME];
    [query whereKey:PF_USER_OBJECTID equalTo:userID];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error)
        {
            PFUser *fetchedUser = (PFUser *) object;
            
            if (imageNeeded)
            {
                PFFile *profileImage = fetchedUser[PF_USER_PICTURE];
                if (!profileImage)
                    handler(fetchedUser, nil);
                else
                {
                    [profileImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error2) {
                        if (!error2)
                        {
                            UIImage *image;
                            if (data)
                                image = [UIImage imageWithData:data];
                            
                            handler(fetchedUser, image);
                        }
                        else
                        {
                            [Utilities handleError:error2];
                        }
                    }];
                }
            }
            else
            {
                handler(fetchedUser, nil);
            }
            
        }
        else
        {
            [Utilities handleError:error];
        }
    }];
}

//------------------------------------------------------------------------------------------------------------------------------
+ (void) retrieveProfileImageForUser:(PFUser *)user andRunBlock:(ImageHandler)handler
//------------------------------------------------------------------------------------------------------------------------------
{
    PFFile *profileImage = user[PF_USER_PICTURE];
    [profileImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error2)
    {
        if (!error2)
        {
            UIImage *image = [UIImage imageWithData:data];
            handler(image);
        }
        else
        {
            [Utilities handleError:error2];
        }
    }];
}

//------------------------------------------------------------------------------------------------------------------------------
+ (void) retrieveUserInfoByUserID: (NSString *) userID andRunBlock:(UserHandler)handler
//------------------------------------------------------------------------------------------------------------------------------
{
    PFQuery *query = [PFQuery queryWithClassName:PF_USER_CLASS_NAME];
    [query whereKey:PF_USER_OBJECTID equalTo:userID];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error)
        {
            PFUser *fetchedUser = (PFUser *) object;
            handler(fetchedUser);
        }
        else
        {
            [Utilities handleError:error];
        }
    }];
}


#pragma mark - Google Analytics

//------------------------------------------------------------------------------------------------------------------------------
+ (void) sendScreenNameToGoogleAnalyticsTracker:(NSString *)screenName
//------------------------------------------------------------------------------------------------------------------------------
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:screenName];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

//------------------------------------------------------------------------------------------------------------------------------
+ (void) sendEventToGoogleAnalyticsTrackerWithEventCategory:(NSString *)category action:(NSString *)action label:(NSString *)label value: (NSNumber*) value
//------------------------------------------------------------------------------------------------------------------------------
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:category
                                                          action:action
                                                           label:label
                                                           value:value] build]];
}

//------------------------------------------------------------------------------------------------------------------------------
+ (void) sendLoadingTimeToGoogleAnalyticsTrackerWithCategory:(NSString *)category interval:(NSNumber *)loadTime name:(NSString *)name label:(NSString *)label
//------------------------------------------------------------------------------------------------------------------------------
{
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder createTimingWithCategory:category
                                                         interval:loadTime
                                                             name:name
                                                            label:label] build]];
}

//------------------------------------------------------------------------------------------------------------------------------
+ (void) sendExceptionInfoToGoogleAnalyticsTrackerWithDescription:(NSString *)description fatal:(NSNumber *)fatal
//------------------------------------------------------------------------------------------------------------------------------
{
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    [tracker send:[[GAIDictionaryBuilder
                    createExceptionWithDescription:description
                    withFatal:fatal] build]];
}


#pragma mark - Log

//------------------------------------------------------------------------------------------------------------------------------
+ (void) logOutMessage:(NSString *)message
//------------------------------------------------------------------------------------------------------------------------------
{
    BOOL debuggingMode = YES;
    
    if (debuggingMode)
        NSLog(@"%@", message);
}


#pragma mark - Error Handlers

//------------------------------------------------------------------------------------------------------------------------------
+ (void) displayErrorAlertView
//------------------------------------------------------------------------------------------------------------------------------
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"We are sorry! An error occurred while processing this request.", nil) message:nil delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    [alertView show];
}

//------------------------------------------------------------------------------------------------------------------------------
+ (void) handleError:(NSError *)error
//------------------------------------------------------------------------------------------------------------------------------
{
    NSString *errorMessage = [NSString stringWithFormat:@"%@ %@", error, [error userInfo]];
    NSLog(@"%@", errorMessage);
    [Utilities sendExceptionInfoToGoogleAnalyticsTrackerWithDescription:errorMessage fatal:@0];
}


#pragma mark - Data Validation

//------------------------------------------------------------------------------------------------------------------------------
+ (BOOL) isEmailValid:(NSString *)email
//------------------------------------------------------------------------------------------------------------------------------
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}


#pragma mark - Date Handlers

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
+ (NSDate *) dateFromCommonlyFormattedString: (NSString *) string;
//------------------------------------------------------------------------------------------------------------------------------
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    return [formatter dateFromString:string];
}

//------------------------------------------------------------------------------------------------------------------------------
+ (NSDate *) dateFromUSStyledString:(NSString *)string
//------------------------------------------------------------------------------------------------------------------------------
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"]];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    return [dateFormatter dateFromString:string];
}

//------------------------------------------------------------------------------------------------------------------------------
+ (NSString *) timestampStringFromDate:(NSDate *)date
//------------------------------------------------------------------------------------------------------------------------------
{
    NSDate *now = [NSDate date];
    NSTimeInterval timeInterval = [now timeIntervalSinceDate:date];
    
    if (timeInterval < NUM_OF_SECONDS_IN_A_MINUTE)
    {
        NSInteger numOfSecs = (NSInteger) timeInterval;
        NSString *timestamp = [NSString stringWithFormat:@"%ld%@%@", (long) numOfSecs, NSLocalizedString(@"s", nil), NSLocalizedString(@"ago", nil)];
        return timestamp;
    }
    else if (timeInterval < NUM_OF_SECONDS_IN_AN_HOUR)
    {
        NSInteger numOfMins = (NSInteger) (timeInterval / NUM_OF_SECONDS_IN_A_MINUTE);
        NSString *timestamp = [NSString stringWithFormat:@"%ld%@%@", (long) numOfMins, NSLocalizedString(@"m", nil), NSLocalizedString(@"ago", nil)];
        return timestamp;
    }
    else if (timeInterval < NUM_OF_SECONDS_IN_A_DAY)
    {
        NSInteger numOfHours = (NSInteger) (timeInterval / NUM_OF_SECONDS_IN_AN_HOUR);
        NSString *timestamp = [NSString stringWithFormat:@"%ld%@%@", (long) numOfHours, NSLocalizedString(@"h", nil), NSLocalizedString(@"ago", nil)];
        return timestamp;
    }
    else if (timeInterval < NUM_OF_SECONDS_IN_A_WEEK)
    {
        NSInteger numOfDays = (NSInteger) (timeInterval / NUM_OF_SECONDS_IN_A_DAY);
        NSString *timestamp = [NSString stringWithFormat:@"%ld%@%@", (long) numOfDays, NSLocalizedString(@"d", nil), NSLocalizedString(@"ago", nil)];
        return timestamp;
    }
    else
    {
        NSInteger numOfWeeks = (NSInteger) (timeInterval / NUM_OF_SECONDS_IN_A_WEEK);
        NSString *timestamp = [NSString stringWithFormat:@"%ld%@%@", (long) numOfWeeks, NSLocalizedString(@"w", nil), NSLocalizedString(@"ago", nil)];
        return timestamp;
    }
    
    return @"";
}

//------------------------------------------------------------------------------------------------------------------------------
+ (NSString *)  longTimestampStringFromDate: (NSDate *) date
//------------------------------------------------------------------------------------------------------------------------------
{
    NSDate *now = [NSDate date];
    NSTimeInterval timeInterval = [now timeIntervalSinceDate:date];
    
    if (timeInterval < NUM_OF_SECONDS_IN_A_MINUTE)
    {
        NSInteger numOfSecs = (NSInteger) timeInterval;
        
        NSString  *timeUnit;
        if (numOfSecs <= 1)
            timeUnit = @"second";
        else
            timeUnit = @"seconds";
        
        NSString *timestamp = [NSString stringWithFormat:@"%ld%@%@", (long) numOfSecs, NSLocalizedString(timeUnit, nil), NSLocalizedString(@"ago", nil)];
        
        return timestamp;
    }
    else if (timeInterval < NUM_OF_SECONDS_IN_AN_HOUR)
    {
        NSInteger numOfMins = (NSInteger) (timeInterval / NUM_OF_SECONDS_IN_A_MINUTE);
        
        NSString  *timeUnit;
        if (numOfMins <= 1)
            timeUnit = @"minute";
        else
            timeUnit = @"minutes";
        
        NSString *timestamp = [NSString stringWithFormat:@"%ld%@%@", (long) numOfMins, NSLocalizedString(timeUnit, nil), NSLocalizedString(@"ago", nil)];
        
        return timestamp;
    }
    else if (timeInterval < NUM_OF_SECONDS_IN_A_DAY)
    {
        NSInteger numOfHours = (NSInteger) (timeInterval / NUM_OF_SECONDS_IN_AN_HOUR);
        
        NSString  *timeUnit;
        if (numOfHours <= 1)
            timeUnit = @"hour";
        else
            timeUnit = @"hours";
        
        NSString *timestamp = [NSString stringWithFormat:@"%ld%@%@", (long) numOfHours, NSLocalizedString(timeUnit, nil), NSLocalizedString(@"ago", nil)];
        
        return timestamp;
    }
    else if (timeInterval < NUM_OF_SECONDS_IN_A_WEEK)
    {
        NSInteger numOfDays = (NSInteger) (timeInterval / NUM_OF_SECONDS_IN_A_DAY);
        
        NSString  *timeUnit;
        if (numOfDays <= 1)
            timeUnit = @"day";
        else
            timeUnit = @"days";
        
        NSString *timestamp = [NSString stringWithFormat:@"%ld%@%@", (long) numOfDays, NSLocalizedString(timeUnit, nil), NSLocalizedString(@"ago", nil)];
        
        return timestamp;
        
    }
    else
    {
        NSInteger numOfWeeks = (NSInteger) (timeInterval / NUM_OF_SECONDS_IN_A_WEEK);
        
        NSString  *timeUnit;
        if (numOfWeeks <= 1)
            timeUnit = @"week";
        else
            timeUnit = @"weeks";
        
        NSString *timestamp = [NSString stringWithFormat:@"%ld%@%@", (long) numOfWeeks, NSLocalizedString(@"w", nil), NSLocalizedString(@"ago", nil)];
        
        return timestamp;
    }
    
    return @"";
}


@end
