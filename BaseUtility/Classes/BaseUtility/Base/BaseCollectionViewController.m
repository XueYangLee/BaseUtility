//
//  BaseCollectionViewController.m
//  BaseTools
//
//  Created by 李雪阳 on 2019/3/29.
//  Copyright © 2019 Singularity. All rights reserved.
//

#import "BaseCollectionViewController.h"
#import "BaseCollectionViewController+EmptyData.h"
#import "UtilityMacro.h"
#import <MJRefresh/MJRefresh.h>

@interface BaseCollectionViewController ()

@end

@implementation BaseCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initCollectionView];
    [self initRefreshControl];
    [self initEmptyData];
    
    self.refreshPages = 1;
    
    self.showRefreshHeader = NO;
    self.showRefreshFooter = NO;
}

- (void)initCollectionView {
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.minimumLineSpacing= 0;
    layout.minimumInteritemSpacing= 0;
    layout.sectionInset=UIEdgeInsetsMake(0, 0, 0, 0);
//    if (self.flowLayout) {
//        layout = self.flowLayout;
//    }
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WINDOW_HEIGHT) collectionViewLayout:layout];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.showsVerticalScrollIndicator=NO;
    self.collectionView.showsHorizontalScrollIndicator=NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    if (@available(iOS 11.0, *)) {
        if ([self respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]){
            self.collectionView.contentInsetAdjustmentBehavior=UIScrollViewContentInsetAdjustmentNever;
        }
    } else {
        if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    [self.view addSubview:self.collectionView];
    
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"baseCollectionViewCell"];
}

- (void)setFlowLayout:(UICollectionViewLayout *)flowLayout {
    _flowLayout = flowLayout;
    self.collectionView.collectionViewLayout = flowLayout;
}


- (void)initRefreshControl{
    WS(weakSelf)
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakSelf.refreshPages = 1;
        [weakSelf loadRefreshData];
    }];
    header.automaticallyChangeAlpha = YES;
    header.lastUpdatedTimeLabel.hidden = YES;
    self.collectionView.mj_header=header;
    
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.refreshPages++;
        [weakSelf loadRefreshData];
    }];
    [footer setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];
    self.collectionView.mj_footer=footer;
}


#pragma mark - collectionView delegate & dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(50, 50);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"baseCollectionViewCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"baseCollectionViewCell" forIndexPath:indexPath];
    }
    
    cell.backgroundColor = [UIColor lightGrayColor];
    
    return cell;
}


- (void)dealloc {
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
}


#pragma mark - baseCellPositionMethod
- (BaseCollectionViewCellPosition)base_cellPositionForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger numberOfRowsInSection = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:indexPath.section];
    if (numberOfRowsInSection == 1) {
        return BaseCollectionViewCellPositionSingleInSection;
    }
    if (indexPath.row == 0) {
        return BaseCollectionViewCellPositionFirstInSection;
    }
    if (indexPath.row == numberOfRowsInSection - 1) {
        return BaseCollectionViewCellPositionLastInSection;
    }
    return BaseCollectionViewCellPositionMiddleInSection;
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
    [self.collectionView.mj_header setHidden:!self.showRefreshHeader];
}

- (void)setShowRefreshFooter:(BOOL)showRefreshFooter{
    _showRefreshFooter=showRefreshFooter;
    [self.collectionView.mj_footer setHidden:!self.showRefreshFooter];
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
    [self.collectionView.mj_header endRefreshing];
}

- (void)endRefreshInFooter{
    [self.collectionView.mj_footer endRefreshing];
}

- (void)endRefreshing{
    [self endRefreshInHeader];
    [self endRefreshInFooter];
}

- (void)resetFooterState{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView.mj_footer setHidden:NO];
        self.collectionView.mj_footer.state = MJRefreshStateIdle;
    });
}

- (void)noMoreData{
    if (self.showRefreshFooter) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView.mj_footer setHidden:NO];
            self.collectionView.mj_footer.state = MJRefreshStateNoMoreData;
        });
    }
}

- (void)noneData{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.collectionView.mj_footer setHidden:YES];
    });
}

- (void)beginRefreshing{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.showRefreshFooter) {
            [self.collectionView.mj_footer setHidden:YES];
        }
        [self.collectionView.mj_header beginRefreshing];
    });
}




@end
