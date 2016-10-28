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

- (void)requestAdapter:(HLLBaseFileHandleAdapter *)requestAdapter downloadFileProgress:(NSProgress *)progress;
@end


@interface HLLBaseFileHandleAdapter : HLLBaseRequestAdapter<HLLFileHandleProtocol>

@property (nonatomic ,weak) id<HLLBaseFileHandleAdapterProtocol> fileHandleDelegate;

/** 具体设定逻辑需要和服务器那边进行协调，需要的HTTP header字段有`filename`、`name`、`mimeType` */
- (void) post:(NSString *)url parameters:(id)parameters image:(UIImage *)image appendHTTPHeader:(NSDictionary *)header;

/** 根据URL下载文件到指定的文件夹，需要设定文件的名字 */
- (void)download:(NSString *)url documentsDirectoryPath:(NSString *)documents fileName:(NSString *)fileName;
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
 
 `-download:documentsDirectoryPath:fileName:`方法将给定的URL下的网络资源下载到本地
 
 `documents`是要下载到的文件夹位置、`fileName`是下载之后文件的名字，要有文件后缀
 
 ///////////////*/


