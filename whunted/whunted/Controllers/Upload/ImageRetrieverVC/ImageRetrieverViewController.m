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

#import <MBProgressHUD.h>
#import <JTImageButton.h>

#define     kLeftMargin             15.0f

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
    if (self)
    {
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
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) viewWillAppear:(BOOL)animated
//--------------------------------------------------------------------------------------------------------------------------------
{
    [super viewWillAppear:animated];
    
    [Utilities sendScreenNameToGoogleAnalyticsTracker:@"ImageDownloaderScreen"];
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
//--------------------------------------------------------------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
    
    [Utilities logOutMessage:@"ImageRetrieverViewController didReceiveMemoryWarning"];
}


#pragma mark - UI Handlers

//--------------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI
//--------------------------------------------------------------------------------------------------------------------------------
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStylePlain target:self action:@selector(topCancelButtonTapEventHandler)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStylePlain target:self action:@selector(topDoneButtonTapEventHandler)];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) addScrollView
//--------------------------------------------------------------------------------------------------------------------------------
{
    _scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_scrollView setContentSize:CGSizeMake(WINSIZE.width, WINSIZE.height)];
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
    [_imageLinkTextView setTextColor:TEXT_COLOR_DARK_GRAY];
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
    CGFloat const kImageViewWidth = WINSIZE.width - 2 * kLeftMargin;
    CGFloat const kImageViewTopMargin = 25.0f;
    CGFloat const kImageViewYPos = _imageLinkTextView.frame.origin.y + _imageLinkTextView.frame.size.height + kImageViewTopMargin;
    
    _itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kLeftMargin, kImageViewYPos, kImageViewWidth, kImageViewWidth)];
    [_itemImageView setImage:[UIImage imageNamed:@"placeholder.png"]];
    _itemImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:_itemImageView];
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) addProceedToEditButton
//--------------------------------------------------------------------------------------------------------------------------------
{
    JTImageButton *proceedToEditButton = [[JTImageButton alloc] init];
    [proceedToEditButton createTitle:NSLocalizedString(@"Proceed to edit", nil) withIcon:nil font:[UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE] iconOffsetY:0];
    proceedToEditButton.titleColor = [UIColor whiteColor];
    proceedToEditButton.cornerRadius = 6.0f;
    proceedToEditButton.borderColor = MAIN_BLUE_COLOR;
    proceedToEditButton.bgColor = MAIN_BLUE_COLOR;
    
    [proceedToEditButton sizeToFit];
    CGFloat const kButtonWidth = proceedToEditButton.frame.size.width + 20.0f;
    CGFloat const kButtonHeight = 40.0f;
    CGFloat const kButtonXPos = WINSIZE.width - kLeftMargin - kButtonWidth;
    CGFloat const kButtonTopMargin = 30.0f;
    CGFloat const kButtonYPos = _itemImageView.frame.origin.y + _itemImageView.frame.size.height + kButtonTopMargin;
    proceedToEditButton.frame = CGRectMake(kButtonXPos, kButtonYPos, kButtonWidth, kButtonHeight);
    [proceedToEditButton addTarget:self action:@selector(proceedToEdit) forControlEvents:UIControlEventTouchUpInside];
    
    [_scrollView addSubview:proceedToEditButton];
    
    // adjust size of the scroll view
    [_scrollView setContentSize:CGSizeMake(WINSIZE.width, proceedToEditButton.frame.origin.y + proceedToEditButton.frame.size.height + 10.0f)];
}

#pragma mark - UITextViewDelegate methods

//--------------------------------------------------------------------------------------------------------------------------------
- (BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//--------------------------------------------------------------------------------------------------------------------------------
{
    if([text isEqualToString:@"\n"])
    {
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
        if (data)
        {
            _currItemImage = [UIImage imageWithData:data];
            [_itemImageView setImage:_currItemImage];
        }
        else
        {
            // handle error
            [Utilities handleError:error];
        }
    }];
}

#pragma mark - Event Handlers

//--------------------------------------------------------------------------------------------------------------------------------
- (void) topCancelButtonTapEventHandler
//--------------------------------------------------------------------------------------------------------------------------------
{
    if (_currItemImage)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Are you sure you want to discard the image?", nil) message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Yes, I'm sure!", nil), nil];
        [alertView show];
    }
    else
    {
        [_delegate imageRetrieverViewControllerDidCancel];
    }
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) topDoneButtonTapEventHandler
//--------------------------------------------------------------------------------------------------------------------------------
{
    [_delegate imageRetrieverViewController:self didRetrieveImage:_currItemImage needEditing:NO];
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void) proceedToEdit
//--------------------------------------------------------------------------------------------------------------------------------
{
    [_delegate imageRetrieverViewController:self didRetrieveImage:_currItemImage needEditing:YES];
}

#pragma mark - UIAlertViewDelegate

//--------------------------------------------------------------------------------------------------------------------------------
- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
//--------------------------------------------------------------------------------------------------------------------------------
{
    if (buttonIndex == 1)
    {
        [_delegate imageRetrieverViewControllerDidCancel];
    }
}


@end
