//
//  HomeMatchingCell.m
//  Demo
//
//  Created by 李静莹 on 2018/12/23.
//  Copyright © 2018年 LiJingYing. All rights reserved.
//

#import "HomeMatchingCell.h"

@interface HomeMatchingCell ()


@end
@implementation HomeMatchingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (IBAction)test:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(homeMatchingCellTestBtnEventWithDictionary:)]) {
        [self.delegate homeMatchingCellTestBtnEventWithDictionary:self.dict];
    }
}
- (IBAction)sure:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(homeMatchingCellSureBtnEventWithDictionary:)]) {
        [self.delegate homeMatchingCellSureBtnEventWithDictionary:self.dict];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
