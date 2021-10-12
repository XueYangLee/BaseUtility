//
//  BaseCollectionViewCell.m
//  BaseTools
//
//  Created by mac on 2020/5/11.
//  Copyright © 2020 Singularity. All rights reserved.
//

#import "BaseCollectionViewCell.h"

@implementation BaseCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initUI];
    }
    return self;
}


- (void)initUI{
    
}



@end
