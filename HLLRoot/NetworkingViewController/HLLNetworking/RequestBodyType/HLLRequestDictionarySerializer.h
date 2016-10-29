//
//  HLLRequestDictionarySerializer.h
//  HLLNetworking
//
//  Created by admin on 16/2/22.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HLLRequestDictionarySerializer <NSObject>

/**
 *  处理请求的字典
 *
 *  @param requestDictioinary 请求的字典
 *
 *  @return 处理之后的字典数据
 */
- (NSDictionary *) serializerRequestDictionary:(NSDictionary *)requestDictioinary;

@end