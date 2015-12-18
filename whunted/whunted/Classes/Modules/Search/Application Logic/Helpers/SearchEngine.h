//
//  SearchEngine.h
//  whunted
//
//  Created by thomas nguyen on 15/10/15.
//  Copyright © 2015 Whunted. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchEngine : NSObject

#pragma mark - Search Keyword Processing

+ (NSString *) removeRedundantWhiteSpacesFromSearchKeyword: (NSString *) searchKeyword;

+ (NSString *) createRegexFromSearchKeyword: (NSString *) searchKeyword;

@end
