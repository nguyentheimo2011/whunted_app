//
//  SettingsTableVC.m
//  whunted
//
//  Created by thomas nguyen on 28/7/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "SettingsTableVC.h"
#import "Utilities.h"
#import "AppConstant.h"

#import <JTImageButton.h>

#define CELL_HEIGHT         45.0f

@implementation SettingsTableVC
{
    UITableViewCell     *_editingProfileCell;
    UITableViewCell     *_emailSupportCell;
    
    UITableViewCell     *_gettingStartedCell;
    UITableViewCell     *_helpFAQCell;
    UITableViewCell     *_communityRulesCell;
    UITableViewCell     *_aboutWhuntedCell;
    
    UITableViewCell     *_notificationSettingsCell;
    UITableViewCell     *_logoutCell;
}

//--------------------------------------------------------------------------------------------------------------------------------
- (id) init
//--------------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    
    if (self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) viewDidLoad
//--------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    
    [self customizeUI];
    [self initCells];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) viewWillAppear:(BOOL)animated
//------------------------------------------------------------------------------------------------------------------------------
{
    [super viewWillAppear:animated];
    
    [Utilities sendScreenNameToGoogleAnalyticsTracker:@"SettingsScreen"];
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) didReceiveMemoryWarning
//--------------------------------------------------------------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
    
    [Utilities logOutMessage:@"SettingsTableVC didReceiveMemoryWarning"];
}


#pragma mark - UI

//-------------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI
//-------------------------------------------------------------------------------------------------------------------------------
{
    [self.view setBackgroundColor:GRAY_COLOR_WITH_WHITE_COLOR_2];
    
    // customize title
    NSString *title = NSLocalizedString(@"Settings", nil);
    [Utilities customizeTitleLabel:title forViewController:self];
    
    [Utilities customizeBackButtonForViewController:self withAction:@selector(topBackButtonTapEventHandler)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStylePlain target:self action:@selector(doneBarButtonTapEventHandler)];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) initCells
//-------------------------------------------------------------------------------------------------------------------------------
{
    [self initEditingProfileCell];
    [self initEmailSupportCell];
    
    [self initLogoutCell];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) initEditingProfileCell
//-------------------------------------------------------------------------------------------------------------------------------
{
    _editingProfileCell = [[UITableViewCell alloc] init];
    _editingProfileCell.textLabel.text  =   NSLocalizedString(@"Edit Profile", nil);
    _editingProfileCell.textLabel.font  =   [UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALL_FONT_SIZE];
    _editingProfileCell.accessoryType   =   UITableViewCellAccessoryDisclosureIndicator;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) initEmailSupportCell
//-------------------------------------------------------------------------------------------------------------------------------
{
    _emailSupportCell = [[UITableViewCell alloc] init];
    _emailSupportCell.textLabel.text  =   NSLocalizedString(@"Email Support/Feedback", nil);
    _emailSupportCell.textLabel.font  =   [UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALL_FONT_SIZE];
    _emailSupportCell.accessoryType   =   UITableViewCellAccessoryDisclosureIndicator;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) initGettingStartedCell
//-------------------------------------------------------------------------------------------------------------------------------
{
    _gettingStartedCell = [[UITableViewCell alloc] init];
    _gettingStartedCell.textLabel.text  =   NSLocalizedString(@"Getting Started Guide", nil);
    _gettingStartedCell.textLabel.font  =   [UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALL_FONT_SIZE];
    _gettingStartedCell.accessoryType   =   UITableViewCellAccessoryDisclosureIndicator;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) initHelpFAQCell
//-------------------------------------------------------------------------------------------------------------------------------
{
    _helpFAQCell = [[UITableViewCell alloc] init];
    _helpFAQCell.textLabel.text     =   NSLocalizedString(@"Help & FAQ", nil);
    _helpFAQCell.textLabel.font     =   [UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALL_FONT_SIZE];
    _helpFAQCell.accessoryType      =   UITableViewCellAccessoryDisclosureIndicator;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) initCommunityRulesCell
//-------------------------------------------------------------------------------------------------------------------------------
{
    _communityRulesCell = [[UITableViewCell alloc] init];
    _communityRulesCell.textLabel.text  =   NSLocalizedString(@"Community Rules", nil);
    _communityRulesCell.textLabel.font  =   [UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALL_FONT_SIZE];
    _communityRulesCell.accessoryType   =   UITableViewCellAccessoryDisclosureIndicator;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) initAboutWhuntedCell
//-------------------------------------------------------------------------------------------------------------------------------
{
    _aboutWhuntedCell = [[UITableViewCell alloc] init];
    _aboutWhuntedCell.textLabel.text    =   NSLocalizedString(@"About Whunted", nil);
    _aboutWhuntedCell.textLabel.font    =   [UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALL_FONT_SIZE];
    _aboutWhuntedCell.accessoryType     =   UITableViewCellAccessoryDisclosureIndicator;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) initNotificationSettingsCell
