//
//  SellersOfferViewController.m
//  whunted
//
//  Created by thomas nguyen on 3/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "BuyersOrSellersOfferViewController.h"
#import "AppConstant.h"
#import "OfferData.h"
#import "Utilities.h"
#import "recent.h"

@interface BuyersOrSellersOfferViewController ()

@property (nonatomic, strong) UILabel *summaryLabel;
@property (nonatomic, strong) UILabel *priceAskingLabel;
@property (nonatomic, strong) UILabel *deliveryAskingLabel;
@property (nonatomic, strong) UILabel *instructionLabel;
@property (nonatomic, strong) UITextField *offeredPriceTextField;
@property (nonatomic, strong) UITextField *offeredDeliveryTextField;

@end

@implementation BuyersOrSellersOfferViewController
{
    CGFloat startingYPos;
}

@synthesize offerData = _offerData;
@synthesize buyerName = _buyerName;
@synthesize isEditingOffer = _isEditingOffer;
@synthesize summaryLabel = _summaryLabel;
@synthesize priceAskingLabel = _priceAskingLabel;
@synthesize deliveryAskingLabel = _deliveryAskingLabel;
@synthesize instructionLabel = _instructionLabel;
@synthesize offeredPriceTextField = _offeredPriceTextField;
@synthesize offeredDeliveryTextField = _offeredDeliveryTextField;
@synthesize delegate = _delegate;
@synthesize user2 = _user2;

//------------------------------------------------------------------------------------------------------------------------------
- (void)viewDidLoad
//------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:LIGHTEST_GRAY_COLOR];
    startingYPos = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;;
    
    [self addSummaryLabel];
    [self addPriceAskingLabel];
    [self addOfferedPriceTextField];
    [self addDeliveryAskingLabel];
    [self addOfferedDeliveryTextField];
    [self addInstructionLabel];
    [self customizeNavigationBar];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void)didReceiveMemoryWarning
//------------------------------------------------------------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - UI Handlers

//------------------------------------------------------------------------------------------------------------------------------
- (void) addSummaryLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    NSString *text = [NSString stringWithFormat:@"%@ %@ %@", _buyerName, NSLocalizedString(@"wants to buy at", nil), _offerData.originalDemandedPrice];
    _summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, startingYPos + 20, WINSIZE.width - 40, 20)];
    _summaryLabel.textAlignment = NSTextAlignmentCenter;
    [_summaryLabel setText:text];
    [_summaryLabel setTextColor:[UIColor grayColor]];
    [_summaryLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:15]];
    [self.view addSubview:_summaryLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addPriceAskingLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    _priceAskingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, startingYPos + 45, WINSIZE.width - 40, 20)];
    _priceAskingLabel.textAlignment = NSTextAlignmentCenter;
    [_priceAskingLabel setText:NSLocalizedString(@"Your offer is ", nil)];
    [_priceAskingLabel setTextColor:[UIColor grayColor]];
    [_priceAskingLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:15]];
    [self.view addSubview:_priceAskingLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addOfferedPriceTextField
//------------------------------------------------------------------------------------------------------------------------------
{
    _offeredPriceTextField = [[UITextField alloc] initWithFrame:CGRectMake(40, startingYPos + 75, WINSIZE.width - 80, 60)];
    _offeredPriceTextField.minimumFontSize = 15;
    [_offeredPriceTextField setText:_offerData.offeredPrice];
    [_offeredPriceTextField setTextColor:[UIColor grayColor]];
    [_offeredPriceTextField setTextAlignment:NSTextAlignmentCenter];
    [_offeredPriceTextField setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:30]];
    [_offeredPriceTextField setPlaceholder:_offerData.originalDemandedPrice];
    [_offeredPriceTextField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    _offeredPriceTextField.delegate = self;
    _offeredPriceTextField.tag = 103;
    _offeredPriceTextField.inputView = ({
        APNumberPad *numberPad = [APNumberPad numberPadWithDelegate:self];
        // configure function button
        [numberPad.leftFunctionButton setTitle:DOT_CHARACTER forState:UIControlStateNormal];
        numberPad.leftFunctionButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        numberPad;
    });
    [self.view addSubview:_offeredPriceTextField];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addDeliveryAskingLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    _deliveryAskingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, startingYPos + 140, WINSIZE.width - 40, 20)];
    _deliveryAskingLabel.textAlignment = NSTextAlignmentCenter;
    [_deliveryAskingLabel setText:NSLocalizedString(@"You can deliver in", nil)];
    [_deliveryAskingLabel setTextColor:[UIColor grayColor]];
    [_deliveryAskingLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:15]];
    [self.view addSubview:_deliveryAskingLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addOfferedDeliveryTextField
//------------------------------------------------------------------------------------------------------------------------------
{
    _offeredDeliveryTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, startingYPos + 175, WINSIZE.width - 120, 40)];
    _offeredDeliveryTextField.minimumFontSize = 15;
    [_offeredDeliveryTextField setTextColor:[UIColor grayColor]];
    [_offeredDeliveryTextField setText:_offerData.deliveryTime];
    [_offeredDeliveryTextField setTextAlignment:NSTextAlignmentCenter];
    [_offeredDeliveryTextField setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:25]];
    [_offeredDeliveryTextField setPlaceholder:@"1 week"];
    _offeredDeliveryTextField.delegate = self;
    [_offeredPriceTextField addTarget:self action:@selector(priceTextFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_offeredDeliveryTextField];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addInstructionLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    _instructionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, startingYPos + 230, WINSIZE.width - 40, 20)];
    _instructionLabel.textAlignment = NSTextAlignmentCenter;
    [_instructionLabel setText:@"Tap to change"];
    [_instructionLabel setTextColor:[UIColor grayColor]];
    [_instructionLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:15]];
    [self.view addSubview:_instructionLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) customizeNavigationBar
