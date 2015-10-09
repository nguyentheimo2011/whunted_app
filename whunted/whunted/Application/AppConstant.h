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
#define     FLAT_GRAY_COLOR_LIGHTER             [UIColor colorWithRed:140/255.0f green:140/255.0f blue:140/255.0f alpha:1.0f]
#define     FLAT_BLUR_RED_COLOR                 [UIColor colorWithRed:236/255.0f green:66/255.0f blue:50/255.0f alpha:1.0f]
#define     FLAT_FRESH_RED_COLOR                [UIColor colorWithRed:233/255.0f green:0/255.0f blue:19/255.0f alpha:1.0f]
#define     LIGHTER_RED_COLOR                   [UIColor colorWithRed:200/255.0f green:0/255.0f blue:0/255.0f alpha:1.0f]

//-----------------------------------------------------------------------------------------------------------------------------
#define     TEXT_COLOR_DARK_GRAY                [UIColor colorWithRed:40/255.0 green:40/255.0 blue:40/255.0 alpha:1.0]
#define     TEXT_COLOR_GRAY                     [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0]
#define     PLACEHOLDER_TEXT_COLOR              [UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1.0]

//-----------------------------------------------------------------------------------------------------------------------------
#define     WINSIZE                             [[UIScreen mainScreen] bounds].size
#define     STATUS_BAR_AND_NAV_BAR_HEIGHT       64.0f
#define     BOTTOM_TAB_BAR_HEIGHT               48.0f
#define     BOTTOM_BUTTON_HEIGHT                45.0f
#define     IPHONE_6_PLUS_WIDTH                 414.0f
#define     FLAT_BUTTON_HEIGHT                  35.0f
#define     kOFFSET_FOR_KEYBOARD                200.0f
#define     NEWSFEED_CELL_HEIGHT                WINSIZE.width + 105.0f

//-----------------------------------------------------------------------------------------------------------------------------
#define     NUM_OF_WHUNTS_IN_EACH_LOADING_TIME  20

//-----------------------------------------------------------------------------------------------------------------------------
#define     ITEM_NAME_KEY                       @"itemName"
#define     ITEM_DESC_KEY                       @"itemDescription"
#define     ITEM_HASH_TAG_KEY                   @"itemHashTag"
#define     ITEM_CATEGORY_KEY                   @"itemCategory"
#define     ITEM_PRICE_KEY                      @"itemPrice"
#define     ITEM_PAYMENT_METHOD                 @"paymentMethod"
#define     ITEM_LOCATION_KEY                   @"location"
#define     ITEM_ORIGINS_KEY                    @"itemOrigins"
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
#define     PF_OBJECT_ID                        @"objectId"
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
#define     PF_ITEM_SELLERS_NUM                 @"sellersNum"
#define     PF_ITEM_LIKES_NUM                   @"likesNum"
#define     PF_ITEM_IS_FULFILLED                @"isFulfilled"

//-----------------------------------------------------------------------------------------------------------------------------
#define     PF_ITEM_PICTURE                     @"itemPicture"

//-----------------------------------------------------------------------------------------------------------------------------
#define     PF_OFFER_ID                         @"offerID"
#define     PF_BUYER_ID                         @"buyerID"
#define     PF_SELLER_ID                        @"sellerID"
#define     PF_INITIATOR_ID                     @"initiatorID"
#define     PF_ORIGINAL_DEMANDED_PRICE          @"originalDemandedPrice"
#define     PF_OFFERED_PRICE                    @"offeredPrice"
#define     PF_DELIVERY_TIME                    @"deliveryTime"
#define     PF_TRANSACTION_STATUS               @"transactionStatus"

//-----------------------------------------------------------------------------------------------------------------------------
#define     TRANSACTION_STATUS_NONE             @"None"
#define     TRANSACTION_STATUS_ONGOING          @"Ongoing"
#define     TRANSACTION_STATUS_CANCELLED        @"Cancelled"
#define     TRANSACTION_STATUS_DECLINED         @"Declined"
#define     TRANSACTION_STATUS_ACCEPTED         @"Accepted"

//-----------------------------------------------------------------------------------------------------------------------------
#define     TRANSACTION_STATUS_DISPLAY_NEGOTIATING      @"Negotiating"
#define     TRANSACTION_STATUS_DISPLAY_OFFERED          @"Offered"

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
#define     FB_ITEM_BUYER_ID                    @"itemBuyerID"
#define     FB_ITEM_SELLER_ID                   @"itemSellerID"
#define     FB_TRANSACTION_STATUS               @"transactionStatus"
#define     FB_TRANSACTION_LAST_USER            @"transactionLastUser"
#define     FB_ORIGINAL_DEMANDED_PRICE          @"originalDemandedPrice"
#define     FB_CURRENT_OFFER_ID                 @"currentOfferID"
#define     FB_CURRENT_OFFERED_PRICE            @"currentOfferedPrice"
#define     FB_CURRENT_OFFERED_DELIVERY_TIME    @"currentOfferedDeliveryTime"
#define     FB_CHAT_MESSAGE_TYPE                @"chatMessageType"


