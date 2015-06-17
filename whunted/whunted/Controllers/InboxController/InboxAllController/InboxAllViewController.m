//
//  InboxAllViewController.m
//  whunted
//
//  Created by thomas nguyen on 17/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "InboxAllViewController.h"
#import "MessageViewCell.h"
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
        [self addInboxTableView];
    }
    
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
}

- (void) addInboxTableView
{
    _inboxTableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _inboxTableView.delegate = self;
    _inboxTableView.dataSource = self;
    [self.view addSubview:_inboxTableView];
}

#pragma mark - UITableView Datasource Delegate methods
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"MessageViewCell";
    MessageViewCell *cell = (MessageViewCell *) [_inboxTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [topLevelObjects objectAtIndex:0];
    }
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0;
}

@end
