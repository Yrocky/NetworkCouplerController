//
//  FileHandle.m
//  HLLMediaPlay
//
//  Created by admin on 15/11/26.
//  Copyright © 2015年 admin. All rights reserved.
//

#import "FileHandle.h"

#define Documents_Media_Cache_Path @"Documents/Private_Documents/Cache"

@implementation FileHandle

static FileHandle *_instance;
+ (id)allocWithZone:(NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
+ (FileHandle *)sharedFileHandle
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self creatCacheFolder];
    }
    return self;
}


#pragma mark -
#pragma mark Create

- (void) creatCacheFolder{
    
    NSString * cachePath = [self getFileCachePath];
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    
    if(![fileManager fileExistsAtPath:cachePath]){
        
        [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

#pragma mark - get

// 获得对应文件的url
- (NSURL *) getFileUrlWithMediaName:(NSString *)fileName{
    
    NSURL * fileUrl = [NSURL fileURLWithPath:[self getFilePathWithFileName:fileName]];
    return fileUrl;
}
// 获得对应文件的path
- (NSString *) getFilePathWithFileName:(NSString *)fileName{
    
    NSString * cachePath = [self getFileCachePath];
    NSString * filePath = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
    return filePath;
}

// 获得视频缓存文件夹的地址
- (NSString *) getFileCachePath{
    
    return [NSHomeDirectory() stringByAppendingPathComponent:Documents_Media_Cache_Path];
}

- (NSURL *) getFileCacheUrl{
    
    NSURL * fileCacheUrl = [NSURL URLWithString:[self getFileCachePath]];
    return fileCacheUrl;
}
#pragma mark - delete
// 删除缓存视频文件夹
- (void) clearFileCacheFolder{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *cachePath = [self getFileCachePath];
    
    [fileManager removeItemAtPath:cachePath error:nil];
}

// 删除本地缓存的文件
- (void) removeFileWithFileName:(NSString *)fileName{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString * mediaPath = [self getFilePathWithFileName:fileName];
    
    [fileManager removeItemAtPath:mediaPath error:nil];
}

#pragma mark - fileAttribute
// 返回cache文件夹
- (NSDictionary *) getCacheFileAttributes{
    
    NSString * cachePath = [self getFileCachePath];
    NSFileManager * filemanager = [NSFileManager defaultManager];
    
    if ([filemanager fileExistsAtPath:cachePath]) {
        return [filemanager attributesOfItemAtPath:cachePath error:nil];
    }
    return nil;
}
// 返回指定文件名的文件信息
- (NSDictionary *) getFileAttributesWithFileName:(NSString *)fileName{

    NSString * mediaPath = [self getFilePathWithFileName:fileName];
    NSFileManager * filemanager = [NSFileManager defaultManager];
    
    if ([filemanager fileExistsAtPath:mediaPath]) {
        return [filemanager attributesOfItemAtPath:mediaPath error:nil];
    }
    return nil;
}
// 获取指定文件名的文件大小 - - 多少M
- (float) getFileSizeWithFileName:(NSString *)fileName{

    NSDictionary * fileAttribute = [self getFileAttributesWithFileName:fileName];

    if (fileAttribute) {
        long long fileSize = [fileAttribute fileSize];
        return fileSize /(1024.0 * 1024.0);
    }
    return 0.0;
}

// 获得cache文件夹的大小 - - 返回多少M
- (float) getFolderSizeAtCachePath{
    
    NSDictionary * cacheAttribute = [self getCacheFileAttributes];
    
    if (cacheAttribute) {
        long long fileSize = [cacheAttribute fileSize];
        return fileSize /(1024.0 * 1024.0);
    }
    return 0.0;
}
// 获取cache文件夹下的文件的总大小 - - 返回多少M
- (float) getCacheFileSizeAtCachePath{

    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:[self getFileCachePath]]) return 0;
    
    NSEnumerator *childFilesEnumerator = [[fileManager subpathsAtPath:[self getFileCachePath]] objectEnumerator];
    
    NSString* fileName;
    
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSLog(@"fileName:%@",fileName);
//        fileName = [fileName stringByDeletingPathExtension];
        folderSize += [self getFileSizeWithFileName:fileName];
    }
    
    return folderSize;
}
// 获取指定文件名的创建时间，格式为yyyy-MM-dd hh:mm
- (NSString *) getFileCreationDateWithFileName:(NSString *)fileName{
    
    NSDictionary * fileAttribute = [self getFileAttributesWithFileName:fileName];
    
    if (fileAttribute) {
        NSDate * creatioinDate = [fileAttribute fileCreationDate];
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        return [dateFormatter stringFromDate:creatioinDate];
    }
    return @"";
}

@end
