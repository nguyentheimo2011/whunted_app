//
//  SellersOfferViewController.m
//  whunted
//
//  Created by thomas nguyen on 3/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "SellersOfferViewController.h"
#import "Utilities.h"
#import "SellersOfferData.h"

@interface SellersOfferViewController ()

@property (nonatomic, strong) UILabel *summaryLabel;
@property (nonatomic, strong) UILabel *priceAskingLabel;
@property (nonatomic, strong) UILabel *deliveryAskingLabel;
@property (nonatomic, strong) UILabel *instructionLabel;
@property (nonatomic, strong) UITextField *offeredPriceTextField;
@property (nonatomic, strong) UITextField *offeredDeliveryTextField;
@property (nonatomic, strong) UIActivityIndicatorView *activityLogin;

@end

@implementation SellersOfferViewController
{
    CGFloat startingYPos;
}

@synthesize wantData;
@synthesize summaryLabel;
@synthesize priceAskingLabel;
@synthesize deliveryAskingLabel;
@synthesize instructionLabel;
@synthesize offeredPriceTextField;
@synthesize offeredDeliveryTextField;
@synthesize activityLogin;
@synthesize delegate;
@synthesize currOfferedPrice;
@synthesize currOfferedDelivery;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:APP_COLOR_6];
    startingYPos = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;;
    
    [self addSummaryLabel];
    [self addPriceAskingLabel];
    [self addOfferedPriceTextField];
    [self addDeliveryAskingLabel];
    [self addOfferedDeliveryTextField];
    [self addInstructionLabel];
    [self customizeNavigationBar];
    [self addActivityIndicatorView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Handlers
- (void) addSummaryLabel
{
    NSString *text = [NSString stringWithFormat:@"%@ 要付 %@", wantData.buyer.objectId, wantData.demandedPrice];
    summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, startingYPos + 20, WINSIZE.width - 40, 20)];
    summaryLabel.textAlignment = NSTextAlignmentCenter;
    [summaryLabel setText:text];
    [summaryLabel setTextColor:[UIColor grayColor]];
    [summaryLabel setFont:[UIFont systemFontOfSize:15]];
    [self.view addSubview:summaryLabel];
}

- (void) addPriceAskingLabel
{
    priceAskingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, startingYPos + 45, WINSIZE.width - 40, 20)];
    priceAskingLabel.textAlignment = NSTextAlignmentCenter;
    [priceAskingLabel setText:@"你的出價是 "];
    [priceAskingLabel setTextColor:[UIColor grayColor]];
    [priceAskingLabel setFont:[UIFont systemFontOfSize:15]];
    [self.view addSubview:priceAskingLabel];
}

- (void) addOfferedPriceTextField
{
    offeredPriceTextField = [[UITextField alloc] initWithFrame:CGRectMake(40, startingYPos + 75, WINSIZE.width - 80, 60)];
    offeredPriceTextField.minimumFontSize = 15;
    [offeredPriceTextField setTextColor:[UIColor grayColor]];
    [offeredPriceTextField setText:currOfferedPrice];
    [offeredPriceTextField setTextAlignment:NSTextAlignmentCenter];
    [offeredPriceTextField setFont:[UIFont systemFontOfSize:30]];
    [offeredPriceTextField setPlaceholder:wantData.demandedPrice];
    [offeredPriceTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    offeredPriceTextField.delegate = self;
    offeredPriceTextField.tag = 103;
    [self.view addSubview:offeredPriceTextField];
}

- (void) addDeliveryAskingLabel
{
    deliveryAskingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, startingYPos + 140, WINSIZE.width - 40, 20)];
    deliveryAskingLabel.textAlignment = NSTextAlignmentCenter;
    [deliveryAskingLabel setText:@"你可以在多長時間里交貨"];
    [deliveryAskingLabel setTextColor:[UIColor grayColor]];
    [deliveryAskingLabel setFont:[UIFont systemFontOfSize:15]];
    [self.view addSubview:deliveryAskingLabel];
}

- (void) addOfferedDeliveryTextField
{
    offeredDeliveryTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, startingYPos + 175, WINSIZE.width - 120, 40)];
    offeredDeliveryTextField.minimumFontSize = 15;
    [offeredDeliveryTextField setTextColor:[UIColor grayColor]];
    [offeredDeliveryTextField setText:currOfferedDelivery];
    [offeredDeliveryTextField setTextAlignment:NSTextAlignmentCenter];
    [offeredDeliveryTextField setFont:[UIFont systemFontOfSize:25]];
    [offeredDeliveryTextField setPlaceholder:@"1 week"];
    offeredDeliveryTextField.delegate = self;
    [self.view addSubview:offeredDeliveryTextField];
}

- (void) addInstructionLabel
{
    instructionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, startingYPos + 230, WINSIZE.width - 40, 20)];
    instructionLabel.textAlignment = NSTextAlignmentCenter;
    [instructionLabel setText:@"Tap to change"];
    [instructionLabel setTextColor:[UIColor grayColor]];
    [instructionLabel setFont:[UIFont systemFontOfSize:15]];
    [self.view addSubview:instructionLabel];
}

- (void) customizeNavigationBar
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClickedHandler)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(submitButtonClickedHandler)];
}

- (void) addActivityIndicatorView
{
    activityLogin = [[UIActivityIndicatorView alloc] init];
    activityLogin.frame = CGRectMake(WINSIZE.width/2 - 25, WINSIZE.height/2 - 25, 50, 50);
    [self.view addSubview:self.activityLogin];
}

#pragma mark - Event Handlers
- (void) cancelButtonClickedHandler
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) submitButtonClickedHandler
{
    [activityLogin startAnimating];
    
    SellersOfferData *offerData = [[SellersOfferData alloc] init];
    offerData.sellerID = [[PFUser currentUser] objectId];
    offerData.itemID = wantData.itemID;
    offerData.offeredPrice = offeredPriceTextField.text;
    offerData.deliveryTime = offeredDeliveryTextField.text;
    
    if (offerData.offeredPrice == nil) {
        offerData.offeredPrice = wantData.demandedPrice;
    }
    
    if (offerData.deliveryTime == nil) {
        offerData.deliveryTime = @"";
    }
    
    [[offerData getPFObjectWithClassName:@"OfferedWant"] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        [activityLogin stopAnimating];
        
        if (!error) {
            [delegate sellerOfferViewController:self didOfferForItem:[offerData getPFObjectWithClassName:@"OfferedWant"]];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

#pragma mark - TextField delegate methods
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    if(range.length + range.location > textField.text.length)
    {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 13;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 103) {
        if ([textField.text length] == 0) {
            NSString *text = [@"TWD" stringByAppendingString:textField.text];
            textField.text = text;
        }
    }
}

@end
