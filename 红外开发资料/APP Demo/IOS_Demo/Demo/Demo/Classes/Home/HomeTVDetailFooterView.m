//
//  HomeTVDetailFooterView.m
//  Demo
//
//  Created by 李静莹 on 2018/12/23.
//  Copyright © 2018年 LiJingYing. All rights reserved.
//

#import "HomeTVDetailFooterView.h"

@implementation HomeTVDetailFooterView
- (IBAction)previous:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(homeTVDetilFooterViewPreviousEvent)]) {
        [self.delegate homeTVDetilFooterViewPreviousEvent];
    }
}
- (IBAction)next:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(homeTVDetilFooterViewNextEvent)]) {
        [self.delegate homeTVDetilFooterViewNextEvent];
    }
}
- (IBAction)sure:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(homeTVDetilFooterViewSureEvent)]) {
        [self.delegate homeTVDetilFooterViewSureEvent];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
