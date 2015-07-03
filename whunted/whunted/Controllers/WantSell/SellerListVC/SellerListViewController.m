//
//  SellerListViewController.m
//  whunted
//
//  Created by thomas nguyen on 5/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "SellerListViewController.h"
#import "OfferData.h"
#import "Utilities.h"

@interface SellerListViewController ()

@end

@implementation SellerListViewController
{
    
}

@synthesize sellerTableView;
@synthesize wantData;
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Handlers
- (void) addTableView
{
    sellerTableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    sellerTableView.dataSource = self;
    sellerTableView.delegate = self;
    [self.view addSubview:sellerTableView];
}

#pragma mark - table view datasource method
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [wantData.sellersOfferList count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SellerListCell";
    SellerListCell *cell = (SellerListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[SellerListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    OfferData *offerData = [wantData.sellersOfferList objectAtIndex:indexPath.row];
    [cell.sellerUsernameButton setTitle:offerData.sellerID forState:UIControlStateNormal];
    [cell.sellersOfferedPrice setText:offerData.offeredPrice];
    [cell.sellersOfferedDelivery setText:offerData.deliveryTime];
    
    if (!wantData.isDealClosed) {
        [cell addButtonsIfNotAccepted];
    }
    
    cell.delegate = self;
    cell.offerData = offerData;
    
    return cell;
}

#pragma mark - TableView Delegate methods

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark - SellerListCell delegate mothods

- (void) sellerListCell:(SellerListCell *)cell didAcceptOfferFromSeller:(OfferData *)offerData
{
    [wantData setIsDealClosed:YES];
    [[wantData getPFObject] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"Update successfully");
        } else {
            NSLog(@"Update unsuccessfully");
        }
        
        PFObject *obj = [offerData getPFObjectWithClassName:@"AcceptedOffer"];
        [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"Upload to AcceptedOffer successfully");
            } else {
                NSLog(@"Upload to AcceptedOffer unsuccessfully");
            }
            
            [delegate sellerListViewController:self didAcceptOfferFromSeller:wantData];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

@end
