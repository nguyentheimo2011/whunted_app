//
//  WantDetailsViewController.m
//  whunted
//
//  Created by thomas nguyen on 16/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "WantDetailsViewController.h"

@interface WantDetailsViewController ()

@property (strong, nonatomic) NSMutableArray *addingButtonList;
@property (strong, nonatomic) UITableViewCell *buttonListCell;

@property (strong, nonatomic) UITableViewCell *categoryCell;
@property (strong, nonatomic) UITableViewCell *itemNameCell;
@property (strong, nonatomic) UITableViewCell *itemInfoCell;
@property (strong, nonatomic) UITableViewCell *priceCell;
@property (strong, nonatomic) UITableViewCell *locationCell;
@property (strong, nonatomic) UITableViewCell *escrowRequestCell;

@property (strong, nonatomic) NSMutableDictionary *wantDetailsDict;

@end

@implementation WantDetailsViewController
{
    NSString *selectedCategory;
    NSString *selectedLocation;
}

- (id) init
{
    self = [super init];
    
    if (self != nil) {
        [self initializeButtonListCell];
        [self initializeSecondSection];
        self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
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
        [addingButton addTarget:self action:@selector(addingButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonListCell addSubview:addingButton];
        [self.addingButtonList addObject:addingButton];
    }
}

- (void) initializeSecondSection
{
    self.categoryCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"category"];
    self.categoryCell.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.8f];
    self.categoryCell.textLabel.text = @"Category";
    self.categoryCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.categoryCell.detailTextLabel.text = @"Choose category";
    self.categoryCell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    
    self.itemNameCell = [[UITableViewCell alloc] init];
    self.itemNameCell.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.8f];
    self.itemNameCell.textLabel.text = @"Item name";
    UITextField *itemTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    UIColor *color = [UIColor colorWithRed:123/255.0 green:123/255.0 blue:129/255.0 alpha:0.8];
    itemTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Item name" attributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName: [UIFont systemFontOfSize:15]}];
    self.itemNameCell.accessoryView = itemTextField;
    self.itemNameCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.itemInfoCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"item info"];
    self.itemInfoCell.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.8f];
    self.itemInfoCell.textLabel.text = @"Item info";
    self.itemInfoCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.itemInfoCell.detailTextLabel.text = @"What are you buying?";
    self.itemInfoCell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    
    self.priceCell = [[UITableViewCell alloc] init];
    self.priceCell.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.8f];
    self.priceCell.textLabel.text = @"Your price";
    UITextField *priceTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    priceTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Set a price" attributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName: [UIFont systemFontOfSize:15]}];
    self.priceCell.accessoryView = priceTextField;
    self.priceCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.locationCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"location"];
    self.locationCell.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.8f];
    self.locationCell.textLabel.text = @"Location";
    self.locationCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.locationCell.detailTextLabel.text = @"Where to meet?";
    self.locationCell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    
    self.escrowRequestCell = [[UITableViewCell alloc] init];
    self.escrowRequestCell.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.8f];
    self.escrowRequestCell.textLabel.text = @"Request for Escrow?";
    self.escrowRequestCell.accessoryView = [[UISwitch alloc] init];
    self.escrowRequestCell.selectionStyle = UITableViewCellSelectionStyleNone;
}

#pragma mark - Set image back ground for button

- (void) setImage:(UIImage *)image forButton:(NSUInteger)buttonIndex
{
    [[self.addingButtonList objectAtIndex: buttonIndex] setBackgroundImage:image forState:UIControlStateNormal];
    
    NSString *key = [NSString stringWithFormat:@"itemImage%lu", (unsigned long)buttonIndex];
    [self.wantDetailsDict setObject:image forKey:key];
}

#pragma mark - Event Handling

- (void) addingButtonEvent: (id) sender
{
    UIButton *button = (UIButton *) sender;
    [self.delegate wantDetailsViewController:self didPressButton:[button tag]];
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
        case 2:  return 6;  // section 1 has 5 rows
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
                case 1: return self.itemNameCell;
                case 2: return self.itemInfoCell;
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
        case 1: return @"DETAILS";
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
            catVC.category = selectedCategory;
            [self.navigationController pushViewController:catVC animated:YES];
        } else if (indexPath.row == 2) {
            ItemInfoTableViewController *itemInfoVC = [[ItemInfoTableViewController alloc] init];
            itemInfoVC.delegate = self;
            [self.navigationController pushViewController:itemInfoVC animated:YES];
        } else if (indexPath.row == 4) {
            LocationTableViewController *locVC = [[LocationTableViewController alloc] init];
            locVC.delegate = self;
            locVC.location = selectedLocation;
            [self.navigationController pushViewController:locVC animated:YES];
        }
    }
}

#pragma mark - CategoryTableViewControllerDelegate

- (void) categoryTableViewController:(CategoryTableViewController *)controller didSelectCategory:(NSString *)category
{
    selectedCategory = category;
    [self.navigationController popViewControllerAnimated:YES];
    self.categoryCell.detailTextLabel.text = selectedCategory;
}

#pragma mark - LocationTableViewControllerDelegate
- (void) locationTableViewController:(LocationTableViewController *)controller didSelectLocation:(NSString *)location
{
    selectedLocation = location;
    [self.navigationController popViewControllerAnimated:YES];
    self.locationCell.detailTextLabel.text = selectedLocation;
}

#pragma mark - ItemInfoTableViewController
- (void) itemInfoTableViewController:(ItemInfoTableViewController *)controller didPressDone:(NSDictionary *)itemInfo
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
