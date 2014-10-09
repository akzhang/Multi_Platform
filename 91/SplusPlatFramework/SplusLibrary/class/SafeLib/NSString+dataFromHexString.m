//
//  NSString+dataFromHexString.m
//  YayawanIOS
//
//  Created by andsky on 14-4-17.
//  Copyright (c) 2014年 akzhang. All rights reserved.
//

#import "NSString+dataFromHexString.h"

@implementation NSString(data)
- (NSData *)dataFromHexString{
    NSString *string = [self lowercaseString];
    NSMutableData *data= [NSMutableData new];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i = 0;
    int length = string.length;
    while (i < length-1) {
        char c = [string characterAtIndex:i++];
        if (c < '0' || (c > '9' && c < 'a') || c > 'f')
            continue;
        byte_chars[0] = c;
        byte_chars[1] = [string characterAtIndex:i++];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
        
    }
    
    return data;
}
@end
