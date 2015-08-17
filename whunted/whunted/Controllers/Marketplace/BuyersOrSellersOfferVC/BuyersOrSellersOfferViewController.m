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

@property (nonatomic, strong) UILabel       *summaryLabel;
@property (nonatomic, strong) UILabel       *priceAskingLabel;
@property (nonatomic, strong) UILabel       *deliveryAskingLabel;
@property (nonatomic, strong) UILabel       *instructionLabel;
@property (nonatomic, strong) UITextField   *offeredPriceTextField;
@property (nonatomic, strong) UITextField   *offeredDeliveryTextField;

@end

@implementation BuyersOrSellersOfferViewController
{
    CGFloat     _startingYPos;
    
    UILabel     *_deliveryTimeUnitLabel;
}

@synthesize offerData                   =   _offerData;
@synthesize buyerName                   =   _buyerName;
@synthesize isEditingOffer              =   _isEditingOffer;
@synthesize summaryLabel                =   _summaryLabel;
@synthesize priceAskingLabel            =   _priceAskingLabel;
@synthesize deliveryAskingLabel         =   _deliveryAskingLabel;
@synthesize instructionLabel            =   _instructionLabel;
@synthesize offeredPriceTextField       =   _offeredPriceTextField;
@synthesize offeredDeliveryTextField    =   _offeredDeliveryTextField;
@synthesize delegate                    =   _delegate;
@synthesize user2                       =   _user2;

