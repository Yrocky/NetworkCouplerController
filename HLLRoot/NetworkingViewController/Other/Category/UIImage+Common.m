//
//  UIImage+Common.m
//  CategoryDemo
//
//  Created by Youngrocky on 16/5/8.
//  Copyright © 2016年 Young Rocky. All rights reserved.
//
#import "UIImage+Common.h"

@implementation UIImage (Common)

+(UIImage *)imageWithColor:(UIColor *)aColor{
    
    return [UIImage imageWithColor:aColor withFrame:CGRectMake(0, 0, 1, 1)];
}

+(UIImage *)imageWithColor:(UIColor *)aColor withFrame:(CGRect)aFrame{
    
    UIGraphicsBeginImageContext(aFrame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [aColor CGColor]);
    CGContextFillRect(context, aFrame);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

//对图片尺寸进行压缩--
-(UIImage*)scaledToSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat scaleFactor = 0.0;
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetSize.width / imageSize.width;
        CGFloat heightFactor = targetSize.height / imageSize.height;
        if (widthFactor < heightFactor){
            scaleFactor = heightFactor; // scale to fit height
        }else{
            scaleFactor = widthFactor; // scale to fit width
        }
    }
    scaleFactor = MIN(scaleFactor, 1.0);
    CGFloat targetWidth = imageSize.width* scaleFactor;
    CGFloat targetHeight = imageSize.height* scaleFactor;

    targetSize = CGSizeMake(floorf(targetWidth), floorf(targetHeight));
    UIGraphicsBeginImageContext(targetSize); // this will crop
    [sourceImage drawInRect:CGRectMake(0, 0, ceilf(targetWidth), ceilf(targetHeight))];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"could not scale image");
        newImage = sourceImage;
    }
    UIGraphicsEndImageContext();
    return newImage;
}
-(UIImage*)scaledToSize:(CGSize)targetSize highQuality:(BOOL)highQuality{
    if (highQuality) {
        targetSize = CGSizeMake(2*targetSize.width, 2*targetSize.height);
    }
    return [self scaledToSize:targetSize];
}

-(UIImage *)scaledToMaxSize:(CGSize)size{
    
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    CGFloat oldWidth = self.size.width;
    CGFloat oldHeight = self.size.height;
    
    CGFloat scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;
    
    // 如果不需要缩放
    if (scaleFactor > 1.0) {
        return self;
    }
    
    CGFloat newHeight = oldHeight * scaleFactor;
    CGFloat newWidth = oldWidth * scaleFactor;
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)imageOutlineWithCornerRadius:(CGFloat)cornerRadius fillColor:(UIColor *)fillColor
{
    return [self imageOutlineWithCornerRadius:cornerRadius
                                  strokeColor:nil
                                    fillColor:fillColor];
}

+ (UIImage *)imageOutlineWithCornerRadius:(CGFloat)cornerRadius strokeColor:(UIColor *)strokeColor
{
    return [self imageOutlineWithCornerRadius:cornerRadius
                                  strokeColor:strokeColor
                                    fillColor:nil];
}

+ (UIImage *)imageOutlineWithCornerRadius:(CGFloat)cornerRadius strokeColor:(UIColor *)strokeColor fillColor:(UIColor *)fillColor insetPonint:(CGPoint)insetPoint drawingRect:(CGRect)drawingRect
{
    UIGraphicsBeginImageContextWithOptions(drawingRect.size, NO, [UIScreen mainScreen].scale);
    UIBezierPath *aPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(drawingRect, insetPoint.x, insetPoint.y) cornerRadius:cornerRadius];
    if (strokeColor) {
        [strokeColor setStroke];
        [aPath stroke];
    }
    if (fillColor) {
        [fillColor setFill];
        [aPath fill];
    }
    UIImage *res = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return res;
}
+ (UIImage *)imageOutlineWithCornerRadius:(CGFloat)cornerRadius strokeColor:(UIColor *)strokeColor fillColor:(UIColor *)fillColor rect:(CGRect)drawingRect
{
    UIGraphicsBeginImageContextWithOptions(drawingRect.size, NO, [UIScreen mainScreen].scale);
    UIBezierPath *aPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(drawingRect, 1.0f, 1.0f) cornerRadius:cornerRadius];
    if (strokeColor) {
        [strokeColor setStroke];
        [aPath stroke];
    }
    if (fillColor) {
        [fillColor setFill];
        [aPath fill];
    }
    UIImage *res = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return res;
}

+ (UIImage *)imageOutlineWithCornerRadius:(CGFloat)cornerRadius strokeColor:(UIColor *)strokeColor fillColor:(UIColor *)fillColor
{
    CGRect drawingRect = CGRectMake(0, 0, 2 * cornerRadius + 3.0f, 2 * cornerRadius + 3.0f);
    UIGraphicsBeginImageContextWithOptions(drawingRect.size, NO, [UIScreen mainScreen].scale);
    UIBezierPath *aPath = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(drawingRect, 1.0f, 1.0f) cornerRadius:cornerRadius];
    aPath.lineWidth = 0.5;
    if (strokeColor) {
        [strokeColor setStroke];
        [aPath stroke];
    }
    if (fillColor) {
        [fillColor setFill];
        [aPath fill];
    }
    UIImage *res = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return res;
}

- (UIImage *)imageByApplyingAlpha:(CGFloat) alpha {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, self.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)imageWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor size:(CGSize)size
{
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.frame = CGRectMake(0, 0, size.width, size.height);
    layer.colors = @[ (__bridge id)startColor.CGColor,   // start color
                      (__bridge id)endColor.CGColor ]; // end color
    
    CIFilter *blur = [CIFilter filterWithName:@"CIGaussianBlur"];
    [blur setDefaults];
    layer.backgroundFilters = [NSArray arrayWithObject:blur];
    UIGraphicsBeginImageContext(size);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *res = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return res;
}

@end
