//
//  CategoryTableViewController.m
//  whunted
//
//  Created by thomas nguyen on 18/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "CategoryTableViewController.h"

@interface CategoryTableViewController ()

@end

@implementation CategoryTableViewController
{
    NSArray *categoryList;
    NSUInteger selectedIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    categoryList = [NSArray arrayWithObjects:@"美容產品", @"書籍雜誌", @"品牌產品", @"遊戲玩具", @"專業服務", @"體育器材", @"門票優惠券", @"手錶", @"定制產品", @"我想藉", @"家具", @"其他", nil];
    
    selectedIndex = [categoryList indexOfObject:self.category];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [categoryList count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"CategoryCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    cell.textLabel.text = [categoryList objectAtIndex:indexPath.row];
    if (indexPath.row == selectedIndex) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (selectedIndex != NSNotFound) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    selectedIndex = indexPath.row;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    NSString *selectedCategory = [categoryList objectAtIndex:indexPath.row];
    [self.delegte categoryTableViewController:self didSelectCategory:selectedCategory];
}


 

@end
