//
//  CustomDatePicker.m
//  Doctor
//
//  Created by 李雪阳 on 2021/9/23.
//

#import "CustomDatePicker.h"
#import "UtilityMacro.h"
#import <Masonry/Masonry.h>
#import <FuncControl/FuncChains.h>

@interface CustomDatePicker ()

@property (nonatomic,strong) UIView *bkView;

@property (nonatomic,strong) UIDatePicker *datePicker;

@property (nonatomic,copy) datePickerCompletion comp;

@end

#define BKVIEW_HEIGHT 334

@implementation CustomDatePicker

- (instancetype)initWithCompletion:(datePickerCompletion)comp {
    self = [super init];
    if (self) {
        _comp=comp;
        [self initUI];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI{
    self.frame=[[UIScreen mainScreen]bounds];
    self.backgroundColor=[[UIColor colorWithHexString:@"000000"]colorWithAlphaComponent:0.4];
    
    _bkView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, self.width, BKVIEW_HEIGHT)];
    _bkView.backgroundColor=[UIColor whiteColor];
    [self addSubview:_bkView];
    
    
    for (NSInteger i=0; i<2; i++){
        UIButton *btn=[UIButton new].func_font(FontRegular(16)).func_titleColor((i==0)?UIColor.app_titleColor:UIColor.app_mainColor).func_title((i==0)?@"取消":@"确认").func_addTarget_action(self,@selector(cancelOrConfirmClick:));
        btn.tag=10+i;
        btn.frame=CGRectMake(i*(_bkView.width-60), 0, 60, 43.5);
        [_bkView addSubview:btn];
    }
    UILabel *seg=[[UILabel alloc]initWithFrame:CGRectMake(0, 43.5, _bkView.width, APP_LINE_WIDTH)];
    seg.backgroundColor=[UIColor app_lineColor];
    [_bkView addSubview:seg];
    
    
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *minDate=[formatter dateFromString:@"1900-1-1"];
    NSDate *maxDate=[formatter dateFromString:@"2099-12-31"];
    
    _datePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(45, 50, _bkView.width-90, _bkView.height-50)];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
    _datePicker.minimumDate=minDate;
    _datePicker.maximumDate=maxDate;
    if (@available(iOS 13.4, *)) {
        _datePicker.preferredDatePickerStyle=UIDatePickerStyleWheels;
    } else {
        // Fallback on earlier versions
    }
    
    [_datePicker addTarget:self action:@selector(dateChange) forControlEvents: UIControlEventValueChanged];
    [_bkView addSubview:_datePicker];
    [_datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(50);
        make.bottom.mas_equalTo(-10);
    }];
}

- (void)dateChange{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
}


- (void)setMinSelectDate:(NSDate *)minSelectDate{
    _minSelectDate=minSelectDate;
    _datePicker.minimumDate=minSelectDate;
}


- (void)setMaxSelectDate:(NSDate *)maxSelectDate{
    _maxSelectDate=maxSelectDate;
    _datePicker.maximumDate=maxSelectDate;
}



- (void)cancelOrConfirmClick:(UIButton *)sender{
    if (sender.tag==11) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        if (self.comp) {
            self.comp(self.datePicker.date, [formatter stringFromDate:self.datePicker.date]);
        }
        if (self.pickerComp) {
            self.pickerComp(self.datePicker.date, [formatter stringFromDate:self.datePicker.date]);
        }
    }
    [self hidden];
}



- (void)show {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    _bkView.alpha = 0;
    
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame=self.bkView.frame;
        frame.origin.y=SCREEN_HEIGHT-BKVIEW_HEIGHT;
        self.bkView.frame=frame;
        
        self.bkView.alpha = 1.0;
    }];
}

- (void)hidden {
    
    [UIView animateWithDuration:0.25f animations:^{
        CGRect frame=self.bkView.frame;
        frame.origin.y=SCREEN_HEIGHT;
        self.bkView.frame=frame;
        
        self.bkView.alpha = 0;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self.bkView removeFromSuperview];
        [self removeFromSuperview];
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint point = [[touches anyObject]  locationInView:self];
    if (point.y < self.height-_bkView.height){
        [self hidden];
    }
}

@end