//------------------------------------------------------------------------------------------------------------------------------
- (void) viewDidLoad
//------------------------------------------------------------------------------------------------------------------------------
{
    [super viewDidLoad];
    
    [self initData];
    [self customizeUI];
    [self addSummaryLabel];
    [self addPriceAskingLabel];
    [self addOfferedPriceTextField];
    [self addDeliveryAskingLabel];
    [self addOfferedDeliveryTextField];
    [self addDeliveryTimeUnitLabel];
    [self addInstructionLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) didReceiveMemoryWarning
//------------------------------------------------------------------------------------------------------------------------------
{
    [super didReceiveMemoryWarning];
    NSLog(@"BuyersOrSellersOfferViewController didReceiveMemoryWarning");
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) initData
//------------------------------------------------------------------------------------------------------------------------------
{
    _startingYPos = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
}

#pragma mark - UI Handlers

//------------------------------------------------------------------------------------------------------------------------------
- (void) customizeUI
//------------------------------------------------------------------------------------------------------------------------------
{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClickedHandler)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Submit", nil) style:UIBarButtonItemStylePlain target:self action:@selector(submitButtonClickedHandler)];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addSummaryLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    NSString *text = [NSString stringWithFormat:@"%@ %@ %@", _buyerName, NSLocalizedString(@"wants to buy at", nil), _offerData.originalDemandedPrice];
    _summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, _startingYPos + 20, WINSIZE.width - 40, 20)];
    _summaryLabel.textAlignment = NSTextAlignmentCenter;
    [_summaryLabel setText:text];
    [_summaryLabel setTextColor:TEXT_COLOR_DARK_GRAY];
    [_summaryLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:16]];
    [self.view addSubview:_summaryLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addPriceAskingLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    _priceAskingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, _startingYPos + 45, WINSIZE.width - 40, 20)];
    _priceAskingLabel.textAlignment = NSTextAlignmentCenter;
    [_priceAskingLabel setText:NSLocalizedString(@"Your offer is ", nil)];
    [_priceAskingLabel setTextColor:TEXT_COLOR_DARK_GRAY];
    [_priceAskingLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:16]];
    [self.view addSubview:_priceAskingLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addOfferedPriceTextField
//------------------------------------------------------------------------------------------------------------------------------
{
    _offeredPriceTextField = [[UITextField alloc] initWithFrame:CGRectMake(40, _startingYPos + 75, WINSIZE.width - 80, 60)];
    _offeredPriceTextField.minimumFontSize  =   15;
    _offeredPriceTextField.text             =   _offerData.offeredPrice;
    _offeredPriceTextField.textColor        =   TEXT_COLOR_DARK_GRAY;
    _offeredPriceTextField.textAlignment    =   NSTextAlignmentCenter;
    _offeredPriceTextField.font             =   [UIFont fontWithName:REGULAR_FONT_NAME size:30];
    _offeredPriceTextField.placeholder      =   _offerData.originalDemandedPrice;
    _offeredPriceTextField.keyboardType     =   UIKeyboardTypeNumbersAndPunctuation;
    _offeredPriceTextField.tag              =   103;
    _offeredPriceTextField.delegate         =   self;
    [_offeredPriceTextField addTarget:self action:@selector(priceTextFieldDidChange) forControlEvents:UIControlEventEditingChanged];
    
    // customize keyboard
    _offeredPriceTextField.inputView        =   ({
        APNumberPad *numberPad = [APNumberPad numberPadWithDelegate:self];
        // configure function button
        [numberPad.leftFunctionButton setTitle:DOT_CHARACTER forState:UIControlStateNormal];
        numberPad.leftFunctionButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        [numberPad.leftFunctionButton setBackgroundImage:[Utilities imageWithColor:[UIColor colorWithRed:251/255.0f green:251/255.0f blue:251/255.0f alpha:1.0f]] forState:UIControlStateNormal];
        numberPad;
    });
    
    // add done button above the keyboard
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width, 50.0f)];
    container.backgroundColor   =   [UIColor colorWithRed:251/255.0f green:251/255.0f blue:251/255.0f alpha:1.0f];
    
    UIView *horizontalLine      =   [[UIView alloc] initWithFrame:CGRectMake(0, 49.5f, WINSIZE.width, 0.5f)];
    horizontalLine.backgroundColor = GRAY_COLOR_LIGHT;
    [container addSubview:horizontalLine];
    
    UIButton *doneButton = [[UIButton alloc] init];
    [doneButton setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
    [doneButton setTitleColor:MAIN_BLUE_COLOR forState:UIControlStateNormal];
    [doneButton sizeToFit];
    CGFloat const kButtonWidth  =   doneButton.frame.size.width;
    CGFloat const kButtonHeight =   doneButton.frame.size.height;
    CGFloat const kButtonXPos   =   WINSIZE.width - kButtonWidth - 20.0f;
    CGFloat const kButtonYPos   =   (50.0f - kButtonHeight) / 2;
    doneButton.frame = CGRectMake(kButtonXPos, kButtonYPos, kButtonWidth, kButtonHeight);
    [doneButton addTarget:self action:@selector(priceKeyboardDoneButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:doneButton];
    _offeredPriceTextField.inputAccessoryView = container;
    
    [self.view addSubview:_offeredPriceTextField];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addDeliveryAskingLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    _deliveryAskingLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, _startingYPos + 140, WINSIZE.width - 40, 20)];
    _deliveryAskingLabel.textAlignment = NSTextAlignmentCenter;
    [_deliveryAskingLabel setText:NSLocalizedString(@"You can deliver in", nil)];
    [_deliveryAskingLabel setTextColor:TEXT_COLOR_DARK_GRAY];
    [_deliveryAskingLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:16]];
    [self.view addSubview:_deliveryAskingLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addOfferedDeliveryTextField
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kTextFieldWidth   =   50.0f;
    CGFloat const kTextFieldHeight  =   40.0f;
    CGFloat const kTextFieldXPos    =   (WINSIZE.width - kTextFieldWidth)/2 - 30.0f;
    CGFloat const kTextFieldYPos    =   _startingYPos + 175;
    
    _offeredDeliveryTextField = [[UITextField alloc] initWithFrame:CGRectMake(kTextFieldXPos, kTextFieldYPos, kTextFieldWidth, kTextFieldHeight)];
    _offeredDeliveryTextField.minimumFontSize   =   15;
    _offeredDeliveryTextField.textColor         =   TEXT_COLOR_DARK_GRAY;
    _offeredDeliveryTextField.text              =   _offerData.deliveryTime;
    _offeredDeliveryTextField.textAlignment     =   NSTextAlignmentCenter;
    _offeredDeliveryTextField.font              =   [UIFont fontWithName:REGULAR_FONT_NAME size:25];
    _offeredDeliveryTextField.placeholder       =   @"5";
    _offeredDeliveryTextField.delegate          =   self;
    
    // customize keyboard
    _offeredDeliveryTextField.inputView        =   ({
        APNumberPad *numberPad = [APNumberPad numberPadWithDelegate:self];
        // configure function button
        [numberPad.leftFunctionButton setBackgroundImage:[Utilities imageWithColor:[UIColor colorWithRed:251/255.0f green:251/255.0f blue:251/255.0f alpha:1.0f]] forState:UIControlStateNormal];
        numberPad;
    });
    
    // add done button above the keyboard
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WINSIZE.width, 50.0f)];
    container.backgroundColor   =   [UIColor colorWithRed:251/255.0f green:251/255.0f blue:251/255.0f alpha:1.0f];
    
    UIView *horizontalLine      =   [[UIView alloc] initWithFrame:CGRectMake(0, 49.5f, WINSIZE.width, 0.5f)];
    horizontalLine.backgroundColor = GRAY_COLOR_LIGHT;
    [container addSubview:horizontalLine];
    
    UIButton *doneButton = [[UIButton alloc] init];
    [doneButton setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
    [doneButton setTitleColor:MAIN_BLUE_COLOR forState:UIControlStateNormal];
    [doneButton sizeToFit];
    CGFloat const kButtonWidth  =   doneButton.frame.size.width;
    CGFloat const kButtonHeight =   doneButton.frame.size.height;
    CGFloat const kButtonXPos   =   WINSIZE.width - kButtonWidth - 20.0f;
    CGFloat const kButtonYPos   =   (50.0f - kButtonHeight) / 2;
    doneButton.frame = CGRectMake(kButtonXPos, kButtonYPos, kButtonWidth, kButtonHeight);
    [doneButton addTarget:self action:@selector(deliveryKeyboardDoneButtonTapEventHandler) forControlEvents:UIControlEventTouchUpInside];
    [container addSubview:doneButton];
    _offeredDeliveryTextField.inputAccessoryView = container;
    
    [self.view addSubview:_offeredDeliveryTextField];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addDeliveryTimeUnitLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kLabelWidth = 60.0f;
    CGFloat const kLabelHeight = 40.0f;
    CGFloat const kLabelXPos = _offeredDeliveryTextField.frame.origin.x + _offeredDeliveryTextField.frame.size.width;
    CGFloat const kLabelYPos = _offeredDeliveryTextField.frame.origin.y;
    
    _deliveryTimeUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelXPos, kLabelYPos, kLabelWidth, kLabelHeight)];
    _deliveryTimeUnitLabel.text = NSLocalizedString(@"days", nil);
    _deliveryTimeUnitLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:22];
    _deliveryTimeUnitLabel.textColor = TEXT_COLOR_DARK_GRAY;
    [self.view addSubview:_deliveryTimeUnitLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addInstructionLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    _instructionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, _startingYPos + 230, WINSIZE.width - 40, 20)];
    _instructionLabel.textAlignment = NSTextAlignmentCenter;
    _instructionLabel.text = @"Tap to change";
    _instructionLabel.textColor = [UIColor grayColor];
    _instructionLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:15];
    [self.view addSubview:_instructionLabel];
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

//------------------------------------------------------------------------------------------------------------------------------
- (void) priceKeyboardDoneButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    if ([_offeredPriceTextField.text isEqualToString:TAIWAN_CURRENCY])
        _offeredPriceTextField.text = nil;
    
    [_offeredPriceTextField resignFirstResponder];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) deliveryKeyboardDoneButtonTapEventHandler
//------------------------------------------------------------------------------------------------------------------------------
{
    if ([_offeredDeliveryTextField.text integerValue] <= 1)
        _deliveryTimeUnitLabel.text = NSLocalizedString(@"day", nil);
    else
        _deliveryTimeUnitLabel.text = NSLocalizedString(@"days", nil);
    
    [_offeredDeliveryTextField resignFirstResponder];
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
        return newLength <= 3;
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
