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
#define kEmailTextFieldTag                      102
#define kMobileTextFieldTag                     103

#define kTextFieldHeight                        30
#define kTextFieldWidthRatio                    0.6

#define kTableNarrowHeaderFooterHeightRatio     0.025
#define kTableMediumHeaderFooterHeightRatio     0.04

#define kAverageCellHeight                      40

#define kTitleFontSize                          16
#define kDetailFontSize                         16

#define kOffsetForKeyboard                      100

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
    UITableViewCell *_userPhotoCell;
    
    UITableViewCell *_passwordChangingCell;
    UITableViewCell *_emailCell;
    UITableViewCell *_mobileCell;
    UITableViewCell *_genderCell;
    UITableViewCell *_birthdayCell;
    
    UILabel         *_myCityLabel;
    
    BOOL            _isProfileModfified;
    BOOL            _isExpandingContentSize;
    
    NSInteger       _currTextFieldTag;
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) viewWillAppear:(BOOL)animated
//--------------------------------------------------------------------------------------------------------------------------------
{
    [super viewWillAppear:animated];
    
    [self registerNotification];
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) viewWillDisappear:(BOOL)animated
//--------------------------------------------------------------------------------------------------------------------------------
{
    [super viewWillDisappear:animated];
    
    [self deregisterNotification];
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
    _isExpandingContentSize = NO;
}

#pragma mark - Notification Registration

//------------------------------------------------------------------------------------------------------------------------------
- (void) registerNotification
//------------------------------------------------------------------------------------------------------------------------------
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) deregisterNotification
//------------------------------------------------------------------------------------------------------------------------------
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

#pragma mark - UI

