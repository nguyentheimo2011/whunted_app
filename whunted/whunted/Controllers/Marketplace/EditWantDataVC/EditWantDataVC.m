//
//  EditWantDataVC.m
//  whunted
//
//  Created by thomas nguyen on 22/9/15.
//  Copyright © 2015 Whunted. All rights reserved.
//

#import "EditWantDataVC.h"


@implementation EditWantDataVC


//------------------------------------------------------------------------------------------------------------------------------
- (id) initWithWantData: (WantData *) wantData forEditing: (BOOL) isEditing
//------------------------------------------------------------------------------------------------------------------------------
{
    self = [super initWithWantData:wantData forEditing:isEditing];
    
    if (self)
    {
        [self addDeletionButton];
    }
    
    return self;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
//------------------------------------------------------------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
}


#pragma mark - UI Handlers

//------------------------------------------------------------------------------------------------------------------------------
- (void) addDeletionButton
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kOriginY  =   WINSIZE.height - STATUS_BAR_AND_NAV_BAR_HEIGHT - BOTTOM_BUTTON_HEIGHT;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, kOriginY, WINSIZE.width, BOTTOM_BUTTON_HEIGHT)];
    [backgroundView setBackgroundColor:[LIGHTEST_GRAY_COLOR colorWithAlphaComponent:0.5f]];
    [self.view addSubview:backgroundView];
    
    JTImageButton *deletionButton = [[JTImageButton alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width, BOTTOM_BUTTON_HEIGHT)];
    [deletionButton createTitle:NSLocalizedString(@"Delete", nil) withIcon:nil font:[UIFont fontWithName:REGULAR_FONT_NAME size:18] iconHeight:0 iconOffsetY:0];
    deletionButton.cornerRadius = 0;
    deletionButton.borderWidth = 0;
    deletionButton.bgColor = [FLAT_FRESH_RED_COLOR colorWithAlphaComponent:0.9f];
    deletionButton.titleColor = [UIColor whiteColor];
    [deletionButton addTarget:self action:@selector(deletionButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:deletionButton];
}


#pragma mark - Event Handler

//------------------------------------------------------------------------------------------------------------------------------
- (void) deletionButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    
}


@end
