//
//  ExhibitTableView.m
//  Doctor
//
//  Created by 李雪阳 on 2021/9/2.
//

#import "ExhibitTableView.h"
#import "UtilityToolsHeader.h"

@implementation ExhibitTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self=[super initWithFrame:frame style:style];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.showsVerticalScrollIndicator=NO;
        self.showsHorizontalScrollIndicator=NO;
        self.separatorStyle=UITableViewCellSeparatorStyleNone;
        self.sectionFooterHeight = 0;
        self.estimatedRowHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
        
        [self initEmptyData];
        [self initUI];
        
        self.scrollEnabled=NO;
        self.bounces=NO;
    }
    return self;
}

- (void)initUI{
    
}


#pragma mark - empty
- (void)initEmptyData{
    self.emptyDataSetSource = self;
    self.emptyDataSetDelegate = self;
    
    self.empty_showData = YES;
}

- (void)reloadEmptyDataSet{
    [self reloadEmptyDataSet];
}


- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    return [UtilityModule imageNamed:@"empty_withTitle"];
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    return self.empty_showData;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return NO;
}


@end
