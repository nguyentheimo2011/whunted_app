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

@implementation UploadingWantDetailsViewController
{
    UITableViewCell             *_buttonListCell;
    UITableViewCell             *_categoryCell;
    UITableViewCell             *_itemInfoCell;
    UITableViewCell             *_productOriginCell;
    UITableViewCell             *_priceCell;
    UITableViewCell             *_locationCell;
    UITableViewCell             *_escrowRequestCell;
    
    UITextField                 *_priceTextField;
    UISwitch                    *_escrowSwitch;
    KLCPopup                    *_popup;
    
    WantData                    *_wantData;
    
    NSMutableArray              *_addingButtonList;
    
    NSString                    *_hashtagString;
}

//------------------------------------------------------------------------------------------------------------------------------
- (id) init
//------------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    
    if (self != nil) {
        [self customizeUI];
        [self initializeButtonListCell];
        [self initializeSecondSection];
        [self initData];
    }
    
    return self;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initData
//------------------------------------------------------------------------------------------------------------------------------
{
    _wantData = [[WantData alloc] init];
    _wantData.buyer = [PFUser currentUser];
    _wantData.itemPictureList = [[PFRelation alloc] init];
    _wantData.backupItemPictureList = [[NSMutableArray alloc] init];
}

#pragma mark - UI Handlers

//------------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI
//------------------------------------------------------------------------------------------------------------------------------
{
    self.view.backgroundColor = LIGHTEST_GRAY_COLOR;
    
    // hide bottom bar when uploading a new want
    self.hidesBottomBarWhenPushed = YES;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Submit", nil) style:UIBarButtonItemStylePlain target:self action:@selector(submittingButtonEvent)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStylePlain target:self action:@selector(topCancelButtonTapEventHandler)];
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
        UIButton *addingButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        addingButton.tag = i;
        [addingButton setBackgroundImage:[UIImage imageNamed:@"squareplus.png"] forState:UIControlStateNormal];
        [addingButton setEnabled:YES];
        addingButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        addingButton.frame = CGRectMake((i+1) * spaceWidth + i * imageSize.width, imageSize.width/6.0, imageSize.width, imageSize.height);
        [addingButton addTarget:self action:@selector(addingImageButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
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
    [self initializeProductOriginCell];
    [self initializePriceCell];
    [self initializeLocationCell];
    [self initializeEscrowRequestCell];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initializeCategoryCell
//------------------------------------------------------------------------------------------------------------------------------
{
    _categoryCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"category"];
    _categoryCell.textLabel.text = NSLocalizedString(@"Category", nil);
    _categoryCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _categoryCell.detailTextLabel.text = NSLocalizedString(@"Choose category", nil);
    _categoryCell.detailTextLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:15];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initializeItemInfoCell
//------------------------------------------------------------------------------------------------------------------------------
{
    _itemInfoCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"item info"];
    _itemInfoCell.textLabel.text = NSLocalizedString(@"Item info", nil);
    _itemInfoCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _itemInfoCell.detailTextLabel.text = NSLocalizedString(@"What are you buying?", nil);
    _itemInfoCell.detailTextLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:15];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initializeProductOriginCell
//------------------------------------------------------------------------------------------------------------------------------
{
    _productOriginCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"productOrigin"];
    _productOriginCell.textLabel.text = NSLocalizedString(@"Product origin", nil);
    _productOriginCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _productOriginCell.detailTextLabel.text = NSLocalizedString(@"Choose origin", nil);
    _productOriginCell.detailTextLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:15];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initializePriceCell
