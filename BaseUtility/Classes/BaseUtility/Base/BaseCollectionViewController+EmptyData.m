//
//  BaseCollectionViewController+EmptyData.m
//  BaseTools
//
//  Created by 李雪阳 on 2020/10/30.
//  Copyright © 2020 Singularity. All rights reserved.
//

#import "BaseCollectionViewController+EmptyData.h"
#import "UtilityMacro.h"
#import "UIColor+AppColor.h"
#import "UtilityToolsHeader.h"

@implementation BaseCollectionViewController (EmptyData)

- (void)initEmptyData{
    self.collectionView.emptyDataSetSource = self;
    self.collectionView.emptyDataSetDelegate = self;
    
    self.empty_showData = YES;
    self.empty_allowScroll = YES;
}

- (void)reloadEmptyDataSet{
    [self.collectionView reloadEmptyDataSet];
}


- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{
    if (self.empty_image) {
        return self.empty_image;
    }
    return [UtilityModule imageNamed:@"empty"];
}


- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *title = self.empty_title?self.empty_title:@"暂无数据";
    NSDictionary *attributes = @{NSFontAttributeName: FontMedium(16), NSForegroundColorAttributeName: UIColor.app_subTitleColor};
    
    return [[NSAttributedString alloc] initWithString:title attributes:attributes];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView{
    
    if (!self.empty_subTitle) {
        return nil;
    }
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    paragraph.lineSpacing = 4.0;
    
    NSDictionary *attributes = @{NSFontAttributeName: FontRegular(14), NSForegroundColorAttributeName: UIColor.app_subTitleColor, NSParagraphStyleAttributeName: paragraph};
    return [[NSAttributedString alloc] initWithString:self.empty_subTitle attributes:attributes];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
    
    if (!self.empty_buttonTitle) {
        return nil;
    }
    
    NSDictionary *attributes = @{NSFontAttributeName: FontRegular(14), NSForegroundColorAttributeName: UIColor.app_mainColor};
    
    return [[NSAttributedString alloc] initWithString:self.empty_buttonTitle attributes:attributes];
}

- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
    if (!self.empty_buttonBackgroundImage) {
        return nil;
    }
    //添加的按钮外框图片不匹配需另设inset
    UIEdgeInsets capInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
    UIEdgeInsets rectInsets = UIEdgeInsetsZero;
    
    return [[self.empty_buttonBackgroundImage resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:rectInsets];
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView{
    if (!self.empty_backgroundColor) {
        return nil;
    }
    return self.empty_backgroundColor;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    if (self.empty_verticalOffset != 0) {
        return self.empty_verticalOffset;
    }
    return -roundf(self.collectionView.frame.size.height/4);
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView{
    return 10;
}


/*
//跳转空白视图显示中心位置
- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return -self.tableView.tableHeaderView.frame.size.height/2.0f;;
}*/


- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    return self.empty_showData;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return self.empty_allowScroll;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view{
    [self empty_tapEmptyView];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button{
    [self empty_buttonClick];
}

@end
