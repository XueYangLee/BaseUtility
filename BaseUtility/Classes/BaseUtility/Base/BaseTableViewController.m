//
//  BaseTableViewController.m
//  BaseTools
//
//  Created by 李雪阳 on 2019/3/29.
//  Copyright © 2019 Singularity. All rights reserved.
//

#import "BaseTableViewController.h"
#import "BaseTableViewController+EmptyData.h"
#import "UtilityMacro.h"
#import <MJRefresh/MJRefresh.h>

@interface BaseTableViewController ()

@end

@implementation BaseTableViewController


- (instancetype)init {
    self = [super init];
    if (self) {
        self.tableViewStyle = UITableViewStyleGrouped;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initTableView];
    [self initRefreshControl];
    [self initEmptyData];
    
    self.refreshPages = 1;
    
    self.showRefreshHeader = NO;
    self.showRefreshFooter = NO;
}

- (void)initTableView{
    [self.tableView removeFromSuperview];
    
    self.tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WINDOW_HEIGHT) style:self.tableViewStyle];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator=NO;
    self.tableView.showsHorizontalScrollIndicator=NO;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0;
    }
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    if (@available(iOS 11.0, *)) {
        if ([self respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]){
            self.tableView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
        }
    } else {
        if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    [self.view addSubview:self.tableView];
    
}


- (void)setTableViewStyle:(UITableViewStyle)tableViewStyle{
    _tableViewStyle=tableViewStyle;
    
    if (self.tableView) {
        [self initTableView];
    }
}


- (void)initRefreshControl{
    WS(weakSelf)
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.refreshPages = 1;
        [weakSelf loadRefreshData];
    }];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header=header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        /* MJRefreshStateNoMoreData
         if (self.totalCount == dataArray.count) {
            scrollView.mj_footer.state = MJRefreshStateNoMoreData;
            return ;
        }
        self.totalCount = dataArray.count;*/
        weakSelf.refreshPages++;
        [weakSelf loadRefreshData];
    }];
    [footer setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];
    self.tableView.mj_footer=footer;
}


#pragma mark - tableView delegate & dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * const identifier = @"baseTableViewCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text=@"如果此内容存在，需配置tableView代理";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.001f;
}


#pragma mark - baseCellPositionMethod
- (BaseTableViewCellPosition)base_cellPositionForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger numberOfRowsInSection = [self.tableView.dataSource tableView:self.tableView numberOfRowsInSection:indexPath.section];
    if (numberOfRowsInSection == 1) {
        return BaseTableViewCellPositionSingleInSection;
    }
    if (indexPath.row == 0) {
        return BaseTableViewCellPositionFirstInSection;
    }
    if (indexPath.row == numberOfRowsInSection - 1) {
        return BaseTableViewCellPositionLastInSection;
    }
    return BaseTableViewCellPositionMiddleInSection;
}

- (BaseTableViewCellPosition)base_cellPositionHasSectionHeaderForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger numberOfRowsInSection = [self.tableView.dataSource tableView:self.tableView numberOfRowsInSection:indexPath.section];
    if (numberOfRowsInSection == 1) {
        return BaseTableViewCellPositionLastInSection;
    }
    if (indexPath.row == 0) {
        return BaseTableViewCellPositionMiddleInSection;
    }
    if (indexPath.row == numberOfRowsInSection - 1) {
        return BaseTableViewCellPositionLastInSection;
    }
    return BaseTableViewCellPositionMiddleInSection;
}


#pragma mark - emptyViewClickMethod
- (void)empty_tapEmptyView{
    //无数据空页面背景点击事件（图片文字范围）
}

- (void)empty_buttonClick{
    //无数据空页面按钮点击事件
}

#pragma mark - setRefresh
- (void)setShowRefreshHeader:(BOOL)showRefreshHeader{
    _showRefreshHeader=showRefreshHeader;
    [self.tableView.mj_header setHidden:!self.showRefreshHeader];
}

- (void)setShowRefreshFooter:(BOOL)showRefreshFooter{
    _showRefreshFooter=showRefreshFooter;
    [self.tableView.mj_footer setHidden:!self.showRefreshFooter];
}

#pragma mark - data refresh protocol
- (void)loadRefreshData{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self endRefreshing];
    });
}

- (void)endRefreshInHeader{
    if (self.showRefreshFooter) {
        [self resetFooterState];
    }
    [self.tableView.mj_header endRefreshing];
}

- (void)endRefreshInFooter{
    [self.tableView.mj_footer endRefreshing];
}

- (void)endRefreshing{
    [self endRefreshInHeader];
    [self endRefreshInFooter];
}

- (void)resetFooterState{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView.mj_footer setHidden:NO];
        self.tableView.mj_footer.state = MJRefreshStateIdle;
    });
}

- (void)noMoreData{
    if (self.showRefreshFooter) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_footer setHidden:NO];
            self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
        });
    }
}

- (void)noneData{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView.mj_footer setHidden:YES];
    });
}

- (void)beginRefreshing{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.showRefreshFooter) {
            [self.tableView.mj_footer setHidden:YES];
        }
        [self.tableView.mj_header beginRefreshing];
    });
}


/*
 * 是否允许多个手势识别器共同识别，一个控件的手势识别后是否阻断手势识别继续向下传播，默认返回NO；如果为YES，响应者链上层对象触发手势识别后，如果下层对象也添加了手势并成功识别也会继续执行，否则上层对象识别后则不再继续传播
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return NO;
}


@end
