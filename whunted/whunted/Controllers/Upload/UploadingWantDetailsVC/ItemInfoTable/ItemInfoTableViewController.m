//
//  ItemInfoTableViewController.m
//  whunted
//
//  Created by thomas nguyen on 18/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "ItemInfoTableViewController.h"
#import "Utilities.h"
#import "AppConstant.h"

#import <SZTextView/SZTextView.h>

#define     kReferenceLinkCellHeight    80.0f
#define     kIconWidth                  20.0f
#define     kIconHeight                 20.0f
#define     kIconLeftMargin             15.0f
#define     kIconTopMargin              10.0f

@implementation ItemInfoTableViewController
{
    UITableViewCell         *_itemNameCell;
    UITableViewCell         *_descriptionCell;
    UITableViewCell         *_hashtagCell;
    UITableViewCell         *_secondHandOptionCell;
    UITableViewCell         *_referenceLinkCell;
    UITableViewCell         *_productOriginCell;
    
    UITextField             *_itemNameTextField;
    SZTextView              *_descriptionTextView;
    SZTextView              *_hashTagTextView;
    UISwitch                *_secondHandOptionSwitch;
    SZTextView              *_referenceLinkTextView;

    NSMutableDictionary     *_itemInfoDict;
}

//------------------------------------------------------------------------------------------------------------------------------
- (id) initWithItemInfoDict: (NSDictionary *) infoDict
//------------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    
    if (self != nil)
    {
        [self initData:infoDict];
        [self customizeUI];
        [self initializeItemNameCell];
        [self initializeDescriptionCell];
        [self initializeHashtagCell];
        [self initializeSecondHandOptionCell];
        [self initReferenceLinkCell];
        [self initializeProductOriginCell];
    }
    
    return self;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initData: (NSDictionary *) infoDict
//------------------------------------------------------------------------------------------------------------------------------
{
    _itemInfoDict = [NSMutableDictionary dictionaryWithDictionary:infoDict];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) viewWillAppear:(BOOL)animated
//------------------------------------------------------------------------------------------------------------------------------
{
    [super viewWillAppear:animated];
    
    [Utilities sendScreenNameToGoogleAnalyticsTracker:@"UploadItemInfoScreen"];
}


#pragma mark - UI Handler

//------------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI
//------------------------------------------------------------------------------------------------------------------------------
{
    self.view.backgroundColor = LIGHTEST_GRAY_COLOR;
    
    [Utilities customizeTitleLabel:NSLocalizedString(@"Item info", nil) forViewController:self];
    
    [Utilities customizeBackButtonForViewController:self withAction:@selector(topBackButtonTapEventHandler)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonEvent)];
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initializeItemNameCell
//------------------------------------------------------------------------------------------------------------------------------
{
    _itemNameCell = [[UITableViewCell alloc] init];
    _itemNameCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat const kTextFieldLeftMargin = 15.0f;
    CGFloat const kTextFieldTopMargin = 5.0f;
    CGFloat const kTextFieldWidth = WINSIZE.width - 2 * kTextFieldLeftMargin;
    CGFloat const kTextFieldHeight = 30.0f;
    
    _itemNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(kTextFieldLeftMargin, kTextFieldTopMargin, kTextFieldWidth, kTextFieldHeight)];
    _itemNameTextField.text = [_itemInfoDict objectForKey:ITEM_NAME_KEY];
    _itemNameTextField.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    _itemNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Item name", nil) attributes:@{NSForegroundColorAttributeName: PLACEHOLDER_TEXT_COLOR, NSFontAttributeName: [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE]}];
    _itemNameTextField.returnKeyType = UIReturnKeyDone;
    _itemNameTextField.delegate = self;
    [_itemNameCell addSubview:_itemNameTextField];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initializeDescriptionCell
//------------------------------------------------------------------------------------------------------------------------------
{
    _descriptionCell = [[UITableViewCell alloc] init];
    _descriptionCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat const kTextViewLeftMargin = 10.0f;
    CGFloat const kTextViewWidth = WINSIZE.width - 2 * kTextViewLeftMargin;
    CGFloat const kTextViewHeight = WINSIZE.height * 0.3;
    
    _descriptionTextView = [[SZTextView alloc] initWithFrame:CGRectMake(kTextViewLeftMargin, 0, kTextViewWidth, kTextViewHeight)];
    _descriptionTextView.text = [_itemInfoDict objectForKey:ITEM_DESC_KEY];
    _descriptionTextView.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    NSString *placeholder = NSLocalizedString(@"Describe more about the item that you want. \nE.g. Size, condition, color, etc.", nil);
    _descriptionTextView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: PLACEHOLDER_TEXT_COLOR, NSFontAttributeName: [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE]}];
    [_descriptionCell addSubview:_descriptionTextView];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initializeHashtagCell
