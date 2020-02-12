//
//  HomeMatchingCell.h
//  Demo
//
//  Created by 李静莹 on 2018/12/23.
//  Copyright © 2018年 LiJingYing. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HomeMatchingCellDelegate <NSObject>

- (void)homeMatchingCellTestBtnEventWithDictionary:(NSDictionary *)dict;
- (void)homeMatchingCellSureBtnEventWithDictionary:(NSDictionary *)dict;
@end
@interface HomeMatchingCell : UITableViewCell
@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, weak) id<HomeMatchingCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

NS_ASSUME_NONNULL_END
