//
//  OfferViewingVC.h
//  whunted
//
//  Created by thomas nguyen on 7/9/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ChatView.h"
#import "WantData.h"

//-----------------------------------------------------------------------------------------------------------------------------
@interface OfferViewingVC : UIViewController <UITableViewDataSource, UITableViewDelegate>
//-----------------------------------------------------------------------------------------------------------------------------

@property (nonatomic, strong)   UIImage     *itemImage;
@property (nonatomic, strong)   WantData    *wantData;

@end
