//
//  CustomFlowLayout.m
//  BaseTools
//
//  Created by Singularity on 2019/4/18.
//  Copyright © 2019 Singularity. All rights reserved.
//

#import "CustomFlowLayout.h"


#pragma mark - section背景色相关

#define kDecorationReuseIdentifier @"kUICollectionSectionColorIdentifier"

@interface UICollectionSectionColorLayoutAttributes : UICollectionViewLayoutAttributes

@property (nonatomic, strong) UIColor *sectionBgColor;

@end

@implementation UICollectionSectionColorLayoutAttributes

@end

@interface UICollectionSectionColorReusableView : UICollectionReusableView

@end

@implementation UICollectionSectionColorReusableView

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    
    if ([layoutAttributes isKindOfClass:[UICollectionSectionColorLayoutAttributes class]]) {
        self.backgroundColor = [(UICollectionSectionColorLayoutAttributes *)layoutAttributes sectionBgColor];
    }
}

@end

#pragma mark section背景色相关 -


@interface CustomFlowLayout ()

@property (strong, nonatomic) NSCache *cache;

@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *decorationViewAttrs;

@end


@implementation CustomFlowLayout

- (void)setAlignment:(FlowLayoutAlignment)alignment
{
    _alignment = alignment;
    [self invalidateLayout];
}

- (void)prepareLayout
{
    [super prepareLayout];
    self.cache = [NSCache new];
    [self sectionColorPrepare];
}

- (void)invalidateLayout
{
    [super invalidateLayout];
    self.cache = [NSCache new];
}

#pragma mark - section Color
- (void)sectionColorPrepare {
    NSInteger numberOfSections = self.collectionView.numberOfSections;
    if (numberOfSections == 0) {
        return;
    }
    
    [self registerClass:[UICollectionSectionColorReusableView class] forDecorationViewOfKind:kDecorationReuseIdentifier];
    
    if (!self.decorationViewAttrs) {
        self.decorationViewAttrs = [NSMutableArray array];
    }
    else{
        [self.decorationViewAttrs removeAllObjects];
    }
    
    for (int i = 0; i < numberOfSections; i++) {
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:i];
        if (numberOfItems == 0 || ![self.collectionView.delegate conformsToProtocol:@protocol(CustomFlowLayout)]) {
            continue;
        }
        
        UICollectionViewLayoutAttributes *firstAttr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
        UICollectionViewLayoutAttributes *lastAttr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:numberOfItems-1 inSection:i]];
        CGRect sectionFrame = CGRectUnion(firstAttr.frame, lastAttr.frame);
        sectionFrame.origin.x -= self.sectionInset.left;
        sectionFrame.origin.y -= self.sectionInset.top;
        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
            sectionFrame.size.width += self.sectionInset.left + self.sectionInset.right;
            sectionFrame.size.height = self.collectionView.frame.size.height;
        }
        else{
            sectionFrame.size.width = self.collectionView.frame.size.width;
            sectionFrame.size.height += self.sectionInset.top + self.sectionInset.bottom;
        }
        
        UICollectionSectionColorLayoutAttributes *decorationAttributes =
        [UICollectionSectionColorLayoutAttributes layoutAttributesForDecorationViewOfKind:kDecorationReuseIdentifier
                                                                            withIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
        decorationAttributes.frame = sectionFrame;
        decorationAttributes.zIndex = -1;
        UIColor *sectionBgColor = nil;
        if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:backgroundColorForSection:)]) {
            id<CustomFlowLayout> delegate = (id<CustomFlowLayout>)self.collectionView.delegate;
            sectionBgColor = [delegate collectionView:self.collectionView layout:self backgroundColorForSection:i];
        }
        decorationAttributes.sectionBgColor = sectionBgColor;
        [self.decorationViewAttrs addObject:decorationAttributes];
    }
}

#pragma mark - sectionHover

