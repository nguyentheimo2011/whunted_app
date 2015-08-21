//
//  AppConstant.h
//  whunted
//
//  Created by thomas nguyen on 15/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <Parse/Parse.h>

#ifndef whunted_AppConstant_h
#define whunted_AppConstant_h

//-----------------------------------------------------------------------------------------------------------------------------
#define     MAIN_BLUE_COLOR                     [UIColor colorWithRed:0.0/255 green:104.0/255 blue:189.0/255 alpha:1.0]
#define     DARK_BLUE_COLOR                     [UIColor colorWithRed:0.0/255 green:124.0/255 blue:220.0/255 alpha:1.0]
#define     DARKER_BLUE_COLOR                   [UIColor colorWithRed:0.0/255 green:64.0/255 blue:115.0/255 alpha:1.0]
#define     DARKEST_BLUE_COLOR                  [UIColor colorWithRed:0.0/255 green:50.0/255 blue:90.0/255 alpha:1.0]
#define     LIGHT_BLUE_COLOR                    [UIColor colorWithRed:33.0/255 green:154.0/255 blue:255.0/255 alpha:1.0]
#define     LIGHTEST_BLUE_COLOR                 [UIColor colorWithRed:80.0/255 green:176.0/255 blue:255.0/255 alpha:1.0]

//-----------------------------------------------------------------------------------------------------------------------------
#define     MAIN_ORANGE_COLOR                   [UIColor colorWithRed:255.0/255 green:76.0/255 blue:0.0/255 alpha:1.0]
#define     LIGHTEST_ORANGE_COLOR               [UIColor colorWithRed:255.0/255 green:123.0/255 blue:67.0/255 alpha:1.0]
#define     LIGHT_ORANGE_COLOR                  [UIColor colorWithRed:255.0/255 green:88.0/255 blue:17.0/255 alpha:1.0]

//-----------------------------------------------------------------------------------------------------------------------------
#define     MAIN_YELLOW_COLOR                   [UIColor colorWithRed:255.0/255 green:192.0/255 blue:0.0/255 alpha:1.0]
#define     LIGHTEST_YELLOW_COLOR               [UIColor colorWithRed:255.0/255 green:209.0/255 blue:67.0/255 alpha:1.0]
#define     LIGHT_YELLOW_COLOR                  [UIColor colorWithRed:255.0/255 green:197.0/255 blue:17.0/255 alpha:1.0]

//-----------------------------------------------------------------------------------------------------------------------------
#define     BRIGHT_BLUE_COLOR                   [UIColor colorWithRed:30.0/255 green:181.0/255 blue:236.0/255 alpha:1.0]
#define     CLASSY_BLUE_COLOR                   [UIColor colorWithRed:70.0/255 green:130.0/255 blue:180.0/255 alpha:1.0]
#define     VIVID_SKY_BLUE_COLOR                [UIColor colorWithRed:0.0/255 green:204.0/255 blue:255.0/255 alpha:1.0]
#define     PICTON_BLUE_COLOR                   [UIColor colorWithRed:69.0/255 green:177.0/255 blue:232.0/255 alpha:1.0]
#define     COLUMBIA_BLUE_COLOR                 [UIColor colorWithRed:155.0/255 green:221.0/255 blue:255.0/255 alpha:1.0]
#define     STAR_COMMAND_BLUE                   [UIColor colorWithRed:0.0/255 green:123.0/255 blue:184.0/255 alpha:1.0]
#define     TUFTS_BLUE_COLOR                    [UIColor colorWithRed:65.0/255 green:125.0/255 blue:193.0/255 alpha:1.0]
#define     CYAN_COLOR                          [UIColor colorWithRed:0.0/255 green:183.0/255 blue:235.0/255 alpha:1.0]
#define     DARK_CYAN_COLOR                     [UIColor colorWithRed:33.0/255 green:107.0/255 blue:150.0/255 alpha:1.0]

//-----------------------------------------------------------------------------------------------------------------------------
#define     DARK_SPRING_GREEN_COLOR             [UIColor colorWithRed:23.0/255 green:114.0/255 blue:69.0/255 alpha:1.0]
#define     PERSIAN_GREEN_COLOR                 [UIColor colorWithRed:0.0/255 green:166.0/255 blue:147.0/255 alpha:1.0]

//-----------------------------------------------------------------------------------------------------------------------------
#define     RED_ORAGNE_COLOR                    [UIColor colorWithRed:255.0/255 green:83.0/255 blue:73.0/255 alpha:1.0]
#define     TEA_ROSE_COLOR                      [UIColor colorWithRed:248.0/255 green:131.0/255 blue:121.0/255 alpha:1.0]

