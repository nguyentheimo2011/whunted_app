//
//  CommonNavController.m
//  whunted
//
//  Created by thomas nguyen on 11/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "GenericController.h"

@interface GenericController ()

- (void) addBarItems;

@end

@implementation GenericController

- (id) init
{
    self = [super init];
    if (self != nil) {
        [self addBarItems];
    }
    return self;
}

- (void) addBarItems
{
    UIImage *searchImage = [UIImage imageNamed:@"search.png"];
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithImage:searchImage style:UIBarButtonItemStylePlain target:self action:nil];
    
    UIImage *chatImage = [UIImage imageNamed:@"chat.png"];
    UIBarButtonItem *chatButton = [[UIBarButtonItem alloc] initWithImage:chatImage style:UIBarButtonItemStylePlain target:self action:nil];
    
    UIImage *profile = [UIImage imageNamed:@"profile.png"];
    UIBarButtonItem *profileButton = [[UIBarButtonItem alloc] initWithImage:profile style:UIBarButtonItemStylePlain target:self action:nil];
    
    UIBarButtonItem *buyButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:nil];
    
    NSArray *actionButtonItems = @[buyButton, profileButton, chatButton, searchButton];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
    UIImage *appIcon = [UIImage imageNamed:@"app_icon.png"];
    UIBarButtonItem *appIconButton = [[UIBarButtonItem alloc] initWithImage:appIcon style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.leftBarButtonItem = appIconButton;
    self.navigationItem.leftBarButtonItem.enabled = NO;
}

@end
