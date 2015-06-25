//
//  AppConstant.h
//  whunted
//
//  Created by thomas nguyen on 15/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#ifndef whunted_AppConstant_h
#define whunted_AppConstant_h

//-----------------------------------------------------------------------------------------------------------------------------
#define     DARKER_BLUE_COLOR                   [UIColor colorWithRed:36.0/255 green:59.0/255 blue:100.0/255 alpha:1.0]
#define     DARK_BLUE_COLOR                     [UIColor colorWithRed:52.0/255 green:68.0/255 blue:105.0/255 alpha:1.0]
#define     LIGHT_GRAY_COLOR                    [UIColor colorWithRed:192.0/255 green:192.0/255 blue:192.0/255 alpha:1.0]
#define     LIGHTER_GRAY_COLOR                  [UIColor colorWithRed:215.0/255 green:215.0/255 blue:215.0/255 alpha:1.0]
#define     LIGHTEST_GRAY_COLOR                 [UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1.0]
#define     BACKGROUND_GRAY_COLOR               [UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1.0]
#define		COLOR_OUTGOING						[UIColor colorWithRed:0.0/255 green:122.0/255 blue:255.0/255 alpha:1.0]
#define		COLOR_INCOMING						[UIColor colorWithRed:230.0/255 green:229.0/255 blue:234.0/255 alpha:1.0]
#define     ACCEPTED_BUTTON_BACKGROUND_COLOR    [UIColor colorWithRed:0.0/255 green:172.0/255 blue:113.0/255 alpha:1.0]

//-----------------------------------------------------------------------------------------------------------------------------
#define WINSIZE                 [[UIScreen mainScreen] bounds].size

//-----------------------------------------------------------------------------------------------------------------------------
#define     ITEM_NAME_KEY                       @"itemName"
#define     ITEM_DESC_KEY                       @"itemDescription"
#define     ITEM_HASH_TAG_KEY                   @"itemHashTag"
#define     ITEM_CATEGORY_KEY                   @"itemCategory"
#define     ITEM_PRICE_KEY                      @"itemPrice"
#define     ITEM_LOCATION_KEY                   @"location"
#define     ITEM_ESCROW_OPTION_KEY              @"escrowOption"
#define     ITEM_SECONDHAND_OPTION              @"secondHandOption"

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
#define     PF_USER_COUNTRY                     @"country"              //  String

//-----------------------------------------------------------------------------------------------------------------------------
#define		NOTIFICATION_USER_LOGGED_IN			@"NCUserLoggedIn"
#define		NOTIFICATION_USER_LOGGED_OUT		@"NCUserLoggedOut"

//-----------------------------------------------------------------------------------------------------------------------------
#define     ESCROW_PAYMENT_METHOD               @"escrow"

//-----------------------------------------------------------------------------------------------------------------------------
#define     FIREBASE                            @"https://incandescent-heat-6966.firebaseio.com/"

//-----------------------------------------------------------------------------------------------------------------------------
#define		VIDEO_LENGTH						5

//-----------------------------------------------------------------------------------------------------------------------------
#define     TAIWAN_CURRENCY                     @"TWD "
#define     DOT_CHARACTER                       @"."
#define     COMMA_CHARACTER                     @","

//-----------------------------------------------------------------------------------------------------------------------------
#define     NORMAL_FONT_SIZE                    16
#define     NORMAL_FONT                         [UIFont systemFontOfSize:16]
#define     REGULAR_FONT_NAME                   @"Montserrat-Regular"
#define     LIGHT_FONT_NAME                     @"Montserrat-Light"
#define     BOLD_FONT_NAME                      @"Montserrat-Bold"

//-----------------------------------------------------------------------------------------------------------------------------
typedef enum {
    PhotoLibrary,
    Camera,
    ImageURL
} ImageGettingMethod;

#endif
