//
//  WantDetailsViewController.m
//  whunted
//
//  Created by thomas nguyen on 16/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "UploadingWantDetailsViewController.h"
#import "AppConstant.h"
#import "Utilities.h"

#import "KLCPopup.h"

#define     kCellHeight                 40.0f
#define     kIconWidth                  20.0f
#define     kIconHeight                 20.0f
#define     kIconLeftMargin             15.0f
#define     kIconTopMargin              10.0f


@implementation UploadingWantDetailsViewController
{
    UITableViewCell             *_buttonListCell;
    UITableViewCell             *_categoryCell;
    UITableViewCell             *_itemInfoCell;
    UITableViewCell             *_priceCell;
    UITableViewCell             *_locationCell;
    
    UITextField                 *_priceTextField;
    KLCPopup                    *_popup;
    
    NSMutableArray              *_addingButtonList;
    
    NSString                    *_hashtagString;
    NSInteger                   _prevTappedButtonIndex;
    BOOL                        _imageEdittingNeeded;
    
    BOOL                        _isEditing;
}

@synthesize wantData        =   _wantData;

//------------------------------------------------------------------------------------------------------------------------------
- (id) init
//------------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    
    if (self != nil)
    {
        [self customizeUI:NO];
        [self initializeButtonListCell];
        [self initializeSecondSection];
        [self initData];
    }
    
    return self;
}

//------------------------------------------------------------------------------------------------------------------------------
- (id) initWithWantData: (WantData *) wantData forEditing: (BOOL) isEditing
//------------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    
    if (self != nil)
    {
        _wantData = wantData;
        _isEditing = isEditing;
        
        [self customizeUI:isEditing];
        [self initializeButtonListCell];
        [self initializeSecondSection];
        [self populateData];
    }
    
    return self;
}


//------------------------------------------------------------------------------------------------------------------------------
- (void) initData
//------------------------------------------------------------------------------------------------------------------------------
{
    _wantData = [[WantData alloc] init];
    _wantData.buyerID = [PFUser currentUser].objectId;
    _wantData.buyerUsername = [PFUser currentUser][PF_USER_USERNAME];
    _wantData.itemPictures = [[NSMutableArray alloc] init];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) viewWillAppear:(BOOL)animated
//------------------------------------------------------------------------------------------------------------------------------
{
    [super viewWillAppear:animated];
    
    [Utilities sendScreenNameToGoogleAnalyticsTracker:@"UploadDetailsScreen"];
}


#pragma mark - UI Handlers

//------------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI: (BOOL) editing
//------------------------------------------------------------------------------------------------------------------------------
{
    self.view.backgroundColor = GRAY_COLOR_WITH_WHITE_COLOR_2;
    
    [Utilities customizeTitleLabel:NSLocalizedString(@"Upload", nil) forViewController:self];
    
    // hide bottom bar when uploading a new want
    self.hidesBottomBarWhenPushed = YES;
    
    [self customizeBarButtons:editing];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) customizeBarButtons: (BOOL) editing
