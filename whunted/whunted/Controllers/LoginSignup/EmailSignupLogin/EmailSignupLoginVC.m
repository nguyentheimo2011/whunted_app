//
//  EmailSignupLoginVC.m
//  whunted
//
//  Created by thomas nguyen on 2/10/15.
//  Copyright © 2015 Whunted. All rights reserved.
//

#import "EmailSignupLoginVC.h"
#import "AppConstant.h"
#import "Utilities.h"

#import <JTImageButton.h>

#define     kUsernameSignupTextFieldTag     102
#define     kEmailSignupTextFieldTag        103
#define     kPasswordSignupTextFieldTag     104

#define     kEmailLoginTextFieldTag         105
#define     kPasswordSLoginTextFieldTag     106

#define     kTableViewCellHeight            40.0f

#define     kTableViewSignupTag             202
#define     kTableViewLoginTag              203

@implementation EmailSignupLoginVC
{
    UISegmentedControl          *_segmentedControl;
    
    UITableView                 *_tableViewSignup;
    UITableView                 *_tableViewLogin;
    
    UIView                      *_containerSignup;
    UIView                      *_containerLogin;
    
    UILabel                     *_signupDisclaimerLabel1;
    
    UITableViewCell             *_usernameSignUpCell;
    UITableViewCell             *_emailSignUpCell;
    UITableViewCell             *_passwordSignupCell;
    
    UITableViewCell             *_emailLoginCell;
    UITableViewCell             *_passwordLoginCell;
    
    UITextField                 *_usernameSignupTextField;
    UITextField                 *_emailSignupTextField;
    UITextField                 *_passwordSignupTextField;
    
    UITextField                 *_emailLoginTextField;
    UITextField                 *_passwordLoginTextField;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    [self customizeUI];
    [self addSegmentedControl];
    [self initCells];
    [self initTableViews];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
//------------------------------------------------------------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
}


#pragma mark - UI Handler

//------------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI
//------------------------------------------------------------------------------------------------------------------------------
{
    [Utilities customizeTitleLabel:NSLocalizedString(@"Sign up", nil) forViewController:self];
    
    self.view.backgroundColor = LIGHTEST_GRAY_COLOR;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonEventHandler)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonEventHandler)];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addSegmentedControl
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kControlWidth     =   WINSIZE.width * 0.6f;
    CGFloat const kControlHeight    =   30.0f;
    CGFloat const kControlOriginX   =   (WINSIZE.width - kControlWidth)/2;
    CGFloat const kControlOriginY   =   20.0f + [Utilities getHeightOfNavigationAndStatusBars:self];
    
    NSArray *categories = @[NSLocalizedString(@"Sign up", nil), NSLocalizedString(@"Log in", nil)];
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:categories];
    _segmentedControl.frame = CGRectMake(kControlOriginX, kControlOriginY, kControlWidth, kControlHeight);
    [_segmentedControl setTitleTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE]} forState:UIControlStateNormal];
    _segmentedControl.selectedSegmentIndex = 0;
    [_segmentedControl addTarget:self action:@selector(segmentedControlValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segmentedControl];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initTableViews
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kTableViewOriginY =   _segmentedControl.frame.origin.y + _segmentedControl.frame.size.height + 30.0f;
    
    // Sign up
    _containerSignup = [[UIView alloc] initWithFrame:CGRectMake(0, kTableViewOriginY, WINSIZE.width, 3 * kTableViewCellHeight + 60.0f)];
    
    _tableViewSignup = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width, 3 * kTableViewCellHeight)];
    _tableViewSignup.delegate = self;
    _tableViewSignup.dataSource = self;
    _tableViewSignup.tag = kTableViewSignupTag;
    [_containerSignup addSubview:_tableViewSignup];
    _containerSignup.hidden = NO;
    [self.view addSubview:_containerSignup];
    [self addSignupDisclaimerLabel1];
    [self addSignupDisclaimerLabel2];
    
    // Log in
    _containerSignup = [[UIView alloc] initWithFrame:CGRectMake(0, kTableViewOriginY, WINSIZE.width, 3 * kTableViewCellHeight)];
    
    _tableViewLogin = [[UITableView alloc] initWithFrame:CGRectMake(0, kTableViewOriginY, WINSIZE.width, 2 * kTableViewCellHeight)];
    _tableViewLogin.delegate = self;
    _tableViewLogin.dataSource = self;
    _tableViewLogin.tag = kTableViewLoginTag;
    [_containerLogin addSubview:_tableViewLogin];
    _containerLogin.hidden = YES;
    [self.view addSubview:_containerLogin];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initCells
