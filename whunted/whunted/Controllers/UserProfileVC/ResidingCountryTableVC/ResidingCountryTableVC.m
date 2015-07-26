//
//  ResidingCountryTableVC.m
//  whunted
//
//  Created by thomas nguyen on 24/7/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "ResidingCountryTableVC.h"

@interface ResidingCountryTableVC ()

@end

@implementation ResidingCountryTableVC

//------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
//------------------------------------------------------------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UI

//------------------------------------------------------------------------------------------------------------------------------
- (void) customizeNavigationBar
//------------------------------------------------------------------------------------------------------------------------------
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(cancelButtonTapEventHandler)];
    
    self.hidesBottomBarWhenPushed = YES;
}

#pragma mark - Event Handler

//------------------------------------------------------------------------------------------------------------------------------
- (void) cancelButtonTapEventHandler
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
