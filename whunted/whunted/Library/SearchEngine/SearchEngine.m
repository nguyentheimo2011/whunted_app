//
//  SearchEngine.m
//  whunted
//
//  Created by thomas nguyen on 15/10/15.
//  Copyright © 2015 Whunted. All rights reserved.
//

#import "SearchEngine.h"

@implementation SearchEngine

//-----------------------------------------------------------------------------------------------------------------------------
+ (NSString *) removeRedundantWhiteSpacesFromSearchKeyword:(NSString *)searchKeyword
//-----------------------------------------------------------------------------------------------------------------------------
{
    // Remove front white spaces
    NSInteger len = 0;
    for (int i=0; i<searchKeyword.length; i++)
    {
        char c = [searchKeyword characterAtIndex:i];
        if (c == ' ')
            len++;
        else
            break;
    }
    searchKeyword = [searchKeyword substringFromIndex:len];
    
    // Remove white spaces at the end of the search keyword
    NSInteger index = searchKeyword.length;
    for (int i=(int)searchKeyword.length - 1; i>=0; i--)
    {
        char c = [searchKeyword characterAtIndex:i];
        if (c == ' ')
            index--;
        else
            break;
    }
    searchKeyword = [searchKeyword substringToIndex:index];
    
    return searchKeyword;
}

//-----------------------------------------------------------------------------------------------------------------------------
+ (NSString *) createRegexFromSearchKeyword:(NSString *)searchKeyword
//-----------------------------------------------------------------------------------------------------------------------------
{
    searchKeyword = [SearchEngine removeRedundantWhiteSpacesFromSearchKeyword:searchKeyword];
    
    NSString *regexString = @"";
    NSString *regexEle;
    for (int i=0; i<searchKeyword.length; i++)
    {
        char c = [searchKeyword characterAtIndex:i];
        if (c >= 'a' && c <= 'z')
        {
            NSString *uppercase = [[NSString stringWithFormat:@"%c",c] uppercaseString];
            regexEle = [NSString stringWithFormat:@"(%c|%@)", c, uppercase];
        }
        else if (c >= 'A' && c <= 'Z')
        {
            NSString *lowercase = [[NSString stringWithFormat:@"%c",c] lowercaseString];
            regexEle = [NSString stringWithFormat:@"(%c|%@)", c, lowercase];
        }
        else
        {
            regexEle = [searchKeyword substringWithRange:NSMakeRange(i, 1)];
        }
        
        regexString = [regexString stringByAppendingString:regexEle];
    }
    
    return regexString;
}

@end
