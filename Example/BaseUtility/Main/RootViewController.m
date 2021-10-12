//
//  RootViewController.m
//  CarServe
//
//  Created by 李雪阳 on 2017/6/5.
//  Copyright © 2017年 singularity. All rights reserved.
//

#import "RootViewController.h"
#import "RootNavigationController.h"
#import "AppDebugBtn.h"

#import "HomeViewController.h"
#import "MineViewController.h"

@interface RootViewController ()<UITabBarControllerDelegate>

@end

@implementation RootViewController

+ (void)initialize
{
    NSMutableDictionary *attrs=[NSMutableDictionary dictionary];
    attrs[NSFontAttributeName]=[UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName]=[UIColor colorWithRed:146/255.0f green:146/255.0f blue:146/255.0f alpha:1];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:166/255.0f green:32/255.0f blue:22/255.0f alpha:1];
    
    UITabBarItem *item=[UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithHexString:@"eeeeee"]];//tabbar背景色
    
    if ([IOS_SYSTEM_VERSION isEqualToString:@"12.1"]) {
        [UITabBar appearance].translucent = NO;
    }
//    [UITabBar appearance].translucent = NO;//取消透明效果/如果使用系统OS12.1 UINavigationController + UITabBarController（ UITabBar 磨砂），在popViewControllerAnimated 会遇到tabbar布局错乱的问题
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    [[UITabBar appearance] setBackgroundColor:[UIColor redColor]];
    self.delegate=self;
    [self setupViewControls];
    
#ifdef DEBUG
    AppDebugBtn *debugBtn = [AppDebugBtn buttonWithType:(UIButtonTypeCustom)];
    debugBtn.frame = CGRectMake(self.view.width - 54, (self.view.height - 44) / 2.0, 44, 44);
    [self.view addSubview:debugBtn];
#endif
    
}

- (void)setupViewControls{
    
    HomeViewController *home=[[HomeViewController alloc]init];
    [self setupViewControl:home title:@"第一页" image:@"tabunselect1" selectedImage:@"tabselect1"];
    
    
    MineViewController *mine=[[MineViewController alloc]init];
    [self setupViewControl:mine title:@"第二页" image:@"tabunselect2" selectedImage:@"tabselect2"];
}

- (void)setupViewControl:(UIViewController *)viewControl title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage{
    
    viewControl.tabBarItem.title=title;
    viewControl.tabBarItem.image=[[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    viewControl.tabBarItem.selectedImage=[[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    RootNavigationController *navi=[[RootNavigationController alloc]initWithRootViewController:viewControl];
    [self addChildViewController:navi];
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
