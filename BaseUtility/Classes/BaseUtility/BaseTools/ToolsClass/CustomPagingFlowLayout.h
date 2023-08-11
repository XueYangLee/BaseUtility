//
//  CustomPagingFlowLayout.h
//  Doctor
//
//  Created by 李雪阳 on 2021/12/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomPagingFlowLayout : UICollectionViewFlowLayout

/** 一行中 cell的个数 */
@property (nonatomic,assign) NSUInteger itemCountPerRow;
/** 一页行数 */
@property (nonatomic,assign) NSUInteger rowCount;

@end

NS_ASSUME_NONNULL_END
