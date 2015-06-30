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

@interface UploadingWantDetailsViewController ()

@property (strong, nonatomic) NSMutableArray    *addingButtonList;
@property (strong, nonatomic) UITableViewCell   *buttonListCell;

@property (strong, nonatomic) UITableViewCell   *categoryCell;
@property (strong, nonatomic) UITableViewCell   *itemInfoCell;
@property (strong, nonatomic) UITableViewCell   *productOriginCell;
@property (strong, nonatomic) UITableViewCell   *priceCell;
@property (strong, nonatomic) UITableViewCell   *locationCell;
@property (strong, nonatomic) UITableViewCell   *escrowRequestCell;

@property (strong, nonatomic) WantData          *wantData;

@end

@implementation UploadingWantDetailsViewController
{
    UITextField     *priceTextField;
    UISwitch        *escrowSwitch;
    NSString        *hashtagString;
}

@synthesize wantData;
@synthesize productOriginCell;

//------------------------------------------------------------------------------------------------------------------------------
- (id) init
//------------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    
    if (self != nil) {
        [self initializeButtonListCell];
        [self initializeSecondSection];
        [self customizeNavigationBar];
        self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
        self.wantData = [[WantData alloc] init];
        self.wantData.buyer = [PFUser currentUser];
        self.wantData.itemPictureList = [[PFRelation alloc] init];
        self.wantData.backupItemPictureList = [[NSMutableArray alloc] init];
        
        // hide bottom bar when uploading a new want
        self.hidesBottomBarWhenPushed = YES;
    }
    
    return self;
}

#pragma mark - UI Handlers

//------------------------------------------------------------------------------------------------------------------------------
- (void) initializeButtonListCell
//------------------------------------------------------------------------------------------------------------------------------
{
    self.buttonListCell = [[UITableViewCell alloc] init];
    self.buttonListCell.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.8f];
    self.buttonListCell.selectionStyle = UITableViewCellSelectionStyleNone;
    CGSize imageSize = [UIImage imageNamed:@"squareplus.png"].size;
    CGSize windowSize = [[UIScreen mainScreen] bounds].size;
    CGFloat spaceWidth = (windowSize.width - 4 * imageSize.width) / 5.0;
    self.addingButtonList = [[NSMutableArray alloc] init];
    
    for (int i=0; i<4; i++) {
        UIButton *addingButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [addingButton setTag:i];
        [addingButton setBackgroundImage:[UIImage imageNamed:@"squareplus.png"] forState:UIControlStateNormal];
        [addingButton setEnabled:YES];
        addingButton.frame = CGRectMake((i+1) * spaceWidth + i * imageSize.width, imageSize.width/6.0, imageSize.width, imageSize.height);
        [addingButton addTarget:self action:@selector(addingImageButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonListCell addSubview:addingButton];
        [self.addingButtonList addObject:addingButton];
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
    self.categoryCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"category"];
    self.categoryCell.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.8f];
    self.categoryCell.textLabel.text = NSLocalizedString(@"Category", nil);
    self.categoryCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.categoryCell.detailTextLabel.text = NSLocalizedString(@"Choose category", nil);
    self.categoryCell.detailTextLabel.font = [UIFont fontWithName:LIGHT_FONT_NAME size:15];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initializeItemInfoCell
//------------------------------------------------------------------------------------------------------------------------------
{
    self.itemInfoCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"item info"];
    self.itemInfoCell.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.8f];
    self.itemInfoCell.textLabel.text = NSLocalizedString(@"Item info", nil);
    self.itemInfoCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.itemInfoCell.detailTextLabel.text = NSLocalizedString(@"What are you buying?", nil);
    self.itemInfoCell.detailTextLabel.font = [UIFont fontWithName:LIGHT_FONT_NAME size:15];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initializeProductOriginCell
//------------------------------------------------------------------------------------------------------------------------------
{
    self.productOriginCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"productOrigin"];
    self.productOriginCell.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.8f];
    self.productOriginCell.textLabel.text = NSLocalizedString(@"Product origin", nil);
    self.productOriginCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.productOriginCell.detailTextLabel.text = NSLocalizedString(@"Choose origin", nil);
    self.productOriginCell.detailTextLabel.font = [UIFont fontWithName:LIGHT_FONT_NAME size:15];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initializePriceCell
