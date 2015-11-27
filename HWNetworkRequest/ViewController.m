//
//  ViewController.m
//  HWNetworkRequest
//
//  Created by HuangWay on 15/11/24.
//  Copyright © 2015年 HuangWay. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(nonatomic,strong) UIScrollView *scroll;
@property(nonatomic,strong) UIView *rotationView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)setUpUI {
    self.rotationView = [[UIView alloc]init];
    self.rotationView.frame = CGRectMake(50, 50, 200, 200);
    for (NSInteger i = 0; i < 4; i ++) {
        NSString *name = [NSString stringWithFormat:@"share%ld",(long)i];
        UIButton *btn = [self buttonWithImageName:name action:@selector(buttonClick:) tag:i];
        [self.rotationView addSubview:btn];
    }
}

- (UIButton *)buttonWithImageName:(NSString *)name action:(SEL)action tag:(NSInteger)tag {
    UIButton *btn = [[UIButton alloc]init];
    [btn setBackgroundImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    btn.tag = tag;
    return btn;
}
- (void)buttonClick:(UIButton *)sender {
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
