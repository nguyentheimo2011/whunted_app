//
//  ItemImageViewController.m
//  whunted
//
//  Created by thomas nguyen on 3/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "ItemImageViewController.h"
#import "AppConstant.h"

@implementation ItemImageViewController

@synthesize itemImageView = _itemImageView;

//-------------------------------------------------------------------------------------------------------------------------------
- (id) init
//-------------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    if (self != nil) {
        [self addItemImageView];
    }
    
    return self;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//-------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
//-------------------------------------------------------------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
    NSLog(@"ItemImageViewController didReceiveMemoryWarning");
}

#pragma mark - UI Handlers

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addItemImageView
//-------------------------------------------------------------------------------------------------------------------------------
{
    _itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width, WINSIZE.width)];
    [_itemImageView setBackgroundColor:[UIColor whiteColor]];
    _itemImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:_itemImageView];
}


@end
