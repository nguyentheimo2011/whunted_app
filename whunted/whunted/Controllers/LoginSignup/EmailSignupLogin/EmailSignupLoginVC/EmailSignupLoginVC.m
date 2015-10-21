//
//  EmailSignupLoginVC.m
//  whunted
//
//  Created by thomas nguyen on 2/10/15.
//  Copyright © 2015 Whunted. All rights reserved.
//

#import "EmailSignupLoginVC.h"
#import "MainViewController.h"
#import "AppConstant.h"
#import "Utilities.h"

#import <JTImageButton.h>

@implementation EmailSignupLoginVC
{
    UISegmentedControl          *_segmentedControl;
    
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
    [self addSignupTableView];
    [self addLoginTableView];
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
    _segmentedControl = [EmailSignupLoginUIHelper addSegmentedControlToViewController:self];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addSignupTableView
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kTableViewOriginY =   _segmentedControl.frame.origin.y + _segmentedControl.frame.size.height + 30.0f;
    
    // Sign up
    _containerSignup = [[UIView alloc] initWithFrame:CGRectMake(0, kTableViewOriginY, WINSIZE.width, 3 * kTableViewCellHeight + 60.0f)];
    
    UITableView *tableViewSignup = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width, 3 * kTableViewCellHeight)];
    tableViewSignup.delegate = self;
    tableViewSignup.dataSource = self;
    tableViewSignup.tag = kTableViewSignupTag;
    [_containerSignup addSubview:tableViewSignup];
    [self.view addSubview:_containerSignup];
    
    [self addSignupDisclaimerLabel1];
    [self addSignupDisclaimerLabel2];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addLoginTableView
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kTableViewOriginY =   _segmentedControl.frame.origin.y + _segmentedControl.frame.size.height + 30.0f;
    
    // Log in
    _containerLogin = [[UIView alloc] initWithFrame:CGRectMake(0, kTableViewOriginY, WINSIZE.width, 2 * kTableViewCellHeight)];
    
    UITableView *tableViewLogin = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width, 2 * kTableViewCellHeight)];
    tableViewLogin.delegate = self;
    tableViewLogin.dataSource = self;
    tableViewLogin.tag = kTableViewLoginTag;
    [_containerLogin addSubview:tableViewLogin];
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
    _signupDisclaimerLabel1 = [EmailSignupLoginUIHelper addSignupDisclaimerLabel1ToView:_containerSignup];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addSignupDisclaimerLabel2
//------------------------------------------------------------------------------------------------------------------------------
{
    [EmailSignupLoginUIHelper addSignupDisclaimerLabel2BehindLable1:_signupDisclaimerLabel1 toView:_containerSignup inViewController:self];
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
    _usernameSignupTextField.keyboardType = UIKeyboardTypeDefault;
    _usernameSignupTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _usernameSignupTextField.returnKeyType = UIReturnKeyDone;
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
    _emailSignupTextField.keyboardType = UIKeyboardTypeEmailAddress;
    _emailSignupTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _emailSignupTextField.returnKeyType = UIReturnKeyDone;
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
    _passwordSignupTextField.keyboardType = UIKeyboardTypeDefault;
    _passwordSignupTextField.secureTextEntry = YES;
    _passwordSignupTextField.returnKeyType = UIReturnKeyDone;
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
    _emailLoginTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Your email", nil) attributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName: [UIFont fontWithName:REGULAR_FONT_NAME size:15]}];
    _emailLoginTextField.delegate = self;
    _emailLoginTextField.tag = kEmailLoginTextFieldTag;
    _emailLoginTextField.keyboardType = UIKeyboardTypeEmailAddress;
    _emailLoginTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _emailLoginTextField.returnKeyType = UIReturnKeyDone;
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
    _passwordLoginTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Password", nil) attributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName: [UIFont fontWithName:REGULAR_FONT_NAME size:15]}];
    _passwordLoginTextField.delegate = self;
    _passwordLoginTextField.tag = kPasswordSignupTextFieldTag;
    _passwordLoginTextField.keyboardType = UIKeyboardTypeDefault;
    _passwordLoginTextField.secureTextEntry = YES;
    _passwordLoginTextField.returnKeyType = UIReturnKeyDone;
    _passwordLoginCell.accessoryView = _passwordLoginTextField;
    _passwordLoginCell.selectionStyle = UITableViewCellSelectionStyleNone;
}


#pragma mark - Event Handler