//-------------------------------------------------------------------------------------------------------------------------------
{
    _notificationSettingsCell = [[UITableViewCell alloc] init];
    _notificationSettingsCell.textLabel.text    =   NSLocalizedString(@"Notification Settings", nil);
    _notificationSettingsCell.textLabel.font    =   [UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALL_FONT_SIZE];
    _notificationSettingsCell.accessoryType     =   UITableViewCellAccessoryDisclosureIndicator;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) initLogoutCell
//-------------------------------------------------------------------------------------------------------------------------------
{
    _logoutCell = [[UITableViewCell alloc] init];
    _logoutCell.backgroundColor = GRAY_COLOR_WITH_WHITE_COLOR_2;
    
    JTImageButton *logoutButton = [[JTImageButton alloc] initWithFrame:CGRectMake(20, 0, WINSIZE.width - 40, CELL_HEIGHT)];
    [logoutButton createTitle:NSLocalizedString(@"Log Out", nil) withIcon:nil font:[UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALL_FONT_SIZE] iconOffsetY:0];
    logoutButton.bgColor = FLAT_FRESH_RED_COLOR;
    logoutButton.titleColor = [UIColor whiteColor];
    logoutButton.borderWidth = 0;
    logoutButton.cornerRadius = 8.0f;
    [logoutButton addTarget:self action:@selector(logoutButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
    [_logoutCell addSubview:logoutButton];
}


#pragma mark - UITableViewDataSource methods

//--------------------------------------------------------------------------------------------------------------------------------
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
//--------------------------------------------------------------------------------------------------------------------------------
{
    return 2;
}

//--------------------------------------------------------------------------------------------------------------------------------
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//--------------------------------------------------------------------------------------------------------------------------------
{
    if (section == 0)
        return 2;
    else
        return 1;
}

//--------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//--------------------------------------------------------------------------------------------------------------------------------
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
            return _editingProfileCell;
        else
            return _emailSupportCell;
    }
    else if (indexPath.section == 1)
    {
        return _logoutCell;
    }
    
    return [[UITableViewCell alloc] init];
}


#pragma mark - UITableViewDelegate methods

//--------------------------------------------------------------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//--------------------------------------------------------------------------------------------------------------------------------
{
    return CELL_HEIGHT;
}

//--------------------------------------------------------------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//--------------------------------------------------------------------------------------------------------------------------------
{
    if (section == 0)
        return 30.0f;
    else
        return 40.0f;
}

//--------------------------------------------------------------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//--------------------------------------------------------------------------------------------------------------------------------
{
    return 0.01f;
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
//--------------------------------------------------------------------------------------------------------------------------------
{
    view.tintColor = GRAY_COLOR_WITH_WHITE_COLOR_2;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
//-------------------------------------------------------------------------------------------------------------------------------
{
    view.tintColor = GRAY_COLOR_WITH_WHITE_COLOR_2;
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//-------------------------------------------------------------------------------------------------------------------------------
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            [self pushEditProfileViewController];
        }
        else
        {
            [self handlerEmailSupport];
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
            [self logoutButtonTapEventHandler];
    }
}


#pragma mark - Event Handlers

//-------------------------------------------------------------------------------------------------------------------------------
- (void) doneBarButtonTapEventHandler
//-------------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController popViewControllerAnimated:YES];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) topBackButtonTapEventHandler
//-------------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController popViewControllerAnimated:YES];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) pushEditProfileViewController
//-------------------------------------------------------------------------------------------------------------------------------
{
    UserData *userData = [[UserData alloc] initWithParseUser:[PFUser currentUser]];
    EditProfileViewController *editProfileVC = [[EditProfileViewController alloc] initWithUserData:userData];
    [self.navigationController pushViewController:editProfileVC animated:YES];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) handlerEmailSupport
//-------------------------------------------------------------------------------------------------------------------------------
{
    // Email Subject
    NSString *emailTitle = NSLocalizedString(@"Email Support/Feedback", nil);
    // Email Content
    NSString *messageBody = @"";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"hello@whunted.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    mc.mailComposeDelegate = self;
    
    mc.navigationBar.tintColor = [UIColor whiteColor];
    mc.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) logoutButtonTapEventHandler
//-------------------------------------------------------------------------------------------------------------------------------
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Log Out Of Whunted", nil) message:NSLocalizedString(@"Are you sure that you want to log out of Whunted?", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
    [alertView show];
}


#pragma mark - UIAlertViewDelegate method

//-------------------------------------------------------------------------------------------------------------------------------
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//-------------------------------------------------------------------------------------------------------------------------------
{
    if (buttonIndex == 1)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USER_LOGGED_OUT object:nil];
    }
}


#pragma mark - MFMailComposeViewControllerDelegate

//-------------------------------------------------------------------------------------------------------------------------------
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
//-------------------------------------------------------------------------------------------------------------------------------
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}


@end
