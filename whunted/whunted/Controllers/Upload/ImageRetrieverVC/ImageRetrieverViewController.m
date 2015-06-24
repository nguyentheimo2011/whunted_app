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

@interface ImageRetrieverViewController ()

@property (nonatomic, strong) UITextView *_imageLinkTextView;
@property (nonatomic, strong) UIImageView *_itemImageView;
@property (nonatomic, strong) UIImage *_currItemImage;
@property (nonatomic, strong) UIScrollView *_scrollView;

@end

@implementation ImageRetrieverViewController

@synthesize _imageLinkTextView;
@synthesize _itemImageView;
@synthesize _currItemImage;
@synthesize _scrollView;
@synthesize delegate;

- (id) init
{
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:LIGHTEST_GRAY_COLOR];
    
    [self customizeNavigationBar];
    
    [self addScrollView];
    [self addInstructionLabel];
    [self addImageLinkTextView];
    [self addItemImageView];
    [self addProceedToEditButton];
    [self addDoneButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Handlers
- (void) customizeNavigationBar
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(didStopEditing)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonClickedEvent)];
}

- (void) addScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [_scrollView setContentSize:CGSizeMake(WINSIZE.width, WINSIZE.width + 130)];
    [self.view addSubview:_scrollView];
}

- (void) addInstructionLabel
{
    UILabel *instructionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, WINSIZE.width - 30, 25)];
    [instructionLabel setText:@"Paste image link here"];
    [instructionLabel setTextColor:[UIColor grayColor]];
    [instructionLabel setFont:[UIFont systemFontOfSize:16]];
    [_scrollView addSubview:instructionLabel];
}

- (void) addImageLinkTextView
{
    _imageLinkTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, 35, WINSIZE.width - 30, 55)];
    [_imageLinkTextView setBackgroundColor:[UIColor whiteColor]];
    [_imageLinkTextView setTextColor:[UIColor grayColor]];
    [_imageLinkTextView setFont:[UIFont systemFontOfSize:16]];
    [_imageLinkTextView setReturnKeyType:UIReturnKeyDone];
    _imageLinkTextView.layer.cornerRadius = 6.0;
    _imageLinkTextView.delegate = self;
    [_scrollView addSubview:_imageLinkTextView];
}

- (void) addItemImageView
{
    _itemImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 110, WINSIZE.width - 30, WINSIZE.width - 30)];
    [_itemImageView setBackgroundColor:BACKGROUND_GRAY_COLOR];
    [_itemImageView setImage:[UIImage imageNamed:@"placeholder.png"]];
    [_scrollView addSubview:_itemImageView];
}

- (void) addProceedToEditButton
{
    UIButton *proceedToEditButton = [[UIButton alloc] initWithFrame:CGRectMake(15, WINSIZE.width + 105, 140, 40)];
    UIColor *normalColor = [UIColor colorWithRed:16.0/255 green:200.0/255 blue:205.0/255 alpha:1.0];
    UIColor *highlightedColor = [UIColor whiteColor];
    [proceedToEditButton setTitle:@"Proceed to edit" forState:UIControlStateNormal];
    [proceedToEditButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [proceedToEditButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [proceedToEditButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [proceedToEditButton setBackgroundImage:[Utilities imageWithColor:normalColor] forState:UIControlStateNormal];
    [proceedToEditButton setBackgroundImage:[Utilities imageWithColor:highlightedColor] forState:UIControlStateHighlighted];
    proceedToEditButton.layer.cornerRadius = 5.0;
    proceedToEditButton.clipsToBounds = YES;
    [Utilities addGradientToButton:proceedToEditButton];
    [_scrollView addSubview:proceedToEditButton];
}

- (void) addDoneButton
{
    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(WINSIZE.width - 75, WINSIZE.width + 105, 60, 40)];
    UIColor *normalColor = [UIColor colorWithRed:51.0/255 green:153.0/255 blue:255.0/255 alpha:1.0];
    UIColor *highlightedColor = [UIColor whiteColor];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [doneButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [doneButton setBackgroundImage:[Utilities imageWithColor:normalColor] forState:UIControlStateNormal];
    [doneButton setBackgroundImage:[Utilities imageWithColor:highlightedColor] forState:UIControlStateHighlighted];
    doneButton.layer.cornerRadius = 5.0;
    doneButton.clipsToBounds = YES;
    [Utilities addGradientToButton:doneButton];
    [doneButton addTarget:self action:@selector(doneButtonClickedEvent) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:doneButton];
}

#pragma mark - Event Handlers
- (void) textViewDidBeginEditing:(UITextView *)textView
{
    [self.navigationItem.rightBarButtonItem setTitle:@"Done"];
}

- (void) textViewDidChange:(UITextView *)textView
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

- (void) didStopEditing
{
    [_imageLinkTextView resignFirstResponder];
    [self.navigationItem.rightBarButtonItem setTitle:@""];
}

- (void) backButtonClickedEvent
{
    if (_currItemImage) {
        UIAlertView *backAlertView = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to discard the image?" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes, I'm sure!", nil];
        [backAlertView show];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) doneButtonClickedEvent
{
    [delegate imageRetrieverViewController:self didRetrieveImage:_currItemImage];
}

#pragma mark - UIAlertViewDelegate
- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