//-----------------------------------------------------------------------------------------------------------------------------
#define     NOTIFICATION_USER_SIGNED_UP                 @"NCUserSignedUp"
#define		NOTIFICATION_USER_LOGGED_IN                 @"NCUserLoggedIn"
#define		NOTIFICATION_USER_LOGGED_OUT                @"NCUserLoggedOut"
#define     NOTIFICATION_NEW_OFFER_MADE_BY_ME           @"NotificationNewOfferMadeByMe"
#define     NOTIFICATION_NEW_OFFER_MADE                 @"NotificationNewOfferMade"
#define     NOTIFICATION_OFFER_CANCELLED                @"NotificationOfferCancelled"
#define     NOTIFICATION_OFFER_DECLINED                 @"NotificationOfferDeclined"
#define     NOTIFICATION_OFFER_ACCEPTED                 @"NotificationOfferAccepted"
#define     NOTIFICATION_USERNAME_BUTTON_TAP_EVENT      @"NotificationUsernameButtonTapEvent"
#define     NOTIFICATION_USER_PROFILE_EDITED_EVENT      @"NotificationUserProfileEditedEvent"
#define     NOTIFICATION_ENTER_APP_THROUGH_PUSH_NOTIFICATION_EVENT  @"NotificationEnterAppThroughPushNotificationEvent"
#define     NOTIFICATION_WHUNT_DETAILS_EDITED_EVENT     @"NotificationWhuntDetailsEditedEvent"
#define     NOTIFICATION_USERNAME_BUTTON_MARKETPLACE_TAP_EVENT      @"NotificationUsernameButtonMarketplaceTapEvent"
#define     NOTIFICATION_USERNAME_BUTTON_USER_PROFILE_TAP_EVENT     @"NotificationUsernameButtonUserProfileTapEvent"
#define     NOTIFICATION_USERNAME_BUTTON_CHAT_TAP_EVENT             @"NotificationUsernameButtonChatTapEvent"

//----------------------------------------------------------------------------------------------------------------------------
#define     PAYMENT_METHOD_ESCROW               @"escrow"
#define     PAYMENT_METHOD_NON_ESCROW           @"non-escrow"

//----------------------------------------------------------------------------------------------------------------------------
#define     FIREBASE                            @"https://incandescent-heat-6966.firebaseio.com/"

//----------------------------------------------------------------------------------------------------------------------------
#define		VIDEO_LENGTH						5

//----------------------------------------------------------------------------------------------------------------------------
#define     TAIWAN_CURRENCY                     @"NT$ "
#define     PROPER_TAIWAN_CURRENCY              @"NT$"
#define     DOT_CHARACTER                       @"."
#define     COMMA_CHARACTER                     @","
#define     WHITE_SPACE_CHARACTER               @" "

//----------------------------------------------------------------------------------------------------------------------------
#define     UI_ACTION                           @"ui_action"


#pragma mark - Font

//----------------------------------------------------------------------------------------------------------------------------
#define     LIGHT_FONT_NAME                     @"HelveticaNeue-Light"
#define     REGULAR_FONT_NAME                   @"HelveticaNeue-Light"
#define     SEMIBOLD_FONT_NAME                  @"HelveticaNeue"
#define     BOLD_FONT_NAME                      @"HelveticaNeue-Medium"

#define     BIG_FONT_SIZE                       18
#define     DEFAULT_FONT_SIZE                   17
#define     SMALL_FONT_SIZE                     16
#define     SMALLER_FONT_SIZE                   15

#define     DEFAULT_FONT                        [UIFont fontWithName:REGULAR_FONT_NAME size:DEFAULT_FONT_SIZE]

//----------------------------------------------------------------------------------------------------------------------------
#define     SYNC_IN_PROGRESS                    @"syncInProgess"

//----------------------------------------------------------------------------------------------------------------------------
#define     PF_ONGOING_TRANSACTION_CLASS        @"OngoingTransactionData"
#define     PF_ACCEPTED_TRANSACTION_CLASS       @"AcceptedTransactionData"
#define     PF_CANCELLED_TRANSACTION_CLASS      @"CancelledTransactionData"
#define     PF_DECLINED_TRANSACTION_CLASS       @"DeclinedTransactionData"
#define     PF_ONGOING_WANT_DATA_CLASS          @"OngoingWantData"
#define     PF_COMPLETED_WANT_DATA_CLASS        @"CompletedWantData"
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
#define     USER_PROFILE_IMAGE                          @"_profileImg"
#define     ITEM_FIRST_IMAGE                            @"_itemFirstImage"

