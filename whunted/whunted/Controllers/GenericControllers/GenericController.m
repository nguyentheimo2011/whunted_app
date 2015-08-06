//
//  CommonNavController.m
//  whunted
//
//  Created by thomas nguyen on 11/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "GenericController.h"
#import "AppConstant.h"

@implementation GenericController


//-------------------------------------------------------------------------------------------------------------------------------
- (id) init
//-------------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    if (self != nil) {
        
    }
    return self;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) viewDidLoad
//-------------------------------------------------------------------------------------------------------------------------------
{
    [self addBarItems];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addBarItems
//-------------------------------------------------------------------------------------------------------------------------------
{
    UIImage *searchImage = [UIImage imageNamed:@"search.png"];
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithImage:searchImage style:UIBarButtonItemStylePlain target:self action:nil];
    
    NSArray *actionButtonItems = @[searchButton];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
    CGSize windowSize = [[UIScreen mainScreen] bounds].size;
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, windowSize.width, 100)];
    UIImage *appIcon = [UIImage imageNamed:@"app_icon.png"];
    UIImageView *appIconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 35, 30, 29)];
    appIconView.layer.cornerRadius = 5;
    appIconView.clipsToBounds = YES;
    [appIconView setImage:appIcon];
    [titleView addSubview:appIconView];
    self.navigationItem.titleView = titleView;
}

#pragma mark - Event Handlers


#pragma mark - Methods for overridding by inherited class

//-------------------------------------------------------------------------------------------------------------------------------
- (void) pushViewController: (UIViewController *) controller
//-------------------------------------------------------------------------------------------------------------------------------
{
    
}


@end
