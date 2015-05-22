//
//  MyWantViewController.m
//  whunted
//
//  Created by thomas nguyen on 21/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "MyWantViewController.h"
#import "HorizontalLineViewController.h"
#import "MyWantTableViewCell.h"

@interface MyWantViewController ()

@end

@implementation MyWantViewController
{
    UITableView *wantTableView;
    UICollectionView *wantCollectionView;
    HorizontalLineViewController *horizontalLineVC;
    CGSize windowSize;
}

- (id) initWithWantDataList: (NSArray *) wantDataList
{
    self = [super init];
    if (self != nil) {
        self.wantDataList = [NSMutableArray arrayWithArray:wantDataList];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    windowSize = [[UIScreen mainScreen] bounds].size;
    
    [self addHorizontalLine];
    [self addTableView];
}

- (void) addHorizontalLine
{
    CGSize navBarSize = self.navigationController.navigationBar.frame.size;
    
    horizontalLineVC = [[HorizontalLineViewController alloc] init];
    CGRect frame = horizontalLineVC.view.frame;
    horizontalLineVC.view.frame = CGRectMake(0, navBarSize.height + 15, windowSize.width, frame.size.height);
    NSString *labelText = [NSString stringWithFormat:@"%d wants", [self.wantDataList count]];
    [horizontalLineVC.numLabel setText:labelText];
    [self.view addSubview:horizontalLineVC.view];
}

- (void) addTableView
{
    wantTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, windowSize.width, windowSize.height * 0.7)];
    wantTableView.dataSource = self;
    wantTableView.delegate = self;
    [self.view addSubview:wantTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return windowSize.width * 1.3;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MyWantTableViewCell";
    
    [tableView registerNib:[UINib nibWithNibName:cellIdentifier bundle:nil] forCellReuseIdentifier:cellIdentifier];
    MyWantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

@end