- (NSArray<UICollectionViewLayoutAttributes *> *)customHoverlayoutAttributesForElementsInRect:(CGRect)rect{
    NSMutableArray *superArray = [[super layoutAttributesForElementsInRect:rect] mutableCopy];

    NSMutableIndexSet *missingSections = [NSMutableIndexSet indexSet];

    for (NSUInteger idx=0; idx<[superArray count]; idx++) {
        UICollectionViewLayoutAttributes *layoutAttributes = superArray[idx];

        if (layoutAttributes.representedElementCategory == UICollectionElementCategoryCell) {
            [missingSections addIndex:layoutAttributes.indexPath.section];  // remember that we need to layout header for this section
        }

        if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            [superArray removeObjectAtIndex:idx];  // remove layout of header done by our super, we will do it right later
            idx--;
        }
    }

    // layout all headers needed for the rect using self code
    [missingSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];

        UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        if (layoutAttributes) {
             [superArray addObject:layoutAttributes];
        }
    }];

    for (UICollectionViewLayoutAttributes *attr in self.decorationViewAttrs) {
        if (CGRectIntersectsRect(rect, attr.frame)) {
            [superArray addObject:attr];
        }
    }

    return [superArray copy];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];

    //添加 indexPath.section == 3条件是为了让第三个Section悬停，其他的正常，如果不设置，就是所有的都悬停
    
    BOOL hover = NO;
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:hoverSectionAtIndexPath:)]) {
        id<CustomFlowLayout> delegate = (id<CustomFlowLayout>)self.collectionView.delegate;
        hover = [delegate collectionView:self.collectionView viewForSupplementaryElementOfKind:kind hoverSectionAtIndexPath:indexPath];
    }

    if ([kind isEqualToString:UICollectionElementKindSectionHeader] && hover) {
        UICollectionView * const cv = self.collectionView;

        CGPoint const contentOffset = cv.contentOffset;
        CGPoint nextHeaderOrigin = CGPointMake(INFINITY, INFINITY);

        if (indexPath.section+1 < [cv numberOfSections]) {
            UICollectionViewLayoutAttributes *nextHeaderAttributes = [super layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:[NSIndexPath indexPathForItem:0 inSection:indexPath.section+1]];
            nextHeaderOrigin = nextHeaderAttributes.frame.origin;
        }

        CGRect frame = attributes.frame;

        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            frame.origin.y = MIN(MAX(contentOffset.y, frame.origin.y), nextHeaderOrigin.y - CGRectGetHeight(frame));
        }

        else { // UICollectionViewScrollDirectionHorizontal
            frame.origin.x = MIN(MAX(contentOffset.x, frame.origin.x), nextHeaderOrigin.x - CGRectGetWidth(frame));
        }

        attributes.zIndex = 1024;

        attributes.frame = frame;
    }

    return attributes;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];

    return attributes;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];

    return attributes;
}

- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBound{
    return YES;
}


/* ios9以下同时设置代理cgsize跟itemsize有崩溃现象
- (BOOL)shouldInvalidateLayoutForPreferredLayoutAttributes:(UICollectionViewLayoutAttributes *)preferredAttributes withOriginalAttributes:(UICollectionViewLayoutAttributes *)originalAttributes
{
    return YES;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}*/

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    BOOL hover = NO;
    if ([self.collectionView.delegate respondsToSelector:@selector(openSectionHeaderHoverInCollectionView:)]) {
        id<CustomFlowLayout> delegate = (id<CustomFlowLayout>)self.collectionView.delegate;
        hover = [delegate openSectionHeaderHoverInCollectionView:self.collectionView];
    }
//    if (hover) {
//        return [self customHoverlayoutAttributesForElementsInRect:rect];
//    }
    
    NSArray<UICollectionViewLayoutAttributes *> *attributes = [super layoutAttributesForElementsInRect:rect].copy;

    if (hover) {
        attributes = [self customHoverlayoutAttributesForElementsInRect:rect].copy;
    }
    
    if (self.alignment == FlowLayoutAlignmentJustify) {//默认排列方式下只对颜色的section模块尺寸属性更改添加
        NSMutableArray *allAttributes = [NSMutableArray arrayWithArray:attributes];
        for (UICollectionSectionColorLayoutAttributes *attr in _decorationViewAttrs) {
            if (CGRectIntersectsRect(rect, attr.frame)) {
                [allAttributes addObject:attr];
            }
        }
        return allAttributes;
    }
    
    return [self layoutAttributesForElements:attributes rect:rect];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.alignment == FlowLayoutAlignmentJustify) {
        return [super layoutAttributesForItemAtIndexPath:indexPath];
    }
    return [self attributesAtIndexPath:indexPath];
}

