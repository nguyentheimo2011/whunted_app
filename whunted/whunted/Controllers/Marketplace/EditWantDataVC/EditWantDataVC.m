//
//  EditWantDataVC.m
//  whunted
//
//  Created by thomas nguyen on 22/9/15.
//  Copyright © 2015 Whunted. All rights reserved.
//

#import "EditWantDataVC.h"
#import "Utilities.h"


@implementation EditWantDataVC

//------------------------------------------------------------------------------------------------------------------------------
- (id) initWithWantData: (WantData *) wantData forEditing: (BOOL) isEditing
//------------------------------------------------------------------------------------------------------------------------------
{
    self = [super initWithWantData:wantData forEditing:isEditing];
    
    if (self)
    {
//        [self addDeletionButton];
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
    [backgroundView setBackgroundColor:[GRAY_COLOR_WITH_WHITE_COLOR_2 colorWithAlphaComponent:0.5f]];
    [self.view addSubview:backgroundView];
    
    JTImageButton *deletionButton = [[JTImageButton alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width, BOTTOM_BUTTON_HEIGHT)];
    [deletionButton createTitle:NSLocalizedString(@"Delete", nil) withIcon:nil font:[UIFont fontWithName:REGULAR_FONT_NAME size:18] iconHeight:0 iconOffsetY:0];
    deletionButton.cornerRadius = 0;
    deletionButton.borderWidth = 0;
    deletionButton.bgColor = [FLAT_FRESH_RED_COLOR colorWithAlphaComponent:0.9f];
    deletionButton.titleColor = [UIColor whiteColor];
    [deletionButton addTarget:self action:@selector(confirmToDelete) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:deletionButton];
}


#pragma mark - Event Handler

//------------------------------------------------------------------------------------------------------------------------------
- (void) confirmToDelete
//------------------------------------------------------------------------------------------------------------------------------
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Are you sure that you want to delete your post?", nil) message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
    alertView.delegate = self;
    [alertView show];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) deletionButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    [Utilities showStandardIndeterminateProgressIndicatorInView:self.view];
    
    PFObject *pfObj = [self.wantData getPFObject];
    [pfObj deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
     {
         if (error)
         {
             [Utilities handleError:error];
             [pfObj deleteEventually];
         }
         
         [Utilities hideIndeterminateProgressIndicatorInView:self.view];
         [self.navigationController popViewControllerAnimated:YES];
     }];
}


#pragma mark - UIAlertViewDelegate methods

////------------------------------------------------------------------------------------------------------------------------------
//- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
////------------------------------------------------------------------------------------------------------------------------------
//{
//    if (buttonIndex == 1)
//    {
//        [self deletionButtonTapEventHandler];
//    }
//}


@end
