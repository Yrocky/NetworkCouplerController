//
//  HLLResponseDataType.h
//  HLLNetworking
//
//  Created by admin on 16/2/22.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLLResponseDataType : NSObject

+ (instancetype) type;

@end


@interface HLLJsonDataType : HLLResponseDataType

@end


@interface HLLHttpDataType : HLLResponseDataType

@end