//------------------------------------------------------------------------------------------------------------------------------
{
    _hashtagCell = [[UITableViewCell alloc] init];
    _hashtagCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat const kTextViewLeftMargin = 10.0f;
    CGFloat const kTextViewWidth = WINSIZE.width - kTextViewLeftMargin;
    CGFloat const kTextViewHeight = WINSIZE.height/6;
    
    _hashTagTextView = [[SZTextView alloc] initWithFrame:CGRectMake(kTextViewLeftMargin, 0, kTextViewWidth, kTextViewHeight)];
    _hashTagTextView.text = [_itemInfoDict objectForKey:ITEM_HASH_TAG_KEY];
    _hashTagTextView.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    NSString *placeholder = NSLocalizedString(@"Enter hashtags for the item to help sellers find you. \nE.g. shoes bag book, etc.", nil);
    _hashTagTextView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: PLACEHOLDER_TEXT_COLOR, NSFontAttributeName: [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE]}];
    [_hashtagCell addSubview:_hashTagTextView];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initializeSecondHandOptionCell
//------------------------------------------------------------------------------------------------------------------------------
{
    _secondHandOptionCell = [[UITableViewCell alloc] init];
    _secondHandOptionCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat const kLabelLeftMargin = 10.0f;
    CGFloat const kLabelTopMargin = 10.0f;
    CGFloat const kLabelWidth = WINSIZE.width * 0.6;
    CGFloat const kLabelHeight = 25.0f;
    
    UILabel *secondHandLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelLeftMargin, kLabelTopMargin, kLabelWidth, kLabelHeight)];
    [secondHandLabel setText:NSLocalizedString(@"Allow second-hand item", nil)];
    [secondHandLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE]];
    [secondHandLabel setTextColor:TEXT_COLOR_DARK_GRAY];
    [_secondHandOptionCell addSubview:secondHandLabel];
    
    _secondHandOptionSwitch = [[UISwitch alloc] init];
    _secondHandOptionSwitch.on = [(NSNumber *)_itemInfoDict[ITEM_SECONDHAND_OPTION] boolValue];
    _secondHandOptionCell.accessoryView = _secondHandOptionSwitch;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initReferenceLinkCell
//------------------------------------------------------------------------------------------------------------------------------
{
    _referenceLinkCell = [[UITableViewCell alloc] init];
    _referenceLinkCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGFloat const kTextViewLeftMargin = 10.0f;
    CGFloat const kTextViewWidth = WINSIZE.width - 2 * kTextViewLeftMargin;
    CGFloat const kTextViewHeight = kReferenceLinkCellHeight;
    
    _referenceLinkTextView = [[SZTextView alloc] initWithFrame:CGRectMake(kTextViewLeftMargin, 0, kTextViewWidth, kTextViewHeight)];
    _referenceLinkTextView.text = [_itemInfoDict objectForKey:ITEM_REFERENCE_LINK];
    _referenceLinkTextView.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    NSString *placeholder = NSLocalizedString(@"Enter reference link. http://...", nil);
    _referenceLinkTextView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: PLACEHOLDER_TEXT_COLOR, NSFontAttributeName: [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE]}];
    [_referenceLinkCell addSubview:_referenceLinkTextView];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initializeProductOriginCell
//------------------------------------------------------------------------------------------------------------------------------
{
    _productOriginCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"productOrigin"];
    _productOriginCell.textLabel.text = NSLocalizedString(@"Product origin", nil);
    _productOriginCell.textLabel.textColor = TEXT_COLOR_DARK_GRAY;
    _productOriginCell.textLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    _productOriginCell.indentationLevel = 3;
    _productOriginCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if ([[_itemInfoDict allKeys] containsObject:ITEM_ORIGINS_KEY])
    {
        NSArray *origins = [_itemInfoDict objectForKey:ITEM_ORIGINS_KEY];
        if (origins.count > 0)
            _productOriginCell.detailTextLabel.text = [origins objectAtIndex:0];
    }
    else
        _productOriginCell.detailTextLabel.text = NSLocalizedString(@"Choose origin", nil);
    _productOriginCell.detailTextLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:15];
    
    // add origin icon
    UIImageView *originImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kIconLeftMargin, kIconTopMargin, kIconWidth, kIconHeight)];
    UIImage *originImage = [UIImage imageNamed:@"product_origin_icon.png"];
    [originImageView setImage:originImage];
    [_productOriginCell addSubview:originImageView];
}


