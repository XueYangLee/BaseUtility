//
//  CustomSectionColorLayout.m
//  BaseTools
//
//  Created by Singularity on 2020/8/12.
//  Copyright © 2020 Singularity. All rights reserved.
//

#import "CustomSectionColorLayout.h"



//#define kDecorationReuseIdentifier @"kUICollectionSectionColorIdentifier"
//
//@interface UICollectionSectionColorLayoutAttributes : UICollectionViewLayoutAttributes
//
//@property (nonatomic, strong) UIColor *sectionBgColor;
//
//@end
//
//@implementation UICollectionSectionColorLayoutAttributes
//
//@end
//
//
//@interface UICollectionSectionColorReusableView : UICollectionReusableView
//
//@end
//
//@implementation UICollectionSectionColorReusableView
//
//- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
//    [super applyLayoutAttributes:layoutAttributes];
//    
//    if ([layoutAttributes isKindOfClass:[UICollectionSectionColorLayoutAttributes class]]) {
//        self.backgroundColor = [(UICollectionSectionColorLayoutAttributes *)layoutAttributes sectionBgColor];
//    }
//}
//
//@end
//
//
//
//
//
//@interface CustomSectionColorLayout (){
//    NSMutableArray *_decorationViewAttrs;
//}
//
//@end
//
//@implementation CustomSectionColorLayout
//
//- (void)prepareLayout
//{
//    [super prepareLayout];
//    
//    NSInteger numberOfSections = self.collectionView.numberOfSections;
//    if (numberOfSections == 0) {
//        return;
//    }
//    
//    [self registerClass:[UICollectionSectionColorReusableView class] forDecorationViewOfKind:kDecorationReuseIdentifier];
//    
//    if (!_decorationViewAttrs) {
//        _decorationViewAttrs = [NSMutableArray array];
//    }
//    else{
//        [_decorationViewAttrs removeAllObjects];
//    }
//    
//    for (int i = 0; i < numberOfSections; i++) {
//        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:i];
//        if (numberOfItems == 0 || ![self.collectionView.delegate conformsToProtocol:@protocol(CustomSectionColorLayout)]) {
//            continue;
//        }
//        
//        UICollectionViewLayoutAttributes *firstAttr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
//        UICollectionViewLayoutAttributes *lastAttr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:numberOfItems-1 inSection:i]];
//        CGRect sectionFrame = CGRectUnion(firstAttr.frame, lastAttr.frame);
//        sectionFrame.origin.x -= self.sectionInset.left;
//        sectionFrame.origin.y -= self.sectionInset.top;
//        if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
//            sectionFrame.size.width += self.sectionInset.left + self.sectionInset.right;
//            sectionFrame.size.height = self.collectionView.frame.size.height;
//        }
//        else{
//            sectionFrame.size.width = self.collectionView.frame.size.width;
//            sectionFrame.size.height += self.sectionInset.top + self.sectionInset.bottom;
//        }
//        
//        UICollectionSectionColorLayoutAttributes *decorationAttributes =
//        [UICollectionSectionColorLayoutAttributes layoutAttributesForDecorationViewOfKind:kDecorationReuseIdentifier
//                                                                            withIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
//        decorationAttributes.frame = sectionFrame;
//        decorationAttributes.zIndex = -1;
//        UIColor *sectionBgColor = nil;
//        if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:backgroundColorForSection:)]) {
//            id<CustomSectionColorLayout> delegate = (id<CustomSectionColorLayout>)self.collectionView.delegate;
//            sectionBgColor = [delegate collectionView:self.collectionView layout:self backgroundColorForSection:i];
//        }
//        decorationAttributes.sectionBgColor = sectionBgColor;
//        [_decorationViewAttrs addObject:decorationAttributes];
//    }
//}
//
//- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
//    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
//    NSMutableArray *allAttributes = [NSMutableArray arrayWithArray:attributes];
//    for (UICollectionSectionColorLayoutAttributes *attr in _decorationViewAttrs) {
//        if (CGRectIntersectsRect(rect, attr.frame)) {
//            [allAttributes addObject:attr];
//        }
//    }
//    
//    return allAttributes;
//}
//
//@end
