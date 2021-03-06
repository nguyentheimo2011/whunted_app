//
//  EditWantDataVC.m
//  whunted
//
//  Created by thomas nguyen on 22/9/15.
//  Copyright © 2015 Whunted. All rights reserved.
//

#import "EditWantDataVC.h"
#import "Utilities.h"

#define     DELETION_ALERT_VIEW_TAG             114

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
    [backgroundView setBackgroundColor:[GRAY_COLOR_WITH_WHITE_COLOR_2 colorWithAlphaComponent:0.5f]];
    [self.view addSubview:backgroundView];
    
    JTImageButton *deletionButton = [[JTImageButton alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width, BOTTOM_BUTTON_HEIGHT)];
    [deletionButton createTitle:NSLocalizedString(@"Delete", nil) withIcon:nil font:[UIFont fontWithName:SEMIBOLD_FONT_NAME size:DEFAULT_FONT_SIZE] iconHeight:0 iconOffsetY:0];
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
    alertView.tag = DELETION_ALERT_VIEW_TAG;
    alertView.delegate = self;
    [alertView show];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) deletionButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    [Utilities showStandardIndeterminateProgressIndicatorInView:self.view];
    
    self.wantData.itemIsDeleted = YES;
    PFObject *pfObj = [self.wantData getPFObject];
    [pfObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if (error)
        {
            [Utilities handleError:error];
            [pfObj saveEventually];
        }
        
        // Broadcast ItemDeletion Event
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ITEM_DELETION_EVENT object:self.wantData.itemID];
         
        [Utilities hideIndeterminateProgressIndicatorInView:self.view];
         
        // Skip itemDetails view when going back because item is already deleted
        // In the viewController list, the last viewController is EditWantDataVC, then ItemDetailsVC, so on.
        NSArray *viewControllers = self.navigationController.viewControllers;
        if (viewControllers.count >= 3)
        {
            UIViewController *nextViewController = viewControllers[viewControllers.count - 3];
            [self.navigationController popToViewController:nextViewController animated:YES];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
     }];
}


#pragma mark - UIAlertViewDelegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
//------------------------------------------------------------------------------------------------------------------------------
{
    if (alertView.tag == DELETION_ALERT_VIEW_TAG)
    {
        if (buttonIndex == 1)
        {
            [self deletionButtonTapEventHandler];
        }
    }
    else
    {
        [super alertView:alertView didDismissWithButtonIndex:buttonIndex];
    }
}


@end
