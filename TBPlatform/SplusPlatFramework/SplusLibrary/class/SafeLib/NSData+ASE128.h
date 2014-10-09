//
//  NSData+ASE128.h
//  YayawanIOS
//
//  Created by andsky on 14-4-15.
//  Copyright (c) 2014年 akzhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (ASE128)

- (NSData *)AES128EncryptWithKey:(NSString *)key;   //加密
- (NSData *)AES128DecryptWithKey:(NSString *)key;   //解密

@end
