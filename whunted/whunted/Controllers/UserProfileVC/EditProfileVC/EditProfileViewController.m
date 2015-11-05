//
//  EditProfileViewController.m
//  whunted
//
//  Created by thomas nguyen on 22/7/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "EditProfileViewController.h"
#import "ProfileImageCache.h"
#import "Utilities.h"
#import "AppConstant.h"
#import "AIDatePickerController.h"

#import <SZTextView.h>
#import <MMPickerView.h>

#define     kCancelButtonAlertViewTag               101
#define     kEmailTextFieldTag                      102
#define     kMobileTextFieldTag                     103

#define     kTextFieldHeight                        30
#define     kTextFieldWidthRatio                    0.6

#define     kUserPhotoHeightRatio                   2.5

#define     kTableNarrowHeaderFooterHeightRatio     0.025
#define     kTableMediumHeaderFooterHeightRatio     0.04

#define     kAverageCellHeight                      40

#define     kTitleFontSize                          16
#define     kDetailFontSize                         16

#define     kOffsetForKeyboard                      100

//-----------------------------------------------------------------------------------------------------------------------------
@implementation EditProfileViewController
//-----------------------------------------------------------------------------------------------------------------------------
{
    UITableView             *_tableView;
    
    UITableViewCell         *_usernameCell;
    UITableViewCell         *_firstNameCell;
    UITableViewCell         *_lastNameCell;
    UITableViewCell         *_myCityCell;
    UITableViewCell         *_bioCell;
    UITableViewCell         *_userPhotoCell;
    
    UITableViewCell         *_passwordChangingCell;
    UITableViewCell         *_emailCell;
    UITableViewCell         *_mobileCell;
    UITableViewCell         *_genderCell;
    UITableViewCell         *_birthdayCell;
    
    UITextField             *_usernameTextField;
    UITextField             *_firstNameTextField;
    UITextField             *_lastNameTextField;
    UITextField             *_emailTextField;
    UITextField             *_mobileTextField;
    
    UILabel                 *_myCityLabel;
    UILabel                 *_genderLabel;
    UILabel                 *_birthdayLabel;
    SZTextView              *_myBioTextView;
    UIImageView             *_userProfileImageView;
    
    BOOL                    _isProfileModfified;
    BOOL                    _isExpandingContentSize;
    
    NSString                *_newCity;
    NSString                *_newCountry;
    
    NSInteger               _currTextFieldTag;
}

@synthesize userData = _userData;

