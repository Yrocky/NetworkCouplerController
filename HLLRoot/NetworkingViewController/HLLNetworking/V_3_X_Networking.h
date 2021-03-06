//
//  V_3_X_Networking.h
//  HLLNetworking
//
//  Created by admin on 16/2/22.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLLNetworking.h"

@interface V_3_X_Networking : HLLNetworking

- (void)uploadWithUrl:(NSString *)urlString parameters:(NSDictionary *)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block;

- (void)downloadWithUrl:(NSString *)urlString destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination;
@end