//------------------------------------------------------------------------------------------------------------------------------
{
    if (editing)
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStylePlain target:self action:@selector(topCancelButtonTapEventHandler)];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStylePlain target:self action:@selector(completeEditingWantData)];
    }
    else
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStylePlain target:self action:@selector(topCancelButtonTapEventHandler)];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Submit", nil) style:UIBarButtonItemStylePlain target:self action:@selector(submittingButtonTapEventHandler)];
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initializeButtonListCell
//------------------------------------------------------------------------------------------------------------------------------
{
    _buttonListCell = [[UITableViewCell alloc] init];
    _buttonListCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGSize imageSize = [UIImage imageNamed:@"squareplus.png"].size;
    CGFloat spaceWidth = (WINSIZE.width - 4 * imageSize.width) / 5.0;
    _addingButtonList = [[NSMutableArray alloc] init];
    
    for (int i=0; i<4; i++) {
        UIImageView *addingButton = [[UIImageView alloc] init];
        addingButton.tag = i;
        [addingButton setImage:[UIImage imageNamed:@"squareplus.png"]];
        addingButton.contentMode = UIViewContentModeScaleAspectFit;
        addingButton.frame = CGRectMake((i+1) * spaceWidth + i * imageSize.width, imageSize.width/6.0, imageSize.width, imageSize.height);
        addingButton.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGesRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addingImageButtonEvent:)];
        [addingButton addGestureRecognizer:tapGesRec];
        [_buttonListCell addSubview:addingButton];
        [_addingButtonList addObject:addingButton];
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initializeSecondSection
//------------------------------------------------------------------------------------------------------------------------------
{
    [self initializeCategoryCell];
    [self initializeItemInfoCell];
    [self initializePriceCell];
    [self initializeLocationCell];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initializeCategoryCell
//------------------------------------------------------------------------------------------------------------------------------
{
    _categoryCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"category"];
    _categoryCell.textLabel.text = NSLocalizedString(@"Category", nil);
    _categoryCell.textLabel.textColor = TEXT_COLOR_DARK_GRAY;
    _categoryCell.textLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALL_FONT_SIZE];
    _categoryCell.indentationLevel = 3;
    _categoryCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _categoryCell.detailTextLabel.text = NSLocalizedString(@"Choose category", nil);
    _categoryCell.detailTextLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:15];
    
    // add category icon
    UIImageView *catImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kIconLeftMargin, kIconTopMargin, kIconWidth, kIconHeight)];
    UIImage *catImage = [UIImage imageNamed:@"category_icon.png"];
    [catImageView setImage:catImage];
    [_categoryCell addSubview:catImageView];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initializeItemInfoCell
//------------------------------------------------------------------------------------------------------------------------------
{
    _itemInfoCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"item info"];
    _itemInfoCell.textLabel.text = NSLocalizedString(@"Item info", nil);
    _itemInfoCell.textLabel.textColor = TEXT_COLOR_DARK_GRAY;
    _itemInfoCell.textLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALL_FONT_SIZE];
    _itemInfoCell.indentationLevel = 3;
    _itemInfoCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _itemInfoCell.detailTextLabel.text = NSLocalizedString(@"What are you buying?", nil);
    _itemInfoCell.detailTextLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:15];
    
    // add info icon
    UIImageView *infoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kIconLeftMargin, kIconTopMargin, kIconWidth, kIconHeight)];
    UIImage *infoImage = [UIImage imageNamed:@"info_icon.png"];
    [infoImageView setImage:infoImage];
    [_itemInfoCell addSubview:infoImageView];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initializePriceCell
//------------------------------------------------------------------------------------------------------------------------------
{
    _priceCell = [[UITableViewCell alloc] init];
    _priceCell.textLabel.text = NSLocalizedString(@"Your price", nil);
    _priceCell.textLabel.textColor = TEXT_COLOR_DARK_GRAY;
    _priceCell.textLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALL_FONT_SIZE];
    _priceCell.indentationLevel = 3;
    _priceTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width * 0.55, 30)];
    [_priceTextField setTextAlignment:NSTextAlignmentRight];
    _priceTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Set a price", nil) attributes:@{NSForegroundColorAttributeName: GRAY_COLOR_WITH_WHITE_COLOR_8, NSFontAttributeName: [UIFont fontWithName:SEMIBOLD_FONT_NAME size:15]}];
    _priceTextField.delegate = self;
    _priceTextField.tag = 102;
    _priceTextField.inputView = ({
        APNumberPad *numberPad = [APNumberPad numberPadWithDelegate:self];
        // configure function button
        [numberPad.leftFunctionButton setTitle:DOT_CHARACTER forState:UIControlStateNormal];
        numberPad.leftFunctionButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        numberPad;
    });
    [_priceTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [_priceTextField addTarget:self action:@selector(priceTextFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    _priceCell.accessoryView = _priceTextField;
    _priceCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // add price tag icon
    UIImageView *priceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kIconLeftMargin, kIconTopMargin, kIconWidth, kIconHeight)];
    UIImage *priceImage = [UIImage imageNamed:@"pricetag_icon.png"];
    [priceImageView setImage:priceImage];
    [_priceCell addSubview:priceImageView];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initializeLocationCell
//------------------------------------------------------------------------------------------------------------------------------
{
    _locationCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"location"];
    _locationCell.textLabel.text = NSLocalizedString(@"Location", nil);
    _locationCell.textLabel.textColor = TEXT_COLOR_DARK_GRAY;
    _locationCell.textLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:SMALL_FONT_SIZE];
    _locationCell.indentationLevel = 3;
    _locationCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _locationCell.detailTextLabel.text = NSLocalizedString(@"Where to meet?", nil);
    _locationCell.detailTextLabel.font = [UIFont fontWithName:SEMIBOLD_FONT_NAME size:15];
    
    // add location icon
    UIImageView *locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kIconLeftMargin, kIconTopMargin, kIconWidth, kIconHeight)];
    UIImage *locationImage = [UIImage imageNamed:@"location_icon.png"];
    [locationImageView setImage:locationImage];
    [_locationCell addSubview:locationImageView];
}