//-----------------------------------------------------------------------------------------------------------------------------
#define     JASMINE_YELLOW_COLOR                [UIColor colorWithRed:248.0/255 green:222.0/255 blue:126.0/255 alpha:1.0]
#define     GOLDEN_YELLOW_COLOR                 [UIColor colorWithRed:255.0/255 green:223.0/255 blue:0.0/255 alpha:1.0]

//-----------------------------------------------------------------------------------------------------------------------------
#define     GRAY_COLOR_LIGHT                    [UIColor colorWithRed:160.0/255 green:160.0/255 blue:160.0/255 alpha:1.0]
#define     GRAY_COLOR_LIGHTER                  [UIColor colorWithRed:175.0/255 green:175.0/255 blue:175.0/255 alpha:1.0]
#define     LIGHT_GRAY_COLOR                    [UIColor colorWithRed:192.0/255 green:192.0/255 blue:192.0/255 alpha:1.0]
#define     LIGHTER_GRAY_COLOR                  [UIColor colorWithRed:215.0/255 green:215.0/255 blue:215.0/255 alpha:1.0]
#define     LIGHTEST_GRAY_COLOR                 [UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1.0]
#define     WHITE_GRAY_COLOR                    [UIColor colorWithRed:250.0/255 green:250.0/255 blue:250.0/255 alpha:1.0]
#define     BACKGROUND_GRAY_COLOR               [UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1.0]
#define		COLOR_OUTGOING						[UIColor colorWithRed:0.0/255 green:122.0/255 blue:255.0/255 alpha:1.0]
#define     COLOR_OUTGOING_SENDING              [UIColor colorWithRed:204.0/255 green:229.0/255 blue:255.0/255 alpha:1.0]
#define		COLOR_INCOMING						[UIColor colorWithRed:230.0/255 green:229.0/255 blue:234.0/255 alpha:1.0]
#define     ACCEPTED_BUTTON_BACKGROUND_COLOR    [UIColor colorWithRed:0.0/255 green:172.0/255 blue:113.0/255 alpha:1.0]
#define     DARK_GRAY_COLOR                     [UIColor colorWithRed:54.0/255 green:60.0/255 blue:62.0/255 alpha:1.0]
#define     DARKER_GRAY_COLOR                   [UIColor colorWithRed:0.0/255 green:0.0/255 blue:0.0/255 alpha:1.0]
#define     CELL_SEPARATOR_GRAY_COLOR           [UIColor colorWithRed:188.0/255 green:186.0/255 blue:193.0/255 alpha:1.0]

//-----------------------------------------------------------------------------------------------------------------------------
#define     FLAT_BLUE_COLOR                     [UIColor colorWithRed:7/255.0f green:188/255.0f blue:248/255.0f alpha:1.0f]
#define     FLAT_GREEN_COLOR                    [UIColor colorWithRed:178/255.0f green:243/255.0f blue:88/255.0f alpha:1.0f]
#define     FLAT_GRAY_COLOR                     [UIColor colorWithRed:108/255.0f green:108/255.0f blue:108/255.0f alpha:1.0f]
#define     FLAT_BLUR_RED_COLOR                 [UIColor colorWithRed:236/255.0f green:66/255.0f blue:50/255.0f alpha:1.0f]
#define     FLAT_FRESH_RED_COLOR                [UIColor colorWithRed:233/255.0f green:0/255.0f blue:19/255.0f alpha:1.0f]

//-----------------------------------------------------------------------------------------------------------------------------
#define     TEXT_COLOR_DARK_GRAY                [UIColor colorWithRed:40/255.0 green:40/255.0 blue:40/255.0 alpha:1.0]
#define     TEXT_COLOR_GRAY                     [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0]
#define     PLACEHOLDER_TEXT_COLOR              [UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1.0]

//-----------------------------------------------------------------------------------------------------------------------------
#define     WINSIZE                             [[UIScreen mainScreen] bounds].size
#define     FLAT_BUTTON_HEIGHT                  35.0f
#define     kOFFSET_FOR_KEYBOARD                200.0f

