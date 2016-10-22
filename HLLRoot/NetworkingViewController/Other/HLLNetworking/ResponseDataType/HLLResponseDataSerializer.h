//
//  HLLResponseDataSerializer.h
//  HLLNetworking
//
//  Created by admin on 16/2/22.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HLLResponseDataSerializer <NSObject>


- (NSDictionary *) serializerResponseDictionary:(NSDictionary *)responseDictionary;

@end
