//
//  ItemImageViewController.m
//  whunted
//
//  Created by thomas nguyen on 3/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "ItemImageViewController.h"
#import "Utilities.h"

@interface ItemImageViewController ()

@end

@implementation ItemImageViewController

@synthesize itemImageView;

- (id) init {
    self = [super init];
    if (self != nil) {
        [self addItemImageView];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Handlers
- (void) addItemImageView
{
    itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width, WINSIZE.height * 0.6)];
    [itemImageView setBackgroundColor:APP_COLOR_4];
    [self.view addSubview:itemImageView];
}


@end
