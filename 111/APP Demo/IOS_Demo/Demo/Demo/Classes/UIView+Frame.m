//
//  UIView+Frame.m
//  YeJu_iOS
//
//  Created by 夜聚网 on 2017/10/24.
//  Copyright © 2017年 YeJu. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)
    
- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame= frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setCenterX:(CGFloat)centerX {
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY {
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY {
    return self.center.y;
}
    
    - (CGFloat)left{
        return self.frame.origin.x;
    }
    
- (CGFloat)top{
    return self.frame.origin.y;
}
    
- (CGFloat)right{
    return self.frame.origin.x+self.frame.size.width;
}
    
- (CGFloat)bottom{
    return self.frame.origin.y+self.frame.size.height;
}

- (void)setLeft:(CGFloat)left{
        CGRect frame=self.frame;
        frame.origin.x=left;
        self.frame=frame;
}
    
- (void)setTop:(CGFloat)top{
    CGRect frame=self.frame;
    frame.origin.y=top;
    self.frame=frame;
}
    
- (void)setRight:(CGFloat)right{
    CGRect frame=self.frame;
    frame.origin.x=right-self.width;
    self.frame=frame;
}
    
- (void)setBottom:(CGFloat)bottom{
    CGRect frame=self.frame;
    frame.origin.y=bottom-self.height;
    self.frame=frame;
}

- (CGFloat)MaxX {
    return [self x] + [self width];
}

- (void)setMaxX:(CGFloat)MaxX {
    CGRect frame = self.frame;
    frame.origin.x = MaxX - [self width];
    self.frame = frame;
    return;
}

- (CGFloat)MaxY {
    return [self y] + [self height];
}

- (void)setMaxY:(CGFloat)MaxY {
    CGRect frame = self.frame;
    frame.origin.y = MaxY - [self height];
    self.frame = frame;
    return;
}

@end
