//
//  RootNavigationController.m
//  CarServe
//
//  Created by 李雪阳 on 2017/6/5.
//  Copyright © 2017年 singularity. All rights reserved.
//

#import "RootNavigationController.h"
#import <BaseUtility/BaseUtility.h>

@interface RootNavigationController ()

@end

@implementation RootNavigationController

+ (void)initialize
{
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];//按钮颜色
    [[UINavigationBar appearance] setBarTintColor:UIColorWithRGBA(180, 0, 0, 1)];//背景色
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:18], NSFontAttributeName, nil]];//标题字体设置
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.interactivePopGestureRecognizer.delegate=(id)self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.childViewControllers.count > 0){
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"navi_back"] forState:UIControlStateNormal];
        button.frame = CGRectMake(0, 0, 70, 30);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        //        [button sizeToFit];
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    
    if (self.viewControllers.count > 0){
        
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)back{
    [self popViewControllerAnimated:YES];
}


- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}

- (NSArray<__kindof UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    if (self.viewControllers.count > 1) {
        self.topViewController.hidesBottomBarWhenPushed = NO;
    }
    // self.viewControllers has two items here on iOS14  //https://developer.apple.com/forums/thread/660750 //ios 14popToRoot问题
    return [super popToRootViewControllerAnimated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
