//
//  ImageRetrieverViewController.m
//  whunted
//
//  Created by thomas nguyen on 10/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "ImageRetrieverViewController.h"
#import "AppConstant.h"
#import "Utilities.h"

#import "MBProgressHUD.h"

#define kLeftMargin             15.0f

@implementation ImageRetrieverViewController
{
    UILabel             *_instructionLabel;
    
    UITextView          *_imageLinkTextView;
    UIImageView         *_itemImageView;
    UIImage             *_currItemImage;
    UIScrollView        *_scrollView;
}

@synthesize delegate = _delegate;

//--------------------------------------------------------------------------------------------------------------------------------
- (id) init
//--------------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//--------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    
    [self customizeUI];
    
    [self addScrollView];
    [self addInstructionLabel];
    [self addImageLinkTextView];
    [self addItemImageView];
    [self addProceedToEditButton];
    [self addDoneButton];
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
//--------------------------------------------------------------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"ImageRetrieverViewController didReceiveMemoryWarning");
}


#pragma mark - UI Handlers

//--------------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI
//--------------------------------------------------------------------------------------------------------------------------------
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(didStopEditing)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(topCancelButtonTapEventHandler)];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) addScrollView
//--------------------------------------------------------------------------------------------------------------------------------
{
    _scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_scrollView setContentSize:CGSizeMake(WINSIZE.width, WINSIZE.width + 130)];
    [self.view addSubview:_scrollView];
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) addInstructionLabel
//--------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kLabelTopMargin = 10.0f;
    CGFloat const kLabelWidth = WINSIZE.width - 2 * kLeftMargin;
    CGFloat const kLabelHeight = 25.0f;
    
    _instructionLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLeftMargin, kLabelTopMargin, kLabelWidth, kLabelHeight)];
    [_instructionLabel setText:NSLocalizedString(@"Paste image link here", nil)];
    [_instructionLabel setTextColor:TEXT_COLOR_DARK_GRAY];
    [_instructionLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE]];
    [_scrollView addSubview:_instructionLabel];
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) addImageLinkTextView
//--------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kTextViewTopMargin = 5.0f;
    CGFloat const kTextViewYPos = _instructionLabel.frame.origin.y + _instructionLabel.frame.size.height + kTextViewTopMargin;
    CGFloat const kTextViewWidth = WINSIZE.width - 2 * kLeftMargin;
    CGFloat const kTextViewHeight = 55.0f;
    
    _imageLinkTextView = [[UITextView alloc] initWithFrame:CGRectMake(kLeftMargin, kTextViewYPos, kTextViewWidth, kTextViewHeight)];
    [_imageLinkTextView setBackgroundColor:[UIColor whiteColor]];
    [_imageLinkTextView setTextColor:[UIColor grayColor]];
    [_imageLinkTextView setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:16]];
    [_imageLinkTextView setReturnKeyType:UIReturnKeyDone];
    _imageLinkTextView.layer.cornerRadius = 10.0f;
    _imageLinkTextView.layer.borderWidth = 1.0f;
    _imageLinkTextView.layer.borderColor = [LIGHTER_GRAY_COLOR CGColor];
    _imageLinkTextView.delegate = self;
    [_scrollView addSubview:_imageLinkTextView];
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) addItemImageView
//--------------------------------------------------------------------------------------------------------------------------------
{
    _itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 110, WINSIZE.width - 30, WINSIZE.width - 30)];
    [_itemImageView setBackgroundColor:BACKGROUND_GRAY_COLOR];
    [_itemImageView setImage:[UIImage imageNamed:@"placeholder.png"]];
    [_scrollView addSubview:_itemImageView];
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) addProceedToEditButton
//--------------------------------------------------------------------------------------------------------------------------------
{
    UIButton *proceedToEditButton = [[UIButton alloc] initWithFrame:CGRectMake(15, WINSIZE.width + 105, 140, 40)];
    UIColor *normalColor = [UIColor colorWithRed:16.0/255 green:200.0/255 blue:205.0/255 alpha:1.0];
    UIColor *highlightedColor = [UIColor whiteColor];
    [proceedToEditButton setTitle:@"Proceed to edit" forState:UIControlStateNormal];
    [proceedToEditButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [proceedToEditButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [proceedToEditButton.titleLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:16]];
    [proceedToEditButton setBackgroundImage:[Utilities imageWithColor:normalColor] forState:UIControlStateNormal];
    [proceedToEditButton setBackgroundImage:[Utilities imageWithColor:highlightedColor] forState:UIControlStateHighlighted];
    proceedToEditButton.layer.cornerRadius = 5.0;
    proceedToEditButton.clipsToBounds = YES;
    [Utilities addGradientToButton:proceedToEditButton];
    [_scrollView addSubview:proceedToEditButton];
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) addDoneButton
//--------------------------------------------------------------------------------------------------------------------------------
{
    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(WINSIZE.width - 75, WINSIZE.width + 105, 60, 40)];
    UIColor *normalColor = [UIColor colorWithRed:51.0/255 green:153.0/255 blue:255.0/255 alpha:1.0];
    UIColor *highlightedColor = [UIColor whiteColor];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [doneButton.titleLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:16]];
    [doneButton setBackgroundImage:[Utilities imageWithColor:normalColor] forState:UIControlStateNormal];
    [doneButton setBackgroundImage:[Utilities imageWithColor:highlightedColor] forState:UIControlStateHighlighted];
    doneButton.layer.cornerRadius = 5.0;
    doneButton.clipsToBounds = YES;
    [Utilities addGradientToButton:doneButton];
    [doneButton addTarget:self action:@selector(doneButtonClickedEvent) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:doneButton];
}

#pragma mark - UITextViewDelegate methods

//--------------------------------------------------------------------------------------------------------------------------------
- (void) textViewDidBeginEditing:(UITextView *)textView
//--------------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
}

//--------------------------------------------------------------------------------------------------------------------------------
- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//--------------------------------------------------------------------------------------------------------------------------------
{
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) textViewDidChange:(UITextView *)textView
//--------------------------------------------------------------------------------------------------------------------------------
{
    [MBProgressHUD showHUDAddedTo:_itemImageView animated:YES];
    
    NSURL *url = [NSURL URLWithString:_imageLinkTextView.text];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:_itemImageView animated:YES];
        if (data) {
            _currItemImage = [UIImage imageWithData:data];
            [_itemImageView setImage:_currItemImage];
        } else {
            // handle error
            NSLog(@"Error %@ %@", error, [error userInfo]);
        }
    }];
}

#pragma mark - Event Handlers

//--------------------------------------------------------------------------------------------------------------------------------
- (void) didStopEditing
//--------------------------------------------------------------------------------------------------------------------------------
{
    [_imageLinkTextView resignFirstResponder];
    [self.navigationItem.rightBarButtonItem setTitle:@""];
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) topCancelButtonTapEventHandler
//--------------------------------------------------------------------------------------------------------------------------------
{
    if (_currItemImage) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to discard the image?" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes, I'm sure!", nil];
        [alertView show];
    } else {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) doneButtonClickedEvent
//--------------------------------------------------------------------------------------------------------------------------------
{
    [_delegate imageRetrieverViewController:self didRetrieveImage:_currItemImage];
}

#pragma mark - UIAlertViewDelegate

//--------------------------------------------------------------------------------------------------------------------------------
- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
//--------------------------------------------------------------------------------------------------------------------------------
{
    if (buttonIndex == 1) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}


@end