//------------------------------------------------------------------------------------------------------------------------------
{
    _priceCell = [[UITableViewCell alloc] init];
    _priceCell.textLabel.text = NSLocalizedString(@"Your price", nil);
    _priceTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width * 0.55, 30)];
    [_priceTextField setTextAlignment:NSTextAlignmentRight];
    UIColor *color = [UIColor colorWithRed:123/255.0 green:123/255.0 blue:129/255.0 alpha:1];
    _priceTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Set a price", nil) attributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName: [UIFont fontWithName:REGULAR_FONT_NAME size:15]}];
    _priceTextField.delegate = self;
    _priceTextField.tag = 102;
    _priceTextField.inputView = ({
        APNumberPad *numberPad = [APNumberPad numberPadWithDelegate:self];
        // configure function button
        //
        [numberPad.leftFunctionButton setTitle:DOT_CHARACTER forState:UIControlStateNormal];
        numberPad.leftFunctionButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        numberPad;
    });
    [_priceTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [_priceTextField addTarget:self action:@selector(priceTextFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    _priceCell.accessoryView = _priceTextField;
    _priceCell.selectionStyle = UITableViewCellSelectionStyleNone;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initializeLocationCell
//------------------------------------------------------------------------------------------------------------------------------
{
    _locationCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"location"];
    _locationCell.textLabel.text = NSLocalizedString(@"Location", nil);
    _locationCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    _locationCell.detailTextLabel.text = NSLocalizedString(@"Where to meet?", nil);
    _locationCell.detailTextLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:15];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initializeEscrowRequestCell
//------------------------------------------------------------------------------------------------------------------------------
{
    _escrowRequestCell = [[UITableViewCell alloc] init];
    _escrowRequestCell.textLabel.text = NSLocalizedString(@"Request for Escrow", nil);
    _escrowSwitch = [[UISwitch alloc] init];
    [_escrowSwitch addTarget:self action:@selector(escrowSwitchDidChangeState) forControlEvents:UIControlEventValueChanged];
    _escrowRequestCell.accessoryView = _escrowSwitch;
    _escrowRequestCell.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - Event Handlers

//------------------------------------------------------------------------------------------------------------------------------
- (void) addingImageButtonEvent: (id) sender
//------------------------------------------------------------------------------------------------------------------------------
{
    UIButton *button = (UIButton *) sender;
    
    ImageGetterViewController *imageGetterVC = [[ImageGetterViewController alloc] init];
    imageGetterVC.delegate = self;
    
    _popup = [KLCPopup popupWithContentViewController:imageGetterVC];
    [_popup show];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) submittingButtonEvent
//------------------------------------------------------------------------------------------------------------------------------
{
    UIAlertView *submissionAlertView;
    if (_wantData.itemCategory == nil) {
        submissionAlertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Please choose a category!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [submissionAlertView show];
    } else if (_wantData.itemName == nil || [_wantData.itemName length] == 0) {
        submissionAlertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Please fill in item name!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [submissionAlertView show];
    } else if (_wantData.demandedPrice == nil || [_wantData.demandedPrice length] == 0) {
        submissionAlertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Please state a price!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [submissionAlertView show];
    } else {
        if (!_wantData.itemDesc)
            _wantData.itemDesc = @"";
        if (!_wantData.hashTagList)
            _wantData.hashTagList = [NSArray array];
        if (!_wantData.demandedPrice)
            _wantData.demandedPrice = @"0";
        if (!_wantData.paymentMethod)
            _wantData.paymentMethod = @"non-escrow";
        if (!_wantData.meetingLocation)
            _wantData.meetingLocation = @"";
        
        _wantData.sellersNum = 0;
        _wantData.itemPicturesNum = [_wantData.backupItemPictureList count];
        
        PFObject *pfObj = [_wantData getPFObject];
        [pfObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [self.delegate uploadingWantDetailsViewController:self didCompleteSubmittingWantData:_wantData];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) topCancelButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to cancel your listing?" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes, I'm sure!", nil];
    [alertView show];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) didFinishEditingPrice
//------------------------------------------------------------------------------------------------------------------------------
{
    _wantData.demandedPrice = _priceTextField.text;
    [_priceTextField resignFirstResponder];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(submittingButtonEvent)];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) escrowSwitchDidChangeState
//------------------------------------------------------------------------------------------------------------------------------
{
    BOOL state = [_escrowSwitch isOn];
    if (state) {
        _wantData.paymentMethod = @"escrow";
    } else {
        _wantData.paymentMethod = @"non-escrow";
    }
}


#pragma mark - Set image for button

//------------------------------------------------------------------------------------------------------------------------------
- (void) setImage:(UIImage *)image forButton:(NSUInteger)buttonIndex
//------------------------------------------------------------------------------------------------------------------------------
{
    [[_addingButtonList objectAtIndex: buttonIndex] setBackgroundImage:image forState:UIControlStateNormal];
    
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    PFFile *imageFile = [PFFile fileWithName:[NSString stringWithFormat:@"%@.jpg", _wantData.buyer.objectId] data:data];
    
    // Temporary code. Not handle changing image yet
    PFObject *itemPictureObj = [PFObject objectWithClassName:@"ItemPicture"];
    itemPictureObj[@"itemPicture"] = imageFile;
    [itemPictureObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (succeeded) {
            [_wantData.itemPictureList addObject:itemPictureObj];
            [_wantData.backupItemPictureList addObject:itemPictureObj];
        } else {
            NSLog(@"Error %@ %@", error, [error userInfo]);
        }
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
        case 0: return 0;   // section 0 has 0 row. Use footer of section i as the header of section i+1
        case 1:  return 1;  // section 0 has 1 row
        case 2:  return 6;  // section 1 has 6 rows
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
                case 2: return _productOriginCell;
                case 3: return _priceCell;
                case 4: return _locationCell;
                case 5: return _escrowRequestCell;
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
            return 40;
            
        default:
            return 40;
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
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            CategoryTableViewController *catVC = [[CategoryTableViewController alloc] init];
            catVC.delegte = self;
            catVC.category = _wantData.itemCategory;
            [self.navigationController pushViewController:catVC animated:YES];
        } else if (indexPath.row == 1) {
            NSDictionary *itemBasicInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:_wantData.itemName, ITEM_NAME_KEY, _wantData.itemDesc, ITEM_DESC_KEY, _hashtagString, ITEM_HASH_TAG_KEY, [NSNumber numberWithBool:_wantData.secondHandOption], ITEM_SECONDHAND_OPTION, nil];
            ItemInfoTableViewController *itemInfoVC = [[ItemInfoTableViewController alloc] initWithItemInfoDict:itemBasicInfoDict];
            itemInfoVC.delegate = self;
            [self.navigationController pushViewController:itemInfoVC animated:YES];
        } else if (indexPath.row == 2) {
            CountryTableViewController *productTableVC = [[CountryTableViewController alloc] initWithSelectedCountries:_wantData.productOriginList];
            productTableVC.delegate = self;
            [self.navigationController pushViewController:productTableVC animated:YES];
        } else if (indexPath.row == 4) {
            LocationTableViewController *locVC = [[LocationTableViewController alloc] init];
            locVC.delegate = self;
            locVC.location = _wantData.meetingLocation;
            [self.navigationController pushViewController:locVC animated:YES];
        }
    }
    
    if (indexPath.section != 2 || (indexPath.row != 2 && indexPath.row != 3)) {
        [_priceTextField resignFirstResponder];
        if ([[self.navigationItem.rightBarButtonItem title] isEqualToString:NSLocalizedString(@"Done", nil)]) {
            _wantData.demandedPrice = _priceTextField.text;
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Submit", nil) style:UIBarButtonItemStylePlain target:self action:@selector(submittingButtonEvent)];
        }
    }
}


#pragma mark - CategoryTableViewControllerDelegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (void) categoryTableViewController:(CategoryTableViewController *)controller didSelectCategory:(NSString *)category
//------------------------------------------------------------------------------------------------------------------------------
{
    _wantData.itemCategory = category;;
    [self.navigationController popViewControllerAnimated:YES];
    _categoryCell.detailTextLabel.text = _wantData.itemCategory;
}


#pragma mark - LocationTableViewControllerDelegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (void) locationTableViewController:(LocationTableViewController *)controller didSelectLocation:(NSString *)location
//------------------------------------------------------------------------------------------------------------------------------
{
    _wantData.meetingLocation = location;
    [self.navigationController popViewControllerAnimated:YES];
    _locationCell.detailTextLabel.text = _wantData.meetingLocation;
}


#pragma mark - ItemInfoTableViewController methods

//------------------------------------------------------------------------------------------------------------------------------
- (void) itemInfoTableViewController:(ItemInfoTableViewController *)controller didPressDone:(NSDictionary *)itemInfo
//------------------------------------------------------------------------------------------------------------------------------
{
    _wantData.itemName = [itemInfo objectForKey:ITEM_NAME_KEY];
    _wantData.itemDesc = [itemInfo objectForKey:ITEM_DESC_KEY];
    _wantData.secondHandOption = [(NSNumber *)[itemInfo objectForKey:ITEM_SECONDHAND_OPTION] boolValue];
    _hashtagString = [itemInfo objectForKey:ITEM_HASH_TAG_KEY];
    if ([_hashtagString length] > 0)
        _wantData.hashTagList = [_hashtagString componentsSeparatedByString:@" "];
    NSString *itemName = [itemInfo objectForKey:ITEM_NAME_KEY];
    if (itemName != nil) {
        _itemInfoCell.detailTextLabel.text = itemName;
    } else {
        _itemInfoCell.detailTextLabel.text = NSLocalizedString(@"What are you buying?", nil);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITextFieldDelegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (void) textFieldDidBeginEditing:(UITextField *)textField
//------------------------------------------------------------------------------------------------------------------------------
{
    if (textField.tag == 102) {
        if ([textField.text length] == 0) {
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
    if (textField.tag == 102) {
        if (range.location >= [TAIWAN_CURRENCY length]) {
            NSString *resultantString = [Utilities getResultantStringFromText:textField.text andRange:range andReplacementString:string];
            return [Utilities checkIfIsValidPrice:resultantString];
        } else
            return NO;
    } else {
        return YES;
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) textFieldDidEndEditing:(UITextField *)textField
//------------------------------------------------------------------------------------------------------------------------------
{
    if (textField.tag == 102) {
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
    if (buttonIndex == 1) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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


#pragma mark - ProductOriginTableViewDelegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (void) countryTableView:(CountryTableViewController *)controller didCompleteChoosingCountries:(NSArray *)countries
//------------------------------------------------------------------------------------------------------------------------------
{
    _wantData.productOriginList = [NSArray arrayWithArray:countries];
    
    if ([_wantData.productOriginList count] > 0) {
        NSString *originText = [_wantData.productOriginList componentsJoinedByString:@", "];
        [_productOriginCell.detailTextLabel setText:originText];
    } else
        _productOriginCell.detailTextLabel.text = NSLocalizedString(@"Choose origin", nil);
}


#pragma mark - ImageGetterViewControllerDelegate

//------------------------------------------------------------------------------------------------------------------------------
- (void) imageGetterViewController:(ImageGetterViewController *)controller didChooseAMethod:(ImageGettingMethod)method
//-------------------------------------------------------------------------------------------------------------------------------
{
    if (_popup != nil) {
        [_popup dismiss:YES];
    }
    
    if (method == PhotoLibrary) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:nil];
    } else if (method == Camera) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:nil];
    } else if (method == ImageURL) {
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
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [self sendImageToUploadingWantDetailsVC:chosenImage withNavigationControllerNeeded:YES];
    
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
    
    if (editingNeeded) {
        [self sendImageToUploadingWantDetailsVC:image withNavigationControllerNeeded:NO];
    } else {
        [self addItemImageToWantDetailVC:image];
    }
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) sendImageToUploadingWantDetailsVC: (UIImage *) image withNavigationControllerNeeded: (BOOL) needed
//-------------------------------------------------------------------------------------------------------------------------------
{
    CLImageEditor *editor = [[CLImageEditor alloc] initWithImage:image];
    editor.delegate = self;
    editor.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:editor animated:YES];
}


#pragma mark - CLImageEditorDelegate methods

//-------------------------------------------------------------------------------------------------------------------------------
- (void) imageEditor:(CLImageEditor *)editor didFinishEdittingWithImage:(UIImage *)image
//-------------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [self addItemImageToWantDetailVC:image];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) addItemImageToWantDetailVC: (UIImage *) image
//-------------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [self setImage:image forButton:0];
}

@end
