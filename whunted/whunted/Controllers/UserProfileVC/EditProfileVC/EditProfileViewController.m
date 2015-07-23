//
//  EditProfileViewController.m
//  whunted
//
//  Created by thomas nguyen on 22/7/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "EditProfileViewController.h"
#import "Utilities.h"

#define kCancelButtonAlertViewTag   101

@interface EditProfileViewController ()

@end

@implementation EditProfileViewController
{
    UITableView     *_tableView;
    
    BOOL            _isProfileModfified;
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) viewDidLoad
//--------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    
    [self initData];
    
    [self customizeUI];
    [self addTableView];
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) didReceiveMemoryWarning
//--------------------------------------------------------------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"EditProfileViewController didReceiveMemoryWarning");
}

#pragma mark - Data initialization

//--------------------------------------------------------------------------------------------------------------------------------
- (void) initData
//--------------------------------------------------------------------------------------------------------------------------------
{
    _isProfileModfified = NO;
}

#pragma mark - UI

//-------------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI
//-------------------------------------------------------------------------------------------------------------------------------
{
    // customize title
    NSString *title = NSLocalizedString(@"Edit Profile", nil);
    [Utilities customizeTitleLabel:title forViewController:self];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelBarButtonTapEventHandler)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(doneBarButtonTapEventHandler)];
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) addTableView
//--------------------------------------------------------------------------------------------------------------------------------
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_tableView];
}

#pragma mark - Event Handlers

//--------------------------------------------------------------------------------------------------------------------------------
- (void) cancelBarButtonTapEventHandler
//--------------------------------------------------------------------------------------------------------------------------------
{
    if (_isProfileModfified) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Are you sure you want to discard changes to your edits?", nil) message:NSLocalizedString(@"Changes will not be saved.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"No", nil) otherButtonTitles:NSLocalizedString(@"Yes, I'm sure", nil), nil];
        alertView.tag = kCancelButtonAlertViewTag;
        [alertView show];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) doneBarButtonTapEventHandler
//--------------------------------------------------------------------------------------------------------------------------------
{
    
}

#pragma mark - UIAlertView Delegate methods

//--------------------------------------------------------------------------------------------------------------------------------
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//--------------------------------------------------------------------------------------------------------------------------------
{
    if (alertView.tag == kCancelButtonAlertViewTag) {
        if (buttonIndex == 0) {
            // Do nothing because user chooses NO
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

@end
