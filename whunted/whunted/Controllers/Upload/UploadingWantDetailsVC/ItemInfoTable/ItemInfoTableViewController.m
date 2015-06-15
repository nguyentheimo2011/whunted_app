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

@property (nonatomic, strong) UITableViewCell *itemNameCell;
@property (nonatomic, strong) UITableViewCell *descriptionCell;
@property (nonatomic,strong) UITableViewCell *hashtagCell;
@property (nonatomic, strong) NSMutableDictionary *itemInfoDict;

@end

@implementation ItemInfoTableViewController
{
    UITextField *itemNameTextField;
    SZTextView *descriptionTextView;
    SZTextView *hashTagTextView;
}

- (id) initWithItemInfoDict: (NSDictionary *) infoDict
{
    self = [super init];
    if (self != nil) {
        self.itemInfoDict = [NSMutableDictionary dictionaryWithDictionary:infoDict];
        [self initializeItemNameCell];
        [self initializeDescriptionCell];
        [self initializeHashtagCell];
        self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
        self.navigationItem.title = @"物品類目";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonEvent)];
    }
    
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialization 

- (void) initializeItemNameCell
{
    self.itemNameCell = [[UITableViewCell alloc] init];
    self.itemNameCell.selectionStyle = UITableViewCellSelectionStyleNone;
    CGSize windowSize = [[UIScreen mainScreen] bounds].size;
    
    itemNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, 5, windowSize.width-15, 30)];
    itemNameTextField.text = [self.itemInfoDict objectForKey:ITEM_NAME_KEY];
    UIColor *color = [UIColor colorWithRed:130/255.0 green:130/255.0 blue:130/255.0 alpha:0.8];
    itemNameTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"物品名稱" attributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName: [UIFont systemFontOfSize:17]}];
    [self.itemNameCell addSubview:itemNameTextField];
}

- (void) initializeDescriptionCell
{
    self.descriptionCell = [[UITableViewCell alloc] init];
    self.descriptionCell.selectionStyle = UITableViewCellSelectionStyleNone;
    CGSize windowSize = [[UIScreen mainScreen] bounds].size;
    
    descriptionTextView = [[SZTextView alloc] initWithFrame:CGRectMake(10, 0, windowSize.width, windowSize.height * 0.3)];
    descriptionTextView.text = [self.itemInfoDict objectForKey:ITEM_DESC_KEY];
    descriptionTextView.font = [UIFont systemFontOfSize:17];
    descriptionTextView.placeholder = @"請描述您所需的物品.\n詳細細節如：尺碼， 顏色，等";
    [self.descriptionCell addSubview:descriptionTextView];
}

- (void) initializeHashtagCell
{
    self.hashtagCell = [[UITableViewCell alloc] init];
    self.hashtagCell.selectionStyle = UITableViewCellSelectionStyleNone;
    CGSize windowSize = [[UIScreen mainScreen] bounds].size;
    
    hashTagTextView = [[SZTextView alloc] initWithFrame:CGRectMake(10, 0, windowSize.width, windowSize.height/6)];
    hashTagTextView.text = [self.itemInfoDict objectForKey:ITEM_HASH_TAG_KEY];
    hashTagTextView.font = [UIFont systemFontOfSize:17];
    hashTagTextView.placeholder = @"鍵入關於所需物品的井字號，好讓賣家滿足您所望.\n列如： #Coach #LV #Prada";
    [self.hashtagCell addSubview:hashTagTextView];
}

#pragma mark - Event Handling
- (void) doneButtonEvent
{
    [self.itemInfoDict setObject:itemNameTextField.text forKey:ITEM_NAME_KEY];
    [self.itemInfoDict setObject:descriptionTextView.text forKey:ITEM_DESC_KEY];
    [self.itemInfoDict setObject:hashTagTextView.text forKey:ITEM_HASH_TAG_KEY];
    
    [self.delegate itemInfoTableViewController:self didPressDone:self.itemInfoDict];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return self.itemNameCell;
    } else if (indexPath.row == 1) {
        return self.descriptionCell;
    } else if (indexPath.row == 2) {
        return self.hashtagCell;
    }
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return @" ";
}

#pragma mark - Table view delegate
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize windowSize = [[UIScreen mainScreen] bounds].size;
    if (indexPath.row == 0) {
        return 35;
    }else if (indexPath.row == 1) {
        return windowSize.height * 0.3;
    } else if (indexPath.row == 2) {
        return windowSize.height/6;
    }
    
    return 0;
}

- (void) tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor clearColor];
}



@end
