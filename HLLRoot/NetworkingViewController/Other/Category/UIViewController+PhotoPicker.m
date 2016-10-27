//
//  UIViewController+PhotoPicker.m
//  HLLRoot
//
//  Created by Rocky Young on 16/10/26.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "UIViewController+PhotoPicker.h"
#import <objc/runtime.h>

@implementation UIViewController (PhotoPicker)



#pragma mark -
#pragma mark runtimer

- (void)setResult:(PhotoPickerResult)result{

    objc_setAssociatedObject(self, @selector(result), result, OBJC_ASSOCIATION_COPY);
}

- (PhotoPickerResult)result{

    return objc_getAssociatedObject(self, _cmd);
}

#pragma mark -
#pragma mark Photo Picker handle

- (void) photoPickerWithSourceType:(UIImagePickerControllerSourceType)type result:(PhotoPickerResult)result{
    
    self.result = result;
    
    if (type == UIImagePickerControllerSourceTypeCamera){
        
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            
            [SVProgressHUD showErrorWithStatus:@"无法拍照"];
            return;
        }
    }
    
    UIImagePickerController *imaPic = [[UIImagePickerController alloc]init];
    imaPic.delegate = self;
    imaPic.sourceType = type;
    
    [imaPic.navigationBar setTranslucent:NO];
    [imaPic.navigationBar setTintColor:[UIColor colorWithHexString:@"FE8A8A"]];
    imaPic.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor blackColor]};
    imaPic.allowsEditing = YES;
    
    [self presentViewController:imaPic animated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image=[[UIImage alloc]init];
    if (picker.allowsEditing == YES){
        
        image = [info objectForKey:UIImagePickerControllerEditedImage];
    }else{
        
        image=[info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    if (self.result) {
        self.result(image);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
