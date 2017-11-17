//
//  NSString+Regexp.m
//  AAA
//
//  Created by 魏翔 on 2017/11/15.
//  Copyright © 2017年 魏翔. All rights reserved.
//

#import "NSString+Regexp.h"

@implementation NSString (Regexp)

-(BOOL)checkContentIsEffective
{
    return [self checkIsLineWithSQLRules] && [self checkIsLineWithXSS];
}

-(BOOL)checkIsLineWithSQLRules
{
    NSRange range = [self rangeOfString:@"(?:')|(?:--)|(/\\*(?:.|[\\n\\r])*?\\*/)|(\\b(select|update|and|or|delete|insert|trancate|char|into|substr|ascii|declare|exec|count|master|into|drop|execute)\\b)" options:NSRegularExpressionSearch];
    return range.location == NSNotFound;
}

-(BOOL)checkIsLineWithXSS
{
    NSRange range = [self rangeOfString:@"(<|<)script.*script(>|>)" options:NSRegularExpressionSearch];
    return range.location == NSNotFound;
}


@end
