//
//  UIImage+Common.h
//  CategoryDemo
//
//  Created by Youngrocky on 16/5/8.
//  Copyright © 2016年 Young Rocky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Common)

/**
 *  根据`颜色`生成一个image实例
 */
+ (UIImage *)imageWithColor:(UIColor *)aColor;

/**
 *  根据`颜色`以及`frame`生成一个image实例
 */
+ (UIImage *)imageWithColor:(UIColor *)aColor withFrame:(CGRect)aFrame;

/**
 *  将原有image实例进行size的改变
 */
- (UIImage*)scaledToSize:(CGSize)targetSize;

/**
 *  将原有image实例进行size的改变，并且提供是否要求输出高质量的image
 */
- (UIImage*)scaledToSize:(CGSize)targetSize highQuality:(BOOL)highQuality;

/**
 *  将原有image实例进行size的改变，
 */
- (UIImage*)scaledToMaxSize:(CGSize )size;

/**
 *  根据`渐变色`以及`尺寸`生成一个图片对象
 */
+ (UIImage *)imageWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor size:(CGSize)size;

/**
 *  根据`圆角度数`以及`填充色`生成一个图片对象
 */
+ (UIImage *)imageOutlineWithCornerRadius:(CGFloat)cornerRadius fillColor:(UIColor *)fillColor;

/**
 *  根据`圆角度数`以及`边缘色`生成一个图片对象
 */
+ (UIImage *)imageOutlineWithCornerRadius:(CGFloat)cornerRadius strokeColor:(UIColor *)strokeColor;

/**
 *  根据`圆角度数`、`边缘色`以及`填充色`生成一个图片对象
 */
+ (UIImage *)imageOutlineWithCornerRadius:(CGFloat)cornerRadius strokeColor:(UIColor *)strokeColor fillColor:(UIColor *)fillColor;

/**
 *  在规定的区域内，根据`圆角度数`、`边缘色`以及`填充色`生成一个图片对象
 */
+ (UIImage *)imageOutlineWithCornerRadius:(CGFloat)cornerRadius strokeColor:(UIColor *)strokeColor fillColor:(UIColor *)fillColor rect:(CGRect)drawingRect;

/**
 *  在规定的区域内，根据`圆角度数`、`边缘色`以及`填充色`生成一个图片对象
 */
+ (UIImage *)imageOutlineWithCornerRadius:(CGFloat)cornerRadius strokeColor:(UIColor *)strokeColor fillColor:(UIColor *)fillColor insetPonint:(CGPoint)insetPoint drawingRect:(CGRect)drawingRect;

/**
 *  将原有image实例进行`alpha`的改变，
 */
- (UIImage *)imageByApplyingAlpha:(CGFloat) alpha;

@end
