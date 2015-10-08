//
//  InboxAllViewController.h
//  whunted
//
//  Created by thomas nguyen on 17/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ChatView.h"

@class InboxAllViewController;

//-----------------------------------------------------------------------------------------------------------------------------
@protocol InboxAllViewDelegate <NSObject>
//-----------------------------------------------------------------------------------------------------------------------------

- (void) inboxAllViewController: (InboxAllViewController *) controller didRetrieveNumOfUnreadConversations: (NSInteger) num;

@end

//-----------------------------------------------------------------------------------------------------------------------------
@interface InboxAllViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ChatViewDelegate>
//-----------------------------------------------------------------------------------------------------------------------------

@property (nonatomic)   id<InboxAllViewDelegate>    delegate;

@property (nonatomic)   NSInteger                   numOfUnreadConversations;

- (void) openChatConversationWithGroupID: (NSString *) groupID;

@end
