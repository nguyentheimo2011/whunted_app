//
//  ItemDetailsEditingVCViewController.m
//  whunted
//
//  Created by thomas nguyen on 15/9/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "ItemDetailsEditingVC.h"


@implementation ItemDetailsEditingVC

//---------------------------------------------------------------------------------------------------------------------------
- (id) initWithWantData:(WantData *)wantData
//---------------------------------------------------------------------------------------------------------------------------
{
    self = [super initWithWantData:wantData];
    
    if (self)
    {
        
    }
    
    return self;
}

//---------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//---------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
}

//---------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
//---------------------------------------------------------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
}


#pragma mark - UI Handlers

//---------------------------------------------------------------------------------------------------------------------------
- (void) customizeBarButtons
//---------------------------------------------------------------------------------------------------------------------------
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStylePlain target:self action:@selector(topCancelButtonTapEventHandler)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStylePlain target:self action:@selector(topDoneButtonTapEventHandler)];
}


#pragma mark - Event Handlers

//---------------------------------------------------------------------------------------------------------------------------
- (void) topCancelButtonTapEventHandler
//---------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController popViewControllerAnimated:YES];
}

//---------------------------------------------------------------------------------------------------------------------------
- (void) topDoneButtonTapEventHandler
//---------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
