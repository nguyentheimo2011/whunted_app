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

@implementation ItemInfoTableViewController
{
    UITableViewCell         *_itemNameCell;
    UITableViewCell         *_descriptionCell;
    UITableViewCell         *_hashtagCell;
    UITableViewCell         *_secondHandOptionCell;
    
    UITextField             *_itemNameTextField;
    SZTextView              *_descriptionTextView;
    SZTextView              *_hashTagTextView;
    UISwitch                *_secondHandOptionSwitch;

    NSMutableDictionary     *_itemInfoDict;
}

//------------------------------------------------------------------------------------------------------------------------------
- (id) initWithItemInfoDict: (NSDictionary *) infoDict
//------------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    if (self != nil) {
        [self initData:infoDict];
        [self customizeUI];
        [self initializeItemNameCell];
        [self initializeDescriptionCell];
        [self initializeHashtagCell];
        [self initializeSecondHandOptionCell];
        
    }
    
    return self;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initData: (NSDictionary *) infoDict
//------------------------------------------------------------------------------------------------------------------------------
{
    _itemInfoDict = [NSMutableDictionary dictionaryWithDictionary:infoDict];
}


#pragma mark - UI Handler

//------------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI
//------------------------------------------------------------------------------------------------------------------------------
{
    self.view.backgroundColor = LIGHTEST_GRAY_COLOR;
    [Utilities customizeTitleLabel:NSLocalizedString(@"Item info", nil) forViewController:self];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonEvent)];
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
    _itemNameTextField.font = [UIFont fontWithName:REGULAR_FONT_NAME size:DEFAULT_FONT_SIZE];
    _itemNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Item name", nil) attributes:@{NSForegroundColorAttributeName: PLACEHOLDER_TEXT_COLOR, NSFontAttributeName: [UIFont fontWithName:REGULAR_FONT_NAME size:DEFAULT_FONT_SIZE]}];
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
    _descriptionTextView.font = [UIFont fontWithName:REGULAR_FONT_NAME size:DEFAULT_FONT_SIZE];
    _descriptionTextView.placeholder = NSLocalizedString(@"Describe more about the item that you want. \nE.g. Size, condition, color, etc.", nil);
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
    _hashTagTextView.font = [UIFont fontWithName:REGULAR_FONT_NAME size:DEFAULT_FONT_SIZE];
    _hashTagTextView.placeholder = NSLocalizedString(@"Enter hashtags for the item to help sellers find you. \nE.g. shoes bag book, etc.", nil);
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
    [secondHandLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:DEFAULT_FONT_SIZE]];
    [secondHandLabel setTextColor:[UIColor blackColor]];
    [_secondHandOptionCell addSubview:secondHandLabel];
    
    _secondHandOptionSwitch = [[UISwitch alloc] init];
    _secondHandOptionSwitch.on = [(NSNumber *)_itemInfoDict[ITEM_SECONDHAND_OPTION] boolValue];
    _secondHandOptionCell.accessoryView = _secondHandOptionSwitch;
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
    
    [self.delegate itemInfoTableViewController:self didPressDone:_itemInfoDict];
}

#pragma mark - Table view data source

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
    return 4;
}

//------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    if (indexPath.row == 0) {
        return _itemNameCell;
    } else if (indexPath.row == 1) {
        return _descriptionCell;
    } else if (indexPath.row == 2) {
        return _hashtagCell;
    } else if (indexPath.row == 3) {
        return _secondHandOptionCell;
    }
    
    return nil;
}

//------------------------------------------------------------------------------------------------------------------------------
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    return @" ";
}

#pragma mark - Table view delegate

//------------------------------------------------------------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//------------------------------------------------------------------------------------------------------------------------------
{
    CGSize windowSize = [[UIScreen mainScreen] bounds].size;
    if (indexPath.row == 0) {
        return 35;
    }else if (indexPath.row == 1) {
        return windowSize.height * 0.3;
    } else if (indexPath.row == 2) {
        return windowSize.height/6;
    } else if (indexPath.row == 3) {
        return 45;
    }
    
    return 0;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
//------------------------------------------------------------------------------------------------------------------------------
{
    view.tintColor = [UIColor clearColor];
}

//------------------------------------------------------------------------------------------------------------------------------
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [_itemNameTextField endEditing:YES];
    return YES;
}



@end
