//
//  NSDictionary+QueryBuilder.h
//  YayawanIOS
//
//  Created by andsky on 14-4-12.
//  Copyright (c) 2014年 akzhang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDictionary (QueryBuilder)

- (NSString *)buildQueryString;
+ (NSDictionary *)dictionaryWithQueryString:(NSString *)queryString;

@end
