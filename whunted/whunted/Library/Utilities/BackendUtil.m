//
//  BackendUtil.m
//  whunted
//
//  Created by thomas nguyen on 13/10/15.
//  Copyright © 2015 Whunted. All rights reserved.
//

#import "BackendUtil.h"
#import "UserProfileViewController.h"
#import "Utilities.h"

#import <MBProgressHUD.h>

@implementation BackendUtil

#pragma mark - User Profile

//-----------------------------------------------------------------------------------------------------------------------------
+ (void) presentUserProfileOfUser:(NSString *)userID fromViewController: (UIViewController *) controller
//-----------------------------------------------------------------------------------------------------------------------------
{
    [Utilities sendEventToGoogleAnalyticsTrackerWithEventCategory:UI_ACTION action:@"ViewUserProfileEvent" label:@"BuyerUsernameButton" value:nil];
    
    [MBProgressHUD showHUDAddedTo:controller.view animated:YES];
    
    UserHandler handler = ^(PFUser *user)
    {
        [MBProgressHUD hideHUDForView:controller.view animated:YES];
        
        UserProfileViewController *userProfileVC = [[UserProfileViewController alloc] initWithProfileOwner:user];
        [controller.navigationController pushViewController:userProfileVC animated:YES];
    };
    
    [Utilities retrieveUserInfoByUserID:userID andRunBlock:handler];
}

@end
