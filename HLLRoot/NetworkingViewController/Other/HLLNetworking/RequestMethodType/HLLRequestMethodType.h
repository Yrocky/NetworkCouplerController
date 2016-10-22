//
//  HLLRequestMethodType.h
//  HLLNetworking
//
//  Created by admin on 16/2/22.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLLRequestMethodType : NSObject

+ (instancetype) type;

@end


@interface HLLGETMethodType : HLLRequestMethodType

@end


@interface HLLPOSTMethodType : HLLRequestMethodType

@end