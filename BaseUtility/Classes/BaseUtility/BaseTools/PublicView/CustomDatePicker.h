//
//  CustomDatePicker.h
//  Doctor
//
//  Created by 李雪阳 on 2021/9/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^datePickerCompletion)(NSDate *date, NSString *dateString);

@interface CustomDatePicker : UIView

- (instancetype)initWithCompletion:(datePickerCompletion)comp;
- (instancetype)init;

@property (nonatomic,copy) datePickerCompletion pickerComp;

@property (nonatomic,strong) NSDate *minSelectDate;
@property (nonatomic,strong) NSDate *maxSelectDate;

- (void)show;

@end

NS_ASSUME_NONNULL_END
