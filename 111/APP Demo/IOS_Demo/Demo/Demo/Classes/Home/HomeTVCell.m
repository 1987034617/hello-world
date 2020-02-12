//
//  HomeTVCell.m
//  Demo
//
//  Created by 李静莹 on 2018/12/23.
//  Copyright © 2018年 LiJingYing. All rights reserved.
//

#import "HomeTVCell.h"

@interface  HomeTVCell()

@end
@implementation HomeTVCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.label];
    }
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.label.frame = self.bounds;
}
- (UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc]initWithFrame:self.bounds];
        _label.font = [UIFont systemFontOfSize:14];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}
@end
