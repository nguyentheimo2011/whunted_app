//
//  MyWantViewController.m
//  whunted
//
//  Created by thomas nguyen on 21/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "MyWantViewController.h"
#import "HorizontalLineViewController.h"

@interface MyWantViewController ()

@end

@implementation MyWantViewController
{
    UITableView *wantTableView;
    CGSize windowSize;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    windowSize = [[UIScreen mainScreen] bounds].size;
    
    HorizontalLineViewController *horizontalLineVC = [[HorizontalLineViewController alloc] init];
    CGRect frame = horizontalLineVC.view.frame;
    horizontalLineVC.view.frame = CGRectMake(0, 80, windowSize.width, frame.size.height);
    [self.view addSubview:horizontalLineVC.view];

    wantTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, windowSize.width, windowSize.height * 0.8)];
    [self.view addSubview:wantTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
