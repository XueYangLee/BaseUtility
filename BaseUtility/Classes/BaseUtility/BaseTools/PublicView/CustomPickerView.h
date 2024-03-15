//
//  CustomPickerView.h
//  BaseTools
//
//  Created by 李雪阳 on 2021/4/22.
//  Copyright © 2021 Singularity. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^pickerCompletion)(NSInteger pickerIndex,NSString *pickerTitle);

@interface CustomPickerView : UIView

- (instancetype)initWithData:(NSArray *)dataArray completion:(pickerCompletion)comp;

- (instancetype)initWithCompletion:(pickerCompletion)comp;

- (instancetype)init;

@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,assign) NSInteger selectRow;

@property (nonatomic,copy) pickerCompletion pickerComp;

@property (nonatomic,copy) NSString *title;

- (void)show;

@end

NS_ASSUME_NONNULL_END
