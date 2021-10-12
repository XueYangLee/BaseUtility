//
//  BaseViewController.m
//  textPod
//
//  Created by 李雪阳 on 2017/11/21.
//  Copyright © 2017年 singularity. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;
@property (nonatomic, assign) BOOL statusBarHidden;
@property (nonatomic, strong) UIView *statusBarView;

@end

@implementation BaseViewController

#if DEBUG
- (void)injected {
    [self viewDidLoad];
}
#endif

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.edgesExtendLayout = YES;//坐标是否从导航栏下计算
    self.hideNavigationBar = NO;//隐藏显示导航栏
    self.hideNaviShadow = YES;//是否隐藏导航栏下阴影线
}

//坐标是否从导航栏下计算
- (void)setEdgesExtendLayout:(BOOL)edgesExtendLayout{
    if (edgesExtendLayout){
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }else{
        if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
            self.edgesForExtendedLayout = UIRectEdgeAll;
        }
    }
}

//隐藏显示导航栏
- (void)setHideNavigationBar:(BOOL)hideNavigationBar{
    self.navigationController.navigationBarHidden = hideNavigationBar;
//    self.fd_prefersNavigationBarHidden=hideNavigationBar;
}

//是否隐藏导航栏下阴影线
- (void)setHideNaviShadow:(BOOL)hideNaviShadow{
    [self.navigationController.navigationBar setShadowImage:(hideNaviShadow)?[UIImage new]:nil];
//    [self wr_setNavBarShadowImageHidden:hideNaviShadow];
}



//左侧导航栏按钮
- (void)setNavigationLeftBarBtnItemWithImage:(UIImage *)image action:(SEL)selector{
    UIImage *searchImg=[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithImage:searchImg style:UIBarButtonItemStylePlain target:self action:selector];
}

//右侧导航栏按钮
- (void)setNavigationRightBarBtnItemWithTitle:(NSString *)title image:(UIImage *)image action:(SEL)selector{
    if (title) {
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:selector];
    } else{
        UIImage *searchImg=[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithImage:searchImg style:UIBarButtonItemStylePlain target:self action:selector];
    }
}


//在 Info.plist 文件中添加 View controller-based status bar appearance 设置为 YES 否则不生效
- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.statusBarStyle;
}

- (BOOL)prefersStatusBarHidden {
    return self.statusBarHidden;
}

//statusBar类型设置
- (void)changeStatusBarStyle:(UIStatusBarStyle)statusBarStyle statusBarHidden:(BOOL)statusBarHidden{
    self.statusBarStyle=statusBarStyle;
    self.statusBarHidden=statusBarHidden;
    [self setNeedsStatusBarAppearanceUpdate];
}
/** 需要在RootNavigationVC中添加函数以重写status做统一设置
 - (UIViewController *)childViewControllerForStatusBarStyle{
 return self.topViewController;
 }
 */

//更改statusbar颜色
- (void)changeStatusBarColor:(UIColor *)barColor{
    self.statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, -([[UIApplication sharedApplication] statusBarFrame].size.height), self.view.frame.size.width, [[UIApplication sharedApplication] statusBarFrame].size.height)];
    self.statusBarView.backgroundColor = barColor;
    [self.navigationController.navigationBar addSubview:self.statusBarView];
}

//移除statusbar颜色
- (void)removeStatusBarColor{
    [self.statusBarView removeFromSuperview];
}


//初始化tableview（需添加代理）
- (UITableView *)tableViewWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    UITableView *tableView=[[UITableView alloc]initWithFrame:frame style:style];
    tableView.showsVerticalScrollIndicator=NO;
    tableView.showsHorizontalScrollIndicator=NO;
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.sectionFooterHeight = 0;
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    tableView.delegate=self;
    tableView.dataSource=self;
    if (@available(iOS 11.0, *)) {
        if ([self respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]){
            tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
        }
    } else {
        if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return tableView;
}



#pragma mark - touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
//    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