//--------------------------------------------------------------------------------------------------------------------------------
- (id) initWithUserData:(UserData *)userData
//--------------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    
    if (self)
    {
        _userData = userData;
    }
    
    return self;
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) viewWillAppear:(BOOL)animated
//--------------------------------------------------------------------------------------------------------------------------------
{
    [super viewWillAppear:animated];
    
    [self registerNotification];
    [Utilities sendScreenNameToGoogleAnalyticsTracker:@"EditProfileScreen"];
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
    
    [Utilities logOutMessage:@"EditProfileViewController didReceiveMemoryWarning"];
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


#pragma mark - UI Handlers

//-------------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI
//-------------------------------------------------------------------------------------------------------------------------------
{
    // customize title
    NSString *title = NSLocalizedString(@"Edit Profile", nil);
    [Utilities customizeTitleLabel:title forViewController:self];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelBarButtonTapEventHandler)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStylePlain target:self action:@selector(doneBarButtonTapEventHandler)];
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) addTableView
//--------------------------------------------------------------------------------------------------------------------------------
{
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    _tableView.backgroundColor = GRAY_COLOR_WITH_WHITE_COLOR_2;
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
    
     _usernameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width * kTextFieldWidthRatio, kTextFieldHeight)];
    _usernameTextField.text = _userData.username;
    [_usernameTextField setTextAlignment:NSTextAlignmentLeft];
    _usernameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"your username", nil) attributes:@{NSForegroundColorAttributeName: PLACEHOLDER_TEXT_COLOR, NSFontAttributeName: [UIFont fontWithName:REGULAR_FONT_NAME size:kDetailFontSize]}];
    _usernameTextField.font = [UIFont fontWithName:REGULAR_FONT_NAME size:kDetailFontSize];
    _usernameTextField.returnKeyType = UIReturnKeyDone;
    _usernameTextField.delegate = self;
    
    _usernameCell.accessoryView = _usernameTextField;
    _usernameCell.selectionStyle = UITableViewCellSelectionStyleNone;
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) initFirstNameCell
//--------------------------------------------------------------------------------------------------------------------------------
{
    _firstNameCell = [[UITableViewCell alloc] init];
    _firstNameCell.textLabel.text = NSLocalizedString(@"First Name", nil);
    _firstNameCell.textLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:kTitleFontSize];
    
    _firstNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width * kTextFieldWidthRatio, kTextFieldHeight)];
    _firstNameTextField.text = _userData.firstName;
    [_firstNameTextField setTextAlignment:NSTextAlignmentLeft];
    _firstNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"your first name", nil) attributes:@{NSForegroundColorAttributeName: PLACEHOLDER_TEXT_COLOR, NSFontAttributeName: [UIFont fontWithName:REGULAR_FONT_NAME size:kDetailFontSize]}];
    _firstNameTextField.font = [UIFont fontWithName:REGULAR_FONT_NAME size:kDetailFontSize];
    _firstNameTextField.returnKeyType = UIReturnKeyDone;
    _firstNameTextField.delegate = self;
    
    _firstNameCell.accessoryView = _firstNameTextField;
    _firstNameCell.selectionStyle = UITableViewCellSelectionStyleNone;
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) initLastNameCell
//--------------------------------------------------------------------------------------------------------------------------------
{
    _lastNameCell = [[UITableViewCell alloc] init];
    _lastNameCell.textLabel.text = NSLocalizedString(@"Last Name", nil);
    _lastNameCell.textLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:kTitleFontSize];
    
    _lastNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width * kTextFieldWidthRatio, kTextFieldHeight)];
    _lastNameTextField.text = _userData.lastName;
    [_lastNameTextField setTextAlignment:NSTextAlignmentLeft];
    _lastNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"your last name", nil) attributes:@{NSForegroundColorAttributeName: PLACEHOLDER_TEXT_COLOR, NSFontAttributeName: [UIFont fontWithName:REGULAR_FONT_NAME size:kDetailFontSize]}];
    _lastNameTextField.font = [UIFont fontWithName:REGULAR_FONT_NAME size:kDetailFontSize];
    _lastNameTextField.returnKeyType = UIReturnKeyDone;
    _lastNameTextField.delegate = self;
    
    _lastNameCell.accessoryView = _lastNameTextField;
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
    _myCityLabel.text = _userData.residingCity;
    _myCityLabel.textColor = TEXT_COLOR_DARK_GRAY;
    _myCityLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:16];
    
    if (!_myCityLabel.text || _myCityLabel.text.length == 0)
    {
        _myCityLabel.text = USER_PROFILE_SELECT_CITY;
        _myCityLabel.textColor = PLACEHOLDER_TEXT_COLOR;
    }
    
    [_myCityCell addSubview:_myCityLabel];
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) initBioCell
//--------------------------------------------------------------------------------------------------------------------------------
{
    _bioCell = [[UITableViewCell alloc] init];
    _bioCell.textLabel.text = NSLocalizedString(@"Biography", nil);
    _bioCell.textLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:kTitleFontSize];
    _bioCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _myBioTextView = [[SZTextView alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width * kTextFieldWidthRatio, 3 * kTextFieldHeight)];
    _myBioTextView.layer.borderWidth = 1.0f;
    _myBioTextView.layer.borderColor = [PLACEHOLDER_TEXT_COLOR CGColor];
    _myBioTextView.layer.cornerRadius = 10.0f;
    _myBioTextView.text = _userData.userDescription;
    _myBioTextView.font = [UIFont fontWithName:REGULAR_FONT_NAME size:16];
    _myBioTextView.placeholder = USER_PROFILE_BIO_PLACEHOLDER;
    [_myBioTextView setContentInset:UIEdgeInsetsMake(-5, 0, 0, 0)];
    
    _bioCell.accessoryView = _myBioTextView;
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) initUserPhotoCell
//--------------------------------------------------------------------------------------------------------------------------------
{
    _userPhotoCell = [[UITableViewCell alloc] init];
    _userPhotoCell.textLabel.text = NSLocalizedString(@"Photo", nil);
    _userPhotoCell.textLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:kTitleFontSize];
    _userPhotoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *imageContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width * kTextFieldWidthRatio, kUserPhotoHeightRatio * kTextFieldHeight)];
    
    CGFloat kImageHeight = 2 * kTextFieldHeight;
    CGFloat kTopMargin = 0.25 * kTextFieldHeight;
    _userProfileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, kTopMargin, kImageHeight, kImageHeight)];
    _userProfileImageView.layer.cornerRadius = kImageHeight/2;
    _userProfileImageView.clipsToBounds = YES;
    _userProfileImageView.backgroundColor = PICTON_BLUE_COLOR;
    [_userProfileImageView setImage:_userData.profileImage];
    [imageContainer addSubview:_userProfileImageView];
    
    UILabel *tapToChangeLabel = [[UILabel alloc] init];
    tapToChangeLabel.text = @"Tap to change";
    tapToChangeLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:16];
    tapToChangeLabel.textColor = PLACEHOLDER_TEXT_COLOR;
    [tapToChangeLabel sizeToFit];
    tapToChangeLabel.frame = CGRectMake(kImageHeight + 10, 10, tapToChangeLabel.frame.size.width, tapToChangeLabel.frame.size.height);
    [imageContainer addSubview:tapToChangeLabel];
    
    // add gesture reconizer to image container
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeUserProfileImage)];
    [imageContainer addGestureRecognizer:singleTap];
    
    _userPhotoCell.accessoryView = imageContainer;
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) initPasswordChangingCell
//--------------------------------------------------------------------------------------------------------------------------------
{
    _passwordChangingCell = [[UITableViewCell alloc] init];
    _passwordChangingCell.textLabel.text = NSLocalizedString(@"Change Password", nil);
    _passwordChangingCell.textLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:kTitleFontSize];
    _passwordChangingCell.selectionStyle = UITableViewCellSelectionStyleNone;
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) initEmailCell
//--------------------------------------------------------------------------------------------------------------------------------
{
    _emailCell = [[UITableViewCell alloc] init];
    _emailCell.textLabel.text = NSLocalizedString(@"Email", nil);
    _emailCell.textLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:kTitleFontSize];
    
    _emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width * kTextFieldWidthRatio, kTextFieldHeight)];
    _emailTextField.text = _userData.emailAddress;
    [_emailTextField setTextAlignment:NSTextAlignmentLeft];
    _emailTextField.font = [UIFont fontWithName:REGULAR_FONT_NAME size:kDetailFontSize];
    _emailTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"your email", nil) attributes:@{NSForegroundColorAttributeName: PLACEHOLDER_TEXT_COLOR, NSFontAttributeName: [UIFont fontWithName:REGULAR_FONT_NAME size:kDetailFontSize]}];
    _emailTextField.tag = kEmailTextFieldTag;
    _emailTextField.returnKeyType = UIReturnKeyDone;
    _emailTextField.delegate = self;
    
    _emailCell.accessoryView = _emailTextField;
    _emailCell.selectionStyle = UITableViewCellSelectionStyleNone;
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) initMobileCell
//--------------------------------------------------------------------------------------------------------------------------------
{
    _mobileCell = [[UITableViewCell alloc] init];
    _mobileCell.textLabel.text = NSLocalizedString(@"Mobile", nil);
    _mobileCell.textLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:kTitleFontSize];
    
    _mobileTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width * kTextFieldWidthRatio, kTextFieldHeight)];
    _mobileTextField.text = _userData.phoneNumber;
    [_mobileTextField setTextAlignment:NSTextAlignmentLeft];
    _mobileTextField.font = [UIFont fontWithName:REGULAR_FONT_NAME size:kDetailFontSize];
    _mobileTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"your mobile number", nil) attributes:@{NSForegroundColorAttributeName: PLACEHOLDER_TEXT_COLOR, NSFontAttributeName: [UIFont fontWithName:REGULAR_FONT_NAME size:kDetailFontSize]}];
    _mobileTextField.tag = kMobileTextFieldTag;
    _mobileTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    _mobileTextField.returnKeyType = UIReturnKeyDone;
    _mobileTextField.delegate = self;
    
    _mobileCell.accessoryView = _mobileTextField;
    _mobileCell.selectionStyle = UITableViewCellSelectionStyleNone;
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) initGenderCell
//--------------------------------------------------------------------------------------------------------------------------------
{
    _genderCell = [[UITableViewCell alloc] init];
    _genderCell.textLabel.text = NSLocalizedString(@"Gender", nil);
    _genderCell.textLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:kTitleFontSize];
    
    _genderLabel = [[UILabel alloc] initWithFrame:CGRectMake(WINSIZE.width * (0.96 - kTextFieldWidthRatio), 0, WINSIZE.width * kTextFieldWidthRatio, kAverageCellHeight)];
    _genderLabel.text = _userData.gender;
    _genderLabel.textColor = TEXT_COLOR_DARK_GRAY;
    _genderLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:16];
    
    if (!_genderLabel.text || _genderLabel.text.length == 0)
    {
        _genderLabel.text = USER_PROFILE_GENDER_SELECT;
        _genderLabel.textColor = PLACEHOLDER_TEXT_COLOR;
    }
    
    [_genderCell addSubview:_genderLabel];
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) initBirthdayCell
//--------------------------------------------------------------------------------------------------------------------------------
{
    _birthdayCell = [[UITableViewCell alloc] init];
    _birthdayCell.textLabel.text = NSLocalizedString(@"Birthday", nil);
    _birthdayCell.textLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:kTitleFontSize];
    
    _birthdayLabel = [[UILabel alloc] initWithFrame:CGRectMake(WINSIZE.width * (0.96 - kTextFieldWidthRatio), 0, WINSIZE.width * kTextFieldWidthRatio, kAverageCellHeight)];
    _birthdayLabel.text = _userData.dateOfBirth;
    _birthdayLabel.textColor = TEXT_COLOR_DARK_GRAY;
    _birthdayLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:16];
    
    [_birthdayCell addSubview:_birthdayLabel];
    _birthdayCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}