//------------------------------------------------------------------------------------------------------------------------------
{
    self.priceCell = [[UITableViewCell alloc] init];
    self.priceCell.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.8f];
    self.priceCell.textLabel.text = NSLocalizedString(@"Your price", nil);
    priceTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width * 0.55, 30)];
    [priceTextField setTextAlignment:NSTextAlignmentRight];
    UIColor *color = [UIColor colorWithRed:123/255.0 green:123/255.0 blue:129/255.0 alpha:0.8];
    priceTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Set a price", nil) attributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName: [UIFont fontWithName:LIGHT_FONT_NAME size:15]}];
    priceTextField.delegate = self;
    priceTextField.tag = 102;
    priceTextField.inputView = ({
        APNumberPad *numberPad = [APNumberPad numberPadWithDelegate:self];
        // configure function button
        //
        [numberPad.leftFunctionButton setTitle:DOT_CHARACTER forState:UIControlStateNormal];
        numberPad.leftFunctionButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        numberPad;
    });
    [priceTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [priceTextField addTarget:self action:@selector(priceTextFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    self.priceCell.accessoryView = priceTextField;
    self.priceCell.selectionStyle = UITableViewCellSelectionStyleNone;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initializeLocationCell
//------------------------------------------------------------------------------------------------------------------------------
{
    self.locationCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"location"];
    self.locationCell.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.8f];
    self.locationCell.textLabel.text = NSLocalizedString(@"Location", nil);
    self.locationCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.locationCell.detailTextLabel.text = NSLocalizedString(@"Where to meet?", nil);
    self.locationCell.detailTextLabel.font = [UIFont fontWithName:LIGHT_FONT_NAME size:15];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initializeEscrowRequestCell
{
    self.escrowRequestCell = [[UITableViewCell alloc] init];
    self.escrowRequestCell.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.8f];
    self.escrowRequestCell.textLabel.text = NSLocalizedString(@"Request for Escrow?", nil);
    escrowSwitch = [[UISwitch alloc] init];
    [escrowSwitch addTarget:self action:@selector(escrowSwitchDidChangeState) forControlEvents:UIControlEventValueChanged];
    self.escrowRequestCell.accessoryView = escrowSwitch;
    self.escrowRequestCell.selectionStyle = UITableViewCellSelectionStyleNone;
}
//------------------------------------------------------------------------------------------------------------------------------

//------------------------------------------------------------------------------------------------------------------------------
- (void) customizeNavigationBar
//------------------------------------------------------------------------------------------------------------------------------
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Submit", nil) style:UIBarButtonItemStylePlain target:self action:@selector(submittingButtonEvent)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Back", nil) style:UIBarButtonItemStylePlain target:self action:@selector(backButtonEvent)];
}

#pragma mark - Event Handling

//------------------------------------------------------------------------------------------------------------------------------
- (void) addingImageButtonEvent: (id) sender
//------------------------------------------------------------------------------------------------------------------------------
{
    UIButton *button = (UIButton *) sender;
    [self.delegate uploadingWantDetailsViewController:self didPressItemImageButton:[button tag]];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) submittingButtonEvent
