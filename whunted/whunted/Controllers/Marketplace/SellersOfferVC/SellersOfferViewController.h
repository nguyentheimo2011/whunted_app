//
//  SellersOfferViewController.h
//  whunted
//
//  Created by thomas nguyen on 3/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WantData.h"

@interface SellersOfferViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) WantData *wantData;

@end