//-------------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI
//-------------------------------------------------------------------------------------------------------------------------------
{
    // customize title
    NSString *title = NSLocalizedString(@"Edit Profile", nil);
    [Utilities customizeTitleLabel:title forViewController:self];
    
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:17]];
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setTextColor:TEXT_COLOR_DARK_GRAY];
    
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
    _tableView.backgroundColor = LIGHTEST_GRAY_COLOR;
    [self.view addSubview:_tableView];
    
    [self initCells];
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) initCells
//--------------------------------------------------------------------------------------------------------------------------------
{
    [self initUsernameCell];
    [self initFirstNameCell];
    [self initLastNameCell];
    [self initMyCityCell];
    [self initBioCell];
    [self initUserPhotoCell];
    [self initPasswordChangingCell];
    [self initEmailCell];
    [self initMobileCell];
    [self initGenderCell];
    [self initBirthdayCell];
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) initUsernameCell
//--------------------------------------------------------------------------------------------------------------------------------
{
    _usernameCell = [[UITableViewCell alloc] init];
    _usernameCell.textLabel.text = NSLocalizedString(@"Username", nil);
    _usernameCell.textLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:kTitleFontSize];
    
    UITextField *usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width * kTextFieldWidthRatio, kTextFieldHeight)];
    [usernameTextField setTextAlignment:NSTextAlignmentLeft];
    usernameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"your username", nil) attributes:@{NSForegroundColorAttributeName: PLACEHOLDER_TEXT_COLOR, NSFontAttributeName: [UIFont fontWithName:REGULAR_FONT_NAME size:kDetailFontSize]}];
    usernameTextField.font = [UIFont fontWithName:REGULAR_FONT_NAME size:kDetailFontSize];
    usernameTextField.delegate = self;
    
    _usernameCell.accessoryView = usernameTextField;
    _usernameCell.selectionStyle = UITableViewCellSelectionStyleNone;
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) initFirstNameCell
//--------------------------------------------------------------------------------------------------------------------------------
{
    _firstNameCell = [[UITableViewCell alloc] init];
    _firstNameCell.textLabel.text = NSLocalizedString(@"First Name", nil);
    _firstNameCell.textLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:kTitleFontSize];
    
    UITextField *firstNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width * kTextFieldWidthRatio, kTextFieldHeight)];
    [firstNameTextField setTextAlignment:NSTextAlignmentLeft];
    firstNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"your first name", nil) attributes:@{NSForegroundColorAttributeName: PLACEHOLDER_TEXT_COLOR, NSFontAttributeName: [UIFont fontWithName:REGULAR_FONT_NAME size:kDetailFontSize]}];
    firstNameTextField.font = [UIFont fontWithName:REGULAR_FONT_NAME size:kDetailFontSize];
    firstNameTextField.delegate = self;
    
    _firstNameCell.accessoryView = firstNameTextField;
    _firstNameCell.selectionStyle = UITableViewCellSelectionStyleNone;
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) initLastNameCell
//--------------------------------------------------------------------------------------------------------------------------------
{
    _lastNameCell = [[UITableViewCell alloc] init];
    _lastNameCell.textLabel.text = NSLocalizedString(@"Last Name", nil);
    _lastNameCell.textLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:kTitleFontSize];
    
    UITextField *lastNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width * kTextFieldWidthRatio, kTextFieldHeight)];
    [lastNameTextField setTextAlignment:NSTextAlignmentLeft];
    lastNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"your last name", nil) attributes:@{NSForegroundColorAttributeName: PLACEHOLDER_TEXT_COLOR, NSFontAttributeName: [UIFont fontWithName:REGULAR_FONT_NAME size:kDetailFontSize]}];
    lastNameTextField.font = [UIFont fontWithName:REGULAR_FONT_NAME size:kDetailFontSize];
    lastNameTextField.delegate = self;
    
    _lastNameCell.accessoryView = lastNameTextField;
    _lastNameCell.selectionStyle = UITableViewCellSelectionStyleNone;
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) initMyCityCell
//--------------------------------------------------------------------------------------------------------------------------------
{
    _myCityCell = [[UITableViewCell alloc] init];
    _myCityCell.textLabel.text = NSLocalizedString(@"My City", nil);
    _myCityCell.textLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:kTitleFontSize];
    _myCityCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    _myCityLabel = [[UILabel alloc] initWithFrame:CGRectMake(WINSIZE.width * (0.96 - kTextFieldWidthRatio), 0, WINSIZE.width * kTextFieldWidthRatio, kAverageCellHeight)];
    _myCityLabel.text = USER_PROFILE_SELECT_CITY;
    _myCityLabel.textColor = PLACEHOLDER_TEXT_COLOR;
    _myCityLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:16];
    
    [_myCityCell addSubview:_myCityLabel];
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) initBioCell
//--------------------------------------------------------------------------------------------------------------------------------
{
    _bioCell = [[UITableViewCell alloc] init];
    _bioCell.textLabel.text = NSLocalizedString(@"Biography", nil);
    _bioCell.textLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:kTitleFontSize];
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) initUserPhotoCell
//--------------------------------------------------------------------------------------------------------------------------------
{
    _userPhotoCell = [[UITableViewCell alloc] init];
    _userPhotoCell.textLabel.text = NSLocalizedString(@"Photo", nil);
    _userPhotoCell.textLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:kTitleFontSize];
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) initPasswordChangingCell
//--------------------------------------------------------------------------------------------------------------------------------
{
    _passwordChangingCell = [[UITableViewCell alloc] init];
    _passwordChangingCell.textLabel.text = NSLocalizedString(@"Change Password", nil);
    _passwordChangingCell.textLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:kTitleFontSize];
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) initEmailCell
//--------------------------------------------------------------------------------------------------------------------------------
{
    _emailCell = [[UITableViewCell alloc] init];
    _emailCell.textLabel.text = NSLocalizedString(@"Email", nil);
    _emailCell.textLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:kTitleFontSize];
    
    UITextField *emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width * kTextFieldWidthRatio, kTextFieldHeight)];
    [emailTextField setTextAlignment:NSTextAlignmentLeft];
    emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"your email", nil) attributes:@{NSForegroundColorAttributeName: PLACEHOLDER_TEXT_COLOR, NSFontAttributeName: [UIFont fontWithName:REGULAR_FONT_NAME size:kDetailFontSize]}];
    emailTextField.tag = kEmailTextFieldTag;
    emailTextField.delegate = self;
    
    _emailCell.accessoryView = emailTextField;
    _emailCell.selectionStyle = UITableViewCellSelectionStyleNone;
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) initMobileCell
//--------------------------------------------------------------------------------------------------------------------------------
{
    _mobileCell = [[UITableViewCell alloc] init];
    _mobileCell.textLabel.text = NSLocalizedString(@"Mobile", nil);
    _mobileCell.textLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:kTitleFontSize];
    
    UITextField *mobileTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width * kTextFieldWidthRatio, kTextFieldHeight)];
    [mobileTextField setTextAlignment:NSTextAlignmentLeft];
    mobileTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"your mobile number", nil) attributes:@{NSForegroundColorAttributeName: PLACEHOLDER_TEXT_COLOR, NSFontAttributeName: [UIFont fontWithName:REGULAR_FONT_NAME size:kDetailFontSize]}];
    mobileTextField.tag = kMobileTextFieldTag;
    mobileTextField.delegate = self;
    
    _mobileCell.accessoryView = mobileTextField;
    _mobileCell.selectionStyle = UITableViewCellSelectionStyleNone;
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) initGenderCell
//--------------------------------------------------------------------------------------------------------------------------------
{
    _genderCell = [[UITableViewCell alloc] init];
    _genderCell.textLabel.text = NSLocalizedString(@"Gender", nil);
    _genderCell.textLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:kTitleFontSize];
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) initBirthdayCell
//--------------------------------------------------------------------------------------------------------------------------------
{
    _birthdayCell = [[UITableViewCell alloc] init];
    _birthdayCell.textLabel.text = NSLocalizedString(@"Birthday", nil);
    _birthdayCell.textLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:kTitleFontSize];
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
        } else if (indexPath.row == 1) {
            return _firstNameCell;
        } else if (indexPath.row == 2) {
            return _lastNameCell;
        } else if (indexPath.row == 3) {
            return _myCityCell;
        } else if (indexPath.row == 4) {
            return _bioCell;
        } else if (indexPath.row == 5) {
            return _userPhotoCell;
        }
    } else if (indexPath.section == 1) {
        return _passwordChangingCell;
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            return _emailCell;
        } else if (indexPath.row == 1) {
            return _mobileCell;
        } else if (indexPath.row == 2) {
            return _genderCell;
        } else if (indexPath.row == 3) {
            return _birthdayCell;
        }
    }
    
    return nil;
}

