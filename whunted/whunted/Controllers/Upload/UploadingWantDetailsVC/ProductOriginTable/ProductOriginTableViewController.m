//
//  ProductOriginTableViewController.m
//  whunted
//
//  Created by thomas nguyen on 23/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "ProductOriginTableViewController.h"

@interface ProductOriginTableViewController ()

@end

@implementation ProductOriginTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CountryNames" ofType:@"plist"]];
    NSLog(@"%lu", (unsigned long)[dictionary count]);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

@end
