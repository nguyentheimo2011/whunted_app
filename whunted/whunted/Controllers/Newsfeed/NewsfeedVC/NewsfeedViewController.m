//
//  NewsfeedViewController.m
//  whunted
//
//  Created by thomas nguyen on 2/9/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "NewsfeedViewController.h"
#import "NewsfeedTableViewCell.h"
#import "AppConstant.h"
#import "Utilities.h"

@implementation NewsfeedViewController
{
    UITableView                 *_newsfeedTableView;
    
    NSMutableArray              *_transactionDataList;
}

//-----------------------------------------------------------------------------------------------------------------------------
- (id)init
//-----------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    if (self != nil) {
        
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//-----------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    
    [self initData];
    
    [self customizeUI];
    [self addNewsfeedTableView];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
//-----------------------------------------------------------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Data Initialization

//-----------------------------------------------------------------------------------------------------------------------------
- (void) initData
//-----------------------------------------------------------------------------------------------------------------------------
{
    
}


#pragma mark - UI

//-----------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI
//-----------------------------------------------------------------------------------------------------------------------------
{
    [Utilities customizeTitleLabel:NSLocalizedString(@"Newsfeed", nil) forViewController:self];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) addNewsfeedTableView
//-----------------------------------------------------------------------------------------------------------------------------
{
    _newsfeedTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width, WINSIZE.height)];
    _newsfeedTableView.separatorColor = [UIColor whiteColor];
    _newsfeedTableView.delegate = self;
    _newsfeedTableView.dataSource = self;
    [self.view addSubview:_newsfeedTableView];
}


#pragma - UITableViewDataSource methods

//-----------------------------------------------------------------------------------------------------------------------------
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//-----------------------------------------------------------------------------------------------------------------------------
{
    return 10;
}

//-----------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//-----------------------------------------------------------------------------------------------------------------------------
{
    static NSString *cellIdentifier = @"NewsFeedTableViewCell";

    NewsfeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil) {
        cell = [[NewsfeedTableViewCell alloc] initCellWithTransactionData:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    return cell;
}

//-----------------------------------------------------------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//-----------------------------------------------------------------------------------------------------------------------------
{
    return NEWSFEED_CELL_HEIGHT;
}


@end

