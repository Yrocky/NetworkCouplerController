//
//  HLLNibProtocol.h
//  HLLRoot
//
//  Created by Rocky Young on 16/10/23.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HLLNibProtocol <NSObject>

@optional;

+ (UINib *) nib;

+ (instancetype) loadWithBundle;

+ (NSString *) cellIdentifier;

- (void) configureCellWithData:(id)data;

@end