#pragma mark - Private

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElements:(NSArray<UICollectionViewLayoutAttributes *> *)attributes rect:(CGRect)rect
{
    NSMutableArray<UICollectionViewLayoutAttributes *> *alignedAttributes = [NSMutableArray new];
    
    for (UICollectionViewLayoutAttributes *item in attributes) {
        if(item.representedElementKind != nil) {
            [alignedAttributes addObject:item];
        } else {
            [alignedAttributes addObject:[self layoutAttributesForItem:item atIndexPath:item.indexPath]];
        }
    }
    //sectionColor
    for (UICollectionSectionColorLayoutAttributes *attr in self.decorationViewAttrs) {
        if (CGRectIntersectsRect(rect, attr.frame)) {
            [alignedAttributes addObject:attr];
        }
    }
    
    return alignedAttributes.copy;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItem:(UICollectionViewLayoutAttributes *)attributes atIndexPath:(NSIndexPath *)indexPath
{
    return [self attributes:attributes atIndexPath:indexPath];
}

- (UICollectionViewLayoutAttributes *)attributesAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath].copy;
    return [self attributes:attributes atIndexPath:indexPath];
}

- (UICollectionViewLayoutAttributes *)attributes:(UICollectionViewLayoutAttributes *)attributes atIndexPath:(NSIndexPath *)indexPath
{
    if ([self.cache objectForKey:indexPath]) {
        return [self.cache objectForKey:indexPath];
    }
    
    NSMutableArray *itemsInRow = [NSMutableArray array];
    
    const NSInteger totalInSection = [self.collectionView numberOfItemsInSection:indexPath.section];
    const CGFloat width = CGRectGetWidth(self.collectionView.bounds);
    const CGRect rowFrame = CGRectMake(0, CGRectGetMinY(attributes.frame), width, CGRectGetHeight(attributes.frame));
    
    // Go forward to the end or the row or section items
    NSInteger index = indexPath.row;
    while(index++ < totalInSection - 1) {
        
        UICollectionViewLayoutAttributes *next = [super layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:index
                                                                                                               inSection:indexPath.section]].copy;
        
        if (!CGRectIntersectsRect(next.frame, rowFrame)) {
            break;
        }
        [itemsInRow addObject:next];
    }
    
    // Current item
    [itemsInRow addObject:attributes];
    
    // Go backward to the start of the row or first item
    index = indexPath.row;
    while (index-- > 0) {
        
        UICollectionViewLayoutAttributes *prev = [super layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:index
                                                                                                               inSection:indexPath.section]].copy;
        
        if (!CGRectIntersectsRect(prev.frame, rowFrame)) {
            break;
        }
        [itemsInRow addObject:prev];
    }
    
    // Total items width include spacings
    CGFloat totalWidth = self.minimumInteritemSpacing * (itemsInRow.count - 1);
    for (UICollectionViewLayoutAttributes *item in itemsInRow) {
        totalWidth += CGRectGetWidth(item.frame);
    }
    
    // Correct sorting in row
    [itemsInRow sortUsingComparator:^NSComparisonResult(UICollectionViewLayoutAttributes *obj1, UICollectionViewLayoutAttributes *obj2) {
        return obj1.indexPath.row > obj2.indexPath.row;
    }];
    
    CGRect rect = CGRectZero;
    for (UICollectionViewLayoutAttributes *item in itemsInRow) {
        
        CGRect frame = item.frame;
        CGFloat x = frame.origin.x;
        
        if (CGRectIsEmpty(rect)) {
            switch (self.alignment) {
                case FlowLayoutAlignmentLeft:
                    x = self.sectionInset.left;
                    break;
                case FlowLayoutAlignmentCenter:
                    x = (width - totalWidth) / 2.0f;
                    break;
                case FlowLayoutAlignmentRight:
                    x = width - totalWidth - self.sectionInset.right;
                default:
                    break;
            }
        } else {
            x = CGRectGetMaxX(rect) + self.minimumInteritemSpacing;
        }
        
        frame.origin.x = x;
        item.frame = frame;
        rect = frame;
        
        [self.cache setObject:item forKey:item.indexPath];
    }
    
    [self.cache setObject:attributes forKey:indexPath];
    return attributes;
}



