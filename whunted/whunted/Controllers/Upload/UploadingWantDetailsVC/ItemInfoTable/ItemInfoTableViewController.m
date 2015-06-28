//
//  ItemInfoTableViewController.m
//  whunted
//
//  Created by thomas nguyen on 18/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "ItemInfoTableViewController.h"
#import <SZTextView/SZTextView.h>
#import "AppConstant.h"

@interface ItemInfoTableViewController ()

@property (nonatomic, strong) UITableViewCell       *itemNameCell;
@property (nonatomic, strong) UITableViewCell       *descriptionCell;
@property (nonatomic,strong) UITableViewCell        *hashtagCell;
@property (nonatomic, strong) UITableViewCell       *_secondHandOptionCell;
@property (nonatomic, strong) NSMutableDictionary   *itemInfoDict;

@end

@implementation ItemInfoTableViewController
{
    UITextField *itemNameTextField;
    SZTextView  *descriptionTextView;
    SZTextView  *hashTagTextView;
    UISwitch    *_secondHandOptionSwitch;
}

@synthesize _secondHandOptionCell;

//------------------------------------------------------------------------------------------------------------------------------
- (id) initWithItemInfoDict: (NSDictionary *) infoDict
//------------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    if (self != nil) {
        self.itemInfoDict = [NSMutableDictionary dictionaryWithDictionary:infoDict];
        [self customizeCell];
        [self initializeItemNameCell];
        [self initializeDescriptionCell];
        [self initializeHashtagCell];
        [self initializeSecondHandOptionCell];
        
    }
    
    return self;
}

#pragma mark - UI Handler

//------------------------------------------------------------------------------------------------------------------------------
- (void) customizeCell
//------------------------------------------------------------------------------------------------------------------------------
{
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    self.navigationItem.title = NSLocalizedString(@"Item info", nil);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonEvent)];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initializeItemNameCell
//------------------------------------------------------------------------------------------------------------------------------
{
    self.itemNameCell = [[UITableViewCell alloc] init];
    self.itemNameCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    itemNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 5, WINSIZE.width-15, 30)];
    itemNameTextField.text = [self.itemInfoDict objectForKey:ITEM_NAME_KEY];
    UIColor *color = [UIColor colorWithRed:130/255.0 green:130/255.0 blue:130/255.0 alpha:0.8];
    itemNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Item name", nil) attributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName: [UIFont fontWithName:LIGHT_FONT_NAME size:17]}];
    itemNameTextField.delegate = self;
    [self.itemNameCell addSubview:itemNameTextField];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initializeDescriptionCell
//------------------------------------------------------------------------------------------------------------------------------
{
    self.descriptionCell = [[UITableViewCell alloc] init];
    self.descriptionCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    descriptionTextView = [[SZTextView alloc] initWithFrame:CGRectMake(10, 0, WINSIZE.width, WINSIZE.height * 0.3)];
    descriptionTextView.text = [self.itemInfoDict objectForKey:ITEM_DESC_KEY];
    descriptionTextView.font = [UIFont fontWithName:LIGHT_FONT_NAME size:17];
    descriptionTextView.placeholder = NSLocalizedString(@"Describe more about the item that you want. \nE.g. Size, condition, color, etc.", nil);
    [self.descriptionCell addSubview:descriptionTextView];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initializeHashtagCell
//------------------------------------------------------------------------------------------------------------------------------
{
    self.hashtagCell = [[UITableViewCell alloc] init];
    self.hashtagCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    hashTagTextView = [[SZTextView alloc] initWithFrame:CGRectMake(10, 0, WINSIZE.width, WINSIZE.height/6)];
    hashTagTextView.text = [self.itemInfoDict objectForKey:ITEM_HASH_TAG_KEY];
    hashTagTextView.font = [UIFont fontWithName:LIGHT_FONT_NAME size:17];
    hashTagTextView.placeholder = NSLocalizedString(@"Enter hashtags for the item to help sellers find you. \nE.g. shoes bag book, etc.", nil);
    [self.hashtagCell addSubview:hashTagTextView];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initializeSecondHandOptionCell
//------------------------------------------------------------------------------------------------------------------------------
{
    _secondHandOptionCell = [[UITableViewCell alloc] init];
    _secondHandOptionCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *secondHandLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, WINSIZE.width * 0.6, 25)];
    [secondHandLabel setText:@"Allow second-hand item?"];
    [secondHandLabel setFont:[UIFont fontWithName:LIGHT_FONT_NAME size:16]];
    [secondHandLabel setTextColor:[UIColor blackColor]];
    [_secondHandOptionCell addSubview:secondHandLabel];
    
    _secondHandOptionSwitch = [[UISwitch alloc] init];
    _secondHandOptionSwitch.on = [(NSNumber *)self.itemInfoDict[ITEM_SECONDHAND_OPTION] boolValue];
    _secondHandOptionCell.accessoryView = _secondHandOptionSwitch;
}

#pragma mark - Event Handling

//------------------------------------------------------------------------------------------------------------------------------
- (void) doneButtonEvent
//------------------------------------------------------------------------------------------------------------------------------
{
    [self.itemInfoDict setObject:itemNameTextField.text forKey:ITEM_NAME_KEY];
    [self.itemInfoDict setObject:descriptionTextView.text forKey:ITEM_DESC_KEY];
    [self.itemInfoDict setObject:hashTagTextView.text forKey:ITEM_HASH_TAG_KEY];
    [self.itemInfoDict setObject:[NSNumber numberWithBool:_secondHandOptionSwitch.on] forKey:ITEM_SECONDHAND_OPTION];
    
    [self.delegate itemInfoTableViewController:self didPressDone:self.itemInfoDict];
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
        return self.itemNameCell;
    } else if (indexPath.row == 1) {
        return self.descriptionCell;
    } else if (indexPath.row == 2) {
        return self.hashtagCell;
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
    [itemNameTextField endEditing:YES];
    return YES;
}



@end
