//
//  HLLNoDataView.m
//  HLLRoot
//
//  Created by Rocky Young on 16/10/22.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLLNoDataView.h"
#import "objc/runtime.h"

@implementation HLLNoDataView

-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor=[UIColor clearColor];
        
        self.titlelable = [[UILabel alloc] init];
        self.titlelable.textColor = [UIColor colorWithHexString:@"FE8A8A"];
        self.titlelable.font = [UIFont systemFontOfSize:14];
        self.titlelable.text = @"没有结果";
        [self addSubview:self.titlelable];
        [self.titlelable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(self.mas_centerY);
        }];
        
        self.imageView = [[UIImageView alloc]init];
        self.imageView.image = [UIImage imageNamed:@"no_data"];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.bottom.mas_equalTo(self.titlelable.mas_top).offset(-30);
        }];
    }
    return self;
}

- (void) configureNoDataViewWithCapion:(NSString *)capion
                            alertImage:(UIImage *)alertImage{

    if (capion) {
        
        self.titlelable.text = capion;
    }
    if (alertImage) {
        
        self.imageView.image = alertImage;
    }
}

@end


@implementation UIScrollView (NoDataView)

- (void)setNoDataView:(UIView *)noDataView{
    
    objc_setAssociatedObject(self, @selector(noDataView), noDataView, OBJC_ASSOCIATION_RETAIN);
    noDataView.hidden = YES;
    [self addSubview:self.noDataView];
}

-(UIView *)noDataView
{
    return objc_getAssociatedObject(self, _cmd);
}

@end
