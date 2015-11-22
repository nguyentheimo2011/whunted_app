//
//  CodeVerifierVC.h
//  whunted
//
//  Created by thomas nguyen on 19/11/15.
//  Copyright © 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CodeVerifierVC : UIViewController<UITextFieldDelegate, UIAlertViewDelegate>

@property (nonatomic, strong)       NSString        *usersPhoneNumber;

@end
