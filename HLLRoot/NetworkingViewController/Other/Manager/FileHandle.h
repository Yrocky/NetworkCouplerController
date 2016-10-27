//
//  FileHandle.h
//  HLLMediaPlay
//
//  Created by admin on 15/11/26.
//  Copyright © 2015年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileHandle : NSObject

#warning 本文件操作仅仅针对于Documents/Private_Documents/Cache下的文件
#warning 切记！！！
+ (FileHandle *)sharedFileHandle;

/** 创建缓存文件夹 */
- (void) creatCacheFile;

// 获得对应视频的path
- (NSString *) getMediaPathWithFileName:(NSString *)fileName;
// 获得对应视频的url
- (NSURL *) getMediaUrlWithMediaName:(NSString *)fileName;
// 获得视频缓存文件夹的地址
- (NSString *) getMediaCachePath;
// 获取视频缓存文件夹的URL
- (NSURL *) getMediaPath;

// 删除缓存视频的文件夹
- (void) clearMediaCacheFolder;
// 删除缓存视频
- (void) removeMediaCacheFileWithFileName:(NSString *)fileName;


// 获取指定文件名的文件大小 - - 多少M
- (float) getFileSizeWithFileName:(NSString *)fileName;
// 获得cache文件夹的大小 - - 返回多少M
// 由于文件夹也有大小，即使文件夹下的文件都被删除了，因此文件夹还是会有一定的内存的
- (float) getFolderSizeAtCachePath;
// 获取cache文件夹下的文件的总大小 - - 返回多少M
- (float) getCacheFileSizeAtCachePath;
// 获取指定文件名的创建时间，格式为yyyy-MM-dd hh:mm
- (NSString *) getFileCreationDateWithFileName:(NSString *)fileName;
@end
