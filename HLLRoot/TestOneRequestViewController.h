//
//  TestOneRequestViewController.h
//  HLLRoot
//
//  Created by Rocky Young on 16/10/23.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "HLLBaseViewController.h"

@class TestTwoAPI;
@class TestOneAPI;

@interface TestOneRequestViewController : HLLBaseViewController

@property (nonatomic ,strong) TestOneAPI * testOneAPI;
@property (nonatomic ,strong) TestTwoAPI * testTwoAPI;
@end


@interface TestOneAPI : HLLBaseRequestAdapter

@property (nonatomic ,strong) NSArray * stories;

@property (nonatomic ,strong) NSArray * top_stories;
@end


@interface TestTwoAPI : HLLBaseRequestAdapter

@property (nonatomic ,strong) NSArray * temp_data;
@end
