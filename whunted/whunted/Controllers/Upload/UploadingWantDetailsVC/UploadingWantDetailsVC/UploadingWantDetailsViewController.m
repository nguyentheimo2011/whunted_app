//
//  WantDetailsViewController.m
//  whunted
//
//  Created by thomas nguyen on 16/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "UploadingWantDetailsViewController.h"
#import "Utilities.h"

@interface UploadingWantDetailsViewController ()

@property (strong, nonatomic) NSMutableArray *addingButtonList;
@property (strong, nonatomic) UITableViewCell *buttonListCell;

@property (strong, nonatomic) UITableViewCell *categoryCell;
@property (strong, nonatomic) UITableViewCell *itemInfoCell;
@property (strong, nonatomic) UITableViewCell *productOriginCell;
@property (strong, nonatomic) UITableViewCell *priceCell;
@property (strong, nonatomic) UITableViewCell *locationCell;
@property (strong, nonatomic) UITableViewCell *escrowRequestCell;

@property (strong, nonatomic) WantData *wantData;

@end

@implementation UploadingWantDetailsViewController
{
    UITextField *productOriginTextField;
    UITextField *priceTextField;
    UISwitch *escrowSwitch;
    NSString *hashtagString;
}

- (id) init
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void) loadView
{
    [super loadView];
}

#pragma mark - Initialization

- (void) initializeButtonListCell
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

- (void) initializeSecondSection
{
    CGSize windowSize = [[UIScreen mainScreen] bounds].size;
    
    self.categoryCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"category"];
    self.categoryCell.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.8f];
    self.categoryCell.textLabel.text = @"品類";
    self.categoryCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.categoryCell.detailTextLabel.text = @"選擇物品品類";
    self.categoryCell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    
    self.itemInfoCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"item info"];
    self.itemInfoCell.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.8f];
    self.itemInfoCell.textLabel.text = @"物品類目";
    self.itemInfoCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.itemInfoCell.detailTextLabel.text = @"你要買什麼?";
    self.itemInfoCell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    
    self.productOriginCell = [[UITableViewCell alloc] init];
    self.productOriginCell.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.8f];
    self.productOriginCell.textLabel.text  = @"物品產地";
    productOriginTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, windowSize.width * 0.50, 30)];
    [productOriginTextField setTextAlignment:NSTextAlignmentRight];
    UIColor *color = [UIColor colorWithRed:123/255.0 green:123/255.0 blue:129/255.0 alpha:0.8];
    productOriginTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Taiwan" attributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName: [UIFont systemFontOfSize:15]}];
    productOriginTextField.delegate = self;
    productOriginTextField.tag = 101;
    [productOriginTextField setKeyboardType:UIKeyboardTypeAlphabet];
    self.productOriginCell.accessoryView = productOriginTextField;
    self.productOriginCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.priceCell = [[UITableViewCell alloc] init];
    self.priceCell.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.8f];
    self.priceCell.textLabel.text = @"你開的價";
    priceTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, windowSize.width * 0.55, 30)];
    [priceTextField setTextAlignment:NSTextAlignmentRight];
    priceTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"開個價" attributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName: [UIFont systemFontOfSize:15]}];
    priceTextField.delegate = self;
    priceTextField.tag = 102;
    [priceTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    self.priceCell.accessoryView = priceTextField;
    self.priceCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.locationCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"location"];
    self.locationCell.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.8f];
    self.locationCell.textLabel.text = @"地點";
    self.locationCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.locationCell.detailTextLabel.text = @"選擇交易地點?";
    self.locationCell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    
    self.escrowRequestCell = [[UITableViewCell alloc] init];
    self.escrowRequestCell.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.8f];
    self.escrowRequestCell.textLabel.text = @"第三方託管?";
    escrowSwitch = [[UISwitch alloc] init];
    [escrowSwitch addTarget:self action:@selector(escrowSwitchDidChangeState) forControlEvents:UIControlEventValueChanged];
    self.escrowRequestCell.accessoryView = escrowSwitch;
    self.escrowRequestCell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void) customizeNavigationBar
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(submittingButtonEvent)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonEvent)];
}

#pragma mark - Event Handling

- (void) addingImageButtonEvent: (id) sender
{
    UIButton *button = (UIButton *) sender;
    [self.delegate uploadingWantDetailsViewController:self didPressItemImageButton:[button tag]];
}

- (void) submittingButtonEvent
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
        if (!self.wantData.productOrigin)
            self.wantData.productOrigin = @"";
        if (!self.wantData.demandedPrice)
            self.wantData.demandedPrice = @"0";
        if (!self.wantData.paymentMethod)
            self.wantData.paymentMethod = @"Pay later";
        if (!self.wantData.meetingLocation)
            self.wantData.meetingLocation = @"";
        
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

- (void) backButtonEvent
{
    UIAlertView *backAlertView = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to cancel your listing?" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes, I'm sure!", nil];
    [backAlertView show];
}

