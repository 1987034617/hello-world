//
//  UIView+Frame.h
//  YeJu_iOS
//
//  Created by 夜聚网 on 2017/10/24.
//  Copyright © 2017年 YeJu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGSize size;
    
@property (nonatomic,assign) CGFloat left;
@property (nonatomic,assign) CGFloat top;
@property (nonatomic,assign) CGFloat right;
@property (nonatomic,assign) CGFloat bottom;

@property (nonatomic, assign) CGFloat MaxX;
@property (nonatomic, assign) CGFloat MaxY;
@end
