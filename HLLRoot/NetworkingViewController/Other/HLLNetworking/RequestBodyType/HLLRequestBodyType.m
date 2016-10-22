//
//  HLLRequestBodyType.m
//  HLLNetworking
//
//  Created by admin on 16/2/22.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLLRequestBodyType.h"

@implementation HLLRequestBodyType

+ (instancetype)type{

    HLLRequestBodyType * bodyType = [[self alloc] init];
    return bodyType;
}
@end

@implementation HLLJsonBodyType

@end

@implementation HLLHTTPBodyType

@end

@implementation HLLPlistBodyType

@end