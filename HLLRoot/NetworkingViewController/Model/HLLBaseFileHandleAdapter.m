//
//  HLLBaseFileHandleAdapter.m
//  HLLRoot
//
//  Created by Rocky Young on 16/10/25.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLLBaseFileHandleAdapter.h"

@implementation HLLBaseFileHandleAdapter

- (instancetype)initWithNetworkManager:(__kindof HLLNetworking *)manager
{
    if( self = [super initWithNetworkManager:manager])
    {
        manager.fileHandleDelegate = self;
    }
    
    return self;
}

- (void)start{

    [super start];
    
}
- (void) progress:(CGFloat)progress withUserInfo:(id)userInfo{
    
    /** 供子类重写，获取下载或者上传进度 */
}

- (void) post:(NSString *)url parameters:(id)parameters data:(NSData *)data appendHTTPHeader:(NSDictionary *)header{

    self.networkManager.tag = self.userInfo;
    
    [self.networkManager uploadWithUrl:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        if (data) {

            NSString * name = header[@"name"];
            NSString * fileName = header[@"fileName"];
            NSString * mineType = header[@"mimeType"];
            [formData appendPartWithFileData:data name:name fileName:fileName mimeType:mineType];
        }
    }];
}

- (void)download:(NSString *)url documentsDirectoryPath:(NSString *)documents fileName:(NSString *)fileName{

    [self.networkManager downloadWithUrl:url destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
       
        NSString * name = fileName;
        if (!name) {
            name = [NSString stringWithFormat:@"%@", [response suggestedFilename]];
        }
        NSString * mediaPath = [documents stringByAppendingPathComponent:fileName];
        
        return [NSURL fileURLWithPath:mediaPath];
    }];
}

#pragma mark -
#pragma mark HLLFileHandleProtocol

- (void) networkingDidUploadFile:(__kindof HLLNetworking *)networking progress:(NSProgress *)progress{

    [self progress:progress.completedUnitCount withUserInfo:networking.tag];
    
    if([_fileHandleDelegate respondsToSelector:@selector(requestAdapter:uploadFileProgress:)]){
        
        [_fileHandleDelegate requestAdapter:self uploadFileProgress:progress];
    }
}

- (void)networkingDidDownloadFile:(__kindof HLLNetworking *)networking progress:(NSProgress *)progress{

    [self progress:progress.completedUnitCount withUserInfo:networking.tag];
    
    if([_fileHandleDelegate respondsToSelector:@selector(requestAdapter:downloadFileProgress:)]){
        
        [_fileHandleDelegate requestAdapter:self downloadFileProgress:progress];
    }
}

@end
