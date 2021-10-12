//
//  CustomSegmentView.m
//  XH_Tenant
//
//  Created by 李雪阳 on 2021/4/28.
//

#import "CustomSegmentView.h"
#import "UtilityMacro.h"
#import "UtilityCategoryHeader.h"
#import <FuncControl/FuncChains.h>
#import <Masonry/Masonry.h>

@interface CustomSegmentView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,assign) NSInteger selectIndex;

@property (nonatomic,copy) segmentSelect comp;

@end

@implementation CustomSegmentView

- (instancetype)initWithSegmentSelected:(segmentSelect)comp {
    self = [super init];
    if (self) {
        _comp=comp;
        [self initUI];
        self.selectIndex=0;
    }
    return self;
}

- (void)setItems:(NSArray *)items{
    _items=items;
    self.selectIndex=0;
    [self.collectionView reloadData];
    
    if (self.comp) {
        self.comp(self.selectIndex, [self.items objectAtIndex:self.selectIndex]);
    }
}

- (void)setDefaultSelect:(NSInteger)defaultSelect{
    self.selectIndex=defaultSelect;
    [self.collectionView reloadData];
    
    if (self.comp) {
        self.comp(self.selectIndex, [self.items objectAtIndex:self.selectIndex]);
    }
}


- (void)initUI{
    
    self.borderColor=FONT_COLOR666;
    self.borderWidth=0.5;
    
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.minimumLineSpacing= 0;
    layout.minimumInteritemSpacing= 0;
    layout.sectionInset=UIEdgeInsetsMake(0, 0, 0, 0);
    layout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
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
    }
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(0);
    }];
    
    RegisterCollectionViewCellWithClassName(self.collectionView, CustomSegmentCell);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.items.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomSegmentCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([CustomSegmentCell class]) forIndexPath:indexPath];
    cell.itemSelected=(indexPath.row==self.selectIndex)?YES:NO;
    cell.content=[self.items objectAtIndex:indexPath.row];
    @weakify(self)
    cell.contentClick = ^{
        @strongify(self)
        self.selectIndex=indexPath.row;
        [self.collectionView reloadData];
        
        if (self.comp) {
            self.comp(self.selectIndex, [self.items objectAtIndex:self.selectIndex]);
        }
    };
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.width/((self.items.count>5)?5:self.items.count), self.height);
}



@end



@implementation CustomSegmentCell

- (void)initUI{
    _itemBtn=[UIButton new].func_frame(self.bounds).func_font(FontRegular(14)).func_titleColor(FONT_COLOR666).func_titleColor_state(UIColor.whiteColor,UIControlStateDisabled).func_addTarget_action(self,@selector(btnClick));
    [_itemBtn setBackgroundColor:UIColor.clearColor];
    [_itemBtn setBackgroundColor:FONT_COLOR666 forState:UIControlStateDisabled];
    [self addSubview:_itemBtn];
    
    _itemSeg=[UILabel new].func_frame(CGRectMake(self.width-0.25, 0, 0.5, self.width)).func_backgroundColor(FONT_COLOR666);
    [self addSubview:_itemSeg];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _itemBtn.func_frame(self.bounds);
    _itemSeg.func_frame(CGRectMake(self.width-0.25, 0, 0.5, self.width));
}

- (void)btnClick{
    if (self.contentClick) {
        self.contentClick();
    }
}

- (void)setItemSelected:(BOOL)itemSelected{
    _itemBtn.enabled=!itemSelected;
}

- (void)setContent:(NSString *)content{
    _itemBtn.func_title(FORMATEString(content));
}

@end
