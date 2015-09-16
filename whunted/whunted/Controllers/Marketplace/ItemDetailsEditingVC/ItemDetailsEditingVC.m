//
//  ItemDetailsEditingVCViewController.m
//  whunted
//
//  Created by thomas nguyen on 15/9/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "ItemDetailsEditingVC.h"
#import <MBProgressHUD.h>


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
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to discard your changes?" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes, I'm sure!", nil];
    [alertView show];
}

//---------------------------------------------------------------------------------------------------------------------------
- (void) topDoneButtonTapEventHandler
//---------------------------------------------------------------------------------------------------------------------------
{
    UIAlertView *submissionAlertView;
    if (super.wantData.itemCategory == nil)
    {
        submissionAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Oops", nil) message:NSLocalizedString(@"Please choose a category!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [submissionAlertView show];
    }
    else if (super.wantData.itemName == nil || [super.wantData.itemName length] == 0)
    {
        submissionAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Oops", nil) message:NSLocalizedString(@"Please fill in item name!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [submissionAlertView show];
    }
    else if (super.wantData.demandedPrice == nil || [super.wantData.demandedPrice length] == 0)
    {
        submissionAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Oops", nil) message:NSLocalizedString(@"Please state a price!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [submissionAlertView show];
    }
    else
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        if (!super.wantData.itemDesc)
            super.wantData.itemDesc = @"";
        
        if (!super.wantData.hashTagList)
            super.wantData.hashTagList = [NSArray array];
        
        if (!super.wantData.referenceURL)
            super.wantData.referenceURL = @"";
        
        if (!super.wantData.demandedPrice)
            super.wantData.demandedPrice = @"0";
        
        if (!super.wantData.paymentMethod)
            super.wantData.paymentMethod = @"non-escrow";
        
        if (!super.wantData.meetingLocation)
            super.wantData.meetingLocation = @"";
        
        if (!super.wantData.itemOrigins)
            super.wantData.itemOrigins = [NSArray array];
        
        super.wantData.itemPicturesNum = [super.wantData.itemPictures count];
        
        PFObject *pfObj = [super.wantData getPFObject];
        [pfObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error)
            {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}


#pragma mark - UIAlertViewDelegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
//------------------------------------------------------------------------------------------------------------------------------
{
    if (buttonIndex == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