//-----------------------------------------------------------------------------------------------------------------------------
#define     ITEM_NAME_KEY                       @"itemName"
#define     ITEM_DESC_KEY                       @"itemDescription"
#define     ITEM_HASH_TAG_KEY                   @"itemHashTag"
#define     ITEM_CATEGORY_KEY                   @"itemCategory"
#define     ITEM_PRICE_KEY                      @"itemPrice"
#define     ITEM_PAYMENT_METHOD                 @"paymentMethod"
#define     ITEM_LOCATION_KEY                   @"location"
#define     ITEM_ESCROW_OPTION_KEY              @"escrowOption"
#define     ITEM_SECONDHAND_OPTION              @"secondHandOption"
#define     ITEM_REFERENCE_LINK                 @"referenceLink"

//-----------------------------------------------------------------------------------------------------------------------------
#define     kItemDetailSelect                   @"Select"
#define     kItemDetailBrand                    @"Brand"
#define     kItemDetailModel                    @"Model"
#define     kHashtagTypeBrand                   @"HashtagTypeBrand"
#define     kHashtagTypeModel                   @"HashtagTypeModel"

//-----------------------------------------------------------------------------------------------------------------------------
#define     ACCEPTABLE_CHARECTERS               @"0123456789."

//-----------------------------------------------------------------------------------------------------------------------------
#define		PF_INSTALLATION_CLASS_NAME			@"_Installation"		//	Class name
#define		PF_INSTALLATION_OBJECTID			@"objectId"				//	String
#define		PF_INSTALLATION_USER				@"user"					//	Pointer to User Class

//-----------------------------------------------------------------------------------------------------------------------------
#define		PF_USER_CLASS_NAME					@"_User"				//	Class name
#define		PF_USER_OBJECTID					@"objectId"				//	String
#define     PF_USER_USERNAME                    @"username"             //  String
#define     PF_USER_PASSWORD                    @"password"             //  String
#define     PF_USER_EMAIL                       @"email"                //  String
#define     PF_USER_EMAIL_VERIFICATION          @"emailVerified"        //  Boolean
#define     PF_USER_FIRSTNAME                   @"firstName"            //  String
#define     PF_USER_LASTNAME                    @"lastName"             //  String
#define     PF_USER_GENDER                      @"gender"               //  String
#define     PF_USER_DOB                         @"dob"                  //  Date
#define		PF_USER_PICTURE						@"profilePicture"		//	File
#define     PF_USER_AREA_ADDRESS                @"areaAddress"          //  String
#define     PF_USER_CITY                        @"city"
#define     PF_USER_COUNTRY                     @"country"              //  String
#define     PF_USER_DESCRIPTION                 @"userDescription"      //  String
#define     PF_USER_PHONE_NUMBER                @"phoneNumber"          //  String
#define     PF_USER_FACEBOOK_VERIFIED           @"facebookVerified"     //  Boolean

//-----------------------------------------------------------------------------------------------------------------------------
#define     PF_ITEM_ID                          @"itemID"
#define     PF_ITEM_NAME                        @"itemName"
#define     PF_ITEM_DESC                        @"itemDesc"
#define     PF_ITEM_CATEGORY                    @"category"
#define     PF_ITEM_ORIGINS                     @"itemOrigins"
#define     PF_ITEM_PICTURE_LIST                @"itemPictures"
#define     PF_ITEM_DEMANDED_PRICE              @"demandedPrice"
#define     PF_ITEM_PAYMENT_METHOD              @"paymentMethod"
#define     PF_ITEM_ACCEPTED_SECONDHAND         @"acceptedSecondHand"
#define     PF_ITEM_MEETING_PLACE               @"meetingPlace"
#define     PF_ITEM_REFERENCE_URL               @"referenceURL"
#define     PF_ITEM_PICTURES_NUM                @"itemPicturesNum"
#define     PF_ITEM_BUYER_ID                    @"buyerID"
#define     PF_ITEM_BUYER_USERNAME              @"buyerUsername"
#define     PF_ITEM_HASHTAG_LIST                @"hashtaglist"
#define     PF_ITEM_CLOSED_DEAL                 @"isDealClosed"
#define     PF_ITEM_SELLERS_NUM                 @"sellersNum"
#define     PF_ITEM_LIKES_NUM                   @"likesNum"

//-----------------------------------------------------------------------------------------------------------------------------
#define     PF_OFFER_ID                         @"offerID"
#define     PF_BUYER_ID                         @"buyerID"
#define     PF_SELLER_ID                        @"sellerID"
#define     PF_INITIATOR_ID                     @"initiatorID"
#define     PF_ORIGINAL_DEMANDED_PRICE          @"originalDemandedPrice"
#define     PF_OFFERED_PRICE                    @"offeredPrice"
#define     PF_DELIVERY_TIME                    @"deliveryTime"
#define     PF_OFFER_STATUS                     @"offerStatus"

