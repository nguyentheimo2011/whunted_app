//
//  SellersOfferViewController.m
//  whunted
//
//  Created by thomas nguyen on 3/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "BuyersOrSellersOfferViewController.h"
#import "AppConstant.h"
#import "TransactionData.h"
#import "Utilities.h"
#import "recent.h"

#import <MBProgressHUD.h>

@implementation BuyersOrSellersOfferViewController
{
    UILabel         *_summaryLabel;
    UILabel         *_priceAskingLabel;
    UILabel         *_deliveryAskingLabel;
    UILabel         *_instructionLabel;
    UILabel         *_deliveryTimeUnitLabel;
    
    UITextField     *_offeredPriceTextField;
    UITextField     *_offeredDeliveryTextField;
    
    CGFloat         _startingYPos;
}

@synthesize offerData               =   _offerData;
@synthesize buyerName               =   _buyerName;
@synthesize isEditingOffer          =   _isEditingOffer;
@synthesize delegate                =   _delegate;
@synthesize user2                   =   _user2;
@synthesize offerFrom               =   _offerFrom;

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
    CGFloat const kLabelLeftMargin  =   20.0f;
    CGFloat const kLabelYPos        =   _startingYPos + 20;
    CGFloat const kLabelWidth       =   WINSIZE.width - 40;
    CGFloat const kLabelHeight      =   50.0f;
    
    NSString *text = [NSString stringWithFormat:@"%@ %@ %@", _buyerName, NSLocalizedString(@"wants to buy at", nil), _offerData.originalDemandedPrice];
    _summaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelLeftMargin, kLabelYPos, kLabelWidth, kLabelHeight)];
    _summaryLabel.textAlignment = NSTextAlignmentCenter;
    [_summaryLabel setText:text];
    [_summaryLabel setTextColor:TEXT_COLOR_DARK_GRAY];
    [_summaryLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:DEFAULT_FONT_SIZE]];
    _summaryLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _summaryLabel.numberOfLines = 2;
    [self.view addSubview:_summaryLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addPriceAskingLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kLabelLeftMargin  =   20.0f;
    CGFloat const kLabelTopMargin   =   20.0f;
    CGFloat const kLabelYPos        =   _summaryLabel.frame.origin.y + _summaryLabel.frame.size.height + kLabelTopMargin;
    CGFloat const kLabelWidth       =   WINSIZE.width - 40.0f;
    CGFloat const kLabelHeight      =   20.0f;
    
    _priceAskingLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelLeftMargin, kLabelYPos, kLabelWidth, kLabelHeight)];
    _priceAskingLabel.textAlignment = NSTextAlignmentCenter;
    [_priceAskingLabel setText:NSLocalizedString(@"Your offer is ", nil)];
    [_priceAskingLabel setTextColor:TEXT_COLOR_DARK_GRAY];
    [_priceAskingLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:DEFAULT_FONT_SIZE]];
    [self.view addSubview:_priceAskingLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addOfferedPriceTextField
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kTextFieldLeftMargin  =   40.0f;
    CGFloat const kTextFieldTopMargin   =   0.0f;
    CGFloat const kTextFieldYPos        =   _priceAskingLabel.frame.origin.y + _priceAskingLabel.frame.size.height + kTextFieldTopMargin;
    CGFloat const kTextFieldWidth       =   WINSIZE.width - 80.0f;
    CGFloat const kTextFieldHeight      =   60.0f;
    
    _offeredPriceTextField = [[UITextField alloc] initWithFrame:CGRectMake(kTextFieldLeftMargin, kTextFieldYPos, kTextFieldWidth, kTextFieldHeight)];
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
    CGFloat const kLabelLeftMargin  =   0.0f;
    CGFloat const kLabelTopMargin   =   15.0f;
    CGFloat const kLabelYPos        =   _offeredPriceTextField.frame.origin.y + _offeredPriceTextField.frame.size.height + kLabelTopMargin;
    CGFloat const kLabelHeight      =   20.0f;
    
    _deliveryAskingLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelLeftMargin, kLabelYPos, 0, kLabelHeight)];
    _deliveryAskingLabel.textAlignment = NSTextAlignmentCenter;
    [_deliveryAskingLabel setText:NSLocalizedString(@"You can deliver in", nil)];
    [_deliveryAskingLabel setTextColor:TEXT_COLOR_DARK_GRAY];
    [_deliveryAskingLabel setFont:[UIFont fontWithName:REGULAR_FONT_NAME size:DEFAULT_FONT_SIZE]];
    [_deliveryAskingLabel sizeToFit];
    [self.view addSubview:_deliveryAskingLabel];
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addOfferedDeliveryTextField
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kTextFieldWidth       =   40.0f;
    CGFloat const kTextFieldHeight      =   20.0f;
    CGFloat const kTextFieldXPos        =   _deliveryAskingLabel.frame.origin.x + _deliveryAskingLabel.frame.size.width;
    CGFloat const kTextFieldYPos        =   _deliveryAskingLabel.frame.origin.y;
    
    _offeredDeliveryTextField = [[UITextField alloc] initWithFrame:CGRectMake(kTextFieldXPos, kTextFieldYPos, kTextFieldWidth, kTextFieldHeight)];
    _offeredDeliveryTextField.minimumFontSize   =   15;
    _offeredDeliveryTextField.textColor         =   TEXT_COLOR_DARK_GRAY;
    _offeredDeliveryTextField.text              =   _offerData.deliveryTime;
    _offeredDeliveryTextField.textAlignment     =   NSTextAlignmentCenter;
    _offeredDeliveryTextField.font              =   [UIFont fontWithName:BOLD_FONT_NAME size:18];
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
    CGFloat const kLabelWidth = 40.0f;
    CGFloat const kLabelHeight = 20.0f;
    CGFloat const kLabelXPos = _offeredDeliveryTextField.frame.origin.x + _offeredDeliveryTextField.frame.size.width;
    CGFloat const kLabelYPos = _offeredDeliveryTextField.frame.origin.y;
    
    _deliveryTimeUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelXPos, kLabelYPos, kLabelWidth, kLabelHeight)];
    _deliveryTimeUnitLabel.text = NSLocalizedString(@"days", nil);
    _deliveryTimeUnitLabel.font = [UIFont fontWithName:REGULAR_FONT_NAME size:DEFAULT_FONT_SIZE];
    _deliveryTimeUnitLabel.textColor = TEXT_COLOR_DARK_GRAY;
    [self.view addSubview:_deliveryTimeUnitLabel];
    
    // cemtralize delivery label
    CGFloat rightSpaceWidth     =   WINSIZE.width - _deliveryTimeUnitLabel.frame.origin.x - _deliveryTimeUnitLabel.frame.size.width;
    CGFloat correctLeftMargin   =   rightSpaceWidth/2;
    _deliveryAskingLabel.frame = CGRectMake(correctLeftMargin, _deliveryAskingLabel.frame.origin.y, _deliveryAskingLabel.frame.size.width, _deliveryAskingLabel.frame.size.height);
    _offeredDeliveryTextField.frame = CGRectMake(_offeredDeliveryTextField.frame.origin.x + correctLeftMargin, _offeredDeliveryTextField.frame.origin.y, _offeredDeliveryTextField.frame.size.width, _offeredDeliveryTextField.frame.size.height);
    _deliveryTimeUnitLabel.frame = CGRectMake(_deliveryTimeUnitLabel.frame.origin.x + correctLeftMargin, _deliveryTimeUnitLabel.frame.origin.y, _deliveryTimeUnitLabel.frame.size.width, _deliveryTimeUnitLabel.frame.size.height);
    
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) addInstructionLabel
//------------------------------------------------------------------------------------------------------------------------------
{
    CGFloat const kLabelLeftMargin  =   20.0f;
    CGFloat const kLabelTopMargin   =   10.0f;
    CGFloat const kLabelYPos        =   _deliveryTimeUnitLabel.frame.origin.y + _deliveryTimeUnitLabel.frame.size.height + kLabelTopMargin;
    CGFloat const kLabelWidth       =   WINSIZE.width - 40.0f;
    CGFloat const kLabelHeight      =   20.0f;
    
    _instructionLabel = [[UILabel alloc] initWithFrame:CGRectMake(kLabelLeftMargin, kLabelYPos, kLabelWidth, kLabelHeight)];
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
    _offerData.offeredPrice         =   _offeredPriceTextField.text;
    _offerData.deliveryTime         =   _offeredDeliveryTextField.text;
    _offerData.initiatorID          =   [PFUser currentUser].objectId;
    _offerData.transactionStatus    =   TRANSACTION_STATUS_ONGOING;
    
    if (_offerData.offeredPrice == nil || _offerData.offeredPrice.length == 0) {
        _offerData.offeredPrice = _offerData.originalDemandedPrice;
    }
    
    if (_offerData.deliveryTime == nil || _offerData.deliveryTime.length == 0) {
        _offerData.deliveryTime = @"5";
    }
    
    BOOL offerChanged = _offerData.objectID.length > 0;
    
    PFObject *offerObj = [_offerData getPFObjectWithClassName:PF_ONGOING_TRANSACTION_CLASS];
    [offerObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        if (!error) {
            [_offerData setObjectID:offerObj.objectId];
            
            if (!offerChanged && ![_offerFrom isEqualToString:OFFER_FROM_CHAT_VIEW]) {
                StartPrivateChat([PFUser currentUser], _user2, _offerData);
            }
            
            [_delegate buyersOrSellersOfferViewController:self didOffer:_offerData];
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
    if ([_offeredPriceTextField.text integerValue] > 0 && [_offeredDeliveryTextField.text integerValue] <= 1)
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
