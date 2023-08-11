//
//  CustomSelectionPicker.m
//  Doctor
//
//  Created by 李雪阳 on 2022/8/18.
//

#import "CustomSelectionPicker.h"
#import "UtilityMacro.h"
#import "UtilityToolsHeader.h"
#import "UtilityCategoryHeader.h"
#import <Masonry/Masonry.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <FuncControl/FuncChains.h>

@interface CustomSelectionPicker ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UIView *bkView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIButton *saveBtn;

@property (nonatomic,assign) BOOL multiple;

@property (nonatomic,strong) NSMutableArray *indexArray;
@property (nonatomic,strong) NSMutableArray *titleArray;

@property (nonatomic,copy) selectionCompletion comp;

@end

#define BKVIEW_HEIGHT 350

@implementation CustomSelectionPicker

- (instancetype)initWithMultiple:(BOOL)multiple
{
    self = [super init];
    if (self) {
        self.multiple = multiple;
        [self initUI];
    }
    return self;
}

- (instancetype)initWithMultiple:(BOOL)multiple completion:(selectionCompletion)comp
{
    self = [super init];
    if (self) {
        self.multiple = multiple;
        self.comp = comp;
        [self initUI];
    }
    return self;
}

- (instancetype)initWithMultiple:(BOOL)multiple data:(NSArray *)dataArray completion:(selectionCompletion)comp
{
    self = [super init];
    if (self) {
        self.multiple = multiple;
        self.comp = comp;
        [self initUI];
        
        if (dataArray.count) {
            _dataArray = dataArray;
            [self.tableView reloadData];
        }
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    [self.tableView reloadData];
}

- (void)setSelectedArray:(NSArray *)selectedArray{
    if (selectedArray.count) {
        NSMutableArray *array=[NSMutableArray array];
        for (NSString *data in self.dataArray) {
            if ([selectedArray containsObject:data]) {
                NSInteger index = [self.dataArray indexOfObject:data];
                [array addObject:@(index)];
            }
        }
        
        self.indexArray=[NSMutableArray arrayWithArray:array];
        self.titleArray=[NSMutableArray arrayWithArray:selectedArray];
        
        [self.tableView reloadData];
    }
}

- (void)setTitle:(NSString *)title{
    _titleLabel.func_text(FORMATEString(title));
}

- (void)initUI{
    
    self.frame=[[UIScreen mainScreen]bounds];
    self.backgroundColor=[[UIColor colorWithHexString:@"000000"]colorWithAlphaComponent:0.4];
    
    _bkView=[[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, self.width, BKVIEW_HEIGHT)];
    _bkView.backgroundColor=[UIColor whiteColor];
    [self addSubview:_bkView];
    _bkView.corner_openClip=YES;
    _bkView.corner_clipType=CornerClipTypeTopBoth;
    _bkView.corner_radius=8;
    
    _titleLabel=[UILabel new].func_frame(CGRectMake(0, 0, _bkView.width, 50)).func_font(FontRegular(16)).func_textColor(UIColor.app_titleColor).func_textAlignment(NSTextAlignmentCenter).func_backgroundColor(UIColor.app_lightBackgroundColor);
    [_bkView addSubview:_titleLabel];
    
    UIButton *closeBtn=[UIButton new].func_frame(CGRectMake(_bkView.width-50, 0, 50, 50)).func_image(UIImageName(@"alert_close")).func_addTarget_action(self,@selector(dismiss));
    [_bkView addSubview:closeBtn];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, MaxY(self.titleLabel), _bkView.width, _bkView.height-MaxY(self.titleLabel)-(self.multiple?60:0)) style:UITableViewStyleGrouped];
    _tableView.backgroundColor = UIColor.whiteColor;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.showsHorizontalScrollIndicator=NO;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.sectionFooterHeight = 0;
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    if (@available(iOS 15.0, *)) {
        _tableView.sectionHeaderTopPadding = 0;
    }
    if (@available(iOS 11.0, *)) {
        if ([self respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]){
            _tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
        }
    }
    [_bkView addSubview:_tableView];
    
    if (self.multiple) {
        _saveBtn=[UIButton new].func_font(FontRegular(15)).func_titleColor(UIColor.whiteColor).func_title(@"保存").func_backgroundColor(UIColor.app_mainColor).func_addTarget_action(self,@selector(saveCompletionClick));
        _saveBtn.cornerRadius=20;
        [_bkView addSubview:_saveBtn];
        [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.bottom.mas_equalTo(-10);
            make.size.mas_equalTo(CGSizeMake(160, 40));
        }];
    }
    
    _indexArray=[NSMutableArray array];
    _titleArray=[NSMutableArray array];
}

- (void)saveCompletionClick{
    
    if (!self.canMultipleEmpty && !self.titleArray.count) {
        [SVProgressHUD showInfoWithStatus:@"请选择"];
        return;
    }
    
    if (self.comp) {
        self.comp(self.indexArray, self.titleArray);
    }
    if (self.selectionComp) {
        self.selectionComp(self.indexArray, self.titleArray);
    }
    
    [self dismiss];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomSelectionPickerTableCell *cell=[CustomSelectionPickerTableCell createCellWithTableView:tableView];
    cell.content=[self.dataArray objectAtIndex:indexPath.row];
    if ([self.indexArray containsObject:@(indexPath.row)]) {
        cell.itemSelected=YES;
    }else{
        cell.itemSelected=NO;
    }
    @weakify(self)
    cell.selectClick = ^(BOOL selected, NSString * _Nonnull title) {
        @strongify(self)
        if (self.multiple) {//多选模式下
            if (selected) {
                if (![self.titleArray containsObject:title]) {
                    [self.titleArray addObject:title];
                }
                if (![self.indexArray containsObject:@(indexPath.row)]) {
                    [self.indexArray addObject:@(indexPath.row)];
                }
                
            }else{
                if ([self.titleArray containsObject:title]) {
                    [self.titleArray removeObject:title];
                }
                if ([self.indexArray containsObject:@(indexPath.row)]) {
                    [self.indexArray removeObject:@(indexPath.row)];
                }
            }
            
        }else{//单选模式下
            self.titleArray = [NSMutableArray arrayWithObject:title];
            self.indexArray = [NSMutableArray arrayWithObject:@(indexPath.row)];
            
            [self saveCompletionClick];
        }
        
        [self.tableView reloadData];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
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

- (void)dismiss {
    
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
        [self dismiss];
    }
}


@end






@implementation CustomSelectionPickerTableCell

- (void)initUI{
    _titleLabel=[UILabel new].func_font(FontRegular(14)).func_textColor(UIColor.app_titleColor);
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-50);
    }];
    
    _selectBtn=[UIButton new].func_image([UIImage new]).func_image_state([UtilityModule imageNamed:@"picker_selected"],UIControlStateSelected).func_contentHorizontalAlignment(UIControlContentHorizontalAlignmentRight).func_addTarget_action(self,@selector(selectBtnClick:));
    [self addSubview:_selectBtn];
    [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-15);
    }];
    
    
    UILabel *seg=[UILabel new].func_backgroundColor(UIColor.app_lineColor);
    [self addSubview:seg];
    [seg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.mas_equalTo(APP_LINE_WIDTH);
    }];
}

- (void)selectBtnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (self.selectClick) {
        self.selectClick(sender.selected, FORMATEString(self.content));
    }
}

- (void)setItemSelected:(BOOL)itemSelected{
    _selectBtn.selected=itemSelected;
}

- (void)setContent:(NSString *)content{
    _content=content;
    _titleLabel.func_text(FORMATEString(content));
}

@end

