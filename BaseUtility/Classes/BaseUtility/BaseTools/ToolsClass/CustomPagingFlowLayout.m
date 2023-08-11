//
//  CustomPagingFlowLayout.m
//  Doctor
//
//  Created by 李雪阳 on 2021/12/9.
//

#import "CustomPagingFlowLayout.h"


@interface CustomPagingFlowLayout ()

@property (strong, nonatomic) NSMutableArray *allAttributes;

@end

@implementation CustomPagingFlowLayout

/**
    这里只简单的实现只支持1个section，而且section的items个数必须是 itemCountPerRow * rowCount 的整数倍。这里需要在UICollectionView的代理里面做好数组越界检查，防止数组越界造成崩溃。
 */


- (void)prepareLayout {
    [super prepareLayout];
    
    self.allAttributes = [NSMutableArray arrayWithCapacity:0];
    // iCount section==0 的cell个数
    NSInteger iCount = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < iCount; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.allAttributes addObject:attributes];
    }
}

- (CGSize)collectionViewContentSize {
    return [super collectionViewContentSize];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger item = indexPath.item; // 第几个item
    NSUInteger x; // 该item的 x坐标
    NSUInteger y; // 该item的 y坐标
    
    [self targetPositionWithItem:item resultX:&x resultY:&y];
    
    NSUInteger item2 = [self originItemAtX:x y:y];
    
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForItem:item2 inSection:indexPath.section];
    UICollectionViewLayoutAttributes *newAttributes = [super layoutAttributesForItemAtIndexPath:newIndexPath];
    newAttributes.indexPath = indexPath;
    return newAttributes;
    
}

- (NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];
    
    NSMutableArray *tmps = [NSMutableArray arrayWithCapacity:0];
    
    for (UICollectionViewLayoutAttributes *bute1 in attributes) {
        for (UICollectionViewLayoutAttributes *bute2 in self.allAttributes) {
            if (bute1.indexPath.item == bute2.indexPath.item) {
                [tmps addObject:bute2];
                break;
            }
        }
    }
    
    return tmps;
}

// 根据 item 计算目标item的位置 // (第几个item)
// x 横向偏移  y 竖向偏移
- (void)targetPositionWithItem:(NSUInteger)item
                       resultX:(NSUInteger *)x
                       resultY:(NSUInteger *)y {
    
    NSUInteger page = item/(self.itemCountPerRow * self.rowCount); // 第几页(左右翻页)： 每行的cell个数 * 几行
    
    NSUInteger itemX = item % self.itemCountPerRow + page * self.itemCountPerRow; //
    NSUInteger itemY = item / self.itemCountPerRow - page * self.rowCount; //
     
    if (x != NULL) {
        *x = itemX;
    }
    if (y != NULL) {
        *y = itemY;
    }
}

// 根据偏移量计算item的origin
- (NSUInteger)originItemAtX:(NSUInteger)x
                          y:(NSUInteger)y {
    NSUInteger item = x * self.rowCount + y;
    return item;
}


@end