#pragma mark - UIAlertViewDelegate methods

//--------------------------------------------------------------------------------------------------------------------------------
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//--------------------------------------------------------------------------------------------------------------------------------
{
    if (alertView.tag == kCancelButtonAlertViewTag)
    {
        if (buttonIndex == 0)
        {
            // Do nothing because user chooses NO
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
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
    {
        return 6;
    }
    else if (section == 1)
    {
        return 4;
    }
    else
    {
        return 0;
    }
}

//--------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//--------------------------------------------------------------------------------------------------------------------------------
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            return _usernameCell;
        }
        else if (indexPath.row == 1)
        {
            return _firstNameCell;
        }
        else if (indexPath.row == 2)
        {
            return _lastNameCell;
        }
        else if (indexPath.row == 3)
        {
            return _myCityCell;
        }
        else if (indexPath.row == 4)
        {
            return _bioCell;
        }
        else if (indexPath.row == 5)
        {
            return _userPhotoCell;
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            return _emailCell;
        }
        else if (indexPath.row == 1)
        {
            return _mobileCell;
        }
        else if (indexPath.row == 2)
        {
            return _genderCell;
        }
        else if (indexPath.row == 3)
        {
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
        return NSLocalizedString(@"PUBLIC PROFILE", nil);
    else if (section == 1)
        return NSLocalizedString(@"PRIVATE PROFILE", nil);
    else
        return nil;
}


#pragma mark - UITableViewDelegate methods

//--------------------------------------------------------------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//--------------------------------------------------------------------------------------------------------------------------------
{
    if (section == 0)
        return 35.0f;
    else if (section == 1)
        return 35.0f;
    else
        return 0.0f;
}

//--------------------------------------------------------------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//--------------------------------------------------------------------------------------------------------------------------------
{
    return 0.0f;
}

//--------------------------------------------------------------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//--------------------------------------------------------------------------------------------------------------------------------
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 4)
            return 3 * kTextFieldHeight + 20;
        else if (indexPath.row == 5)
            return kUserPhotoHeightRatio * kTextFieldHeight + 5;
        else
            return kAverageCellHeight;
    }
    else if (indexPath.section == 1)
    {
        return kAverageCellHeight;
    }
    else
    {
        return 0.0f;
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    view.tintColor = GRAY_COLOR_WITH_WHITE_COLOR_2;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) tableView:(UITableView *) tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    view.tintColor = GRAY_COLOR_WITH_WHITE_COLOR_2;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 3)
        {
            ResidingCountryTableVC *countryTableVC = [[ResidingCountryTableVC alloc] init];
            countryTableVC.delegate = self;
            [self.navigationController pushViewController:countryTableVC animated:YES];
        }
    }
    else if (indexPath.section == 1)
    {
        
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 2)
        {
            [self presentGenderPicker];
        }
        else if (indexPath.row == 3)
        {
            [self presentDatePicker];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // hide keyboard
    [_usernameTextField resignFirstResponder];
    [_firstNameTextField resignFirstResponder];
    [_lastNameTextField resignFirstResponder];
    [_myBioTextView resignFirstResponder];
    [_emailTextField resignFirstResponder];
    [_mobileTextField resignFirstResponder];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) presentGenderPicker