#pragma mark - Event Handling

//------------------------------------------------------------------------------------------------------------------------------
- (void) doneButtonEvent
//------------------------------------------------------------------------------------------------------------------------------
{
    [_itemInfoDict setObject:_itemNameTextField.text forKey:ITEM_NAME_KEY];
    [_itemInfoDict setObject:_descriptionTextView.text forKey:ITEM_DESC_KEY];
    [_itemInfoDict setObject:_hashTagTextView.text forKey:ITEM_HASH_TAG_KEY];
    [_itemInfoDict setObject:[NSNumber numberWithBool:_secondHandOptionSwitch.on] forKey:ITEM_SECONDHAND_OPTION];
    [_itemInfoDict setObject:_referenceLinkTextView.text forKey:ITEM_REFERENCE_LINK];
    
    if (![[_itemInfoDict allKeys] containsObject:ITEM_ORIGINS_KEY])
        [_itemInfoDict setObject:[NSArray array] forKey:ITEM_ORIGINS_KEY];
    
    [self.delegate itemInfoTableViewController:self didPressDone:_itemInfoDict];
}

//-------------------------------------------------------------------------------------------------------------------------------
- (void) pushProductOriginViewController
//-------------------------------------------------------------------------------------------------------------------------------
{
    CityViewController *productOriginVC = [[CityViewController alloc] init];
    NSArray *productOrigins = [_itemInfoDict objectForKey:ITEM_ORIGINS_KEY];
    productOriginVC.labelText = NSLocalizedString(@"Product origin:", nil);
    productOriginVC.currentLocation = (productOrigins.count > 0) ? [productOrigins objectAtIndex:0] : nil;
    productOriginVC.viewTitle = NSLocalizedString(@"Product origin", nil);
    productOriginVC.delegate = self;
    
    [self.navigationController pushViewController:productOriginVC animated:YES];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) topBackButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDataSource methods

//------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//------------------------------------------------------------------------------------------------------------------------------
{
    // Return the number of sections.
    return 1;
}

//------------------------------------------------------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    // Return the number of rows in the section.
    return 6;
}

//------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    if (indexPath.row == 0)
        return _itemNameCell;
    else if (indexPath.row == 1)
        return _descriptionCell;
    else if (indexPath.row == 2)
        return _hashtagCell;
    else if (indexPath.row == 3)
        return _referenceLinkCell;
    else if (indexPath.row == 4)
        return _productOriginCell;
    else if (indexPath.row == 5)
        return _secondHandOptionCell;
    
    return nil;
}

//------------------------------------------------------------------------------------------------------------------------------
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    return @" ";
}

#pragma mark - UITableViewDelegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    CGSize windowSize = [[UIScreen mainScreen] bounds].size;
    if (indexPath.row == 0)
        return 35;
    else if (indexPath.row == 1)
        return windowSize.height * 0.3;
    else if (indexPath.row == 2)
        return windowSize.height/6;
    else if (indexPath.row == 3)
        return kReferenceLinkCellHeight;
    else if (indexPath.row == 4)
        return 45;
    else if (indexPath.row == 5)
        return 45;
    
    return 0;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 4)
        [self pushProductOriginViewController];
}

//------------------------------------------------------------------------------------------------------------------------------
- (BOOL) textFieldShouldReturn:(UITextField *)textField
//------------------------------------------------------------------------------------------------------------------------------
{
    [_itemNameTextField endEditing:YES];
    return YES;
}


#pragma mark - CityViewDelegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (void) cityView:(CityViewController *)controller didSpecifyLocation:(NSString *)location
//------------------------------------------------------------------------------------------------------------------------------
{
    [_itemInfoDict setObject:[NSArray arrayWithObject:location] forKey:ITEM_ORIGINS_KEY] ;
    
    if (location.length > 0)
        _productOriginCell.detailTextLabel.text = location;
    else
        _productOriginCell.detailTextLabel.text = NSLocalizedString(@"Choose origin", nil);
}

@end