//------------------------------------------------------------------------------------------------------------------------------
{
    [self initUsernameSignupCell];
    [self initEmailSignupCell];
    [self initPasswordSignupCell];
    
    [self initEmailLoginCell];
    [self initPasswordLoginCell];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addSignupDisclaimerLabel1
//------------------------------------------------------------------------------------------------------------------------------
{
    _signupDisclaimerLabel1 = [[UILabel alloc] init];
    _signupDisclaimerLabel1.text = NSLocalizedString(@"By proceeding, you agree to Whunted's", nil);
    _signupDisclaimerLabel1.textColor = TEXT_COLOR_GRAY;
    _signupDisclaimerLabel1.font = [UIFont fontWithName:REGULAR_FONT_NAME size:13];
    [_signupDisclaimerLabel1 sizeToFit];
    
    CGFloat const kLabelOriginX = (WINSIZE.width - _signupDisclaimerLabel1.frame.size.width) / 2;
    CGFloat const kLabelOriginY = 3 * kTableViewCellHeight + 15.0f;
    _signupDisclaimerLabel1.frame = CGRectMake(kLabelOriginX, kLabelOriginY, _signupDisclaimerLabel1.frame.size.width, _signupDisclaimerLabel1.frame.size.height);
    [_containerSignup addSubview:_signupDisclaimerLabel1];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addSignupDisclaimerLabel2
//------------------------------------------------------------------------------------------------------------------------------
{
    JTImageButton *termOfServiceButton = [[JTImageButton alloc] init];
    [termOfServiceButton createTitle:NSLocalizedString(@"Terms of Service", nil) withIcon:nil font:[UIFont fontWithName:REGULAR_FONT_NAME size:13] iconOffsetY:0];
    termOfServiceButton.titleColor = LIGHTER_RED_COLOR;
    termOfServiceButton.borderWidth = 0;
    [termOfServiceButton addTarget:self action:@selector(termsOfServiceButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
    [termOfServiceButton sizeToFit];
    
    UILabel *disclaimerLabel = [[UILabel alloc] init];
    disclaimerLabel.text = [NSString stringWithFormat:@" %@ ", NSLocalizedString(@"and", nil)];
    disclaimerLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:13];
    disclaimerLabel.textColor = TEXT_COLOR_GRAY;
    [disclaimerLabel sizeToFit];
    
    JTImageButton *privacyPoliciesButton = [[JTImageButton alloc] init];
    [privacyPoliciesButton createTitle:NSLocalizedString(@"Privacy Policy", nil) withIcon:nil font:[UIFont fontWithName:REGULAR_FONT_NAME size:13] iconOffsetY:0];
    privacyPoliciesButton.titleColor = LIGHTER_RED_COLOR;
    privacyPoliciesButton.borderWidth = 0;
    [privacyPoliciesButton addTarget:self action:@selector(privacyPoliciesButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
    [privacyPoliciesButton sizeToFit];
    
    CGFloat totalWidth =  termOfServiceButton.frame.size.width + disclaimerLabel.frame.size.width + privacyPoliciesButton.frame.size.width;
    CGFloat kLabelOriginX   =   (WINSIZE.width - totalWidth) / 2;
    CGFloat kLabelOriginY   =   _signupDisclaimerLabel1.frame.origin.y + _signupDisclaimerLabel1.frame.size.height + 2.0f;
    
    CGFloat kButtonOriginY  =   kLabelOriginY - 6.0f;
    termOfServiceButton.frame = CGRectMake(kLabelOriginX, kButtonOriginY, termOfServiceButton.frame.size.width, termOfServiceButton.frame.size.height);
    [_containerSignup addSubview:termOfServiceButton];
    
    CGFloat kDisclaimerLabelOriginX   =   kLabelOriginX + termOfServiceButton.frame.size.width;
    disclaimerLabel.frame = CGRectMake(kDisclaimerLabelOriginX, kLabelOriginY, disclaimerLabel.frame.size.width, disclaimerLabel.frame.size.height);
    [_containerSignup addSubview:disclaimerLabel];
    
    CGFloat kButtonOriginX  =   disclaimerLabel.frame.origin.x + disclaimerLabel.frame.size.width;
    privacyPoliciesButton.frame = CGRectMake(kButtonOriginX, kButtonOriginY, privacyPoliciesButton.frame.size.width, privacyPoliciesButton.frame.size.height);
    [_containerSignup addSubview:privacyPoliciesButton];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initUsernameSignupCell
//------------------------------------------------------------------------------------------------------------------------------
{
    _usernameSignUpCell = [[UITableViewCell alloc] init];
    _usernameSignUpCell.textLabel.text = NSLocalizedString(@"Username", nil);
    _usernameSignUpCell.textLabel.textColor = TEXT_COLOR_DARK_GRAY;
    _usernameSignUpCell.textLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    _usernameSignupTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width - 120.0f, 30)];
    [_usernameSignupTextField setTextAlignment:NSTextAlignmentLeft];
    UIColor *color = [UIColor colorWithRed:123/255.0 green:123/255.0 blue:129/255.0 alpha:1];
    _usernameSignupTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Choose a username", nil) attributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName: [UIFont fontWithName:REGULAR_FONT_NAME size:15]}];
    _usernameSignupTextField.delegate = self;
    _usernameSignupTextField.tag = kUsernameSignupTextFieldTag;
    [_usernameSignupTextField setKeyboardType:UIKeyboardTypeDefault];
    _usernameSignUpCell.accessoryView = _usernameSignupTextField;
    _usernameSignUpCell.selectionStyle = UITableViewCellSelectionStyleNone;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initEmailSignupCell
//------------------------------------------------------------------------------------------------------------------------------
{
    _emailSignUpCell = [[UITableViewCell alloc] init];
    _emailSignUpCell.textLabel.text = NSLocalizedString(@"Email", nil);
    _emailSignUpCell.textLabel.textColor = TEXT_COLOR_DARK_GRAY;
    _emailSignUpCell.textLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    _emailSignupTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width - 120.0f, 30)];
    [_emailSignupTextField setTextAlignment:NSTextAlignmentLeft];
    UIColor *color = [UIColor colorWithRed:123/255.0 green:123/255.0 blue:129/255.0 alpha:1];
    _emailSignupTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Your email", nil) attributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName: [UIFont fontWithName:REGULAR_FONT_NAME size:15]}];
    _emailSignupTextField.delegate = self;
    _emailSignupTextField.tag = kEmailSignupTextFieldTag;
    [_emailSignupTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    _emailSignUpCell.accessoryView = _emailSignupTextField;
    _emailSignUpCell.selectionStyle = UITableViewCellSelectionStyleNone;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initPasswordSignupCell
//------------------------------------------------------------------------------------------------------------------------------
{
    _passwordSignupCell = [[UITableViewCell alloc] init];
    _passwordSignupCell.textLabel.text = NSLocalizedString(@"Password", nil);
    _passwordSignupCell.textLabel.textColor = TEXT_COLOR_DARK_GRAY;
    _passwordSignupCell.textLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    _passwordSignupTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width - 120.0f, 30)];
    [_passwordSignupTextField setTextAlignment:NSTextAlignmentLeft];
    UIColor *color = [UIColor colorWithRed:123/255.0 green:123/255.0 blue:129/255.0 alpha:1];
    _passwordSignupTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Choose a password", nil) attributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName: [UIFont fontWithName:REGULAR_FONT_NAME size:15]}];
    _passwordSignupTextField.delegate = self;
    _passwordSignupTextField.tag = kPasswordSignupTextFieldTag;
    [_passwordSignupTextField setKeyboardType:UIKeyboardTypeDefault];
    _passwordSignupCell.accessoryView = _passwordSignupTextField;
    _passwordSignupCell.selectionStyle = UITableViewCellSelectionStyleNone;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initEmailLoginCell
//------------------------------------------------------------------------------------------------------------------------------
{
    _emailLoginCell = [[UITableViewCell alloc] init];
    _emailLoginCell.textLabel.text = NSLocalizedString(@"Email", nil);
    _emailLoginCell.textLabel.textColor = TEXT_COLOR_DARK_GRAY;
    _emailLoginCell.textLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    _emailLoginTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width - 120.0f, 30)];
    [_emailLoginTextField setTextAlignment:NSTextAlignmentLeft];
    UIColor *color = [UIColor colorWithRed:123/255.0 green:123/255.0 blue:129/255.0 alpha:1];
    _emailLoginTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"your email", nil) attributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName: [UIFont fontWithName:REGULAR_FONT_NAME size:15]}];
    _emailLoginTextField.delegate = self;
    _emailLoginTextField.tag = kEmailLoginTextFieldTag;
    [_emailLoginTextField setKeyboardType:UIKeyboardTypeEmailAddress];
    _emailLoginCell.accessoryView = _emailLoginTextField;
    _emailLoginCell.selectionStyle = UITableViewCellSelectionStyleNone;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initPasswordLoginCell
