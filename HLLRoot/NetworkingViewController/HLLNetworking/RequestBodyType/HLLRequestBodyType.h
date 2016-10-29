//
//  HLLRequestBodyType.h
//  HLLNetworking
//
//  Created by admin on 16/2/22.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLLRequestBodyType : NSObject

+ (instancetype) type;

@end


@interface HLLHTTPBodyType : HLLRequestBodyType

@end


@interface HLLJsonBodyType : HLLRequestBodyType

@end


@interface HLLPlistBodyType : HLLRequestBodyType

@end