//
//  BackendUtil.h
//  whunted
//
//  Created by thomas nguyen on 13/10/15.
//  Copyright © 2015 Whunted. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BackendUtil : NSObject

#pragma mark - User Profile

+ (void) presentUserProfileOfUser: (NSString *) userID fromViewController: (UIViewController *) controller;

@end