//-----------------------------------------------------------------------------------------------------------------------------
#define     OFFER_STATUS_NOT_OFFERED            @"NotOffered"
#define     OFFER_STATUS_OFFERED                @"Offered"
#define     OFFER_STATUS_CANCELLED              @"Cancelled"
#define     OFFER_STATUS_DECLINED               @"Declined"
#define     OFFER_STATUS_ACCEPTED               @"Accepted"

//-----------------------------------------------------------------------------------------------------------------------------
#define     PF_FEEDBACK_WRITER_ID               @"writerID"
#define     PF_FEEDBACK_RECEIVER_ID             @"receiverID"
#define     PF_FEEDBACK_RATING                  @"rating"
#define     PF_FEEDBACK_COMMENT                 @"comment"
#define     PF_FEEDBACK_IS_WRITER_THE_BUYER     @"isWriterTheBuyer"
#define     PF_CREATED_AT                       @"createdAt"
#define     PF_UPDATED_AT                       @"updatedAt"

// Firebase Chat Recent
//-----------------------------------------------------------------------------------------------------------------------------
#define     FB_RECENT_CHAT_ID                   @"recentChatID"
#define     FB_GROUP_ID                         @"groupID"
#define     FB_GROUP_MEMBERS                    @"groupMembers"
#define     FB_CHAT_INITIATOR                   @"chatInitiator"
#define     FB_SELF_USER_ID                     @"selfUserID"
#define     FB_OPPOSING_USER_ID                 @"opposingUserID"
#define     FB_OPPOSING_USER_USERNAME           @"opposingUserUsername"
#define     FB_LAST_MESSAGE                     @"lastMessage"
#define     FB_LAST_USER                        @"lastUser"
#define     FB_TIMESTAMP                        @"timestamp"
#define     FB_UNREAD_MESSAGES_COUNTER          @"unreadMessagesCounter"
#define     FB_ITEM_ID                          @"itemID"
#define     FB_ITEM_NAME                        @"itemName"
#define     FB_TRANSACTION_STATUS               @"transactionStatus"
#define     FB_TRANSACTION_LAST_USER            @"transactionLastUser"
#define     FB_ORIGINAL_DEMANDED_PRICE          @"originalDemandedPrice"
#define     FB_CURRENT_OFFER_ID                 @"currentOfferID"
#define     FB_CURRENT_OFFERED_PRICE            @"currentOfferedPrice"
#define     FB_CURRENT_OFFERED_DELIVERY_TIME    @"currentOfferedDeliveryTime"


//-----------------------------------------------------------------------------------------------------------------------------
#define		NOTIFICATION_USER_LOGGED_IN			@"NCUserLoggedIn"
#define		NOTIFICATION_USER_LOGGED_OUT		@"NCUserLoggedOut"

//----------------------------------------------------------------------------------------------------------------------------
#define     ESCROW_PAYMENT_METHOD               @"escrow"

//----------------------------------------------------------------------------------------------------------------------------
#define     FIREBASE                            @"https://incandescent-heat-6966.firebaseio.com/"

//----------------------------------------------------------------------------------------------------------------------------
#define		VIDEO_LENGTH						5

//----------------------------------------------------------------------------------------------------------------------------
#define     TAIWAN_CURRENCY                     @"TWD "
#define     DOT_CHARACTER                       @"."
#define     COMMA_CHARACTER                     @","
#define     WHITE_SPACE_CHARACTER               @" "


#pragma mark - Font

//----------------------------------------------------------------------------------------------------------------------------
#define     LIGHT_FONT_NAME                     @"HelveticaNeue-Light"
#define     REGULAR_FONT_NAME                   @"HelveticaNeue-Light"
#define     SEMIBOLD_FONT_NAME                  @"HelveticaNeue"
#define     BOLD_FONT_NAME                      @"HelveticaNeue-Medium"

#define     DEFAULT_FONT_SIZE                   17
#define     BIG_FONT_SIZE                       18
#define     SMALL_FONT_SIZE                     16
#define     DEFAULT_FONT                        [UIFont fontWithName:REGULAR_FONT_NAME size:DEFAULT_FONT_SIZE]

//----------------------------------------------------------------------------------------------------------------------------
#define     SYNC_IN_PROGRESS                    @"syncInProgess"