//------------------------------------------------------------------------------------------------------------------------------
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClickedHandler)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStylePlain target:self action:@selector(submitButtonClickedHandler)];
}

#pragma mark - Event Handlers

//------------------------------------------------------------------------------------------------------------------------------
- (void) cancelButtonClickedHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    [self.navigationController popViewControllerAnimated:YES];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) submitButtonClickedHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    _offerData.offeredPrice = _offeredPriceTextField.text;
    _offerData.deliveryTime = _offeredDeliveryTextField.text;
    _offerData.initiatorID = [PFUser currentUser].objectId;
    _offerData.offerStatus = PF_OFFER_STATUS_OFFERED;
    
    if (_offerData.offeredPrice == nil || _offerData.offeredPrice.length == 0) {
        _offerData.offeredPrice = _offerData.originalDemandedPrice;
    }
    
    if (_offerData.deliveryTime == nil || _offerData.deliveryTime.length == 0) {
        _offerData.deliveryTime = @"1 week";
    }
    
    PFObject *offerObj = [_offerData getPFObjectWithClassName:PF_OFFER_CLASS];
    [ offerObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (!error) {
            [_offerData setObjectID:offerObj.objectId];
            
            NSString *groupId;
            if (_user2) {
                groupId = StartPrivateChat([PFUser currentUser], _user2, _offerData);
            } else {
                NSString *id1 = _offerData.buyerID;
                NSString *id2 = _offerData.sellerID;
                
                groupId = ([id1 compare:id2] < 0) ? [NSString stringWithFormat:@"%@%@%@", _offerData.itemID, id1, id2] : [NSString stringWithFormat:@"%@%@%@", _offerData.itemID, id2, id1];
            }
            
            [self.navigationController popViewControllerAnimated:YES];
            
            [_delegate buyersOrSellersOfferViewController:self didOffer:_offerData];
            
            // Update recent message with new offer details
            NSString *message = [NSString stringWithFormat:@"Made An Offer\n  %@  \nDeliver in %@", _offerData.offeredPrice, _offerData.deliveryTime];
            UpdateRecentOffer1(groupId, _offerData.objectID, _offerData.initiatorID, _offerData.offeredPrice, _offerData.deliveryTime, _offerData.offerStatus, message);
        } else {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

#pragma mark - TextField delegate methods

//------------------------------------------------------------------------------------------------------------------------------
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//------------------------------------------------------------------------------------------------------------------------------
{
    // Prevent crashing undo bug – see note below.
    
    if (textField.tag == 103) {
        if (range.location >= [TAIWAN_CURRENCY length]) {
            NSString *resultantString = [Utilities getResultantStringFromText:textField.text andRange:range andReplacementString:string];
            return [Utilities checkIfIsValidPrice:resultantString];
        } else
            return NO;
    } else {
        if(range.length + range.location > textField.text.length)
        {
            return NO;
        }
        
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return newLength <= 13;
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) textFieldDidBeginEditing:(UITextField *)textField
//------------------------------------------------------------------------------------------------------------------------------
{
    if (textField.tag == 103) {
        if ([textField.text length] == 0) {
            NSString *text = [TAIWAN_CURRENCY stringByAppendingString:textField.text];
            textField.text = text;
        }
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) textFieldDidEndEditing:(UITextField *)textField
//------------------------------------------------------------------------------------------------------------------------------
{
    if (textField.tag == 103) {
        NSString *text = [Utilities removeLastDotCharacterIfNeeded:textField.text];
        [textField setText:text];
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) priceTextFieldDidChange
//------------------------------------------------------------------------------------------------------------------------------
{
    [_offeredPriceTextField setText:[Utilities formatPriceText:_offeredPriceTextField.text]];
}

#pragma mark - APNumberPad

//------------------------------------------------------------------------------------------------------------------------------
- (void)numberPad:(APNumberPad *)numberPad functionButtonAction:(UIButton *)functionButton textInput:(UIResponder<UITextInput> *)textInput
//------------------------------------------------------------------------------------------------------------------------------
{
    NSRange range = {[[_offeredPriceTextField text] length], 1};
    if ([self textField:_offeredPriceTextField shouldChangeCharactersInRange:range replacementString:DOT_CHARACTER])
        [textInput insertText:DOT_CHARACTER];
}

@end