/*
//------------------------------------------------------------------------------------------------------------------------------
- (void) initializeEscrowRequestCell
//------------------------------------------------------------------------------------------------------------------------------
{
    _escrowRequestCell = [[UITableViewCell alloc] init];
    _escrowRequestCell.textLabel.text = NSLocalizedString(@"Request for Escrow", nil);
    _escrowRequestCell.textLabel.textColor = TEXT_COLOR_DARK_GRAY;
    _escrowRequestCell.textLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    _escrowRequestCell.indentationLevel = 3;
    _escrowSwitch = [[UISwitch alloc] init];
    [_escrowSwitch addTarget:self action:@selector(escrowSwitchDidChangeState) forControlEvents:UIControlEventValueChanged];
    _escrowRequestCell.accessoryView = _escrowSwitch;
    _escrowRequestCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // add payment icon
    UIImageView *paymentImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kIconLeftMargin, kIconTopMargin, kIconWidth, kIconHeight)];
    UIImage *paymentImage = [UIImage imageNamed:@"payment_method_icon.png"];
    [paymentImageView setImage:paymentImage];
    [_escrowRequestCell addSubview:paymentImageView];
}
 */

//------------------------------------------------------------------------------------------------------------------------------
- (void) populateData
//------------------------------------------------------------------------------------------------------------------------------
{
    if (_wantData.itemPictures.count > 0)
    {
        for (int i=0; i<_wantData.itemPictures.count; i++)
        {
            PFFile *imageFile = [_wantData.itemPictures objectAtIndex:i][PF_ITEM_PICTURE];
            [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                UIImage *image = [UIImage imageWithData:data];
                [[_addingButtonList objectAtIndex:i] setImage: image];
            }];
        }
    }
    
    if (_wantData.itemCategory.length > 0)
        _categoryCell.detailTextLabel.text = _wantData.itemCategory;
    
    if (_wantData.itemName.length > 0)
        _itemInfoCell.detailTextLabel.text = _wantData.itemName;
    
    if (_wantData.demandedPrice.length > 0)
        _priceTextField.text = _wantData.demandedPrice;
    
    if (_wantData.meetingLocation.length > 0)
        _locationCell.detailTextLabel.text = _wantData.meetingLocation;
    
//    if ([_wantData.paymentMethod isEqualToString:PAYMENT_METHOD_ESCROW])
//        _escrowSwitch.on = YES;
}


#pragma mark - Event Handlers

