//
//  HLLNoDataView.h
//  HLLRoot
//
//  Created by Rocky Young on 16/10/22.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLLNoDataView : UIView

@property(nonatomic,strong)UIImageView * imageView;
@property(nonatomic,strong)UILabel * titlelable;

- (void) configureNoDataViewWithCapion:(NSString *)capion
                            alertImage:(UIImage *)alertImage;

@end


@interface UIScrollView (NoDataView)

@property(nonatomic,strong)UIView * noDataView;

@end
