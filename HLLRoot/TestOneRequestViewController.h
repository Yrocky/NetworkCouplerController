//
//  TestOneRequestViewController.h
//  HLLRoot
//
//  Created by Rocky Young on 16/10/23.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLLBaseViewController.h"

@class TestAPI;

@interface TestOneRequestViewController : HLLBaseViewController

@end


@interface TestAPI : HLLBaseRequestAdapter

@property (nonatomic ,strong) NSArray * stories;

@property (nonatomic ,strong) NSArray * top_stories;
@end
