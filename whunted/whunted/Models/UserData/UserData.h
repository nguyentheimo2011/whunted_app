//
//  UserData.h
//  whunted
//
//  Created by thomas nguyen on 27/7/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface UserData : NSObject

@property (nonatomic, strong) NSString  *userID;
@property (nonatomic, strong) NSString  *username;
@property (nonatomic, strong) NSString  *password;
@property (nonatomic, strong) NSString  *firstName;
@property (nonatomic, strong) NSString  *lastName;
@property (nonatomic, strong) NSString  *emailAddress;
@property (nonatomic, strong) NSString  *phoneNumber;
@property (nonatomic, strong) NSString  *gender;
@property (nonatomic, strong) NSString  *dateOfBirth;
@property (nonatomic, strong) NSString  *residingCity;
@property (nonatomic, strong) NSString  *residingCountry;
@property (nonatomic, strong) NSString  *userDescription;
@property (nonatomic, strong) UIImage   *profileImage;

- (id) initWithParseUser: (PFUser *) user;

@end
