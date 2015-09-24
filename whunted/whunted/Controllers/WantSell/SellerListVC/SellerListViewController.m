//
//  SellerListViewController.m
//  whunted
//
//  Created by thomas nguyen on 5/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "SellerListViewController.h"
#import "TransactionData.h"
#import "Utilities.h"
#import "AppConstant.h"

@implementation SellerListViewController
{
    
}

@synthesize sellerTableView = _sellerTableView;
@synthesize wantData = _wantData;
@synthesize delegate = _delegate;

//--------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//--------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    
    [self addTableView];
}

//--------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
//--------------------------------------------------------------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UI Handlers

//--------------------------------------------------------------------------------------------------------------------------------
- (void) addTableView
//--------------------------------------------------------------------------------------------------------------------------------
{
    _sellerTableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _sellerTableView.dataSource = self;
    _sellerTableView.delegate = self;
    [self.view addSubview:_sellerTableView];
}

#pragma mark - table view datasource method

//--------------------------------------------------------------------------------------------------------------------------------
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//--------------------------------------------------------------------------------------------------------------------------------
{
    return [_wantData.sellersOfferList count];
}

//--------------------------------------------------------------------------------------------------------------------------------
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//--------------------------------------------------------------------------------------------------------------------------------
{
    static NSString *cellIdentifier = @"SellerListCell";
    SellerListCell *cell = (SellerListCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[SellerListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    TransactionData *offerData = [_wantData.sellersOfferList objectAtIndex:indexPath.row];
    [cell.sellerUsernameButton setTitle:offerData.sellerID forState:UIControlStateNormal];
    [cell.sellersOfferedPrice setText:offerData.offeredPrice];
    [cell.sellersOfferedDelivery setText:offerData.deliveryTime];
    
    if (!_wantData.isFulfilled) {
        [cell addButtonsIfNotAccepted];
    }
    
    cell.delegate = self;
    cell.offerData = offerData;
    
    return cell;
}

#pragma mark - TableView Delegate methods

//--------------------------------------------------------------------------------------------------------------------------------
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//--------------------------------------------------------------------------------------------------------------------------------
{
    return 80;
}

#pragma mark - SellerListCell delegate mothods

//--------------------------------------------------------------------------------------------------------------------------------
- (void) sellerListCell:(SellerListCell *)cell didAcceptOfferFromSeller:(TransactionData *)offerData
//--------------------------------------------------------------------------------------------------------------------------------
{
    _wantData.isFulfilled = YES;
    [[_wantData getPFObject] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
//            NSLog(@"Update successfully");
        } else {
//            NSLog(@"Update unsuccessfully");
        }
        
        PFObject *obj = [offerData getPFObjectWithClassName:PF_ACCEPTED_TRANSACTION_CLASS];
        [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
//                NSLog(@"Upload to AcceptedOffer successfully");
            } else {
//                NSLog(@"Upload to AcceptedOffer unsuccessfully");
            }
            
            [_delegate sellerListViewController:self didAcceptOfferFromSeller:_wantData];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

@end
