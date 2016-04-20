//
//  XXXEasing.m
//  SimpleDictionary
//
//  Created by 张超 on 16/3/23.
//  Copyright © 2016年 gerinn. All rights reserved.
//

#import "CustomEasingAnimation.h"
#import "bezier.h"
@interface CustomEasingAnimation()
{
    int _count;
    int _total;
}
@property (nonatomic, strong) CADisplayLink* link;
@property (nonatomic, strong) void (^ block)(CGFloat value);
@property (nonatomic, strong) void (^ finish) ();
@property (nonatomic, strong) NSArray* data;
@end

@implementation CustomEasingAnimation

+ (NSArray *)calculateFrameFromValue:(CGFloat)fromValue toValue:(CGFloat)toValue timing:(CAMediaTimingFunction *)function frameCount:(size_t)frameCount
{
    float p[4][2];
    Point2D cp[4];
    
    for (int i = 0; i < 4; ++i) {
        [function getControlPointAtIndex:i values:p[i]];
        //        NSLog(@"{%f,%f}",p[i][0],p[i][1]);
        cp[i].x = p[i][0];
        cp[i].y = p[i][1];
    }
    
    Point2D* curve = (Point2D*)malloc(frameCount * sizeof(Point2D));
    ComputeBezier(cp, (int)frameCount, curve);
    
    NSMutableArray* array = [NSMutableArray array];
    for (int i = 0; i < frameCount; ++i) {
        //        NSLog(@"{%f,%f}",curve[i].x,curve[i].y);
        [array addObject:@(curve[i].y * (toValue - fromValue) + fromValue)];
    }
    
    free(curve);
    
    return [array copy];
}


+ (CustomEasingAnimation*)easingFrom:(CGFloat)fromValue to:(CGFloat)toValue interval:(NSTimeInterval)interval timing:(CAMediaTimingFunction *)function block:(void (^)(CGFloat))block comeplte:(void (^)(void))finish
{
    CustomEasingAnimation* e = [[CustomEasingAnimation alloc] init];
    e.link = [CADisplayLink displayLinkWithTarget:e selector:@selector(tick:)];
//    e.link.frameInterval = 2;
    [e.link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    e.block = block;
    e.data = [[self class] calculateFrameFromValue:fromValue toValue:toValue timing:function frameCount:interval * 60 / e.link.frameInterval];
    e.finish = finish;
    return e;
}

- (void)setData:(NSArray *)data
{
    _data = data;
    _total = (int)data.count;
    _count = 0;
}

- (void)tick:(CADisplayLink*)sender
{
    if (_count < _total) {
        if (self.block) {
            self.block([self.data[_count] doubleValue]);
        }
        _count ++;
    }
    else
    {
        if (self.finish) {
            self.finish();
        }
        [sender invalidate];
    }
}

- (void)invalidate
{
    [self.link invalidate];
    self.link = nil;
}

@end
