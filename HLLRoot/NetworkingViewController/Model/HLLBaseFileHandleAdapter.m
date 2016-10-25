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
        manager.uploadFileDelegate = self;
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

- (void) progress:(CGFloat)progress withUserInfo:(id)userInfo{

    [NSException raise:@"Upload file is continue ,there is the progress"
                format:@"You Must Override This Method."];
    
}


#pragma mark -
#pragma mark HLLUploadFileProtocol

- (void) networkingDidUploadFile:(HLLNetworking *)networking progress:(NSProgress *)progress{

    if([_fileHandleDelegate respondsToSelector:@selector(requestAdapter:uploadFileProgress:)]){
        
        [_fileHandleDelegate requestAdapter:self uploadFileProgress:progress];
    }
    [self progress:0 withUserInfo:networking.tag];
}

@end
