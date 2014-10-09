//
//  User.m
//  yywaniosSDK
//
//  Created by akzhang on 14-2-22.
//  Copyright (c) 2014年 akzhang. All rights reserved.
//

#import "UserData.h"

@implementation UserData

+ (UserData *)sharedSingleton{
    static UserData *sharedSingleton = nil;
    @synchronized(self){
        if (!sharedSingleton) {
            sharedSingleton = [[UserData alloc] init];
            return sharedSingleton;
        }
    }
    return sharedSingleton;
}

+(void)push:(NSString*)username password:(NSString*)argPassword{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *_userAesDataHex = [defaults objectForKey:@"SplusUserDataA"];
    NSData *_userAesData = [[_userAesDataHex dataFromHexString] AES128DecryptWithKey:@"Spluspasswordkey"];
    NSString *_userData = [[NSString alloc] initWithData:_userAesData encoding:NSUTF8StringEncoding];
    NSDictionary *_JsonParserResult = [_userData JSONValue];
    
    if ([_JsonParserResult objectForKey:username]) {
//        return;
    }
    NSMutableDictionary *mutableRetrievedDictionary;
    if (_JsonParserResult == NULL) {
        mutableRetrievedDictionary = [NSMutableDictionary dictionaryWithCapacity:5];
    }else{
        mutableRetrievedDictionary = [_JsonParserResult mutableCopy];
    }
    
    int unixtime = [[NSNumber numberWithDouble: [[NSDate date] timeIntervalSince1970]] integerValue];
    
    NSDictionary *_userName = [NSDictionary dictionaryWithObjectsAndKeys: username,@"username",
                                argPassword,@"password", 
                               [NSString stringWithFormat:@"%d", unixtime] ,@"last_date",nil];
    [mutableRetrievedDictionary setObject:_userName forKey:username];
    //[data dataUsingEncoding:NSUTF8StringEncoding]
    NSData *_aesData = [[[mutableRetrievedDictionary JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding] AES128EncryptWithKey:@"Spluspasswordkey"];
    NSString *_aexStringHex = [_aesData hexRepresentationWithSpaces_AS:NO];
    NSLog(@"aes-----%@", _aexStringHex);

    [defaults setObject:_aexStringHex forKey:@"SplusUserDataA"];
    [defaults synchronize];

}

+(void)pop:(NSString*)username{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *_userAesDataHex = [defaults objectForKey:@"SplusUserDataA"];
    NSData *_userAesData = [[_userAesDataHex dataFromHexString] AES128DecryptWithKey:@"Spluspasswordkey"];
    NSString *_userData = [[NSString alloc] initWithData:_userAesData encoding:NSUTF8StringEncoding];
    NSDictionary *_JsonParserResult = [_userData JSONValue];
    
    if (![_JsonParserResult objectForKey:username]) {
        return;
    }
    
    NSMutableDictionary *mutableRetrievedDictionary;
    mutableRetrievedDictionary = [_JsonParserResult mutableCopy];
    
    [mutableRetrievedDictionary removeObjectForKey:username];
    
    NSData *_aesData = [[[mutableRetrievedDictionary JSONRepresentation] dataUsingEncoding:NSUTF8StringEncoding] AES128EncryptWithKey:@"Spluspasswordkey"];
    NSString *_aexStringHex = [_aesData hexRepresentationWithSpaces_AS:NO];
    
    [defaults setObject:_aexStringHex forKey:@"SplusUserDataA"];
    [defaults synchronize];
    
}

+(NSDictionary *)get{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //NSString *_userData = [defaults objectForKey:@"SplusUserDataA"];
    //NSDictionary *_JsonParserResult = [_userData JSONValue];
    NSString *_userAesDataHexString = [defaults objectForKey:@"SplusUserDataA"];
    NSData *_userAesHexData = [_userAesDataHexString dataFromHexString];
    NSData *_userAesData = [_userAesHexData AES128DecryptWithKey:@"Spluspasswordkey"];
    NSString *_userData = [[NSString alloc] initWithData:_userAesData encoding:NSUTF8StringEncoding];
    NSDictionary *_JsonParserResult = [_userData JSONValue];
    return  _JsonParserResult;
}

+(void)update:(NSString*)username{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *_userData = [defaults objectForKey:@"SplusUserDataA"];
    NSDictionary *_JsonParserResult = [_userData JSONValue];
    NSDictionary *_userInfo = [_JsonParserResult objectForKey:username];
    if (_userInfo == nil) {
        return;
    }
    
    int unixtime = [[NSNumber numberWithDouble: [[NSDate date] timeIntervalSince1970]] integerValue];
    
    NSMutableDictionary *mutableRetrievedDictionary;
    mutableRetrievedDictionary = [_JsonParserResult mutableCopy];
    
    NSDictionary *_userName = [NSDictionary dictionaryWithObjectsAndKeys: username,@"username",
                               [_userInfo objectForKey:@"password"],@"password",
                               [NSString stringWithFormat:@"%d", unixtime] ,@"last_date",nil];
    [mutableRetrievedDictionary setObject:_userName forKey:username];
    [defaults setObject:[mutableRetrievedDictionary JSONRepresentation] forKey:@"SplusUserDataA"];
    [defaults synchronize];
}


@end