//------------------------------------------------------------------------------------------------------------------------------
{
    _passwordLoginCell = [[UITableViewCell alloc] init];
    _passwordLoginCell.textLabel.text = NSLocalizedString(@"Password", nil);
    _passwordLoginCell.textLabel.textColor = TEXT_COLOR_DARK_GRAY;
    _passwordLoginCell.textLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    _passwordLoginTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width - 120.0f, 30)];
    [_passwordLoginTextField setTextAlignment:NSTextAlignmentLeft];
    UIColor *color = [UIColor colorWithRed:123/255.0 green:123/255.0 blue:129/255.0 alpha:1];
    _passwordLoginTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Choose a password", nil) attributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName: [UIFont fontWithName:REGULAR_FONT_NAME size:15]}];
    _passwordLoginTextField.delegate = self;
    _passwordLoginTextField.tag = kPasswordSignupTextFieldTag;
    [_passwordLoginTextField setKeyboardType:UIKeyboardTypeDefault];
    _passwordLoginCell.accessoryView = _passwordLoginTextField;
    _passwordLoginCell.selectionStyle = UITableViewCellSelectionStyleNone;
}


#pragma mark - Event Handler

//------------------------------------------------------------------------------------------------------------------------------
- (void) segmentedControlValueChanged
//------------------------------------------------------------------------------------------------------------------------------
{
    
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) cancelButtonEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) doneButtonEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) termsOfServiceButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    UIWebView *webView = [[UIWebView alloc] init];
    NSMutableURLRequest * request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://whunted.com/Termsofservice.html"]];
    [webView loadRequest:request];
    
    UIViewController *viewController = [[UIViewController alloc] init];
    [Utilities customizeTitleLabel:NSLocalizedString(@"Terms of Service", nil) forViewController:viewController];
    viewController.view = webView;
    [self.navigationController pushViewController:viewController animated:YES];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) privacyPoliciesButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    UIWebView *webView = [[UIWebView alloc] init];
    NSMutableURLRequest * request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://whunted.com/privacy.html"]];
    [webView loadRequest:request];
    
    UIViewController *viewController = [[UIViewController alloc] init];
    [Utilities customizeTitleLabel:NSLocalizedString(@"Privacy Policy", nil) forViewController:viewController];
    viewController.view = webView;
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark - UITableViewDataSource methods

//------------------------------------------------------------------------------------------------------------------------------
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    if (tableView.tag == kTableViewSignupTag)
        return 3;
    else
        return 2;
}

//------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    if (tableView.tag == kTableViewSignupTag)
    {
        if (indexPath.row == 0)
            return _usernameSignUpCell;
        else if (indexPath.row == 1)
            return _emailSignUpCell;
        else
            return _passwordSignupCell;
    }
    else
    {
        if (indexPath.row == 0)
            return _emailLoginCell;
        else
            return _passwordLoginCell;
    }
}


#pragma mark - UITableViewDelegate

//------------------------------------------------------------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    return kTableViewCellHeight;
}


@end
