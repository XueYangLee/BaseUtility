//
//  BaseTableViewCell.m
//  BaseTools
//
//  Created by mac on 2020/5/11.
//  Copyright © 2020 Singularity. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)createCellWithTableView:(UITableView *)tableView {
    
    NSString *className = NSStringFromClass([self class]);
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:className];
    if (!cell) {
        cell = [[[self class] alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:className];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self initUI];
    }
    return self;
}

- (void)initUI{
    
}



@end