//------------------------------------------------------------------------------------------------------------------------------
- (void) addingImageButtonEvent: (id) sender
//------------------------------------------------------------------------------------------------------------------------------
{
    UIGestureRecognizer *tapGesRec = (UIGestureRecognizer *) sender;
    _prevTappedButtonIndex = tapGesRec.view.tag;
    _imageEdittingNeeded = YES;
    
    ImageGetterViewController *imageGetterVC = [[ImageGetterViewController alloc] init];
    imageGetterVC.delegate = self;
    
    _popup = [KLCPopup popupWithContentViewController:imageGetterVC];
    [_popup show];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) submittingButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    [Utilities sendEventToGoogleAnalyticsTrackerWithEventCategory:UI_ACTION action:@"UploadNewWhuntEvent" label:@"SubmitButton" value:nil];
    
    UIAlertView *submissionAlertView;
    if (_wantData.itemCategory == nil)
    {
        submissionAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Oops!", nil) message:NSLocalizedString(@"Please choose a category", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [submissionAlertView show];
    }
    else if (_wantData.itemName == nil || [_wantData.itemName length] == 0)
    {
        submissionAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Oops!", nil) message:NSLocalizedString(@"Please fill in item name", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [submissionAlertView show];
    }
    else if (_wantData.demandedPrice == nil || [_wantData.demandedPrice length] == 0)
    {
        submissionAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Oops!", nil) message:NSLocalizedString(@"Please state a price", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [submissionAlertView show];
    }
    else
    {
        [Utilities showStandardIndeterminateProgressIndicatorInView:self.view];
        
        if (!_wantData.itemDesc)
            _wantData.itemDesc = @"";
        
        if (!_wantData.hashTagList)
            _wantData.hashTagList = [NSArray array];
        
        if (!_wantData.referenceURL)
            _wantData.referenceURL = @"";
        
        if (!_wantData.demandedPrice)
            _wantData.demandedPrice = @"0";

//        if (!_wantData.paymentMethod)
//            _wantData.paymentMethod = @"non-escrow";
        
        if (!_wantData.meetingLocation)
            _wantData.meetingLocation = @"";
        
        if (!_wantData.itemOrigins)
            _wantData.itemOrigins = [NSArray array];
        
        _wantData.sellersNum = 0;
        _wantData.itemPicturesNum = [_wantData.itemPictures count];
        
        PFObject *pfObj = [_wantData getPFObject];
        [pfObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
        {
            if (succeeded)
            {
                [self.delegate uploadingWantDetailsViewController:self didCompleteSubmittingWantData:_wantData];
            }
            else
            {
                [Utilities handleError:error];
            }
            
            [Utilities hideIndeterminateProgressIndicatorInView:self.view];
        }];
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) topCancelButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    if (_isEditing)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Are you sure you want to discard your changes?", nil) message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Yes, I'm sure!", nil), nil];
        [alertView show];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Are you sure you want to cancel your listing?", nil) message:@"" delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Yes, I'm sure!", nil), nil];
        [alertView show];
    }
}

/*
 * 1. Update whunt data on server  2. Call delegate (ItemDetailsVC) to update its UI
 */

