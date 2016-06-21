//
//  ViewController.m
//  HWNetworkRequest
//
//  Created by HuangWay on 15/11/24.
//  Copyright © 2015年 HuangWay. All rights reserved.
//

#import "ViewController.h"
#import "HWNetworkRequest.h"
@interface ViewController ()
@property(nonatomic,strong) UIScrollView *scroll;
@property(nonatomic,strong) UIView *rotationView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@end
static NSString *const kETagImageURL = @"http://ac-g3rossf7.clouddn.com/xc8hxXBbXexA8LpZEHbPQVB.jpg";
static NSString *const kLastModifiedImageURL = @"http://image17-c.poco.cn/mypoco/myphoto/20151211/16/17338872420151211164742047.png";
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
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [HWNetworkRequest GET:kETagImageURL params:nil success:^(AFHTTPRequestOperation *operation,id responseObject) {
        NSLog(@"%@",responseObject);
        self.iconView.image = [UIImage imageWithData:operation.responseData];
    } failure:^(NSError *error,NSString *resultDescription) {
        NSLog(@"%@,%@",error,resultDescription);
    }];
}
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