//------------------------------------------------------------------------------------------------------------------------------
{
    NSArray *genders = @[USER_PROFILE_GENDER_NONE, USER_PROFILE_GENDER_MALE, USER_PROFILE_GENDER_FEMALE];
    NSString *selectedGender = USER_PROFILE_GENDER_NONE;
    if (_genderLabel.text && ![_genderLabel.text isEqualToString:USER_PROFILE_GENDER_SELECT])
        selectedGender = _genderLabel.text;
    
    [MMPickerView showPickerViewInView:self.view
                           withStrings:genders
                           withOptions:@{MMbackgroundColor: [UIColor whiteColor],
                                         MMtextColor: [UIColor blackColor],
                                         MMtoolbarColor: [UIColor whiteColor],
                                         MMbuttonColor: MAIN_BLUE_COLOR_WITH_WHITE_2,
                                         MMfont: [UIFont systemFontOfSize:18],
                                         MMvalueY: @5,
                                         MMselectedObject:selectedGender}
                            completion:^(NSString *selectedString) {
                                if ([selectedString isEqualToString:USER_PROFILE_GENDER_NONE])
                                {
                                    _genderLabel.text = USER_PROFILE_GENDER_SELECT;
                                    _genderLabel.textColor = PLACEHOLDER_TEXT_COLOR;
                                }
                                else
                                {
                                    _genderLabel.text = selectedString;
                                    _genderLabel.textColor = TEXT_COLOR_DARK_GRAY;
                                }
                            }];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) presentDatePicker
