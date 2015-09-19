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

#import <Parse/Parse.h>

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
    
    if (self != nil)
    {
        [self initData];
        [self retrieveTransactionDataList];
        
        [self customizeUI];
        [self addNewsfeedTableView];
    }
    return self;
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//-----------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) viewWillAppear:(BOOL)animated
//-----------------------------------------------------------------------------------------------------------------------------
{
    [super viewWillAppear:animated];
    
    [Utilities sendScreenNameToGoogleAnalyticsTracker:@"NewsfeedScreen"];
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
    _newsfeedTableView.backgroundColor = WHITE_GRAY_COLOR;
    [self.view addSubview:_newsfeedTableView];
}


#pragma - UITableViewDataSource methods

//-----------------------------------------------------------------------------------------------------------------------------
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//-----------------------------------------------------------------------------------------------------------------------------
{
    return _transactionDataList.count;
}

//-----------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//-----------------------------------------------------------------------------------------------------------------------------
{
    static NSString *cellIdentifier = @"NewsFeedTableViewCell";

    NewsfeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil) {
        cell = [[NewsfeedTableViewCell alloc] init];
        [cell initUI];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell setTransactionData:[_transactionDataList objectAtIndex:indexPath.row]];

    return cell;
}

//-----------------------------------------------------------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//-----------------------------------------------------------------------------------------------------------------------------
{
    return NEWSFEED_CELL_HEIGHT;
}


#pragma mark - Backend

//-----------------------------------------------------------------------------------------------------------------------------
- (void) retrieveTransactionDataList
//-----------------------------------------------------------------------------------------------------------------------------
{
    _transactionDataList = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:PF_ACCEPTED_TRANSACTION_CLASS];
    [query orderByDescending:PF_UPDATED_AT];
    [query findObjectsInBackgroundWithBlock:^(NSArray *transactionObjects, NSError *error)
    {
        if (!error)
        {
            for (PFObject *object in transactionObjects) {
                TransactionData *transactionData = [[TransactionData alloc] initWithPFObject:object];
                [_transactionDataList addObject:transactionData];
            }
            
            [_newsfeedTableView reloadData];
        }
        else
        {
            [Utilities handleError:error];
        }
    }];
}


@end

