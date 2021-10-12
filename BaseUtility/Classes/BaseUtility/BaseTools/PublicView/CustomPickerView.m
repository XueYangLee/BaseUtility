//
//  CustomPickerView.m
//  BaseTools
//
//  Created by 李雪阳 on 2021/4/22.
//  Copyright © 2021 Singularity. All rights reserved.
//

#import "CustomPickerView.h"
#import "UtilityMacro.h"
#import "UtilityCategoryHeader.h"
#import <FuncControl/FuncChains.h>

@interface CustomPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong) UIView *bkView;
@property (nonatomic,strong) UIPickerView *pickerView;

@property (nonatomic,assign) NSInteger pickerIndex;
@property (nonatomic,copy) NSString *pickerTitle;

@property (nonatomic,copy) pickerCompletion comp;

@end

#define BKVIEW_HEIGHT 334

@implementation CustomPickerView

- (instancetype)initWithData:(NSArray *)dataArray completion:(pickerCompletion)comp{
    if ([super init]) {
        
        _comp=comp;
        [self initUI];
        
        if (dataArray.count) {
            _dataArray=dataArray;
            _pickerTitle=dataArray.firstObject;
            _pickerIndex=0;
            [_pickerView reloadAllComponents];
        }
        
    }
    return self;
    
}

- (instancetype)initWithCompletion:(pickerCompletion)comp {
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
    UILabel *seg=[[UILabel alloc]initWithFrame:CGRectMake(0, 43.5, _bkView.width, 0.5)];
    seg.backgroundColor=[UIColor app_lineColor];
    [_bkView addSubview:seg];
    
    
    _pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 50, _bkView.width, _bkView.height-50)];
    _pickerView.delegate=self;
    _pickerView.dataSource=self;
    [_bkView addSubview:_pickerView];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger) row forComponent:(NSInteger)component {
    return [self.dataArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _pickerIndex=row;
    _pickerTitle=[_dataArray objectAtIndex:row];
}


- (void)cancelOrConfirmClick:(UIButton *)sender{
    if (sender.tag==11) {
        if (self.comp) {
            self.comp(_pickerIndex, _pickerTitle);
        }
        if (self.pickerComp) {
            self.pickerComp(_pickerIndex, _pickerTitle);
        }
    }
    [self hidden];
}


- (void)setDataArray:(NSArray *)dataArray{
    _dataArray=dataArray;
    _pickerTitle=dataArray.firstObject;
    _pickerIndex=0;
    [_pickerView reloadAllComponents];
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
