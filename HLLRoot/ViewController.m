//
//  ViewController.m
//  HLLRoot
//
//  Created by Rocky Young on 16/10/20.
//  Copyright © 2016年 HLL. All rights reserved.
//

#import "ViewController.h"
#import "TestOneRequestViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor randomColor];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 80, 40);
    [button setTitle:@"Next" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor randomColor];
    [button addTarget:self action:@selector(sendRequest:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)sendRequest:(id)sender {

    TestOneRequestViewController * vc = [[TestOneRequestViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
