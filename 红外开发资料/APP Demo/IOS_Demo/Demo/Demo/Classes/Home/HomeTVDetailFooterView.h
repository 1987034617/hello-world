//
//  HomeTVDetailFooterView.h
//  Demo
//
//  Created by 李静莹 on 2018/12/23.
//  Copyright © 2018年 LiJingYing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HomeTVDetailFooterViewDelegate <NSObject>

- (void)homeTVDetilFooterViewPreviousEvent;
- (void)homeTVDetilFooterViewNextEvent;
- (void)homeTVDetilFooterViewSureEvent;

@end
@interface HomeTVDetailFooterView : UIView
@property (weak, nonatomic) IBOutlet UIButton *numButton;
@property (nonatomic,weak)id<HomeTVDetailFooterViewDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
