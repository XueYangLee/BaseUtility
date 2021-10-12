//
//  CustomAlert.m
//  BaseTools
//
//  Created by Singularity on 2019/4/19.
//  Copyright © 2019 Singularity. All rights reserved.
//

#import "CustomAlert.h"

@implementation CustomAlert


+ (void)showAlertAddTarget:(UIViewController *)viewController title:(NSString *_Nullable)title message:(NSString *_Nullable)message cancelBtnTitle:(NSString *_Nullable)cancelBtnTitle defaultBtnTitle:(NSString *_Nullable)defaultBtnTitle actionHandle:(void (^ __nullable)(NSInteger actionIndex,NSString *btnTitle))actionHandle{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (cancelBtnTitle) {
        __weak typeof(alert) weakAlert = alert;
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelBtnTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            __strong typeof(weakAlert) alert = weakAlert;
            if (actionHandle) {
                actionHandle([alert.actions indexOfObject:action], action.title);
            }
        }];
        [alert addAction:cancelAction];
    }
    
    if (defaultBtnTitle) {
        __weak typeof(alert) weakAlert = alert;
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:defaultBtnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            __strong typeof(weakAlert) alert = weakAlert;
            if (actionHandle) {
                actionHandle([alert.actions indexOfObject:action], action.title);
            }
        }];
        [alert addAction:defaultAction];
    }
    
    
    [viewController presentViewController:alert animated:YES completion:nil];
    
//    UIViewController *currentViewController = viewController;
//    while (currentViewController.presentedViewController) {
//        currentViewController = currentViewController.presentedViewController;
//    }
//    [currentViewController presentViewController:alert animated:YES completion:nil];
}

+ (void)showAlertWithBtnsAddTarget:(UIViewController *)viewController title:(NSString *_Nullable)title message:(NSString *_Nullable)message cancelBtnTitle:(NSString *_Nullable)cancelBtnTitle otherBtnTitles:(NSArray *_Nullable)otherBtnTitles actionHandle:(void (^ __nullable)(NSInteger actionIndex,NSString *btnTitle))actionHandle{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (cancelBtnTitle) {
        __weak typeof(alert) weakAlert = alert;
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelBtnTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            __strong typeof(weakAlert) alert = weakAlert;
            if (actionHandle) {
                actionHandle([alert.actions indexOfObject:action], action.title);
            }
        }];
        [alert addAction:cancelAction];
    }
    
    if (otherBtnTitles.count!=0) {
        __weak typeof(alert) weakAlert = alert;
        for (NSString *defaultBtnTitle in otherBtnTitles) {
            UIAlertAction *defaultAction=[UIAlertAction actionWithTitle:defaultBtnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                __strong typeof(weakAlert) alert = weakAlert;
                if (actionHandle) {
                    actionHandle([alert.actions indexOfObject:action], action.title);
                }
            }];
            [alert addAction:defaultAction];
        }
        
    }
    
    [viewController presentViewController:alert animated:YES completion:nil];
}



+ (void)showActionSheetAddTarget:(UIViewController *)viewController title:(NSString *_Nullable)title message:(NSString *_Nullable)message redWarnBtnTitle:(NSString *_Nullable)redWarnBtnTitle cancelBtnTitle:(NSString *_Nullable)cancelBtnTitle otherBtnTitles:(NSArray *_Nullable)otherBtnTitles actionHandle:(void (^ __nullable)(NSInteger actionIndex,NSString *btnTitle))actionHandle{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    if (cancelBtnTitle) {
        __weak typeof(alert) weakAlert = alert;
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelBtnTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            __strong typeof(weakAlert) alert = weakAlert;
            if (actionHandle) {
                actionHandle([alert.actions indexOfObject:action], action.title);
            }
        }];
        [alert addAction:cancelAction];
    }
    
    if (redWarnBtnTitle) {
        __weak typeof(alert) weakAlert = alert;
        UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:redWarnBtnTitle style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            __strong typeof(weakAlert) alert = weakAlert;
            if (actionHandle) {
                actionHandle([alert.actions indexOfObject:action], action.title);
            }
        }];
        [alert addAction:destructiveAction];
    }
    
    if (otherBtnTitles.count!=0) {
        __weak typeof(alert) weakAlert = alert;
        for (NSString *defaultBtnTitle in otherBtnTitles) {
            UIAlertAction *defaultAction=[UIAlertAction actionWithTitle:defaultBtnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                __strong typeof(weakAlert) alert = weakAlert;
                if (actionHandle) {
                    actionHandle([alert.actions indexOfObject:action], action.title);
                }
            }];
            [alert addAction:defaultAction];
        }
    }
    
    
    
    [viewController presentViewController:alert animated:YES completion:nil];
}





