//
//  UIViewController+PhotoPicker.h
//  HLLRoot
//
//  Created by Rocky Young on 16/10/26.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PhotoPickerResult)(UIImage *image);
typedef void(^PhotoPickerCancel)();

@interface UIViewController (PhotoPicker)<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic ,copy) PhotoPickerResult result;
@property (nonatomic ,copy) PhotoPickerCancel cancel;

- (void) photoPickerWithSourceType:(UIImagePickerControllerSourceType)type
                            result:(PhotoPickerResult)result
                            cancel:(PhotoPickerCancel)cancel;

@end