- (void) didFinishEditingPrice
{
    self.wantData.demandedPrice = priceTextField.text;
    self.wantData.productOrigin = productOriginTextField.text;
    [priceTextField resignFirstResponder];
    [productOriginTextField resignFirstResponder];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(submittingButtonEvent)];
}

- (void) escrowSwitchDidChangeState
{
    BOOL state = [escrowSwitch isOn];
    if (state) {
        self.wantData.paymentMethod = @"escrow";
    } else {
        self.wantData.paymentMethod = @"non-escrow";
    }
}

#pragma mark - Set image back ground for button

- (void) setImage:(UIImage *)image forButton:(NSUInteger)buttonIndex
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    switch(section)
    {
        case 0: return 0;   // section 0 has 0 row. Use footer of section i as the header of section i+1
        case 1:  return 1;  // section 0 has 1 row
        case 2:  return 6;  // section 1 has 6 rows
        default: return 0;
    };
}

// Return the row for the corresponding section and row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
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

// Customize the section headings for each section
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch(section)
    {
        case 1: return @" ";
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    switch(section)
    {
        case 1: return @"具體信息";
    }
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch(section)
    {
        case 0: return 0.0f;
        case 1: return 10.0f;
    }
    return 0.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
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

- (void) tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor clearColor];
}

- (void) tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor clearColor];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            CategoryTableViewController *catVC = [[CategoryTableViewController alloc] init];
            catVC.delegte = self;
            catVC.category = self.wantData.itemCategory;
            [self.navigationController pushViewController:catVC animated:YES];
        } else if (indexPath.row == 1) {
            NSDictionary *itemBasicInfoDict = [NSDictionary dictionaryWithObjectsAndKeys:self.wantData.itemName, ITEM_NAME_KEY, self.wantData.itemDesc, ITEM_DESC_KEY, hashtagString, ITEM_HASH_TAG_KEY, nil];
            ItemInfoTableViewController *itemInfoVC = [[ItemInfoTableViewController alloc] initWithItemInfoDict:itemBasicInfoDict];
            itemInfoVC.delegate = self;
            [self.navigationController pushViewController:itemInfoVC animated:YES];
        } else if (indexPath.row == 4) {
            LocationTableViewController *locVC = [[LocationTableViewController alloc] init];
            locVC.delegate = self;
            locVC.location = self.wantData.meetingLocation;
            [self.navigationController pushViewController:locVC animated:YES];
        }
    }
    
    if (indexPath.section != 2 || (indexPath.row != 2 && indexPath.row != 3)) {
        [productOriginTextField resignFirstResponder];
        [priceTextField resignFirstResponder];
        if ([[self.navigationItem.rightBarButtonItem title] isEqualToString:@"Done"]) {
            self.wantData.demandedPrice = priceTextField.text;
            self.wantData.productOrigin = productOriginTextField.text;
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(submittingButtonEvent)];
        }
    }
}

#pragma mark - CategoryTableViewControllerDelegate

- (void) categoryTableViewController:(CategoryTableViewController *)controller didSelectCategory:(NSString *)category
{
    self.wantData.itemCategory = category;;
    [self.navigationController popViewControllerAnimated:YES];
    self.categoryCell.detailTextLabel.text = self.wantData.itemCategory;
}

#pragma mark - LocationTableViewControllerDelegate
- (void) locationTableViewController:(LocationTableViewController *)controller didSelectLocation:(NSString *)location
{
    self.wantData.meetingLocation = location;
    [self.navigationController popViewControllerAnimated:YES];
    self.locationCell.detailTextLabel.text = self.wantData.meetingLocation;
}

#pragma mark - ItemInfoTableViewController
- (void) itemInfoTableViewController:(ItemInfoTableViewController *)controller didPressDone:(NSDictionary *)itemInfo
{
    self.wantData.itemName = [itemInfo objectForKey:ITEM_NAME_KEY];
    self.wantData.itemDesc = [itemInfo objectForKey:ITEM_DESC_KEY];
    hashtagString = [itemInfo objectForKey:ITEM_HASH_TAG_KEY];
    if ([hashtagString length] > 0)
        self.wantData.hashTagList = [hashtagString componentsSeparatedByString:@" "];
    NSString *itemName = [itemInfo objectForKey:ITEM_NAME_KEY];
    if (itemName != nil) {
        self.itemInfoCell.detailTextLabel.text = itemName;
    } else {
        self.itemInfoCell.detailTextLabel.text = @"What are you buying?";
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate
- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 102) {
        if ([textField.text length] == 0) {
            NSString *text = [@"TWD" stringByAppendingString:textField.text];
            textField.text = text;
        }
    }

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(didFinishEditingPrice)];
}

#pragma mark - UIAlertViewDelegate
- (void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 102) {
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARECTERS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    } else {
        return YES;
    }
}

@end
