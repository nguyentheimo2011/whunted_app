//
//  Utilities.h
//  whunted
//
//  Created by thomas nguyen on 13/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    PhotoLibrary,
    Camera,
    ImageURL
} ImageGettingMethod;

@interface Utilities : NSObject

+ (void) addBorderAndShadow: (UIView *) view;
+ (void) setTopRoundedCorner: (UIView *) view;

@end