//----------------------------------------------------------------------------------------------------------------------------
#define     STRING_OF_YES                               @"YES"
#define     STRING_OF_NO                                @"NO"

//----------------------------------------------------------------------------------------------------------------------------
#define     OFFER_FROM_CHAT_VIEW                        @"offerFromChatView"
#define     OFFER_FROM_ITEM_DETAILS                     @"offerFromItemDetails"

//----------------------------------------------------------------------------------------------------------------------------
#define     CURRENT_SORTING_BY                          @"currSortingBy"
#define     SORTING_BY_POPULAR                          @"Popular"
#define     SORTING_BY_RECENT                           @"Recent"
#define     SORTING_BY_LOWEST_PRICE                     @"Lowest Price"
#define     SORTING_BY_HIGHEST_PRICE                    @"Highest Price"
#define     SORTING_BY_NEAREST                          @"Nearest"

//----------------------------------------------------------------------------------------------------------------------------
#define     CURRENT_CATEGORY_FILTER                     @"currCategoryFilter"
#define     ITEM_CATEGORY_ALL                           @"All"
#define     ITEM_CATEGORY_BEAUTY_PRODUCTS               @"Beauty products"
#define     ITEM_CATEGORY_BOOKS_AND_MAGAZINES           @"Books and magazines"
#define     ITEM_CATEGORY_LUXURY_BRANDED                @"Luxury branded"
#define     ITEM_CATEGORY_GAMES_AND_TOYS                @"Games & Toys"
#define     ITEM_CATEGORY_PROFESSIONAL_SERVICES         @"Professional services"
#define     ITEM_CATEGORY_SPORT_EQUIPMENTS              @"Sporting equipment"
#define     ITEM_CATEGORY_TICKETS_AND_VOUCHERS          @"Tickets and vouchers"
#define     ITEM_CATEGORY_WATCHES                       @"Watches"
#define     ITEM_CATEGORY_CUSTOMIZATION                 @"Customization"
#define     ITEM_CATEGORY_BORROWING                     @"Borrowing"
#define     ITEM_CATEGORY_FUNITURE                      @"Furniture"
#define     ITEM_CATEGORY_OTHERS                        @"Others"
#define     ITEM_CHINESE_CATEGORY_BEAUTY_PRODUCTS       @"美容產品"
#define     ITEM_CHINESE_CATEGORY_BOOKS_AND_MAGAZINES   @"書籍雜誌"
#define     ITEM_CHINESE_CATEGORY_LUXURY_BRANDED        @"名牌產品"
#define     ITEM_CHINESE_CATEGORY_GAMES_AND_TOYS        @"遊戲玩具"
#define     ITEM_CHINESE_CATEGORY_PROFESSIONAL_SERVICES @"專業服務"
#define     ITEM_CHINESE_CATEGORY_SPORT_EQUIPMENTS      @"體育器材"
#define     ITEM_CHINESE_CATEGORY_TICKETS_AND_VOUCHERS  @"門票優惠券"
#define     ITEM_CHINESE_CATEGORY_WATCHES               @"手錶"
#define     ITEM_CHINESE_CATEGORY_CUSTOMIZATION         @"定製產品"
#define     ITEM_CHINESE_CATEGORY_BORROWING             @"我想借"
#define     ITEM_CHINESE_CATEGORY_FUNITURE              @"家具"
#define     ITEM_CHINESE_CATEGORY_OTHERS                @"其他"


//----------------------------------------------------------------------------------------------------------------------------
#define     LANGUAGE_USED_IN_LAST_SESSION               @"appLanguage"

//----------------------------------------------------------------------------------------------------------------------------
#define     CURRENT_PRODUCT_ORIGIN_FILTER               @"currProductOrigin"
#define     ITEM_PRODUCT_ORIGIN_ALL                     @"All"

//----------------------------------------------------------------------------------------------------------------------------
#define     CURRENT_BUYER_LOCATION_FILTER               @"currBuyerLocationFilter"
#define     ITEM_BUYER_LOCATION_DEFAULT                 @"All"

//----------------------------------------------------------------------------------------------------------------------------
#define     CELL_IN_MARKETPLACE                         @"cellInMarketplace"
#define     CELL_IN_USER_PROFILE                        @"cellInUserProfile"

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
typedef void (^FetchedUserHandler)  (PFUser *, UIImage *);
typedef void (^UserHandler)         (PFUser *);
typedef void (^ImageHandler)        (UIImage *);
typedef void (^CompletionHandler)   (void);

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
    ChatMessageTypeCancellingOffer,
    ChatMessageTypeLeavingFeeback
} ChatMessageType;


#endif
