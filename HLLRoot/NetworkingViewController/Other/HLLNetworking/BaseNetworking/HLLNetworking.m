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


#pragma mark -
#pragma mark 打印响应信息

- (void)logWithSuccessResponse:(id)response url:(NSString *)url params:(NSDictionary *)params {
    
    if (self.EnableLogParseResponseDebug) {
        NSLog(@"================================\nRequest success\n URL: %@\n params:%@\n response:%@",[self generateGETAbsoluteURL:url params:params],params,[self tryToParseData:response]);
    }
}

- (void)logWithFailError:(NSError *)error url:(NSString *)url params:(id)params {
    
    if (self.EnableLogParseResponseDebug) {
        NSString *format = @" params: ";
        if (params == nil || ![params isKindOfClass:[NSDictionary class]]) {
            format = @"";
            params = @"";
        }
        
        if ([error code] == NSURLErrorCancelled) {
            NSLog(@"================================\nRequest was canceled mannully \n URL: %@ %@%@\n\n",[self generateGETAbsoluteURL:url params:params],format,params);
        } else {
            NSLog(@"\nRequest error \n URL: %@ %@%@\n errorInfos:%@\n\n",[self generateGETAbsoluteURL:url params:params],format,params,[error localizedDescription]);
        }
    }
}

- (NSString *)generateGETAbsoluteURL:(NSString *)url params:(id)params {
    
    if (params == nil || ![params isKindOfClass:[NSDictionary class]] || [params count] == 0) {
        return url;
    }
    
    NSString *queries = @"";
    for (NSString *key in params) {
        id value = [params objectForKey:key];
        
        if ([value isKindOfClass:[NSDictionary class]]) {
            continue;
        } else if ([value isKindOfClass:[NSArray class]]) {
            continue;
        } else if ([value isKindOfClass:[NSSet class]]) {
            continue;
        } else {
            queries = [NSString stringWithFormat:@"%@%@=%@&",
                       (queries.length == 0 ? @"&" : queries),
                       key,
                       value];
        }
    }
    
    if (queries.length > 1) {
        queries = [queries substringToIndex:queries.length - 1];
    }
    
    if (([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"]) && queries.length > 1) {
        if ([url rangeOfString:@"?"].location != NSNotFound || [url rangeOfString:@"#"].location != NSNotFound) {
            url = [NSString stringWithFormat:@"%@%@", url, queries];
        } else {
            queries = [queries substringFromIndex:1];
            url = [NSString stringWithFormat:@"%@?%@", url, queries];
        }
    }
    
    return url.length == 0 ? queries : url;
}

- (id)tryToParseData:(id)responseData {
    
    if ([responseData isKindOfClass:[NSData class]]) {
        // 尝试解析成JSON
        if (responseData == nil) {
            return responseData;
        } else {
            NSError *error = nil;
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&error];
            
            if (error != nil) {
                return responseData;
            } else {
                return response;
            }
        }
    } else {
        return responseData;
    }
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



#pragma mark -
#pragma mark 缓存响应数据

- (void)cacheResponseObject:(id)responseObject request:(NSURLRequest *)request parameters:params {
    
    if (request && responseObject && ![responseObject isKindOfClass:[NSNull class]]) {
        NSString *directoryPath = cachePath();
        
        NSError *error = nil;
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&error];
            if (error) {
                NSLog(@"Create cache dir error: %@\n", error.localizedDescription);
                return;
            }
        }
        
        NSString *absoluteURL = [self generateGETAbsoluteURL:request.URL.absoluteString params:params];
        NSString *key = [absoluteURL md5];
        NSString *path = [directoryPath stringByAppendingPathComponent:key];
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        NSData *data = nil;
        if ([dict isKindOfClass:[NSData class]]) {
            data = responseObject;
        } else {
            data = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
        }
        
        if (data && error == nil) {
            BOOL isOk = [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
            if (isOk) {
                NSLog(@"Cache file OK for request: %@\n", absoluteURL);
            } else {
                NSLog(@"Cache file Error for request: %@\n", absoluteURL);
            }
        }
    }
}

- (id)getCacheResponseWithURL:(NSString *)url parameters:params {
    
    id cacheData = nil;
    
    if (url) {
        // 缓存路径
        NSString *directoryPath = cachePath();
        // 生成get绝对路径url
        NSString *absoluteURL = [self generateGETAbsoluteURL:url params:params];
        NSString *key = [absoluteURL md5];
        NSString *path = [directoryPath stringByAppendingPathComponent:key];
        
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
        if (data) {
            cacheData = data;
            NSLog(@"Read data from cache for url: %@\n", url);
        }
    }
    
    return [self tryToParseData:cacheData];
}

static inline NSString *cachePath() {
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/HLLNetworkingCaches"];
}

@end