//--------------------------------------------------------------------------------------------------------------------------------
- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//--------------------------------------------------------------------------------------------------------------------------------
{
    if (section == 0)
        return @"Public Profile";
    else if (section == 1)
        return @"";
    else if (section == 2)
        return @"Private Profile";
    else
        return nil;
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

//------------------------------------------------------------------------------------------------------------------------------
- (void) tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    view.tintColor = LIGHTEST_GRAY_COLOR;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) tableView:(UITableView *) tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    view.tintColor = LIGHTEST_GRAY_COLOR;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    if (indexPath.row == 3) {
        ResidingCountryTableVC *countryTableVC = [[ResidingCountryTableVC alloc] init];
        countryTableVC.delegate = self;
        [self.navigationController pushViewController:countryTableVC animated:YES];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - UITextField Delegate

//------------------------------------------------------------------------------------------------------------------------------
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
//------------------------------------------------------------------------------------------------------------------------------
{
    
    if (textField.tag == kEmailTextFieldTag)
        _currTextFieldTag = kEmailTextFieldTag;
    else if (textField.tag == kMobileTextFieldTag)
        _currTextFieldTag = kMobileTextFieldTag;
    else
        _currTextFieldTag = 0;
    
    return YES;
}

#pragma mark - Event Handler

//------------------------------------------------------------------------------------------------------------------------------
-(void) keyboardWillShow: (NSNotification *) notification
//------------------------------------------------------------------------------------------------------------------------------
{
        NSDictionary* keyboardInfo = [notification userInfo];
        NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardFrame = [keyboardFrameBegin CGRectValue];
    
    if (_currTextFieldTag == kEmailTextFieldTag || _currTextFieldTag == kMobileTextFieldTag) {
        [self setViewMovedUp:YES scrollDown:YES withKeyboardHeight:keyboardFrame.size.height];
    } else {
        [self setViewMovedUp:YES scrollDown:NO withKeyboardHeight:keyboardFrame.size.height];
    }
}

//------------------------------------------------------------------------------------------------------------------------------
-(void) keyboardWillHide: (NSNotification *) notification
//------------------------------------------------------------------------------------------------------------------------------
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = [keyboardFrameBegin CGRectValue];
    
    [self setViewMovedUp:NO scrollDown:NO withKeyboardHeight:keyboardFrame.size.height];
}

//method to move the view up/down whenever the keyboard is shown/dismissed
//------------------------------------------------------------------------------------------------------------------------------
-(void)setViewMovedUp:(BOOL)movedUp scrollDown: (BOOL) scrollDown withKeyboardHeight: (CGFloat) keyboardHeight
//------------------------------------------------------------------------------------------------------------------------------
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGSize contentSize = _tableView.contentSize;
    CGFloat bottomTabBarHeight = self.tabBarController.tabBar.frame.size.height;
    CGFloat addedHeight = keyboardHeight - bottomTabBarHeight;
    
    if (movedUp) {
        if (!_isExpandingContentSize) {
            contentSize.height += addedHeight;
            [_tableView setContentSize:contentSize];
            _isExpandingContentSize = YES;
            
            if (scrollDown)
                [Utilities scrollToBottom:_tableView];
        }
    } else {
        if (_isExpandingContentSize) {
            contentSize.height -= addedHeight;
            [_tableView setContentSize:contentSize];
            _isExpandingContentSize = NO;
        }
    }
    
    [UIView commitAnimations];
}

#pragma mark - ResidingCityDelegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (void) residingCity:(ResidingCityTableVC *)controller didSelectCity:(NSDictionary *)countryCity
//------------------------------------------------------------------------------------------------------------------------------
{
    NSString *countryName = [countryCity objectForKey:USER_PROFILE_USER_COUNTRY];
    NSString *cityName = [countryCity objectForKey:USER_PROFILE_USER_CITY];
    _myCityLabel.text = [NSString stringWithFormat:@"%@, %@", cityName, countryName];
}

@end
