//
//  EditWantDataVC.h
//  whunted
//
//  Created by thomas nguyen on 22/9/15.
//  Copyright © 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UploadingWantDetailsViewController.h"

@interface EditWantDataVC : UploadingWantDetailsViewController <UIAlertViewDelegate>

- (id) initWithWantData: (WantData *) wantData forEditing: (BOOL) isEditing;

@end
