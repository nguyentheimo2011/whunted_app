//
//  InboxAllViewController.m
//  whunted
//
//  Created by thomas nguyen on 17/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "InboxAllViewController.h"
#import "MessageViewCell.h"
#import "ChatView.h"
#import "AppConstant.h"
#import "converter.h"
#import <Firebase/Firebase.h>

@interface InboxAllViewController ()

@property (nonatomic, strong) UITableView *_inboxTableView;
@property (nonatomic, strong) Firebase *_firebase;
@property (nonatomic, strong) NSMutableArray *_recentMessages;

@end

@implementation InboxAllViewController

@synthesize _inboxTableView;
@synthesize _firebase;
@synthesize _recentMessages;

- (id) init
{
    self = [super init];
    if (self != nil) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadRecents) name:NOTIFICATION_APP_STARTED object:nil];
        [self addInboxTableView];
        _recentMessages = [NSMutableArray array];
        [self loadRecents];
    }
    
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Inbox";
    [_inboxTableView registerNib:[UINib nibWithNibName:@"MessageViewCell" bundle:nil] forCellReuseIdentifier:@"MessageViewCell"];
}

- (void) addInboxTableView
{
    _inboxTableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _inboxTableView.delegate = self;
    _inboxTableView.dataSource = self;
    [self.view addSubview:_inboxTableView];
}

#pragma mark - Backend methods
//------------------------------------------------------------------------------------------------------------------------------
- (void)loadRecents
//------------------------------------------------------------------------------------------------------------------------------
{
    PFUser *user = [PFUser currentUser];
    if ((user != nil) && (_firebase == nil))
    {
        _firebase = [[Firebase alloc] initWithUrl:[NSString stringWithFormat:@"%@/Recent", FIREBASE]];
        FQuery *query = [[_firebase queryOrderedByChild:@"userId"] queryEqualToValue:user.objectId];
        [query observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot)
         {
             [_recentMessages removeAllObjects];
             if (snapshot.value != [NSNull null])
             {
                 NSArray *sorted = [[snapshot.value allValues] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
                                    {
                                        NSDictionary *recent1 = (NSDictionary *)obj1;
                                        NSDictionary *recent2 = (NSDictionary *)obj2;
                                        NSDate *date1 = String2Date(recent1[@"date"]);
                                        NSDate *date2 = String2Date(recent2[@"date"]);
                                        return [date2 compare:date1];
                                    }];
                 for (NSDictionary *recent in sorted)
                 {
                     [_recentMessages addObject:recent];
                 }
             }
             [_inboxTableView reloadData];
         }];
    }
}

#pragma mark - UITableView Datasource Delegate methods

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_recentMessages count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"MessageViewCell";
    MessageViewCell *cell = (MessageViewCell *) [_inboxTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell bindData:_recentMessages[indexPath.row]];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [_inboxTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *recent = _recentMessages[indexPath.row];
    ChatView *chatView = [[ChatView alloc] initWith:recent[@"groupId"]];
    chatView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatView animated:YES];
}

@end