//----------------------------------------------------------------------------------------------------------------------------
#define     PF_OFFER_CLASS                      @"OfferedWant"
#define     PF_ACCEPTED_OFFER_CLASS             @"AcceptedOffer"
#define     PF_WANT_DATA_CLASS                  @"WantedPost"
#define     PF_FEEDBACK_DATA_CLASS              @"FeedbackData"

//----------------------------------------------------------------------------------------------------------------------------
#define     TAB_BAR_MARKETPLACE_PAGE_TITLE      @"Marketplace"
#define     TAB_BAR_NEWSFEED_PAGE_TITLE         @"Newsfeed"
#define     TAB_BAR_UPLOAD_PAGE_TITLE           @"Upload"
#define     TAB_BAR_INBOX_PAGE_TITLE            @"Chats"
#define     TAB_BAR_PROFILE_PAGE_TITLE          @"Profile"

//----------------------------------------------------------------------------------------------------------------------------
#define     NOTIFICATION_UPLOAD_MESSAGE_SUCCESSFULLY    @"uploadMessageSuccessfullyNotification"
#define     NOTIFICATION_WILL_UPLOAD_MESSAGE            @"willUploadMessageNotification"

//----------------------------------------------------------------------------------------------------------------------------
#define     USER_PROFILE_SELECT_CITY                    @"Select city"
#define     USER_PROFILE_BIO_PLACEHOLDER                @"Tell us about you"
#define     USER_PROFILE_USER_COUNTRY                   @"userCountry"
#define     USER_PROFILE_USER_CITY                      @"userCity"
#define     USER_PROFILE_GENDER_SELECT                  @"Select gender"
#define     USER_PROFILE_GENDER_NONE                    @"--"
#define     USER_PROFILE_GENDER_MALE                    @"male"
#define     USER_PROFILE_GENDER_FEMALE                  @"female"

//----------------------------------------------------------------------------------------------------------------------------
#define     STRING_OF_YES                               @"YES"
#define     STRING_OF_NO                                @"NO"

//----------------------------------------------------------------------------------------------------------------------------
#define     OFFER_FROM_CHAT_VIEW                        @"offerFromChatView"
#define     OFFER_FROM_ITEM_DETAILS                     @"offerFromItemDetails"

//----------------------------------------------------------------------------------------------------------------------------
#define     NUM_OF_SECONDS_IN_A_MINUTE                  60
#define     NUM_OF_SECONDS_IN_AN_HOUR                   3600
#define     NUM_OF_SECONDS_IN_A_DAY                     86400
#define     NUM_OF_SECONDS_IN_A_WEEK                    604800

//----------------------------------------------------------------------------------------------------------------------------
#define     MAX_NUM_OF_CHARACTERS_FOR_PRICE             16


#pragma mark - Chat Message

//----------------------------------------------------------------------------------------------------------------------------
#define     CHAT_MESSAGE_TYPE                           @"chatMessageType"

//----------------------------------------------------------------------------------------------------------------------------
typedef enum {
    PhotoLibrary,
    Camera,
    ImageURL
} ImageGettingMethod;

//----------------------------------------------------------------------------------------------------------------------------
typedef enum {
    HashtagTypeBrand,
    HashtagTypeModel,
    HashtagTypeNone
} HashtagType;

//----------------------------------------------------------------------------------------------------------------------------
typedef enum {
    FeedbackRatingPositive,
    FeedbackRatingNeutral,
    FeedbackRatingNegative
} FeedbackRatingType;

//----------------------------------------------------------------------------------------------------------------------------
#define     FEEDBACK_RATING_POSITIVE                    @"positive"
#define     FEEDBACK_RATING_NEUTRAL                     @"neutral"
#define     FEEDBACK_RATING_NEGATIVE                    @"negative"

//----------------------------------------------------------------------------------------------------------------------------
typedef void (^FetchedUserHandler) (PFUser *, UIImage *);
typedef void (^CompletionHandler) (void);

//----------------------------------------------------------------------------------------------------------------------------
typedef enum {
    HistoryCollectionViewModeBuying,
    HistoryCollectionViewModeSelling
} HistoryCollectionViewMode;

//----------------------------------------------------------------------------------------------------------------------------
typedef enum {
    ChatMessageTypeNone,
    ChatMessageTypeNormal,
    ChatMessageTypeMakingOffer,
    ChatMessageTypeAcceptingOffer,
    ChatMessageTypeDecliningOffer,
    ChatMessageTypeCancellingOffer
} ChatMessageType;

#endif