//------------------------------------------------------------------------------------------------------------------------------
{
    AIDatePickerController *datePickerViewController = [AIDatePickerController pickerWithDate:[NSDate date] selectedBlock:^(NSDate *selectedDate)
    {
        NSString *string = [Utilities commonlyFormattedStringFromDate:selectedDate];
        _birthdayLabel.text = string;
        
        [self dismissViewControllerAnimated:YES completion:nil];
    } cancelBlock:^
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self presentViewController:datePickerViewController animated:YES completion:nil];
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

//------------------------------------------------------------------------------------------------------------------------------
- (BOOL) textFieldShouldReturn:(UITextField *)textField
//------------------------------------------------------------------------------------------------------------------------------
{
    [textField resignFirstResponder];
    
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
    
    if (_currTextFieldTag == kEmailTextFieldTag || _currTextFieldTag == kMobileTextFieldTag)
    {
        [self setViewMovedUp:YES scrollDown:YES withKeyboardHeight:keyboardFrame.size.height];
    }
    else
    {
        [self setViewMovedUp:YES scrollDown:NO withKeyboardHeight:keyboardFrame.size.height];
    }
}

//------------------------------------------------------------------------------------------------------------------------------
-(void) keyboardWillHide: (NSNotification *) notification
//------------------------------------------------------------------------------------------------------------------------------
{
    _currTextFieldTag = 0;
    
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
    
    if (movedUp)
    {
        if (!_isExpandingContentSize)
        {
            contentSize.height += addedHeight;
            [_tableView setContentSize:contentSize];
            _isExpandingContentSize = YES;
            
            if (scrollDown)
                [Utilities scrollToBottom:_tableView];
        }
    }
    else
    {
        if (_isExpandingContentSize)
        {
            contentSize.height -= addedHeight;
            [_tableView setContentSize:contentSize];
            _isExpandingContentSize = NO;
        }
    }
    
    [UIView commitAnimations];
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) cancelBarButtonTapEventHandler
//--------------------------------------------------------------------------------------------------------------------------------
{
//    if (_isProfileModfified)
//    {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Are you sure you want to discard changes to your edits?", nil) message:NSLocalizedString(@"Changes will not be saved.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"No", nil) otherButtonTitles:NSLocalizedString(@"Yes, I'm sure", nil), nil];
//        alertView.tag = kCancelButtonAlertViewTag;
//        [alertView show];
//    }
//    else
//    {
        [self.navigationController popViewControllerAnimated:YES];
//    }
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) doneBarButtonTapEventHandler
//--------------------------------------------------------------------------------------------------------------------------------
{
    // Save new changes
    
    PFUser *currUser = [PFUser currentUser];
    
    if (_usernameTextField.text.length > 0 && ![_usernameTextField.text isEqualToString:_userData.username])
        currUser[PF_USER_USERNAME] = _usernameTextField.text;
    
    if (_firstNameTextField.text.length > 0 && ![_firstNameTextField.text isEqualToString:_userData.firstName])
        currUser[PF_USER_FIRSTNAME] = _firstNameTextField.text;
    
    if (_lastNameTextField.text.length > 0 && ![_lastNameTextField.text isEqualToString:_userData.lastName])
        currUser[PF_USER_LASTNAME] = _lastNameTextField.text;
    
    if (_newCity.length > 0 && ![_newCity isEqualToString:_userData.residingCity])
        currUser[PF_USER_CITY] = _newCity;
    
    if (_newCountry .length > 0 && ![_newCountry isEqualToString:_userData.residingCountry])
        currUser[PF_USER_COUNTRY] = _newCountry;
    
    if (_myBioTextView.text.length > 0 && ![_myBioTextView.text isEqualToString:_userData.description])
        currUser[PF_USER_DESCRIPTION] = _myBioTextView.text;
    
    if (![_userProfileImageView.image isEqual:_userData.profileImage])
    {
        if (_userProfileImageView.image)
        {
            UIImage *resizedImage = [Utilities resizeImage:_userProfileImageView.image toSize:CGSizeMake(300, 300) scalingProportionally:YES];
            NSData *imageData = UIImagePNGRepresentation(resizedImage);
            currUser[PF_USER_PICTURE] = [PFFile fileWithName:currUser.objectId data:imageData];
        
            NSString *key = [NSString stringWithFormat:@"%@%@", currUser.objectId, USER_PROFILE_IMAGE];
            [[ProfileImageCache sharedCache] setObject:resizedImage forKey:key];
        }
    }
    
    if (_emailTextField.text.length > 0 && ![_emailTextField.text isEqualToString:_userData.emailAddress])
        currUser[PF_USER_EMAIL] = _emailTextField.text;
    
    if (_mobileTextField.text.length > 0 && ![_mobileTextField.text isEqualToString:_userData.phoneNumber])
        currUser[PF_USER_PHONE_NUMBER] = _mobileTextField.text;
    
    if (_genderLabel.text > 0 && ![_genderLabel.text isEqualToString:_userData.gender])
    {
        if ([_genderLabel.text isEqualToString:USER_PROFILE_GENDER_SELECT])
            currUser[PF_USER_GENDER] = @"";
        else
            currUser[PF_USER_GENDER] = _genderLabel.text;
    }
    
    if (_birthdayLabel.text.length > 0 && ![_birthdayLabel.text isEqualToString:_userData.dateOfBirth])
        currUser[PF_USER_DOB] = [Utilities dateFromCommonlyFormattedString:_birthdayLabel.text];
    
    [currUser saveInBackground];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USER_PROFILE_EDITED_EVENT object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) changeUserProfileImage
//------------------------------------------------------------------------------------------------------------------------------
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:nil];
}


#pragma mark - ResidingCityDelegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (void) residingCity:(ResidingCityTableVC *)controller didSelectCity:(NSDictionary *)countryCity
//------------------------------------------------------------------------------------------------------------------------------
{
    _newCountry = [countryCity objectForKey:USER_PROFILE_USER_COUNTRY];
    _newCity = [countryCity objectForKey:USER_PROFILE_USER_CITY];
    _myCityLabel.text = [NSString stringWithFormat:@"%@, %@", _newCity, _newCountry];
}


#pragma mark - UIImagePickerControllerDelegate methods

//-------------------------------------------------------------------------------------------------------------------------------
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//-------------------------------------------------------------------------------------------------------------------------------
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [_userProfileImageView setImage:chosenImage];
    
    [picker dismissViewControllerAnimated:NO completion:NULL];
}

@end
