//
//  HLLBaseFileHandleAdapter.m
//  HLLRoot
//
//  Created by Rocky Young on 16/10/25.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLLBaseFileHandleAdapter.h"

@implementation HLLBaseFileHandleAdapter

- (instancetype)initWithNetworkManager:(HLLNetworking *)manager
{
    if( self = [super initWithNetworkManager:manager])
    {
        manager.fileHandleDelegate = self;
    }
    
    return self;
}

- (void) post:(NSString *)url parameters:(id)parameters image:(UIImage *)image appendHTTPHeader:(NSDictionary *)header{

    self.networkManager.tag = self.userInfo;
    
    NSData * data = UIImageJPEGRepresentation(image, 1.0);
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
- (void) progress:(CGFloat)progress withUserInfo:(id)userInfo{

    [NSException raise:@"Upload file is continue ,there is the progress"
                format:@"You Must Override This Method."];
}


#pragma mark -
#pragma mark HLLFileHandleProtocol

- (void) networkingDidUploadFile:(HLLNetworking *)networking progress:(NSProgress *)progress{

    if([_fileHandleDelegate respondsToSelector:@selector(requestAdapter:uploadFileProgress:)]){
        
        [_fileHandleDelegate requestAdapter:self uploadFileProgress:progress];
    }
    [self progress:progress.completedUnitCount withUserInfo:networking.tag];
}


- (void)networkingDidDownloadFile:(HLLNetworking *)networking progress:(NSProgress *)progress{

    if([_fileHandleDelegate respondsToSelector:@selector(requestAdapter:downloadFileProgress:)]){
        
        [_fileHandleDelegate requestAdapter:self downloadFileProgress:progress];
    }
    [self progress:progress.completedUnitCount withUserInfo:networking.tag];
}

@end
