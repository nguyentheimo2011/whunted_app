//
//  ItemInfoTableViewController.m
//  whunted
//
//  Created by thomas nguyen on 18/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "ItemInfoTableViewController.h"
#include <SZTextView/SZTextView.h>

@interface ItemInfoTableViewController ()

@property (nonatomic, strong) UITableViewCell *descriptionCell;
@property (nonatomic,strong) UITableViewCell *hashtagCell;

@end

@implementation ItemInfoTableViewController

- (void) loadView
{
    [super loadView];
    [self initializeDescriptionCell];
    [self initializeHashtagCell];
    self.view.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1.0];
    self.navigationItem.title = @"Item Info";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonEvent)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initialization 
- (void) initializeDescriptionCell
{
    self.descriptionCell = [[UITableViewCell alloc] init];
    CGSize windowSize = [[UIScreen mainScreen] bounds].size;
    
    SZTextView *textView = [[SZTextView alloc] initWithFrame:CGRectMake(10, 0, windowSize.width, windowSize.height/3)];
    textView.placeholder = @"Descibe more about the item that you want.\nE.g. Size, condition, color, etc.";
    [self.descriptionCell addSubview:textView];
}

- (void) initializeHashtagCell
{
    self.hashtagCell = [[UITableViewCell alloc] init];
    CGSize windowSize = [[UIScreen mainScreen] bounds].size;
    
    SZTextView *textView = [[SZTextView alloc] initWithFrame:CGRectMake(10, 0, windowSize.width, windowSize.height/6)];
    textView.placeholder = @"Enter hash tags for the item to help sellers find you.\nE.g. #shoes #bag #book, etc.";
    [self.hashtagCell addSubview:textView];
}

#pragma mark - Event Handling
- (void) doneButtonEvent
{
    [self.delegate itemInfoTableViewController:self didPressDone:[NSDictionary dictionaryWithObjectsAndKeys:@"", @"", nil]];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return self.descriptionCell;
    } else if (indexPath.row == 1) {
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
        return windowSize.height/3;
    } else if (indexPath.row == 1) {
        return windowSize.height/6;
    }
    
    return 0;
}

- (void) tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor clearColor];
}



@end