//------------------------------------------------------------------------------------------------------------------------------
- (void) segmentedControlValueChanged
//------------------------------------------------------------------------------------------------------------------------------
{
    if (_segmentedControl.selectedSegmentIndex == 0)  // Sign up
    {
        [Utilities customizeTitleLabel:NSLocalizedString(@"Sign up", nil) forViewController:self];
        _containerSignup.hidden = NO;
        _containerLogin.hidden = YES;
        [self resignFirstResponderForAll];
    }
    else
    {
        [Utilities customizeTitleLabel:NSLocalizedString(@"Log in", nil) forViewController:self];
        _containerSignup.hidden = YES;
        _containerLogin.hidden = NO;
        [self resignFirstResponderForAll];
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) cancelButtonEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    [self resignFirstResponderForAll];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) doneButtonEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    [self resignFirstResponderForAll];
    
    if (_segmentedControl.selectedSegmentIndex == 0) // Sign up
    {
        [self handleSignupEvent];
    }
    else
    {
        [self handleLoginEvent];
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) handleSignupEvent
//------------------------------------------------------------------------------------------------------------------------------
{
    if (_usernameSignupTextField.text.length == 0)
    {
        [self displayAlertForMissingInfo:NSLocalizedString(@"Username cannot be blank", nil)];
    }
    else if (_emailSignupTextField.text.length == 0)
    {
        [self displayAlertForMissingInfo:NSLocalizedString(@"Email cannot be blank", nil)];
    }
    else if (![Utilities isEmailValid:_emailSignupTextField.text])
    {
        [self displayAlertForMissingInfo:NSLocalizedString(@"Invalid email", nil)];
    }
    else if (_passwordSignupTextField.text.length < 6)
    {
        [self displayAlertForMissingInfo:NSLocalizedString(@"Password must be at least 6 characters", nil)];
    }
    else
    {
        [self checkIfEmailAlreadyInUse:_emailSignupTextField.text];
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) handleLoginEvent
//------------------------------------------------------------------------------------------------------------------------------
{
    if (_emailLoginTextField.text.length == 0)
    {
        [self displayAlertForMissingInfo:NSLocalizedString(@"Email cannot be blank", nil)];
    }
    else if (![Utilities isEmailValid:_emailLoginTextField.text])
    {
        [self displayAlertForMissingInfo:NSLocalizedString(@"Invalid email!", nil)];
    }
    else if (_passwordLoginTextField.text.length < 6)
    {
        [self displayAlertForMissingInfo:NSLocalizedString(@"Password must be at least 6 characters!", nil)];
    }
    else
    {
        [self loginWithEmail:_emailLoginTextField.text password:_passwordLoginTextField.text];
    }
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

//------------------------------------------------------------------------------------------------------------------------------
- (void) resignFirstResponderForAll
//------------------------------------------------------------------------------------------------------------------------------
{
    [_usernameSignupTextField resignFirstResponder];
    [_emailSignupTextField resignFirstResponder];
    [_passwordSignupTextField resignFirstResponder];
    [_emailLoginTextField resignFirstResponder];
    [_passwordLoginTextField resignFirstResponder];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) displayAlertForMissingInfo: (NSString *) message
//------------------------------------------------------------------------------------------------------------------------------
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Oops!", nil) message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    [alertView show];
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


#pragma mark - UITableViewDelegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    return kTableViewCellHeight;
}


#pragma mark - UITextFieldDelegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (BOOL) textFieldShouldReturn:(UITextField *)textField
//------------------------------------------------------------------------------------------------------------------------------
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - Backend

//------------------------------------------------------------------------------------------------------------------------------
- (void) checkIfEmailAlreadyInUse: (NSString *) email
//------------------------------------------------------------------------------------------------------------------------------
{
    [Utilities showStandardIndeterminateProgressIndicatorInView:self.view];
    
    PFQuery *query = [[PFQuery alloc] initWithClassName:PF_USER_CLASS_NAME];
    [query whereKey:PF_USER_EMAIL equalTo:email];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (!error)
        {
            if (objects.count > 0)
            {
                [Utilities hideIndeterminateProgressIndicatorInView:self.view];
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Oops!", nil) message:NSLocalizedString(@"Email is already in use", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
                [alertView show];
            }
            else
            {
                // Validation passed
                PFUser *user = [PFUser user];
                user.username = _usernameSignupTextField.text;
                user.email = _emailSignupTextField.text;
                user.password = _passwordSignupTextField.text;
                
                [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                {
                    if (!error)
                    {
                        // Hooray! Let them use the app now.
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_USER_SIGNED_UP object:nil];
                        
                        [Utilities hideIndeterminateProgressIndicatorInView:self.view];
                        
                        MainViewController *mainVC = [[MainViewController alloc] initWithNibName:nil bundle:nil];
                        [self presentViewController:mainVC animated:NO completion:^{}];
                    }
                    else
                    {
                        // Sign up failed
                        [Utilities handleError:error];
                    }
                }];
            }
        }
        else
        {
            [Utilities handleError:error];
        }
    }];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) loginWithEmail: (NSString *) email password: (NSString *) password
//------------------------------------------------------------------------------------------------------------------------------
{
    [Utilities showStandardIndeterminateProgressIndicatorInView:self.view];
    
    PFQuery *query = [[PFQuery alloc] initWithClassName:PF_USER_CLASS_NAME];
    [query whereKey:PF_USER_EMAIL equalTo:email];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
       if (!error)
       {
           if (objects.count > 0)
           {
               PFObject *object = [objects objectAtIndex:0];
               NSString *username = object[PF_USER_USERNAME];
               [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * _Nullable user, NSError * _Nullable error) {
                   if (!error)
                   {
                       [Utilities hideIndeterminateProgressIndicatorInView:self.view];
                       
                       MainViewController *mainVC = [[MainViewController alloc] initWithNibName:nil bundle:nil];
                       [self presentViewController:mainVC animated:NO completion:^{}];
                   }
                   else
                   {
                       [Utilities hideIndeterminateProgressIndicatorInView:self.view];
                       
                       [Utilities handleError:error];
                       
                       UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Oops!", nil) message:NSLocalizedString(@"Email and password do not match", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
                       [alertView show];
                   }
               }];
           }
           else
           {
               [Utilities hideIndeterminateProgressIndicatorInView:self.view];
               
               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Oops!", nil) message:NSLocalizedString(@"Email and password do not match", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
               [alertView show];
           }
       }
       else
       {
           [Utilities handleError:error];
           [Utilities hideIndeterminateProgressIndicatorInView:self.view];
       }
    }];
}


@end
