//
//  FeedbackReviewVC.m
//  whunted
//
//  Created by thomas nguyen on 30/7/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "FeedbackReviewVC.h"
#import "Utilities.h"
#import "AppConstant.h"

#define kControlContainerHeight 60.0f

@implementation FeedbackReviewVC
{
    UITableView         *_feedbackTableView;
    
    UISegmentedControl  *_categorySegmentedControl;
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//-----------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    
    [self customizeUI];
    [self addTableView];
    [self addSegmentedControl];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
//-----------------------------------------------------------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UI Handlers

//-----------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI
//-----------------------------------------------------------------------------------------------------------------------------
{
    [Utilities customizeTitleLabel:@"+10 / 0 / -0" forViewController:self];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) addSegmentedControl
//-----------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kContainerYPos = [Utilities getHeightOfNavigationAndStatusBars:self];
    UIView *segmentContainer = [[UIView alloc] initWithFrame:CGRectMake(0, kContainerYPos, WINSIZE.width, kControlContainerHeight)]
    ;
    [segmentContainer setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:segmentContainer];
    
    CGFloat const kControlTopMargin = 15.0f;
    CGFloat const kControlLeftMargin = 30.0f;
    CGFloat const kControlHeight = kControlContainerHeight - 2 * kControlTopMargin;
    CGFloat const kControlWidth = WINSIZE.width - 2 * kControlLeftMargin;
    
    NSArray *categories = @[@"All", @"As Seller", @"As Buyer"];
    _categorySegmentedControl = [[UISegmentedControl alloc] initWithItems:categories];
    _categorySegmentedControl.frame = CGRectMake(kControlLeftMargin, kControlTopMargin, kControlWidth, kControlHeight);
    [_categorySegmentedControl setTitleTextAttributes:@{NSFontAttributeName : DEFAULT_FONT} forState:UIControlStateNormal];
    _categorySegmentedControl.selectedSegmentIndex = 0;
    [segmentContainer addSubview:_categorySegmentedControl];
    
    CGFloat const kSeparatorLineLeftMargin = 15.0f;
    CGFloat const kSeparatorLineHeight = 0.75f;
    CGFloat const kSeparatorLineWidth = WINSIZE.width - kSeparatorLineLeftMargin;
    CGFloat const kSeparatorLineYPos = kControlContainerHeight - kSeparatorLineHeight;
    UIView *separatorLine = [[UIView alloc] initWithFrame:CGRectMake(kSeparatorLineLeftMargin, kSeparatorLineYPos, kSeparatorLineWidth, kSeparatorLineHeight)];
    [separatorLine setBackgroundColor:CELL_SEPARATOR_GRAY_COLOR];
    [segmentContainer addSubview:separatorLine];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) addTableView
//-----------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kTableHeight = WINSIZE.height - [Utilities getHeightOfNavigationAndStatusBars:self];

    _feedbackTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kControlContainerHeight, WINSIZE.width, kTableHeight)];
    [self.view addSubview:_feedbackTableView];
}

@end
