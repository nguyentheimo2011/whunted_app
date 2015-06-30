//
//  SystemCache.m
//  whunted
//
//  Created by thomas nguyen on 30/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "SystemCache.h"
#import "AppConstant.h"

@implementation SystemCache

//------------------------------------------------------------------------------------------------------------------------------
+ (SystemCache *) sharedCache
//------------------------------------------------------------------------------------------------------------------------------
{
    static SystemCache *sharedCache;    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCache = [[SystemCache alloc] init];
    });
    
    return sharedCache;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) setImage: (UIImage *) image forKey: (NSString *) key
//------------------------------------------------------------------------------------------------------------------------------
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"cached_%@.jpg", key];
    NSString *imagePath = [documentsDirectory stringByAppendingString:fileName];
    
    if (![imageData writeToFile:imagePath atomically:NO])
    {
        NSLog((@"Failed to cache image data to disk"));
    }
    else
    {
        NSLog(@"the cachedImagedPath is %@",imagePath);
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (UIImage *) imageForKey: (NSString *) key
//------------------------------------------------------------------------------------------------------------------------------
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"cached_%@.jpg", key];
    NSString *imagePath = [documentsDirectory stringByAppendingString:fileName];
    
    NSData *data = [NSData dataWithContentsOfFile:imagePath];
    UIImage *image = [UIImage imageWithData:data];
    
    return image;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) removeImageForKey: (NSString *) key
//------------------------------------------------------------------------------------------------------------------------------
{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"cached_%@.jpg", key];
    NSString *filePath = [documentsPath stringByAppendingPathComponent:fileName];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    if (success) {
        
    }
    else
    {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
}

@end
