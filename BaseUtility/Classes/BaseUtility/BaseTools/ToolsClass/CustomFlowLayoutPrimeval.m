//
//  CustomFlowLayoutPrimeval.m
//  BaseTools
//
//  Created by Singularity on 2020/8/12.
//  Copyright © 2020 Singularity. All rights reserved.
//

#import "CustomFlowLayoutPrimeval.h"

//@interface CustomFlowLayoutPrimeval ()
//
//@property (strong, nonatomic) NSCache *cache;
//
//@end
//
//@implementation CustomFlowLayoutPrimeval
//
//
//- (void)setAlignment:(FlowLayoutAlignment)alignment
//{
//    _alignment = alignment;
//    [self invalidateLayout];
//}
//
//- (void)prepareLayout
//{
//    [super prepareLayout];
//    self.cache = [NSCache new];
//}
//
//- (void)invalidateLayout
//{
//    [super invalidateLayout];
//    self.cache = [NSCache new];
//}
//
///* ios9以下同时设置代理cgsize跟itemsize有崩溃现象
//- (BOOL)shouldInvalidateLayoutForPreferredLayoutAttributes:(UICollectionViewLayoutAttributes *)preferredAttributes withOriginalAttributes:(UICollectionViewLayoutAttributes *)originalAttributes
//{
//    return YES;
//}
//
//- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
//{
//    return YES;
//}*/
//
//- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
//{
//    NSArray<UICollectionViewLayoutAttributes *> *attributes = [super layoutAttributesForElementsInRect:rect].copy;
//    if (self.alignment == FlowLayoutAlignmentJustify) {
//        return attributes;
//    }
//    return [self layoutAttributesForElements:attributes];
//}
//
//- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (self.alignment == FlowLayoutAlignmentJustify) {
//        return [super layoutAttributesForItemAtIndexPath:indexPath];
//    }
//    return [self attributesAtIndexPath:indexPath];
//}
//
//#pragma mark - Private
//
//- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElements:(NSArray<UICollectionViewLayoutAttributes *> *)attributes
//{
//    NSMutableArray<UICollectionViewLayoutAttributes *> *alignedAttributes = [NSMutableArray new];
//    
//    for (UICollectionViewLayoutAttributes *item in attributes) {
//        if(item.representedElementKind != nil) {
//            [alignedAttributes addObject:item];
//        } else {
//            [alignedAttributes addObject:[self layoutAttributesForItem:item atIndexPath:item.indexPath]];
//        }
//    }
//    
//    return alignedAttributes.copy;
//}
//
//- (UICollectionViewLayoutAttributes *)layoutAttributesForItem:(UICollectionViewLayoutAttributes *)attributes atIndexPath:(NSIndexPath *)indexPath
//{
//    return [self attributes:attributes atIndexPath:indexPath];
//}
//
//- (UICollectionViewLayoutAttributes *)attributesAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath].copy;
//    return [self attributes:attributes atIndexPath:indexPath];
//}
//
//- (UICollectionViewLayoutAttributes *)attributes:(UICollectionViewLayoutAttributes *)attributes atIndexPath:(NSIndexPath *)indexPath
//{
//    if ([self.cache objectForKey:indexPath]) {
//        return [self.cache objectForKey:indexPath];
//    }
//    
//    NSMutableArray *itemsInRow = [NSMutableArray array];
//    
//    const NSInteger totalInSection = [self.collectionView numberOfItemsInSection:indexPath.section];
//    const CGFloat width = CGRectGetWidth(self.collectionView.bounds);
//    const CGRect rowFrame = CGRectMake(0, CGRectGetMinY(attributes.frame), width, CGRectGetHeight(attributes.frame));
//    
//    // Go forward to the end or the row or section items
//    NSInteger index = indexPath.row;
//    while(index++ < totalInSection - 1) {
//        
//        UICollectionViewLayoutAttributes *next = [super layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:index
//                                                                                                               inSection:indexPath.section]].copy;
//        
//        if (!CGRectIntersectsRect(next.frame, rowFrame)) {
//            break;
//        }
//        [itemsInRow addObject:next];
//    }
//    
//    // Current item
//    [itemsInRow addObject:attributes];
//    
//    // Go backward to the start of the row or first item
//    index = indexPath.row;
//    while (index-- > 0) {
//        
//        UICollectionViewLayoutAttributes *prev = [super layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:index
//                                                                                                               inSection:indexPath.section]].copy;
//        
//        if (!CGRectIntersectsRect(prev.frame, rowFrame)) {
//            break;
//        }
//        [itemsInRow addObject:prev];
//    }
//    
//    // Total items width include spacings
//    CGFloat totalWidth = self.minimumInteritemSpacing * (itemsInRow.count - 1);
//    for (UICollectionViewLayoutAttributes *item in itemsInRow) {
//        totalWidth += CGRectGetWidth(item.frame);
//    }
//    
//    // Correct sorting in row
//    [itemsInRow sortUsingComparator:^NSComparisonResult(UICollectionViewLayoutAttributes *obj1, UICollectionViewLayoutAttributes *obj2) {
//        return obj1.indexPath.row > obj2.indexPath.row;
//    }];
//    
//    CGRect rect = CGRectZero;
//    for (UICollectionViewLayoutAttributes *item in itemsInRow) {
//        
//        CGRect frame = item.frame;
//        CGFloat x = frame.origin.x;
//        
//        if (CGRectIsEmpty(rect)) {
//            switch (self.alignment) {
//                case FlowLayoutAlignmentLeft:
//                    x = self.sectionInset.left;
//                    break;
//                case FlowLayoutAlignmentCenter:
//                    x = (width - totalWidth) / 2.0f;
//                    break;
//                case FlowLayoutAlignmentRight:
//                    x = width - totalWidth - self.sectionInset.right;
//                default:
//                    break;
//            }
//        } else {
//            x = CGRectGetMaxX(rect) + self.minimumInteritemSpacing;
//        }
//        
//        frame.origin.x = x;
//        item.frame = frame;
//        rect = frame;
//        
//        [self.cache setObject:item forKey:item.indexPath];
//    }
//    
//    [self.cache setObject:attributes forKey:indexPath];
//    return attributes;
//}
//
//
//
//-(CGFloat)collectionContentHeightWithItemWidths:(NSArray *)widths WithMaxWidth:(CGFloat)maxWidth WithOneItemHeight:(CGFloat)height{
//    CGFloat viewheight = 0;
//    
//    CGFloat xOffset = self.sectionInset.left;
//    CGFloat yOffset = self.sectionInset.top;
//    CGFloat xNextOffset = self.sectionInset.left;
//    
//    for (NSInteger idx = 0; idx < widths.count; idx++) {
//        
//        float width = [[widths objectAtIndex:idx]floatValue];
//        CGSize itemSize = CGSizeMake(width, height);
//        
//        xNextOffset+=(self.minimumInteritemSpacing + itemSize.width);
//        if (xNextOffset > maxWidth - self.sectionInset.right) {
//            xOffset = self.sectionInset.left;
//            xNextOffset = (self.sectionInset.left + self.minimumInteritemSpacing + itemSize.width);
//            yOffset += (itemSize.height + self.minimumLineSpacing);
//        }
//        else
//        {
//            xOffset = xNextOffset - (self.minimumInteritemSpacing + itemSize.width);
//        }
//        
//        
//        viewheight = yOffset + itemSize.height + self.sectionInset.bottom;
//    }
//    
//    return viewheight;
//    
//}
//
//-(CalculateData *)collectionContentHeightDataWithItemWidths:(NSArray *)widths WithMaxWidth:(CGFloat)maxWidth WithOneItemHeight:(CGFloat)height WithMoreItemWidth:(CGFloat)moreItemWidth{
//    
//    CGFloat viewheight = 0;
//    CGFloat yOffset = self.sectionInset.top;
//    
//    CGFloat endX = self.sectionInset.left;
//    
//    NSInteger noExpandIndex = widths.count;
//    NSInteger lineIndex = 0;
//    
//    for (NSInteger idx = 0; idx < widths.count; idx++) {
//        
//        float width = [[widths objectAtIndex:idx]floatValue];
//        CGSize itemSize = CGSizeMake(width, height);
//        
//        if (endX + self.minimumInteritemSpacing + moreItemWidth <= maxWidth - self.sectionInset.right) {
//            if (lineIndex < 2) {
//                noExpandIndex = idx;
//            }
//        }
//        
//        if (endX == self.sectionInset.left) {
//            endX += itemSize.width;
//        }else {
//            endX += (self.minimumLineSpacing + itemSize.width);
//        }
//        
//        if (endX > maxWidth - self.sectionInset.right) {
//            //说明放不下了
//            endX = self.sectionInset.left + (itemSize.width);
//            lineIndex ++;
//            yOffset += (itemSize.height + self.minimumInteritemSpacing);
//        }
//        
//        if (lineIndex < 2) {
//        }else if (lineIndex >= 2) {
//            //说明有多行 最后一颗编辑的不需要计算进去
//            if (idx == widths.count - 1) {
//                continue;
//            }
//        }
//        
//        viewheight = yOffset + itemSize.height + self.sectionInset.bottom;
//        
//    }
//    
//    CGFloat heightNotExpand = height * 2 + self.sectionInset.top + self.sectionInset.bottom + self.minimumLineSpacing;
//    
//    CalculateData *data = [CalculateData new];
//    data.notExpandHeight = MIN(viewheight, heightNotExpand);
//    data.expandHeight = viewheight + (height + self.minimumLineSpacing);
//    data.canExpand = lineIndex >= 2?YES:NO;
//    data.noExpandIndex = noExpandIndex - 1;
//    
//    return data;
//    
//}
//
//-(CGFloat)collectionContentTotalHeightDataWithItemWidths:(NSArray *)widths WithMaxWidth:(CGFloat)maxWidth WithOneItemHeight:(CGFloat)height {
//    
//    CGFloat viewheight = 0;
//    
//    CGFloat xOffset = self.sectionInset.left;
//    CGFloat yOffset = self.sectionInset.top;
//    CGFloat xNextOffset = self.sectionInset.left;
//    
//    for (NSInteger idx = 0; idx < widths.count; idx++) {
//        
//        float width = [[widths objectAtIndex:idx]floatValue];
//        CGSize itemSize = CGSizeMake(width, height);
//        
//        xNextOffset+=(self.minimumInteritemSpacing + itemSize.width);
//        if (xNextOffset > maxWidth - self.sectionInset.right) {
//            xOffset = self.sectionInset.left;
//            xNextOffset = (self.sectionInset.left + self.minimumInteritemSpacing + itemSize.width);
//            yOffset += (itemSize.height + self.minimumLineSpacing);
//            
//        }
//        else
//        {
//            xOffset = xNextOffset - (self.minimumInteritemSpacing + itemSize.width);
//            
//            
//        }
//        
//        viewheight = yOffset + itemSize.height + self.sectionInset.bottom;
//    }
//    
//    
//    return viewheight;
//    //    return (viewheight + (height + self.minimumLineSpacing));
//    
//}
//
//
//@end
//
//
//
//
//@implementation CalculateData
//
//@end
