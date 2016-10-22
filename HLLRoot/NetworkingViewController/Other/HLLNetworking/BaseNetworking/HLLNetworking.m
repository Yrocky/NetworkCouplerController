//
//  HLLNetworking.m
//  HLLNetworking
//
//  Created by admin on 16/2/22.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLLNetworking.h"

@implementation HLLNetworking

- (void)startRequest{

    [NSException raise:@"Networking Start Request"
                format:@"You Must Override This Method."];
}

- (void)cancelRequest{

    [NSException raise:@"Networking Cancel Request"
                format:@"You Must Override This Method."];
}

+ (id)getMethodNetworkingWithUrlString:(NSString *)urlString
                     requestDictionary:(NSDictionary *)requestDictioinary
                       requestBodyType:(HLLRequestBodyType *)requestType
                      responseDataType:(HLLResponseDataType *)responseType{

    
    [NSException raise:@"Networking GET Request"
                format:@"You Must Override This Method."];
    
    return nil;
}

+ (id)postMethodNetworkingWithUrlString:(NSString *)urlString
                      requestDictionary:(NSDictionary *)requestDictioinary
                        requestBodyType:(HLLRequestBodyType *)requestType
                       responseDataType:(HLLResponseDataType *)responseType{

    
    [NSException raise:@"Networking POST Request"
                format:@"You Must Override This Method."];
    return nil;
}

- (NSDictionary *) accessRequestDictionarySerializerWithRequestDictionary:(NSDictionary *)requestDictionary{

    [NSException raise:@"Networking Serializer Request Dictionary"
                format:@"You Must Override This Method."];
    return nil;
}

- (NSString *) descriptionRequestURL{

    NSMutableString * url = [NSMutableString string];
    
    if ([self.method isKindOfClass:[HLLGETMethodType class]]) {
        [url appendString:@"----<<<<Get:"];
    }else if([self.method isKindOfClass:[HLLPOSTMethodType class]]){
        [url appendString:@"----<<<<Post:"];
    }
    
    [url appendString:[NSString stringWithFormat:@"%@?",self.urlString]];
    
    NSDictionary * params = [self accessRequestDictionarySerializerWithRequestDictionary:self.requestDictionary];
    
    for (NSString * key in params) {
        
        NSString * value = [params valueForKey:key];
        
        [url appendString:[NSString stringWithFormat:@"%@=%@&",key,value]];
    }
    NSString * resule = [url substringToIndex:url.length - 1];
    
    return resule;
}
@end
