//
//  SellerListViewController.m
//  whunted
//
//  Created by thomas nguyen on 5/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "SellerListViewController.h"
#import "SellerListCell.h"
#import "Utilities.h"

@interface SellerListViewController ()

@end

@implementation SellerListViewController
{
    
}

@synthesize sellerTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Handlers
- (void) addTableView
{
    sellerTableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    sellerTableView.dataSource = self;
    sellerTableView.delegate = self;
    [self.view addSubview:sellerTableView];
}

#pragma mark - table view datasource method
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SellerListCell";
    SellerListCell *cell = (SellerListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[SellerListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

#pragma mark - TableView Delegate methods

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

@end
