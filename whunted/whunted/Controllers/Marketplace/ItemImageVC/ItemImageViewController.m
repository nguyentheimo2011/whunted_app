//
//  ItemImageViewController.m
//  whunted
//
//  Created by thomas nguyen on 3/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "ItemImageViewController.h"
#import "AppConstant.h"

@interface ItemImageViewController ()

@end

@implementation ItemImageViewController

@synthesize itemImageView;

- (id) init
{
    self = [super init];
    if (self != nil) {
        [self addItemImageView];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"ItemImageViewController didReceiveMemoryWarning");
}

#pragma mark - UI Handlers
- (void) addItemImageView
{
    itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width, WINSIZE.height * 0.6)];
    [itemImageView setBackgroundColor:LIGHTER_GRAY_COLOR];
    [self.view addSubview:itemImageView];
}


@end
