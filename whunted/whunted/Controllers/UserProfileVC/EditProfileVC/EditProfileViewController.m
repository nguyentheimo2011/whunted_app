//
//  EditProfileViewController.m
//  whunted
//
//  Created by thomas nguyen on 22/7/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "EditProfileViewController.h"
#import "Utilities.h"
#import "AppConstant.h"

#define kCancelButtonAlertViewTag               101

#define kTextFieldHeight                        30
#define kTextFieldWidthRatio                    0.6

#define kTableNarrowHeaderFooterHeightRatio     0.025
#define kTableMediumHeaderFooterHeightRatio     0.04

#define kAverageCellHeight                      35

@interface EditProfileViewController ()

@end

@implementation EditProfileViewController
{
    UITableView     *_tableView;
    
    UITableViewCell *_usernameCell;
    UITableViewCell *_firstNameCell;
    UITableViewCell *_lastNameCell;
    UITableViewCell *_myCityCell;
    UITableViewCell *_bioCell;
    UITableViewCell *_photoCell;
    
    UITableViewCell *_passwordChangingCell;
    UITableViewCell *_emailCell;
    UITableViewCell *_mobileCell;
    UITableViewCell *_genderCell;
    UITableViewCell *_birthdayCell;
    
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
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    [self.view addSubview:_tableView];
    
    [self initCells];
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) initCells
//--------------------------------------------------------------------------------------------------------------------------------
{
    [self initUsernameCell];
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) initUsernameCell
//--------------------------------------------------------------------------------------------------------------------------------
{
    _usernameCell = [[UITableViewCell alloc] init];
    _usernameCell.textLabel.text = NSLocalizedString(@"Username", nil);
    _usernameCell.textLabel.font = [UIFont fontWithName:LIGHT_FONT_NAME size:16];
    
    UITextField *usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width * kTextFieldWidthRatio, kTextFieldHeight)];
    [usernameTextField setTextAlignment:NSTextAlignmentLeft];
    usernameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"your username", nil) attributes:@{NSForegroundColorAttributeName: PLACEHOLDER_TEXT_COLOR, NSFontAttributeName: [UIFont fontWithName:LIGHT_FONT_NAME size:15]}];
    usernameTextField.delegate = self;
    
    _usernameCell.accessoryView = usernameTextField;
    _usernameCell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - UITableView Datasource

//--------------------------------------------------------------------------------------------------------------------------------
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
//--------------------------------------------------------------------------------------------------------------------------------
{
    return 3;
}

//--------------------------------------------------------------------------------------------------------------------------------
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//--------------------------------------------------------------------------------------------------------------------------------
{
    if (section == 0) {
        return 6;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return 4;
    } else {
        return 0;
    }
}

//--------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//--------------------------------------------------------------------------------------------------------------------------------
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return _usernameCell;
        } else {
            return [[UITableViewCell alloc] init];
        }
    } else {
        return [[UITableViewCell alloc] init];
    }
}

#pragma mark - UITableView Delegate methods

//--------------------------------------------------------------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//--------------------------------------------------------------------------------------------------------------------------------
{
    if (section == 0)
        return WINSIZE.height * kTableMediumHeaderFooterHeightRatio;
    else if (section == 1)
        return 0.0f;
    else if (section == 2)
        return WINSIZE.height * kTableMediumHeaderFooterHeightRatio;
    else
        return 0.0f;
}

//--------------------------------------------------------------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//--------------------------------------------------------------------------------------------------------------------------------
{
    if (section == 0 || section == 1)
        return WINSIZE.height * kTableNarrowHeaderFooterHeightRatio;
    else if (section == 2)
        return WINSIZE.height * kTableMediumHeaderFooterHeightRatio;
    else
        return 0.0f;
}

//--------------------------------------------------------------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//--------------------------------------------------------------------------------------------------------------------------------
{
    if (indexPath.section == 0) {
        return kAverageCellHeight;
    } else if (indexPath.section == 1) {
        return kAverageCellHeight;
    } else if (indexPath.section == 2) {
        return kAverageCellHeight;
    } else {
        return 0.0f;
    }
}

@end
