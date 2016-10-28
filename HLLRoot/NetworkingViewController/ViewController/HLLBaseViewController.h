//
//  HLLBaseViewController.h
//  HLLRoot
//
//  Created by Rocky Young on 16/10/21.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLLBaseRequestAdapter.h"

@interface HLLBaseViewController : UIViewController<HLLBaseRequestAdapterProtocol>

/** 是否隐藏导航栏，默认不隐藏 */
@property (nonatomic ,assign ,getter=isHidenNavigationBar) BOOL hidenNavigationBar;
/** 是否在进行网络请求的时候出现HUD，默认YES */
@property (nonatomic ,assign) BOOL allowHUDWhenRequestLoading;

@property (nonatomic, readonly, strong) V_3_X_Networking * networkManager;

@property (nonatomic, readonly, strong) HLLBaseRequestAdapter * baseRequest;

- (HLLBaseRequestAdapter *)generateRequest;

/** 供子类重写，以获取网络加载的数据 */
- (void) refreshUIWithRequest:(HLLBaseRequestAdapter *)request withUserInfo:(id)userInfo;
/** 供子类重写，以获取网络加载失败时候的信的数据 */
- (void) showError:(NSError *)error withUserInfo:(id)userInfo;

/** HUD */
- (void) hud_showLoading;
- (void) hud_showSuccessWithMessage:(NSString *)message;
- (void) hud_showErrorWithMessage:(NSString *)message;
- (void) hud_hidenLoading;

@end



/*///////////////
 
 `-generateRequest`方法用于为每一个界面生成一个网络请求，子类可以重写也可以不重写
 
 子类如果就一个网络请求，重写比较方便
 
 子类如果涉及到多个网络请求，需要自己写方法进行请求类的实例化
 
 这个时候`-refreshUIWithRequest:withUserInfo:`的作用就凸显出来了，
 这个方法是在网络请求成功之后可以拿到数据并且用于更新UI，`info`可以用来区别不同的请求，类似于tag的作用
 
 ///////////////*/




/*///////////////
 
 关于`HLLBaseRequestAdapterProtocol`，子类可以重写其中的方法，如果没有特殊的需求，只要重写`-refreshUIWithRequest:withUserInfo:`方法获取数据就可以
 
 ///////////////*/




/*///////////////
 
 HUD部分可供子类进行调用
 
 在进行网络加载的情况下(包括开始加载、成功或失败)子类不需要再进行调用
 
 ///////////////*/



/*///////////////
 
 `allowHUDWhenRequestLoading`属性用来决定在开始进行网络请求开始的时候是否进行HUD展示
 
 因为有的控制器具有下拉刷新功能，一般下拉刷新都有动画进行指示，不需要额外再多一个HUD
 
 ///////////////*/
