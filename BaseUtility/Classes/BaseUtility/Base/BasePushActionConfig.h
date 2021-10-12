//
//  BasePushActionConfig.h
//  BaseTools
//
//  Created by 李雪阳 on 2019/3/29.
//  Copyright © 2019 Singularity. All rights reserved.
//

#ifndef BasePushActionConfig_h
#define BasePushActionConfig_h


/** push页面 */
#define NaviRoutePushToVC(ViewController,beAnimated)\
UINavigationController *navi = [UIViewController currentViewController].navigationController;\
[navi pushViewController:ViewController animated:beAnimated];


/** 跳转新页面同时移除老页面或指定页面 */
#define NaviRoutePushToNewVCRemoveVC(ViewController,RemoveViewControllerClass,beAnimated)\
UINavigationController *navi = [UIViewController currentViewController].navigationController;\
[navi pushViewController:ViewController animated:beAnimated];\
if ([navi.childViewControllers indexOfObject:[UIViewController currentViewController]]!=0) {\
    NSMutableArray *vcs = [navi.viewControllers mutableCopy];\
    for (UIViewController *vc in navi.viewControllers) {\
        if ([vc isKindOfClass:RemoveViewControllerClass] ) {\
            [vcs removeObject:vc];}\
    }\
    navi.viewControllers=vcs;}


/** pop页面 */
#define NaviRoutePopVC(beAnimated)\
UINavigationController *navi = [UIViewController currentViewController].navigationController;\
[navi popViewControllerAnimated:beAnimated]


/** popToRoot页面 */
#define NaviRoutePopToRoot(beAnimated)\
UINavigationController *navi = [UIViewController currentViewController].navigationController;\
[navi popToRootViewControllerAnimated:beAnimated];


/** pop到指定页面 */
#define NaviRoutePopToVC(ViewController,beAnimated)\
UINavigationController *navi = [UIViewController currentViewController].navigationController;\
[navi popToViewController:ViewController animated:beAnimated];


/** navi使用Present样式出现页面  从下到上动画出现 */
#define NaviRoutePresentToVC(ViewController)\
UINavigationController *navi = [UIViewController currentViewController].navigationController;\
CATransition *transition = [CATransition animation];\
transition.duration = 0.35f;\
transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];\
transition.type = kCATransitionMoveIn;\
transition.subtype = kCATransitionFromTop;\
[navi.view.layer addAnimation:transition forKey:nil];\
[navi pushViewController:ViewController animated:NO];\


/** navi使用Present样式离开页面  从上到下动画离开 */
#define NaviRouteDismissVC \
UINavigationController *navi = [UIViewController currentViewController].navigationController;\
CATransition *transition = [CATransition animation];\
transition.duration = 0.35f;\
transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];\
transition.type = kCATransitionReveal;\
transition.subtype = kCATransitionFromBottom;\
[navi.view.layer addAnimation:transition forKey:nil];\
[navi popViewControllerAnimated:NO];\



#endif /* BasePushActionConfig_h */
