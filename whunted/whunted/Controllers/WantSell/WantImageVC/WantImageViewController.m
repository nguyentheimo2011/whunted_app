//
//  WantImageViewController.m
//  whunted
//
//  Created by thomas nguyen on 22/5/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "WantImageViewController.h"

@interface WantImageViewController ()

@end

@implementation WantImageViewController

- (id) initWithImage: (UIImage *) itemImage
{
    self = [super init];
    if (self != nil) {
        self.itemImage = itemImage;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.itemImage];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
