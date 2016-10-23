//
//  HLLBaseViewController.m
//  HLLRoot
//
//  Created by Rocky Young on 16/10/21.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLLBaseViewController.h"

@interface HLLBaseViewController ()

@end

@implementation HLLBaseViewController


#pragma mark -
#pragma mark Life cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self commonInit];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)loadView{

    [super loadView];
    
    [self loadDefaultConfigure];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureBaseRequest];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:self.hidenNavigationBar
                                             animated:YES];
}

- (void)dealloc {

    [self hud_hidenLoading];
    [self.networkManager cancelRequest];
}

#pragma mark -
#pragma mark Method

- (void) commonInit{
    
    _networkManager = [[V_3_X_Networking alloc] init];
}

- (void) loadDefaultConfigure{
    
    self.hidenNavigationBar = NO;
    self.allowHUDWhenRequestLoading = YES;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
}

- (void) configureBaseRequest{
    
    _baseRequest = [self generateRequest];
    _baseRequest.delegate = self;
}

#pragma mark -
#pragma mark API

- (HLLBaseRequestAdapter *)generateRequest{

    /** 供子类重写，生成不同的网络请求类 */
    return nil;
}

- (void) refreshUIWithRequest:(HLLBaseRequestAdapter *)request withUserInfo:(id)userInfo{

    /** 供子类重写，以获取网络加载的数据 */
}

#pragma mark -
#pragma mark HUD

/** HUD */
- (void) hud_showLoading{
    
    if (![SVProgressHUD isVisible]) {
        
        [SVProgressHUD show];
    }
}
- (void) hud_showSuccessWithMessage:(NSString *)message{
    
    [SVProgressHUD showSuccessWithStatus:message];
}
- (void) hud_showErrorWithMessage:(NSString *)message{

    [SVProgressHUD showErrorWithStatus:message];
}
- (void) hud_hidenLoading{

    [SVProgressHUD dismiss];
}

#pragma mark -
#pragma mark HLLBaseRequestAdapterProtocol

- (void)requestAdapterDidStartRequest:(HLLBaseRequestAdapter *)requestAdapter{

    if (self.allowHUDWhenRequestLoading) {
        
        [self hud_showLoading];
    }
}

- (void)requestAdapter:(HLLBaseRequestAdapter *)requestAdapter didCompleteWithUserInfo:(id)userInfo{

    [self refreshUIWithRequest:requestAdapter withUserInfo:userInfo];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hud_hidenLoading];
    });
}

- (void)requestAdapter:(HLLBaseRequestAdapter *)requestAdapter didFailWithError:(NSError *)error{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hud_showErrorWithMessage:[error localizedDescription]];
    });
}
@end
