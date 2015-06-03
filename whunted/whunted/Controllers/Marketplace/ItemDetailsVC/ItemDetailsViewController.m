//
//  ItemDetailsViewController.m
//  whunted
//
//  Created by thomas nguyen on 2/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "ItemDetailsViewController.h"
#import "Utilities.h"
#import "ItemImageViewController.h"

@interface ItemDetailsViewController ()

@property (nonatomic, strong) NSMutableArray *itemImageList;

@end

@implementation ItemDetailsViewController
{
    NSInteger currIndex;
}

@synthesize pageViewController;
@synthesize wantData;
@synthesize itemImageList;
@synthesize itemImageNum;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self retrieveItemImages];
    [self.view setBackgroundColor:APP_COLOR_2];
    
    pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    pageViewController.dataSource = self;
    CGFloat yPos = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    pageViewController.view.frame = CGRectMake(0, yPos, WINSIZE.width, WINSIZE.height * 0.6);
    
    ItemImageViewController *itemImageVC = [self viewControllerAtIndex:0];
    NSArray *viewControllers = [NSArray arrayWithObject:itemImageVC];
    [pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:pageViewController];
    [self.view addSubview:pageViewController.view];
    [pageViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ItemImageViewController *) viewControllerAtIndex: (NSInteger) index
{
    ItemImageViewController *itemImageVC = [[ItemImageViewController alloc] init];
    itemImageVC.index = index;
    currIndex = index;
    if (index < [itemImageList count]) {
        [itemImageVC.itemImageView setImage:[itemImageList objectAtIndex:index]];
    }
    
    return itemImageVC;
}

#pragma mark - Data Handlers
- (void) retrieveItemImages
{
    itemImageList = [[NSMutableArray alloc] init];
    PFRelation *picRelation = wantData.itemPictureList;
    
    [[picRelation query] findObjectsInBackgroundWithBlock:^(NSArray *pfObjList, NSError *error ) {
        for (PFObject *pfObj in pfObjList) {
            PFFile *imageFile = pfObj[@"itemPicture"];
            [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                UIImage *image = [UIImage imageWithData:data];
                [itemImageList addObject:image];
                ItemImageViewController *itemImageVC = [self viewControllerAtIndex:currIndex];
                NSArray *viewControllers = [NSArray arrayWithObject:itemImageVC];
                [pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
            }];
        }
    }];
}

#pragma mark - PageViewController datasource methods
- (UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [(ItemImageViewController*)viewController index];
    if (index == 0) {
        return nil;
    } else {
        return [self viewControllerAtIndex:index-1];
    }
}

- (UIViewController *) pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [(ItemImageViewController*)viewController index];
    if (index == itemImageNum-1) {
        return nil;
    } else {
        return [self viewControllerAtIndex:index+1];
    }
}

- (NSInteger) presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return itemImageNum;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}


@end