//---------------------------------------------------------------------------------------------------------------------------
- (void) completeEditingWantData
//---------------------------------------------------------------------------------------------------------------------------
{
    [Utilities sendEventToGoogleAnalyticsTrackerWithEventCategory:UI_ACTION action:@"CompleteEditingWhuntEvent" label:@"DoneButton" value:nil];
    
    UIAlertView *submissionAlertView;
    if (_wantData.itemCategory == nil)
    {
        submissionAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Oops", nil) message:NSLocalizedString(@"Please choose a category!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [submissionAlertView show];
    }
    else if (_wantData.itemName == nil || [_wantData.itemName length] == 0)
    {
        submissionAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Oops", nil) message:NSLocalizedString(@"Please fill in item name!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [submissionAlertView show];
    }
    else if (_wantData.demandedPrice == nil || [_wantData.demandedPrice length] == 0)
    {
        submissionAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Oops", nil) message:NSLocalizedString(@"Please state a price!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles: nil];
        [submissionAlertView show];
    }
    else
    {
        [Utilities showStandardIndeterminateProgressIndicatorInView:self.view];
        
        if (!_wantData.itemDesc)
            _wantData.itemDesc = @"";
        
        if (!_wantData.hashTagList)
            _wantData.hashTagList = [NSArray array];
        
        if (!_wantData.referenceURL)
            _wantData.referenceURL = @"";
        
        if (!_wantData.demandedPrice)
            _wantData.demandedPrice = @"0";
        
//        if (!_wantData.paymentMethod)
//            _wantData.paymentMethod = @"non-escrow";
        
        if (!_wantData.meetingLocation)
            _wantData.meetingLocation = @"";
        
        if (!_wantData.itemOrigins)
            _wantData.itemOrigins = [NSArray array];
        
        _wantData.itemPicturesNum = [_wantData.itemPictures count];
        
        PFObject *pfObj = [_wantData getPFObject];
        [pfObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
        {
            if (error)
            {
                [Utilities handleError:error];
            }
            else
            {
                [Utilities hideIndeterminateProgressIndicatorInView:self.view];
                
                [_delegate completeEditingWantData];
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_WHUNT_DETAILS_EDITED_EVENT object:_wantData];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) didFinishEditingPrice
//------------------------------------------------------------------------------------------------------------------------------
{
    [self normalizePriceText];
    
    _wantData.demandedPrice = _priceTextField.text;
    [_priceTextField resignFirstResponder];
    
    if (_isEditing)
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStylePlain target:self action:@selector(completeEditingWantData)];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Submit", nil) style:UIBarButtonItemStylePlain target:self action:@selector(submittingButtonTapEventHandler)];
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) normalizePriceText
//------------------------------------------------------------------------------------------------------------------------------
{
    if ([_priceTextField.text isEqualToString:TAIWAN_CURRENCY])
    {
        _priceTextField.text = [_priceTextField.text stringByAppendingString:@"0"];
    }
}


/*
//------------------------------------------------------------------------------------------------------------------------------
- (void) escrowSwitchDidChangeState
//------------------------------------------------------------------------------------------------------------------------------
{
    BOOL state = [_escrowSwitch isOn];
    if (state)
    {
        _wantData.paymentMethod = PAYMENT_METHOD_ESCROW;
    }
    else
    {
        _wantData.paymentMethod = PAYMENT_METHOD_NON_ESCROW;
    }
}*/

//-------------------------------------------------------------------------------------------------------------------------------
- (void) editorTopCancelButtonTapEventHandler
//-------------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController popToViewController:self animated:YES];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) pushCategoryViewController
//-------------------------------------------------------------------------------------------------------------------------------
{
    CategoryTableViewController *catVC = [[CategoryTableViewController alloc] initWithCategory:_wantData.itemCategory usedForFiltering:NO];
    catVC.delegte = self;
    [self.navigationController pushViewController:catVC animated:YES];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) pushItemInfoViewController
//-------------------------------------------------------------------------------------------------------------------------------
{
    _hashtagString = [_wantData.hashTagList componentsJoinedByString:WHITE_SPACE_CHARACTER];
    
    NSMutableDictionary *itemBasicInfoDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:_wantData.itemName, ITEM_NAME_KEY, _wantData.itemDesc, ITEM_DESC_KEY, _wantData.referenceURL, ITEM_REFERENCE_LINK, [NSNumber numberWithBool:_wantData.acceptedSecondHand], ITEM_SECONDHAND_OPTION, _hashtagString, ITEM_HASH_TAG_KEY, nil];
    
    if (_wantData.itemOrigins.count > 0)
        [itemBasicInfoDict setObject:_wantData.itemOrigins forKey:ITEM_ORIGINS_KEY];
    
    ItemInfoTableViewController *itemInfoVC = [[ItemInfoTableViewController alloc] initWithItemInfoDict:itemBasicInfoDict];
    itemInfoVC.delegate = self;
    [self.navigationController pushViewController:itemInfoVC animated:YES];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) pushMeetingLocationViewController
//-------------------------------------------------------------------------------------------------------------------------------
{
    CityViewController *meetingLocationVC = [[CityViewController alloc] init];
    meetingLocationVC.labelText = NSLocalizedString(@"Meeting location:", nil);
    meetingLocationVC.currentLocation = _wantData.meetingLocation;
    meetingLocationVC.viewTitle = NSLocalizedString(@"Location", nil);
    meetingLocationVC.usedForFiltering = NO;
    meetingLocationVC.delegate = self;
    
    [self.navigationController pushViewController:meetingLocationVC animated:YES];
}


#pragma mark - Set image for button

//------------------------------------------------------------------------------------------------------------------------------
- (void) setImage:(UIImage *)image forButton:(NSUInteger)buttonIndex
//------------------------------------------------------------------------------------------------------------------------------
{
    UIButton *button = [_addingButtonList objectAtIndex:buttonIndex];
    [Utilities showSmallIndeterminateProgressIndicatorInView:button];
    
    [[_addingButtonList objectAtIndex: buttonIndex] setImage: image];
    
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    PFFile *imageFile = [PFFile fileWithName:[NSString stringWithFormat:@"%@.jpg", _wantData.buyerID] data:data];
    
    // Did supporting changing image
    PFObject *itemPictureObj = [PFObject objectWithClassName:@"ItemPicture"];
    itemPictureObj[@"itemPicture"] = imageFile;
    
    if (_wantData.itemPictures.count >= buttonIndex + 1) // replace one photo by another
    {
        PFObject *replacedObj = [_wantData.itemPictures objectAtIndex:buttonIndex];
        itemPictureObj.objectId = replacedObj.objectId;
    }
    
    [itemPictureObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if (succeeded)
        {
            if (buttonIndex + 1 > _wantData.itemPictures.count)
                [_wantData.itemPictures addObject:itemPictureObj];
            else
                [_wantData.itemPictures replaceObjectAtIndex:buttonIndex withObject:itemPictureObj];
        }
        else
        {
            [Utilities handleError:error];
        }
        
        UIButton *button = [_addingButtonList objectAtIndex:buttonIndex];
        [Utilities hideIndeterminateProgressIndicatorInView:button];
    }];
}