//------------------------------------------------------------------------------------------------------------------------------
{
    UIAlertView *submissionAlertView;
    if (self.wantData.itemCategory == nil) {
        submissionAlertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Please choose a category!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [submissionAlertView show];
    } else if (self.wantData.itemName == nil || [self.wantData.itemName length] == 0) {
        submissionAlertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Please fill in item name!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [submissionAlertView show];
    } else if (self.wantData.demandedPrice == nil || [self.wantData.demandedPrice length] == 0) {
        submissionAlertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Please state a price!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [submissionAlertView show];
    } else {
        if (!self.wantData.itemDesc)
            self.wantData.itemDesc = @"";
        if (!self.wantData.hashTagList)
            self.wantData.hashTagList = [NSArray array];
        if (!self.wantData.demandedPrice)
            self.wantData.demandedPrice = @"0";
        if (!self.wantData.paymentMethod)
            self.wantData.paymentMethod = @"non-escrow";
        if (!self.wantData.meetingLocation)
            self.wantData.meetingLocation = @"";
        
        self.wantData.sellersNum = 0;
        self.wantData.itemPicturesNum = [self.wantData.backupItemPictureList count];
        
        PFObject *pfObj = [self.wantData getPFObject];
        [pfObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [self.delegate uploadingWantDetailsViewController:self didCompleteSubmittingWantData:self.wantData];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) backButtonEvent
//------------------------------------------------------------------------------------------------------------------------------
{
    UIAlertView *backAlertView = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to cancel your listing?" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes, I'm sure!", nil];
    [backAlertView show];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) didFinishEditingPrice
//------------------------------------------------------------------------------------------------------------------------------
{
    self.wantData.demandedPrice = priceTextField.text;
    [priceTextField resignFirstResponder];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(submittingButtonEvent)];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) escrowSwitchDidChangeState
//------------------------------------------------------------------------------------------------------------------------------
{
    BOOL state = [escrowSwitch isOn];
    if (state) {
        self.wantData.paymentMethod = @"escrow";
    } else {
        self.wantData.paymentMethod = @"non-escrow";
    }
}

#pragma mark - Set image back ground for button

//------------------------------------------------------------------------------------------------------------------------------
- (void) setImage:(UIImage *)image forButton:(NSUInteger)buttonIndex
//------------------------------------------------------------------------------------------------------------------------------
{
    [[self.addingButtonList objectAtIndex: buttonIndex] setBackgroundImage:image forState:UIControlStateNormal];
    
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    PFFile *imageFile = [PFFile fileWithName:[NSString stringWithFormat:@"%@.jpg", self.wantData.buyer.objectId] data:data];
    
    // Temporary code. Not handle changing image yet
    PFObject *itemPictureObj = [PFObject objectWithClassName:@"ItemPicture"];
    itemPictureObj[@"itemPicture"] = imageFile;
    [itemPictureObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (succeeded) {
            [self.wantData.itemPictureList addObject:itemPictureObj];
            [self.wantData.backupItemPictureList addObject:itemPictureObj];
        } else {
            NSLog(@"Error %@ %@", error, [error userInfo]);
        }
    }];
}

#pragma mark - Table view data source and table view delegate

//------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//------------------------------------------------------------------------------------------------------------------------------
{
    // Return the number of sections.
    return 3;
}

//------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    // Return the number of rows in the section.
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
            return self.buttonListCell;
        case 2:
            switch(indexPath.row)
            {
                case 0: return self.categoryCell;
                case 1: return self.itemInfoCell;
                case 2: return self.productOriginCell;
                case 3: return self.priceCell;
                case 4: return self.locationCell;
                case 5: return self.escrowRequestCell;
            }
    }
    return nil;
}

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
            catVC.category = self.wantData.itemCategory;
            [self.navigationController pushViewController:catVC animated:YES];
        } else if (indexPath.row == 1) {
            NSDictionary *itemBasicInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:self.wantData.itemName, ITEM_NAME_KEY, self.wantData.itemDesc, ITEM_DESC_KEY, hashtagString, ITEM_HASH_TAG_KEY, [NSNumber numberWithBool:self.wantData.secondHandOption], ITEM_SECONDHAND_OPTION, nil];
            ItemInfoTableViewController *itemInfoVC = [[ItemInfoTableViewController alloc] initWithItemInfoDict:itemBasicInfoDict];
            itemInfoVC.delegate = self;
            [self.navigationController pushViewController:itemInfoVC animated:YES];
        } else if (indexPath.row == 2) {
            ProductOriginTableViewController *productTableVC = [[ProductOriginTableViewController alloc] initWithSelectedOrigins:wantData.productOriginList];
            productTableVC.delegate = self;
            [self.navigationController pushViewController:productTableVC animated:YES];
        } else if (indexPath.row == 4) {
            LocationTableViewController *locVC = [[LocationTableViewController alloc] init];
            locVC.delegate = self;
            locVC.location = self.wantData.meetingLocation;
            [self.navigationController pushViewController:locVC animated:YES];
        }
    }
    
    if (indexPath.section != 2 || (indexPath.row != 2 && indexPath.row != 3)) {
        [priceTextField resignFirstResponder];
        if ([[self.navigationItem.rightBarButtonItem title] isEqualToString:NSLocalizedString(@"Done", nil)]) {
            self.wantData.demandedPrice = priceTextField.text;
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Submit", nil) style:UIBarButtonItemStylePlain target:self action:@selector(submittingButtonEvent)];
        }
    }
}

