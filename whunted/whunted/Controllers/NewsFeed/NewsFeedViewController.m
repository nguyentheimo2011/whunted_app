//
//  NewsFeedViewController.m
//  whunted
//
//  Created by thomas nguyen on 5/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "NewsFeedViewController.h"
#import "NewsFeedTableViewCell.h"

@interface NewsFeedViewController ()

- (void) addBarItems;

@end

@implementation NewsFeedViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.newsfeedList = [[NSMutableArray alloc] initWithObjects:@"One",@"Two",@"Three",@"Four",@"Five",@"Six",@"Seven",@"Eight",@"Nine",@"Ten",nil];
    
    [self addBarItems];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) addBarItems
{
    UIImage *searchImage = [UIImage imageNamed:@"search.png"];
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithImage:searchImage style:UIBarButtonItemStylePlain target:self action:nil];
    
    UIImage *chatImage = [UIImage imageNamed:@"chat.png"];
    UIBarButtonItem *chatButton = [[UIBarButtonItem alloc] initWithImage:chatImage style:UIBarButtonItemStylePlain target:self action:nil];
    
    UIImage *profile = [UIImage imageNamed:@"profile.png"];
    UIBarButtonItem *profileButton = [[UIBarButtonItem alloc] initWithImage:profile style:UIBarButtonItemStylePlain target:self action:nil];
    
    UIBarButtonItem *buyButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:nil];
    
    NSArray *actionButtonItems = @[buyButton, profileButton, chatButton, searchButton];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    
    UIImage *appIcon = [UIImage imageNamed:@"app_icon.png"];
    UIBarButtonItem *appIconButton = [[UIBarButtonItem alloc] initWithImage:appIcon style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.leftBarButtonItem = appIconButton;
    self.navigationItem.leftBarButtonItem.enabled = NO;
}

#pragma - TableView Delegate Methods
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.newsfeedList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"NewsFeedTableViewCell";
    
    NewsFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    [cell.itemImageView setBackgroundColor:[UIColor colorWithRed:135.0/255 green:206.0/255 blue:255.0/255 alpha:1]];
    [cell.itemName setText:@"Coach"];
    
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:[NSString stringWithFormat:@"Selected Value is %@",[self.newsfeedList objectAtIndex:indexPath.row]] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//    [alertView show];
//}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300;
}


@end
