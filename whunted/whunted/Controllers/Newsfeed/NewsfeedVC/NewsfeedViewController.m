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
        [self customizeUI];
        [self addTextView];
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


#pragma mark - UI

//-----------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI
//-----------------------------------------------------------------------------------------------------------------------------
{
    [Utilities customizeTitleLabel:NSLocalizedString(@"Mystery Function", nil) forViewController:self];
    
    self.view.backgroundColor = LIGHTEST_GRAY_COLOR;
}

//-----------------------------------------------------------------------------------------------------------------------------
- (void) addTextView
//-----------------------------------------------------------------------------------------------------------------------------
{
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(20.0f, 15.0f, WINSIZE.width - 40.0f, WINSIZE.height)];
    textView.editable = NO;
    textView.text = NSLocalizedString(@"NewsFeed Message", nil);
    textView.textColor = TEXT_COLOR_DARK_GRAY;
    textView.font = [UIFont fontWithName:REGULAR_FONT_NAME size:SMALL_FONT_SIZE];
    textView.backgroundColor = LIGHTEST_GRAY_COLOR;
    [self.view addSubview:textView];
}


#pragma mark - Next version

/*
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
 */


@end

