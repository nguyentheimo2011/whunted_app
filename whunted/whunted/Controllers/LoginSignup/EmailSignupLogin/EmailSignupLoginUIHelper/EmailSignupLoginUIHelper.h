//
//  EmailSignupLoginUIHelper.h
//  whunted
//
//  Created by thomas nguyen on 21/10/15.
//  Copyright © 2015 Whunted. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define     kUsernameSignupTextFieldTag     102
#define     kEmailSignupTextFieldTag        103
#define     kPasswordSignupTextFieldTag     104

#define     kEmailLoginTextFieldTag         105
#define     kPasswordSLoginTextFieldTag     106

#define     kTableViewCellHeight            40.0f

#define     kTableViewSignupTag             202
#define     kTableViewLoginTag              203

//----------------------------------------------------------------------------------------------------------------------------
@protocol EmailSignupLoginEventHandler
//----------------------------------------------------------------------------------------------------------------------------

- (void) segmentedControlValueChanged;

- (void) termsOfServiceButtonTapEventHandler;

- (void) privacyPoliciesButtonTapEventHandler;

@end


//-----------------------------------------------------------------------------------------------------------------------------
@interface EmailSignupLoginUIHelper : NSObject
//-----------------------------------------------------------------------------------------------------------------------------

+ (UISegmentedControl *) addSegmentedControlToViewController: (UIViewController<EmailSignupLoginEventHandler> *) viewController;

+ (UILabel *) addSignupDisclaimerLabel1ToView: (UIView *) container;

+ (void) addSignupDisclaimerLabel2BehindLable1: (UILabel *) label1 toView: (UIView *) container inViewController: (UIViewController<EmailSignupLoginEventHandler> *) viewController;

@end
