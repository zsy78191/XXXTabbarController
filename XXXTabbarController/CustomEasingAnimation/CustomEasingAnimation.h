//
//  XXXEasing.h
//  SimpleDictionary
//
//  Created by 张超 on 16/3/23.
//  Copyright © 2016年 gerinn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CustomEasingAnimation : NSObject

+ (CustomEasingAnimation*)easingFrom:(CGFloat)fromValue
                to:(CGFloat)toValue
          interval:(NSTimeInterval)interval
            timing:(CAMediaTimingFunction*)function
             block:(void (^)(CGFloat value))block
          comeplte:(void (^)(void)) finish;

+ (NSArray *)calculateFrameFromValue:(CGFloat)fromValue
                             toValue:(CGFloat)toValue
                              timing:(CAMediaTimingFunction*)function
                          frameCount:(size_t)frameCount;

- (void)invalidate;

@end
