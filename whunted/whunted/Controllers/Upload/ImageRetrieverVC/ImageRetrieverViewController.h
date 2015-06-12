//
//  ImageRetrieverViewController.h
//  whunted
//
//  Created by thomas nguyen on 10/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageRetrieverViewController;

@protocol ImageRetrieverDelegate <NSObject>

- (void) imageRetrieverViewController: (ImageRetrieverViewController *) controller didRetrieveImage: (UIImage *) image;

@end

@interface ImageRetrieverViewController : UIViewController<UITextViewDelegate, UIAlertViewDelegate>

@property (nonatomic, weak) id<ImageRetrieverDelegate> delegate;

@end
