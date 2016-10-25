//
//  HLLBaseFileHandleAdapter.h
//  HLLRoot
//
//  Created by Rocky Young on 16/10/25.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLLBaseRequestAdapter.h"

@class HLLBaseFileHandleAdapter;
@protocol HLLBaseFileHandleAdapterProtocol <NSObject>

- (void)requestAdapter:(HLLBaseFileHandleAdapter *)requestAdapter uploadFileProgress:(NSProgress *)progress;

@end


@interface HLLBaseFileHandleAdapter : HLLBaseRequestAdapter<HLLUploadFileProtocol>

@property (nonatomic ,weak) id<HLLBaseFileHandleAdapterProtocol> fileHandleDelegate;

/** 具体设定逻辑需要和服务器那边进行协调，需要的HTTP header字段有`filename`、`name`、`mimeType` */
- (void) post:(NSString *)url parameters:(id)parameters image:(UIImage *)image appendHTTPHeader:(NSDictionary *)header;

@end



/*///////////////
 
 该类用于封装具有特殊网络请求的操作
 
 比如下载文件、上传文件，特殊的如上传图片
 
 ///////////////*/





/*///////////////
 
 `-post:parameters:image:appendHTTPHeader:`方法用于传递一个图片对象给指定服务器
 
 使用`UIImageJPEGRepresentation(image, 1.0)`对图片进行处理
 
 `header`参数需要按照固定的键值对进行传递，用于对HTTP 的header进行字段的添加
 @{
     @"fileName":@"",
     @"name":@"",
     @"mimeType":@""
 }
 
 ///////////////*/





/*///////////////
 
 该类用于封装具有特殊网络请求的操作
 
 比如下载文件、上传文件，特殊的如上传图片
 
 ///////////////*/



