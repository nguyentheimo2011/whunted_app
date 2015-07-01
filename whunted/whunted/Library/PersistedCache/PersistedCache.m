//
//  SystemCache.m
//  whunted
//
//  Created by thomas nguyen on 30/6/15.
//  Copyright (c) 2015 Whunted. All rights reserved.
//

#import "PersistedCache.h"
#import "AppConstant.h"

@implementation PersistedCache

//------------------------------------------------------------------------------------------------------------------------------
+ (PersistedCache *) sharedCache
//------------------------------------------------------------------------------------------------------------------------------
{
    static PersistedCache *sharedCache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCache = [[PersistedCache alloc] init];
    });
    
    return sharedCache;
}

//------------------------------------------------------------------------------------------------------------------------------
- (void) setImage: (UIImage *) image forKey: (NSString *) key
//------------------------------------------------------------------------------------------------------------------------------
{
    NSString* path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@.jpg", key]];
    
    BOOL ok = [[NSFileManager defaultManager] createFileAtPath:path
                                                      contents:nil attributes:nil];
    
    if (!ok)
    {
        NSLog(@"Error creating file %@", path);
    }
    else
    {
        NSFileHandle* myFileHandle = [NSFileHandle fileHandleForWritingAtPath:path];
        [myFileHandle writeData:UIImagePNGRepresentation(image)];
        [myFileHandle closeFile];
    }
}

//------------------------------------------------------------------------------------------------------------------------------
- (UIImage *) imageForKey: (NSString *) key
//------------------------------------------------------------------------------------------------------------------------------
{
    NSString* path = [NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"/Documents/%@.jpg", key]];
    
    NSFileHandle* myFileHandle = [NSFileHandle fileHandleForReadingAtPath:path];
    UIImage* loadedImage = [UIImage imageWithData:[myFileHandle readDataToEndOfFile]];
    
    return loadedImage;
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