#pragma mark - UITableViewDataSouce methods

//------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//------------------------------------------------------------------------------------------------------------------------------
{
    return 3;
}

//------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    switch(section)
    {
        case 0: return 0;
        case 1:  return 1;
        case 2:  return 4;  
        default: return 0;
    };
}

//------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    switch(indexPath.section)
    {
        case 0: return nil;
        case 1:
            return _buttonListCell;
        case 2:
            switch(indexPath.row)
            {
                case 0: return _categoryCell;
                case 1: return _itemInfoCell;
                case 2: return _priceCell;
                case 3: return _locationCell;
//                case 4: return _escrowRequestCell;
            }
    }
    return nil;
}


#pragma mark - UITableViewDelegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    switch (indexPath.section) {
        case 0:
            return 0;
        case 1:
            return 80.0f;
        case 2:
            return kCellHeight;
            
        default:
            return kCellHeight;
            break;
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    switch(section)
    {
        case 1: return @" ";
    }
    return nil;
}

//------------------------------------------------------------------------------------------------------------------------------
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    switch(section)
    {
        case 1: return NSLocalizedString(@"Details", nil);
    }
    return nil;
}

//------------------------------------------------------------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    switch(section)
    {
        case 0: return 0.0f;
        case 1: return 10.0f;
    }
    return 0.0f;
}

//------------------------------------------------------------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    switch(section)
    {
        case 0: return 0.0f;
        case 1: return 40.0f;
        case 2:
            return 10.0f;
    }
    return 0.0f;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    view.tintColor = [UIColor clearColor];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    view.tintColor = [UIColor clearColor];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
            [self pushCategoryViewController];
        else if (indexPath.row == 1)
            [self pushItemInfoViewController];
        else if (indexPath.row == 3)
            [self pushMeetingLocationViewController];
    }
    
    // stop editing price
    if (indexPath.section != 3)
    {
        [_priceTextField resignFirstResponder];
        if ([[self.navigationItem.rightBarButtonItem title] isEqualToString:NSLocalizedString(@"Done", nil)])
        {
            _wantData.demandedPrice = _priceTextField.text;
            
            if (_isEditing)
            {
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStylePlain target:self action:@selector(completeEditingWantData)];
            }
            else
            {
                self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Submit", nil) style:UIBarButtonItemStylePlain target:self action:@selector(submittingButtonTapEventHandler)];
            }
        }
    }
}


#pragma mark - CategoryTableViewControllerDelegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (void) categoryTableView:(CategoryTableViewController *)controller didSelectCategory:(NSString *)category
//------------------------------------------------------------------------------------------------------------------------------
{
    _wantData.itemCategory = category;;
    _categoryCell.detailTextLabel.text = _wantData.itemCategory;
}


#pragma mark - CityViewDelegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (void) cityView:(CityViewController *)controller didSpecifyLocation:(NSString *)location
//------------------------------------------------------------------------------------------------------------------------------
{
    _wantData.meetingLocation = location;
    
    if (location.length > 0)
        _locationCell.detailTextLabel.text = location;
    else
        _locationCell.detailTextLabel.text = NSLocalizedString(@"Where to meet?", nil);
}


