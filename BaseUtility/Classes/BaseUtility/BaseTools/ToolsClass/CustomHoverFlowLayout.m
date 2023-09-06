//
//  CustomHoverFlowLayout.m
//  Doctor
//
//  Created by 李雪阳 on 2023/8/22.
//

#import "CustomHoverFlowLayout.h"

@implementation CustomHoverFlowLayout

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
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
        id<CustomHoverFlowLayout> delegate = (id<CustomHoverFlowLayout>)self.collectionView.delegate;
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


@end
