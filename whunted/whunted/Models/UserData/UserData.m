//
//  UserData.m
//  whunted
//
//  Created by thomas nguyen on 27/7/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "UserData.h"
#import "AppConstant.h"
#import "Utilities.h"
#import "ProfileImageCache.h"

@implementation UserData

@synthesize userID          =   _userID;
@synthesize username        =   _username;
@synthesize password        =   _password;
@synthesize firstName       =   _firstName;
@synthesize lastName        =   _lastName;
@synthesize emailAddress    =   _emailAddress;
@synthesize phoneNumber     =   _phoneNumber;
@synthesize gender          =   _gender;
@synthesize dateOfBirth     =   _dateOfBirth;
@synthesize residingCity    =   _residingCity;
@synthesize residingCountry =   _residingCountry;
@synthesize userDescription =   _userDescription;
@synthesize profileImage    =   _profileImage;

//-------------------------------------------------------------------------------------------------------------------------------
- (id) initWithParseUser:(PFUser *)user
//-------------------------------------------------------------------------------------------------------------------------------
{
    self = [super init];
    
    if (self)
    {
        _userID             =   user.objectId;
        _username           =   user[PF_USER_USERNAME];
        _password           =   user[PF_USER_PASSWORD];
        _firstName          =   user[PF_USER_FIRSTNAME];
        _lastName           =   user[PF_USER_LASTNAME];
        _emailAddress       =   user[PF_USER_EMAIL];
        _phoneNumber        =   user[PF_USER_PHONE_NUMBER];
        _gender             =   user[PF_USER_GENDER];
        _dateOfBirth        =   [Utilities commonlyFormattedStringFromDate:user[PF_USER_DOB]];
        _residingCity       =   user[PF_USER_CITY];
        _residingCountry    =   user[PF_USER_COUNTRY];
        _userDescription    =   user[PF_USER_DESCRIPTION];
        
        NSString *key = [NSString stringWithFormat:@"%@%@", [PFUser currentUser].objectId, USER_PROFILE_IMAGE];
        UIImage *image = [[ProfileImageCache sharedCache] objectForKey:key];
        
        if (image)
            _profileImage = image;
        else
        {
            PFFile *file = [PFUser currentUser][PF_USER_PICTURE];
            NSData *data = [file getData];
            _profileImage = [UIImage imageWithData:data];
        }
    }
    
    return self;
}



@end