+ (void)showAlertRemindAddTarget:(UIViewController *)viewController title:(NSString *_Nullable)title message:(NSString *_Nullable)message actionTitle:(NSString *_Nullable)actionTitle{
    
    [self showAlertAddTarget:viewController title:title message:message cancelBtnTitle:actionTitle defaultBtnTitle:nil actionHandle:nil];
}

+ (void)showAlertMessageConfirmAddTarget:(UIViewController *)viewController message:(NSString *_Nullable)message{
    
    [self showAlertAddTarget:viewController title:nil message:message cancelBtnTitle:@"确认" defaultBtnTitle:nil actionHandle:nil];
}

+ (void)showAlertAddTarget:(UIViewController *)viewController title:(NSString *_Nullable)title message:(NSString *_Nullable)message actionHandle:(void (^ __nullable)(NSInteger actionIndex,NSString *btnTitle))actionHandle{
    
    [self showAlertAddTarget:viewController title:title message:message cancelBtnTitle:@"取消" defaultBtnTitle:@"确认" actionHandle:actionHandle];
}






+ (void)showCustomAlertAddTarget:(UIViewController *)viewController title:(NSString *_Nullable)title titleFont:(UIFont *_Nullable)titleFont titleColor:(UIColor *_Nullable)titleColor message:(NSString *_Nullable)message messageFont:(UIFont *_Nullable)messageFont messageColor:(UIColor *_Nullable)messageColor messageAlignment:(NSTextAlignment)messageAlignment cancelBtnTitle:(NSString *_Nullable)cancelBtnTitle cancelBtnColor:(UIColor *_Nullable)cancelBtnColor defaultBtnTitle:(NSString *_Nullable)defaultBtnTitle defaultBtnColor:(UIColor *_Nullable)defaultBtnColor actionHandle:(void (^ __nullable)(NSInteger actionIndex,NSString *btnTitle))actionHandle{
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (title) {
        
        NSMutableAttributedString *attributedTitStr = [[NSMutableAttributedString alloc] initWithString:title];
        //设置颜色
        if (titleColor) {
            [attributedTitStr addAttribute:NSForegroundColorAttributeName value:titleColor range:NSMakeRange(0, attributedTitStr.length)];
        }
        
        //设置大小
        if (titleFont) {
            [attributedTitStr addAttribute:NSFontAttributeName value:titleFont range:NSMakeRange(0, attributedTitStr.length)];
        }
        
        [alert setValue:attributedTitStr forKey:@"attributedTitle"];
        
    }
    
    if (message) {
        
        NSMutableAttributedString *attributedMsgStr = [[NSMutableAttributedString alloc] initWithString:message];
        //设置颜色
        if (messageColor) {
            [attributedMsgStr addAttribute:NSForegroundColorAttributeName value:messageColor range:NSMakeRange(0, attributedMsgStr.length)];
        }
        
        //设置大小
        if (messageFont) {
            [attributedMsgStr addAttribute:NSFontAttributeName value:messageFont range:NSMakeRange(0, attributedMsgStr.length)];
        }
        //文字对齐校准  需接入YYText
//        attributedMsgStr.alignment=messageAlignment;
        
        [alert setValue:attributedMsgStr forKey:@"attributedMessage"];
        
    }
    
    
    if (cancelBtnTitle) {
        __weak typeof(alert) weakAlert = alert;
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelBtnTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            __strong typeof(weakAlert) alert = weakAlert;
            if (actionHandle) {
                actionHandle([alert.actions indexOfObject:action], action.title);
            }
        }];
        [alert addAction:cancelAction];
        
        
        if (cancelBtnColor) {
            [cancelAction setValue:cancelBtnColor forKey:@"titleTextColor"];
        }
    }
    
    if (defaultBtnTitle) {
        __weak typeof(alert) weakAlert = alert;
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:defaultBtnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            __strong typeof(weakAlert) alert = weakAlert;
            if (actionHandle) {
                actionHandle([alert.actions indexOfObject:action], action.title);
            }
        }];
        [alert addAction:defaultAction];
        
        
        if (defaultBtnColor) {
            [defaultAction setValue:defaultBtnColor forKey:@"titleTextColor"];
        }
    }
    
    [viewController presentViewController:alert animated:YES completion:nil];
    
}


@end
