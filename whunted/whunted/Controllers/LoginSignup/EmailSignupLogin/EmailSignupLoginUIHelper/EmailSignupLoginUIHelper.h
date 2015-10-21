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

#define     kTableViewCellHeight            45.0f

#define     kTableViewSignupTag             202
#define     kTableViewLoginTag              203

//----------------------------------------------------------------------------------------------------------------------------
@protocol EmailSignupLoginEventHandler
//----------------------------------------------------------------------------------------------------------------------------

- (void) segmentedControlValueChanged;

- (void) termsOfServiceButtonTapEventHandler;

- (void) privacyPoliciesButtonTapEventHandler;

- (void) forgotPasswordButtonTapEventHandler;

@end


//-----------------------------------------------------------------------------------------------------------------------------
@interface EmailSignupLoginUIHelper : NSObject
//-----------------------------------------------------------------------------------------------------------------------------

+ (UISegmentedControl *) addSegmentedControlToViewController: (UIViewController<EmailSignupLoginEventHandler> *) viewController;

+ (UILabel *) addSignupDisclaimerLabel1ToView: (UIView *) container;

+ (void) addSignupDisclaimerLabel2BehindLable1: (UILabel *) label1 toView: (UIView *) container inViewController: (UIViewController<EmailSignupLoginEventHandler> *) viewController;

+ (void) addForgotPasswordButtonToView: (UIView *) container inViewController: (UIViewController<EmailSignupLoginEventHandler> *) viewController;

+ (NSArray *) initUsernameSignupCellInViewController: (UIViewController<UITextFieldDelegate> *) viewController;

+ (NSArray *) initEmailSignupCellInViewController: (UIViewController<UITextFieldDelegate> *) viewController;

+ (NSArray *) initPasswordSignupCellInViewController: (UIViewController<UITextFieldDelegate> *) viewController;

+ (NSArray *) initEmailLoginCellInViewController: (UIViewController<UITextFieldDelegate> *) viewController;

+ (NSArray *) initPasswordLoginCellInViewController: (UIViewController<UITextFieldDelegate> *) viewController;

@end
