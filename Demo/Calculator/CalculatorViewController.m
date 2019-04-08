//
//  CalculatorViewController.m
//  Demo
//
//  Created by bob on 2019/4/8.
//  Copyright © 2019 bob. All rights reserved.
//

#import "CalculatorViewController.h"
#import <Expression/Expression.h>

@interface CalculatorViewController ()

@property (nonatomic, strong) UITextField *codeInput;
@property (nonatomic, strong) UILabel *codeOutput;

@end

@implementation CalculatorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    CGFloat width = self.view.bounds.size.width;
    UITextField *input = [[UITextField alloc] initWithFrame:CGRectMake(20, 100, width - 40, 44)];
    input.borderStyle = UITextBorderStyleRoundedRect;
    input.text = @"3+2";
    self.codeInput = input;
    [self.view addSubview:input];

    UILabel *codeOutput = [[UILabel alloc] initWithFrame:CGRectMake(20, 160, width - 40, 44)];
    codeOutput.textAlignment = NSTextAlignmentCenter;
    codeOutput.backgroundColor = [UIColor grayColor];
    self.codeOutput = codeOutput;
    [self.view addSubview: codeOutput];

    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(20, 220, width - 40, 44)];
    [button1 setTitle:@"Calculate" forState:(UIControlStateNormal)];
    [button1 addTarget:self action:@selector(calculateEx) forControlEvents:(UIControlEventTouchUpInside)];
    button1.backgroundColor = [UIColor blueColor];
    [self.view addSubview:button1];
}

- (void)calculateEx {
    NSString *code = self.codeInput.text;
    self.codeOutput.text = code;
}

@end