#pragma mark - ItemInfoTableViewControllerDelegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (void) itemInfoTableViewController:(ItemInfoTableViewController *)controller didPressDone:(NSDictionary *)itemInfo
//------------------------------------------------------------------------------------------------------------------------------
{
    _wantData.itemName              =   [itemInfo objectForKey:ITEM_NAME_KEY];
    _wantData.itemDesc              =   [itemInfo objectForKey:ITEM_DESC_KEY];
    _wantData.acceptedSecondHand    =   [(NSNumber *)[itemInfo objectForKey:ITEM_SECONDHAND_OPTION] boolValue];
    _wantData.referenceURL          =   [itemInfo objectForKey:ITEM_REFERENCE_LINK];
    
    if ([[itemInfo allKeys] containsObject:ITEM_ORIGINS_KEY])
        _wantData.itemOrigins = [itemInfo objectForKey:ITEM_ORIGINS_KEY];
    
    _hashtagString = [itemInfo objectForKey:ITEM_HASH_TAG_KEY];
    if (_hashtagString.length > 0)
        _wantData.hashTagList = [_hashtagString componentsSeparatedByString:WHITE_SPACE_CHARACTER];
    
    NSString *itemName = [itemInfo objectForKey:ITEM_NAME_KEY];
    if (itemName != nil && itemName.length > 0)
    {
        _itemInfoCell.detailTextLabel.text = itemName;
    }
    else
    {
        _itemInfoCell.detailTextLabel.text = NSLocalizedString(@"What are you buying?", nil);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITextFieldDelegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (void) textFieldDidBeginEditing:(UITextField *)textField
//------------------------------------------------------------------------------------------------------------------------------
{
    if (textField.tag == 102)
    {
        if ([textField.text length] == 0)
        {
            NSString *text = [TAIWAN_CURRENCY stringByAppendingString:textField.text];
            textField.text = text;
        }
    }

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStylePlain target:self action:@selector(didFinishEditingPrice)];
}

//------------------------------------------------------------------------------------------------------------------------------
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//------------------------------------------------------------------------------------------------------------------------------
{
    if (textField.tag == 102)
    {
        if (range.location >= [TAIWAN_CURRENCY length])
        {
            NSString *resultantString = [Utilities getResultantStringFromText:textField.text andRange:range andReplacementString:string];
            return [Utilities checkIfIsValidPrice:resultantString];
        }
        else
            return NO;
    }
    else
    {
        return YES;
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) textFieldDidEndEditing:(UITextField *)textField
//------------------------------------------------------------------------------------------------------------------------------
{
    if (textField.tag == 102)
    {
        NSString *text = [Utilities removeLastDotCharacterIfNeeded:textField.text];
        [textField setText:text];
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) priceTextFieldDidChange
//------------------------------------------------------------------------------------------------------------------------------
{
    [_priceTextField setText:[Utilities formatPriceText:_priceTextField.text]];
}


#pragma mark - UIAlertViewDelegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
//------------------------------------------------------------------------------------------------------------------------------
{
    if (buttonIndex == 1)
    {
        if (_isEditing)
        {
            [Utilities sendEventToGoogleAnalyticsTrackerWithEventCategory:UI_ACTION action:@"CancelEditingWhuntEvent" label:@"CancelButton" value:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [Utilities sendEventToGoogleAnalyticsTrackerWithEventCategory:UI_ACTION action:@"CancelPostingNewWhunt" label:@"CancelButton" value:nil];
            
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        }
    }
}


#pragma mark - APNumberPad

//------------------------------------------------------------------------------------------------------------------------------
- (void)numberPad:(APNumberPad *)numberPad functionButtonAction:(UIButton *)functionButton textInput:(UIResponder<UITextInput> *)textInput
//------------------------------------------------------------------------------------------------------------------------------
{
    NSRange range = {[[_priceTextField text] length], 1};
    if ([self textField:_priceTextField shouldChangeCharactersInRange:range replacementString:DOT_CHARACTER])
        [textInput insertText:DOT_CHARACTER];
}


#pragma mark - ImageGetterViewControllerDelegate

//------------------------------------------------------------------------------------------------------------------------------
- (void) imageGetterViewController:(ImageGetterViewController *)controller didChooseAMethod:(ImageGettingMethod)method
//-------------------------------------------------------------------------------------------------------------------------------
{
    if (_popup != nil)
    {
        [_popup dismiss:YES];
    }
    
    if (method == PhotoLibrary)
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:nil];
    }
    else if (method == Camera)
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:nil];
    }
    else if (method == ImageURL)
    {
        ImageRetrieverViewController *retrieverVC = [[ImageRetrieverViewController alloc] init];
        retrieverVC.delegate = self;
        
        [self.navigationController pushViewController:retrieverVC animated:YES];
    }
}


#pragma mark - ImagePickerControllerDelegate methods

