//
//  MainViewController.m
//  whunted
//
//  Created by thomas nguyen on 11/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "MainViewController.h"
#import "NewsFeedViewController.h"
#import "BrowseViewController.h"
#import "GenericController.h"
#import "MySellViewController.h"
#import "MyWantViewController.h"

#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKGraphRequest.h>
#import <Parse/Parse.h>

@interface MainViewController ()

- (void) customizeNavigationBar;

@end

@implementation MainViewController

- (id) init
{
    self = [super init];
    if (self != nil) {
        UINavigationController *browserNavController = [[UINavigationController alloc] init];
        BrowseViewController *brController = [[BrowseViewController alloc] init];
        [browserNavController setViewControllers:[NSArray arrayWithObject:brController]];
        [browserNavController setTitle:@"Browse"];
        [browserNavController.tabBarItem setImage:[UIImage imageNamed:@"shopping_cart.png"]];
        
        UINavigationController *newsFeedfNavController = [[UINavigationController alloc] init];
        NewsFeedViewController *newsFeedVC = [[NewsFeedViewController alloc] init];
        [newsFeedfNavController setViewControllers:[NSArray arrayWithObject:newsFeedVC]];
        [newsFeedfNavController setTitle:@"News Feed"];
        [newsFeedfNavController.tabBarItem setImage:[UIImage imageNamed:@"newsfeed.png"]];
        
        UINavigationController *myWantNavController = [[UINavigationController alloc] init];
        MyWantViewController *myWantVC = [[MyWantViewController alloc] init];
        [myWantNavController setViewControllers: [NSArray arrayWithObject:myWantVC]];
        [myWantNavController setTitle:@"Want"];
        [myWantNavController.tabBarItem setImage:[UIImage imageNamed:@"want_icon.png"]];
        
        UINavigationController *mySellNavController = [[UINavigationController alloc] init];
        MySellViewController *mySellVC = [[MySellViewController alloc] init];
        [mySellNavController setViewControllers: [NSArray arrayWithObject:mySellVC]];
        [mySellNavController setTitle:@"Sell"];
        [mySellNavController.tabBarItem setImage:[UIImage imageNamed:@"sell_icon.png"]];
        
        NSArray *controllers = [NSArray arrayWithObjects:browserNavController, newsFeedfNavController, myWantNavController, mySellNavController, nil];
        [self setViewControllers:controllers];
        
        [self customizeNavigationBar];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addDataToUser];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) customizeNavigationBar
{
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:6.0/255 green:122.0/255 blue:181.0/255 alpha:1.0]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
}

- (void) addDataToUser
{
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        // result is a dictionary with the user's Facebook data
        NSDictionary *userData = (NSDictionary *)result;
        PFUser *user = [PFUser currentUser];
        
        NSString *facebookID = userData[@"id"];
        user[@"email"] = userData[@"email"];
        user[@"username"] = [self extractUsernameFromEmail:user[@"email"]];
        user[@"firstName"] = userData[@"first_name"];
        user[@"lastName"] = userData[@"last_name"];
        user[@"gender"] = userData[@"gender"];
        
        NSArray *addresses = [self extractCountry:userData[@"location"][@"name"]];
        user[@"areaAddress"] = addresses[0];
        user[@"country"] = addresses[1];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"]];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
        user[@"dob"] = [dateFormatter dateFromString:userData[@"birthday"]];
        
        [user saveEventually];
        
        NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
        
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];
        
        //Run network request asynchronously
        [NSURLConnection sendAsynchronousRequest:urlRequest
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:
         ^(NSURLResponse *response, NSData *data, NSError *connectionError) {
             if (connectionError == nil && data != nil) {
                 PFFile *profilePictureFile = [PFFile fileWithName:[NSString stringWithFormat:@"%@.png", facebookID] data:data];
                 user[@"profilePicture"] = profilePictureFile;
                 [user saveEventually];
             }
         }];
    }];
}

#pragma mark - Supporting functions

- (NSString *) extractUsernameFromEmail: (NSString *) email
{
    NSRange atCharRange = [email rangeOfString:@"@"];
    NSString *username = [email substringToIndex:atCharRange.location];
    return username;
}

- (NSArray *) extractCountry: (NSString *) location
{
    NSRange commaSignRange = [location rangeOfString:@"," options:NSBackwardsSearch];
    NSString *specificAddress = [location substringToIndex:commaSignRange.location];
    NSString *country = [location substringFromIndex:commaSignRange.location + 1];
    
    return [NSArray arrayWithObjects:specificAddress, country, nil];
}

@end
