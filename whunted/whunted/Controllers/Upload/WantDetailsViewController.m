//
//  WantDetailsViewController.m
//  whunted
//
//  Created by thomas nguyen on 16/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "WantDetailsViewController.h"

@interface WantDetailsViewController ()

@property (strong, nonatomic) UIButton *firstAddingButton;
@property (strong, nonatomic) UIButton *secondAddingButton;
@property (strong, nonatomic) UIButton *thirdAddingButton;
@property (strong, nonatomic) UIButton *fourthAddingButton;
@property (strong, nonatomic) UITableViewCell *buttonListCell;

@property (strong, nonatomic) UITableViewCell *categoryCell;
@property (strong, nonatomic) UITableViewCell *itemCell;
@property (strong, nonatomic) UITableViewCell *priceCell;
@property (strong, nonatomic) UITableViewCell *locationCell;
@property (strong, nonatomic) UITableViewCell *escrowRequestCell;

@end

@implementation WantDetailsViewController

- (void) loadView
{
    [super loadView];
    
    [self initializeButtonListCell];
    [self initializeSecondSection];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Initialization

- (void) initializeButtonListCell
{
    self.buttonListCell = [[UITableViewCell alloc] init];
    self.buttonListCell.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f];
    CGSize imageSize = [UIImage imageNamed:@"squareplus.png"].size;
    CGSize windowSize = [[UIScreen mainScreen] bounds].size;
    CGFloat spaceWidth = (windowSize.width - 4 * imageSize.width) / 5.0;

    self.firstAddingButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.firstAddingButton setBackgroundImage:[UIImage imageNamed:@"squareplus.png"] forState:UIControlStateNormal];
    [self.firstAddingButton setEnabled:YES];
    self.firstAddingButton.frame = CGRectMake(spaceWidth, imageSize.width/6.0, imageSize.width, imageSize.height);
    [self.buttonListCell addSubview:self.firstAddingButton];
    
    self.secondAddingButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.secondAddingButton setBackgroundImage:[UIImage imageNamed:@"squareplus.png"] forState:UIControlStateNormal];
    [self.secondAddingButton setEnabled:YES];
    self.secondAddingButton.frame = CGRectMake(2*spaceWidth + imageSize.width, imageSize.width/6.0, imageSize.width, imageSize.height);
    [self.buttonListCell addSubview:self.secondAddingButton];
    
    self.thirdAddingButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.thirdAddingButton setBackgroundImage:[UIImage imageNamed:@"squareplus.png"] forState:UIControlStateNormal];
    [self.thirdAddingButton setEnabled:YES];
    self.thirdAddingButton.frame = CGRectMake(3*spaceWidth + 2*imageSize.width, imageSize.width/6.0, imageSize.width, imageSize.height);
    [self.buttonListCell addSubview:self.thirdAddingButton];
    
    self.fourthAddingButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.fourthAddingButton setBackgroundImage:[UIImage imageNamed:@"squareplus.png"] forState:UIControlStateNormal];
    [self.fourthAddingButton setEnabled:YES];
    self.fourthAddingButton.frame = CGRectMake(4*spaceWidth + 3*imageSize.width, imageSize.width/6.0, imageSize.width, imageSize.height);
    [self.buttonListCell addSubview:self.fourthAddingButton];
}

- (void) initializeSecondSection
{
    self.categoryCell = [[UITableViewCell alloc] init];
    self.categoryCell.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f];
    self.categoryCell.textLabel.text = @"Category";
    
    self.itemCell = [[UITableViewCell alloc] init];
    self.itemCell.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f];
    self.itemCell.textLabel.text = @"Item";
    
    self.priceCell = [[UITableViewCell alloc] init];
    self.priceCell.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f];
    self.priceCell.textLabel.text = @"Item price";
    
    self.locationCell = [[UITableViewCell alloc] init];
    self.locationCell.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f];
    self.locationCell.textLabel.text = @"Location";
    
    self.escrowRequestCell = [[UITableViewCell alloc] init];
    self.escrowRequestCell.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f];
    self.escrowRequestCell.textLabel.text = @"Escrow Request";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    switch(section)
    {
        case 0:  return 1;  // section 0 has 1 row
        case 1:  return 5;  // section 1 has 5 rows
        default: return 0;
    };
}

// Return the row for the corresponding section and row
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.section)
    {
        case 0:
            return self.buttonListCell;
        case 1:
            switch(indexPath.row)
            {
                case 0: return self.categoryCell;
                case 1: return self.itemCell;
                case 2: return self.priceCell;
                case 3: return self.locationCell;
                case 4: return self.escrowRequestCell;
            }
    }
    return self.buttonListCell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 80.0f;
            break;
        case 1:
            return 40;
            
        default:
            return 40;
            break;
    }
}


@end
