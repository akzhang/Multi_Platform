//
//  NSDictionary+QueryBuilder.m
//  YayawanIOS
//
//  Created by andsky on 14-4-12.
//  Copyright (c) 2014年 akzhang. All rights reserved.
//

#import "NSDictionary+QueryBuilder.h"

static NSString * escapeString(NSString *string)
{
    NSString *result = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                    NULL, (__bridge CFStringRef)string, NULL,
                                                                                    (CFStringRef)@"!*'\"();:@&=+$,/?%#[] ", kCFStringEncodingUTF8);
    return result;
}

static NSString * unescapeString(NSString *string)
{
    NSString *result = [string stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    return [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@implementation NSDictionary (QueryBuilder)

- (NSString *)buildQueryString
{
    NSMutableArray *query = [NSMutableArray array];
    
    for (id key in self) {
        id value = [self objectForKey:key];
        [query addObject:[NSString stringWithFormat:@"%@=%@",
                          escapeString([key description]),
                          escapeString([value description])]];
    }
    
    return [query componentsJoinedByString:@"&"];
}

+ (NSDictionary *)dictionaryWithQueryString:(NSString *)queryString
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    NSArray *items = [queryString componentsSeparatedByString:@"&"];
    for (NSString *item in items) {
        NSRange pos = [item rangeOfString:@"="];
        if (pos.location == NSNotFound) {
            continue;
        }
        NSString *key = [item substringToIndex:pos.location];
        NSString *value = [item substringFromIndex:pos.location + 1];
        [result setObject:unescapeString(value) forKey:unescapeString(key)];
    }
    
    return result;
}


@end
