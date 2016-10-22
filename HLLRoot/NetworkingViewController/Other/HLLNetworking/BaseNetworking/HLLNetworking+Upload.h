//
//  HLLNetworking+Upload.h
//  HLLNetworking
//
//  Created by Rocky Young on 16/8/11.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLLNetworking.h"

@interface HLLNetworking (Upload)

+ (void)postUploadWithUrl:(NSString *)urlStr fileUrl:(NSURL *)fileURL fileName:(NSString *)fileName fileType:(NSString *)fileTye success:(void (^)(id responseObject))success fail:(void (^)())fail;
@end