//-------------------------------------------------------------------------------------------------------------------------------
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
//-------------------------------------------------------------------------------------------------------------------------------
{
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    // crop tool
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:chosenImage cropMode:RSKImageCropModeSquare];
    imageCropVC.cropMode = RSKImageCropModeCustom;
    imageCropVC.dataSource = self;
    imageCropVC.delegate = self;
    [self.navigationController pushViewController:imageCropVC animated:NO];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//-------------------------------------------------------------------------------------------------------------------------------
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - ImageRetrieverDelegate methods

//-------------------------------------------------------------------------------------------------------------------------------
- (void) imageRetrieverViewController:(ImageRetrieverViewController *)controller didRetrieveImage:(UIImage *)image needEditing: (BOOL) editingNeeded
//-------------------------------------------------------------------------------------------------------------------------------
{  
    _imageEdittingNeeded = editingNeeded;
    
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image cropMode:RSKImageCropModeSquare];
    imageCropVC.cropMode = RSKImageCropModeCustom;
    imageCropVC.dataSource = self;
    imageCropVC.delegate = self;
    
    [self.navigationController pushViewController:imageCropVC animated:YES];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) imageRetrieverViewControllerDidCancel
//-------------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController popToViewController:self animated:YES];
}


#pragma mark - CLImageEditorDelegate methods

//-------------------------------------------------------------------------------------------------------------------------------
- (void) imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image
//-------------------------------------------------------------------------------------------------------------------------------
{
    [self addItemImageToWantDetailVC:image];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addItemImageToWantDetailVC: (UIImage *) image
//-------------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController popToViewController:self animated:YES];
    
    [self setImage:image forButton:_prevTappedButtonIndex];
}


#pragma mark - RSKImageCropViewControllerDataSource methods

// cropt non-square images to squared images
//-------------------------------------------------------------------------------------------------------------------------------
- (CGRect)imageCropViewControllerCustomMaskRect:(RSKImageCropViewController *)controller
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGRect maskRect = CGRectMake(0,
                                 (WINSIZE.height - WINSIZE.width) * 0.5f,
                                 WINSIZE.width,
                                 WINSIZE.width);
    
    return maskRect;
}

// Returns a custom path for the mask.
//-------------------------------------------------------------------------------------------------------------------------------
- (UIBezierPath *)imageCropViewControllerCustomMaskPath:(RSKImageCropViewController *)controller
//-------------------------------------------------------------------------------------------------------------------------------
{
    CGRect rect = controller.maskRect;
    CGPoint point1 = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGPoint point2 = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGPoint point3 = CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect));
    CGPoint point4 = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
    
    UIBezierPath *rectangle = [UIBezierPath bezierPath];
    [rectangle moveToPoint:point1];
    [rectangle addLineToPoint:point2];
    [rectangle addLineToPoint:point3];
    [rectangle addLineToPoint:point4];
    [rectangle closePath];
    
    return rectangle;
}

// Returns a custom rect in which the image can be moved.
//-------------------------------------------------------------------------------------------------------------------------------
- (CGRect)imageCropViewControllerCustomMovementRect:(RSKImageCropViewController *)controller
//-------------------------------------------------------------------------------------------------------------------------------
{
    // If the image is not rotated, then the movement rect coincides with the mask rect.
    return controller.maskRect;
}


#pragma mark - RSKImageCropViewControllerDelegate methods

// Crop image has been canceled.
//-------------------------------------------------------------------------------------------------------------------------------
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
//-------------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController popToViewController:self animated:YES];
}

// The original image has been cropped.
//-------------------------------------------------------------------------------------------------------------------------------
- (void)imageCropViewController:(RSKImageCropViewController *)controller
                   didCropImage:(UIImage *)croppedImage
                  usingCropRect:(CGRect)cropRect
//-------------------------------------------------------------------------------------------------------------------------------
{
    UIImage *resizedImage = [Utilities resizeImage:croppedImage toSize:CGSizeMake(IPHONE_6_PLUS_WIDTH, IPHONE_6_PLUS_WIDTH) scalingProportionally:YES];
    
    if (_imageEdittingNeeded) {
        CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:resizedImage];
        editor.delegate = self;
        editor.hidesBottomBarWhenPushed = YES;
        
        editor.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(editorTopCancelButtonTapEventHandler)];
        
        [self.navigationController pushViewController:editor animated:YES];
    } else {
        [self addItemImageToWantDetailVC:resizedImage];
    }
    
}

@end