#pragma mark - CategoryTableViewControllerDelegate

//------------------------------------------------------------------------------------------------------------------------------
- (void) categoryTableViewController:(CategoryTableViewController *)controller didSelectCategory:(NSString *)category
//------------------------------------------------------------------------------------------------------------------------------
{
    self.wantData.itemCategory = category;;
    [self.navigationController popViewControllerAnimated:YES];
    self.categoryCell.detailTextLabel.text = self.wantData.itemCategory;
}

#pragma mark - LocationTableViewControllerDelegate

//------------------------------------------------------------------------------------------------------------------------------
- (void) locationTableViewController:(LocationTableViewController *)controller didSelectLocation:(NSString *)location
//------------------------------------------------------------------------------------------------------------------------------
{
    self.wantData.meetingLocation = location;
    [self.navigationController popViewControllerAnimated:YES];
    self.locationCell.detailTextLabel.text = self.wantData.meetingLocation;
}

#pragma mark - ItemInfoTableViewController
//------------------------------------------------------------------------------------------------------------------------------
- (void) itemInfoTableViewController:(ItemInfoTableViewController *)controller didPressDone:(NSDictionary *)itemInfo
//------------------------------------------------------------------------------------------------------------------------------
{
    self.wantData.itemName = [itemInfo objectForKey:ITEM_NAME_KEY];
    self.wantData.itemDesc = [itemInfo objectForKey:ITEM_DESC_KEY];
    self.wantData.secondHandOption = [(NSNumber *)[itemInfo objectForKey:ITEM_SECONDHAND_OPTION] boolValue];
    hashtagString = [itemInfo objectForKey:ITEM_HASH_TAG_KEY];
    if ([hashtagString length] > 0)
        self.wantData.hashTagList = [hashtagString componentsSeparatedByString:@" "];
    NSString *itemName = [itemInfo objectForKey:ITEM_NAME_KEY];
    if (itemName != nil) {
        self.itemInfoCell.detailTextLabel.text = itemName;
    } else {
        self.itemInfoCell.detailTextLabel.text = NSLocalizedString(@"What are you buying?", nil);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate

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
    [priceTextField setText:[Utilities formatPriceText:priceTextField.text]];
}

//------------------------------------------------------------------------------------------------------------------------------
#pragma mark - UIAlertViewDelegate
//------------------------------------------------------------------------------------------------------------------------------
- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//------------------------------------------------------------------------------------------------------------------------------
#pragma mark - APNumberPad
//------------------------------------------------------------------------------------------------------------------------------
- (void)numberPad:(APNumberPad *)numberPad functionButtonAction:(UIButton *)functionButton textInput:(UIResponder<UITextInput> *)textInput
{
    NSRange range = {[[priceTextField text] length], 1};
    if ([self textField:priceTextField shouldChangeCharactersInRange:range replacementString:DOT_CHARACTER])
        [textInput insertText:DOT_CHARACTER];
}

#pragma mark - ProductOriginTableViewDelegate

//------------------------------------------------------------------------------------------------------------------------------
- (void) productOriginTableView:(ProductOriginTableViewController *)controller didCompleteChoosingOrigins:(NSArray *)countries
//------------------------------------------------------------------------------------------------------------------------------
{
    wantData.productOriginList = [NSArray arrayWithArray:countries];
    
    if ([wantData.productOriginList count] > 0) {
        NSString *originText = [wantData.productOriginList componentsJoinedByString:@", "];
        [productOriginCell.detailTextLabel setText:originText];
    } else
        productOriginCell.detailTextLabel.text = NSLocalizedString(@"Choose origin", nil);
}


@end
