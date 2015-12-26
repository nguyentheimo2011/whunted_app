//
//  MainLogInSignUpWireframe.h
//  whunted
//
//  Created by thomas nguyen on 26/12/15.
//  Copyright © 2015 Whunted. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "MainLogInSignUpPresenter.h"

@interface MainLogInSignUpWireframe : NSObject

@property (nonatomic, strong) MainLogInSignUpPresenter      *mainLogInSignUpEventHandler;

- (void) presentMainLogInSignUpInterfaceFromWindow: (UIWindow *) window;

- (void) presentTermsOfService;

@end
