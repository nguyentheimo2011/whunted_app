//
//  MarketplaceLogicHelper.m
//  whunted
//
//  Created by thomas nguyen on 12/10/15.
//  Copyright © 2015 Whunted. All rights reserved.
//

#import "MarketplaceLogicHelper.h"
#import "AppConstant.h"

@implementation MarketplaceLogicHelper

//-----------------------------------------------------------------------------------------------------------------------------
+ (BOOL) hasPhoneLanguageChangedRecently
//-----------------------------------------------------------------------------------------------------------------------------
{
    NSString *currLang = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
    NSString *lastLang = [[NSUserDefaults standardUserDefaults] objectForKey:LANGUAGE_USED_IN_LAST_SESSION];
    BOOL languageChanged = NO;
    if (![currLang isEqualToString:lastLang])
    {
        languageChanged = YES;
        [[NSUserDefaults standardUserDefaults] setObject:currLang forKey:LANGUAGE_USED_IN_LAST_SESSION];
    }
    
    return languageChanged;
}

@end
