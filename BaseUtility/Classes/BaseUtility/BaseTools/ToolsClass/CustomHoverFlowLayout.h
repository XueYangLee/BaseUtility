//
//  CustomHoverFlowLayout.h
//  Doctor
//
//  Created by 李雪阳 on 2023/8/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CustomHoverFlowLayout <UICollectionViewDelegateFlowLayout>
// @interface ViewController ()<CustomHoverFlowLayout>
@optional

/// 那组开启那组返回yes
- (BOOL)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind hoverSectionAtIndexPath:(NSIndexPath *)indexPath;

@end



@interface CustomHoverFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *decorationViewAttrs;

@end

NS_ASSUME_NONNULL_END