-(CGFloat)collectionContentHeightWithItemWidths:(NSArray *)widths WithMaxWidth:(CGFloat)maxWidth WithOneItemHeight:(CGFloat)height{
    CGFloat viewheight = 0;
    
    CGFloat xOffset = self.sectionInset.left;
    CGFloat yOffset = self.sectionInset.top;
    CGFloat xNextOffset = self.sectionInset.left;
    
    for (NSInteger idx = 0; idx < widths.count; idx++) {
        
        float width = [[widths objectAtIndex:idx]floatValue];
        CGSize itemSize = CGSizeMake(width, height);
        
        xNextOffset+=(self.minimumInteritemSpacing + itemSize.width);
        if (xNextOffset > maxWidth - self.sectionInset.right) {
            xOffset = self.sectionInset.left;
            xNextOffset = (self.sectionInset.left + self.minimumInteritemSpacing + itemSize.width);
            yOffset += (itemSize.height + self.minimumLineSpacing);
        }
        else
        {
            xOffset = xNextOffset - (self.minimumInteritemSpacing + itemSize.width);
        }
        
        
        viewheight = yOffset + itemSize.height + self.sectionInset.bottom;
    }
    
    return viewheight;
    
}

-(CalculateData *)collectionContentHeightDataWithItemWidths:(NSArray *)widths WithMaxWidth:(CGFloat)maxWidth WithOneItemHeight:(CGFloat)height WithMoreItemWidth:(CGFloat)moreItemWidth{
    
    CGFloat viewheight = 0;
    CGFloat yOffset = self.sectionInset.top;
    
    CGFloat endX = self.sectionInset.left;
    
    NSInteger noExpandIndex = widths.count;
    NSInteger lineIndex = 0;
    
    for (NSInteger idx = 0; idx < widths.count; idx++) {
        
        float width = [[widths objectAtIndex:idx]floatValue];
        CGSize itemSize = CGSizeMake(width, height);
        
        if (endX + self.minimumInteritemSpacing + moreItemWidth <= maxWidth - self.sectionInset.right) {
            if (lineIndex < 2) {
                noExpandIndex = idx;
            }
        }
        
        if (endX == self.sectionInset.left) {
            endX += itemSize.width;
        }else {
            endX += (self.minimumLineSpacing + itemSize.width);
        }
        
        if (endX > maxWidth - self.sectionInset.right) {
            //说明放不下了
            endX = self.sectionInset.left + (itemSize.width);
            lineIndex ++;
            yOffset += (itemSize.height + self.minimumInteritemSpacing);
        }
        
        if (lineIndex < 2) {
        }else if (lineIndex >= 2) {
            //说明有多行 最后一颗编辑的不需要计算进去
            if (idx == widths.count - 1) {
                continue;
            }
        }
        
        viewheight = yOffset + itemSize.height + self.sectionInset.bottom;
        
    }
    
    CGFloat heightNotExpand = height * 2 + self.sectionInset.top + self.sectionInset.bottom + self.minimumLineSpacing;
    
    CalculateData *data = [CalculateData new];
    data.notExpandHeight = MIN(viewheight, heightNotExpand);
    data.expandHeight = viewheight + (height + self.minimumLineSpacing);
    data.canExpand = lineIndex >= 2?YES:NO;
    data.noExpandIndex = noExpandIndex - 1;
    
    return data;
    
}

-(CGFloat)collectionContentTotalHeightDataWithItemWidths:(NSArray *)widths WithMaxWidth:(CGFloat)maxWidth WithOneItemHeight:(CGFloat)height {
    
    CGFloat viewheight = 0;
    
    CGFloat xOffset = self.sectionInset.left;
    CGFloat yOffset = self.sectionInset.top;
    CGFloat xNextOffset = self.sectionInset.left;
    
    for (NSInteger idx = 0; idx < widths.count; idx++) {
        
        float width = [[widths objectAtIndex:idx]floatValue];
        CGSize itemSize = CGSizeMake(width, height);
        
        xNextOffset+=(self.minimumInteritemSpacing + itemSize.width);
        if (xNextOffset > maxWidth - self.sectionInset.right) {
            xOffset = self.sectionInset.left;
            xNextOffset = (self.sectionInset.left + self.minimumInteritemSpacing + itemSize.width);
            yOffset += (itemSize.height + self.minimumLineSpacing);
            
        }
        else
        {
            xOffset = xNextOffset - (self.minimumInteritemSpacing + itemSize.width);
            
            
        }
        
        viewheight = yOffset + itemSize.height + self.sectionInset.bottom;
    }
    
    
    return viewheight;
    //    return (viewheight + (height + self.minimumLineSpacing));
    
}



@end







@implementation CalculateData

@end
