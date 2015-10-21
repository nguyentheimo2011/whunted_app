//
//  EmailSignupLoginVC.m
//  whunted
//
//  Created by thomas nguyen on 2/10/15.
//  Copyright © 2015 Whunted. All rights reserved.
//

#import "EmailSignupLoginVC.h"
#import "MainViewController.h"
#import "PasswordResetVC.h"
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
    
    UITableView *tableViewSignup = [[UITableView alloc] initWithFrame:CGRectMake(15.0f, 0, WINSIZE.width - 30.0f, 3 * kTableViewCellHeight)];
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
    _containerLogin = [[UIView alloc] initWithFrame:CGRectMake(0, kTableViewOriginY, WINSIZE.width, 2 * kTableViewCellHeight + 50.0f)];
    
    UITableView *tableViewLogin = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width, 2 * kTableViewCellHeight)];
    tableViewLogin.delegate = self;
    tableViewLogin.dataSource = self;
    tableViewLogin.tag = kTableViewLoginTag;
    [_containerLogin addSubview:tableViewLogin];
    _containerLogin.hidden = YES;
    [self.view addSubview:_containerLogin];
    
    [self addForgotPasswordButton];
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
- (void) addForgotPasswordButton
//------------------------------------------------------------------------------------------------------------------------------
{
    [EmailSignupLoginUIHelper addForgotPasswordButtonToView:_containerLogin inViewController:self];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initUsernameSignupCell
//------------------------------------------------------------------------------------------------------------------------------
{
    NSArray *array = [EmailSignupLoginUIHelper initUsernameSignupCellInViewController:self];
    _usernameSignUpCell = array[0];
    _usernameSignupTextField = array[1];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initEmailSignupCell
//------------------------------------------------------------------------------------------------------------------------------
{
    NSArray *array = [EmailSignupLoginUIHelper initEmailSignupCellInViewController:self];
    _emailSignUpCell = array[0];
    _emailSignupTextField = array[1];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initPasswordSignupCell
//------------------------------------------------------------------------------------------------------------------------------
{
    NSArray *array = [EmailSignupLoginUIHelper initPasswordSignupCellInViewController:self];
    _passwordSignupCell = array[0];
    _passwordSignupTextField = array[1];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initEmailLoginCell
//------------------------------------------------------------------------------------------------------------------------------
{
    NSArray *array = [EmailSignupLoginUIHelper initEmailLoginCellInViewController:self];
    _emailLoginCell = array[0];
    _emailLoginTextField = array[1];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initPasswordLoginCell
//------------------------------------------------------------------------------------------------------------------------------
{
    NSArray *array = [EmailSignupLoginUIHelper initPasswordLoginCellInViewController:self];
    _passwordLoginCell = array[0];
    _passwordLoginTextField = array[1];
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
- (void) forgotPasswordButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    PasswordResetVC *passwordResetVC = [[PasswordResetVC alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:passwordResetVC];
    [self.navigationController presentViewController:navController animated:YES completion:nil];
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
