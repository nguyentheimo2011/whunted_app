//
//  HorizontalLineViewController.m
//  whunted
//
//  Created by thomas nguyen on 21/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "HorizontalLineViewController.h"

@interface HorizontalLineViewController ()

@end

@implementation HorizontalLineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.firstLine setBackgroundColor:[UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1.0]];
    [self.secondLine setBackgroundColor:[UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1.0]];
    [self.numLabel setTextColor:[UIColor colorWithRed:150.0/255 green:150.0/255 blue:150.0/255 alpha:1.0]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
