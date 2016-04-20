//
//  XXXTabbar.m
//  SimpleDictionary
//
//  Created by 张超 on 16/3/24.
//  Copyright © 2016年 gerinn. All rights reserved.
//

#import "XXXTabbar.h"


@implementation XXXItem

XXXItem* makeItem(NSString* title, UIImage* image)
{
    @autoreleasepool {
        XXXItem* item = [[XXXItem alloc] init];
        item.title = title;
        item.image = image;
        return item;
    }
}

@end

@interface XXXTabbar ()
{
    BOOL _firstlayout;
    BOOL _lock;
    CGFloat _detlaDark;
}
@property (nonatomic, assign) CGFloat deltaHeight;

@property (nonatomic, copy) NSArray<XXXItem *>* itemArray;
@property (nonatomic, strong) NSMutableArray* iconArray;
@property (nonatomic, strong) NSMutableArray* titleArray;
@property (nonatomic, strong) NSMutableArray* blockArray;

@property (nonatomic, strong) CustomEasingAnimation* easing;

@end

@implementation XXXTabbar


- (NSMutableArray *)iconArray
{
    if (!_iconArray) {
        _iconArray = [NSMutableArray array];
    }
    return _iconArray;
}

- (NSMutableArray *)titleArray
{
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

- (NSMutableArray *)blockArray
{
    if (!_blockArray) {
        _blockArray = [NSMutableArray array];
    }
    return _blockArray;
}

- (void)loadItems:(NSArray<XXXItem *> *)items
{
    _firstlayout = YES;
    self.itemArray = items;
    [self reload];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    [self.blockArray enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.backgroundColor = backgroundColor;
        obj.tintColor = [self darkerColorForColor:backgroundColor deep:_detlaDark];
        if (idx == self.selectTabIndex) {
            obj.backgroundColor = obj.tintColor;
        }
    }];
    
    [self.iconArray enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.tintColor = [self darkerColorForColor:backgroundColor deep:_detlaDark];
        if (self.selectTabIndex == idx) {
            obj.tintColor = self.tintColor;
        }
       
    }];
}

- (void)reload
{
    self.layer.shadowOffset = CGSizeMake(0, -1);
    self.layer.shadowRadius = 2;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.1;
    
    _detlaDark = 0.3;
    self.deltaHeight = 10;
    
    [[self subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
   
    [self.itemArray enumerateObjectsUsingBlock:^(XXXItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIView* block = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/self.itemArray.count, self.frame.size.height)];
        [self addSubview:block];
        block.backgroundColor = self.backgroundColor;
        block.tintColor = self.backgroundColor;
        [self.blockArray addObject:block];
        
        UIImageView* iconView = [[UIImageView alloc] initWithImage:obj.image];
        [self addSubview:iconView];
        iconView.tintColor = [self darkerColorForColor:self.backgroundColor deep:_detlaDark];
        [self.iconArray addObject:iconView];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
        label.text = obj.title;
        [self addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        [label setFont:[UIFont fontWithName:@"PingFangSC-Light" size:14]];
        [label setTextColor:self.tintColor];
        [self.titleArray addObject:label];
        label.alpha = 0;
        
    }];
    
    _selectTabIndex = -1;
    [self selectTabIndex:0 animate:NO];
}

- (void)dealloc
{
    [self.iconArray removeAllObjects];
    self.iconArray = nil;
    [self.blockArray removeAllObjects];
    self.blockArray = nil;
    [self.titleArray removeAllObjects];
    self.titleArray = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_firstlayout) {
        NSInteger count = self.itemArray.count;
        
        [self.iconArray enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.center = CGPointMake(self.frame.size.width/(count)*(idx+0.5), self.frame.size.height/2);
        }];
        
        [self.blockArray enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.frame = ({
                CGRect frame = obj.frame;
                frame.size.width = self.frame.size.width / count;
                frame.size.height = self.frame.size.height;
                frame.origin.y = 0;
                frame.origin.x = idx * self.frame.size.width / count;
                frame;
            });
            if (idx == self.selectTabIndex) {
                obj.frame = ({
                    CGRect frame = obj.frame;
                    frame.size.width = self.frame.size.width / count;
                    frame.size.height = self.frame.size.height + self.deltaHeight;
                    frame.origin.y = - self.deltaHeight;
                    frame.origin.x = idx * self.frame.size.width / count;
                    frame;
                });
            }
        }];
        
        [self.titleArray enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
            obj.center = CGPointMake(self.frame.size.width/count * (idx + 0.5), self.frame.size.height/2 + 12);
        }];
        
        
        
        _firstlayout = NO;
    }
}

- (void)selectTabIndex:(NSUInteger)index animate:(BOOL)animate
{
    if (_lock) {
        return;
    }
    _lock = YES;
    [self openTab:index animate:animate];
    _selectTabIndex = index;
    _lock = NO;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)openTab:(NSInteger)tab animate:(BOOL)animate
{
    if (tab >= self.blockArray.count) {
        return;
    }
    
    if (tab == self.selectTabIndex) {
        return;
    }
    
    UIView* last = nil;
    if (self.selectTabIndex != -1) {
        last = [self.blockArray objectAtIndex:self.selectTabIndex];
    }

    UIView* new  = [self.blockArray objectAtIndex:tab];
    
//    NSLog(@"----");
    
    if (new == last) {
//        NSLog(@"123123");
    }
    
    if (last) {
        [self animateHighlight:last icon:self.iconArray[self.selectTabIndex] label:self.titleArray[self.selectTabIndex] highlight:NO animate:animate];
    }
    
    [self animateHighlight:new icon:self.iconArray[tab] label:self.titleArray[tab] highlight:YES animate:animate];
}

- (void)animateHighlight:(UIView*)view icon:(UIImageView*)icon label:(UILabel*)label highlight:(BOOL)highlight animate:(BOOL)animate
{
    if (animate) {
        
        UIColor* dark = [self darkerColorForColor:self.backgroundColor deep:_detlaDark];
        
        [CustomEasingAnimation easingFrom:0 to:self.deltaHeight interval:0.14 timing:[CAMediaTimingFunction functionWithControlPoints:.25 :.1 :.25 :1] block:^(CGFloat value) {
          
            if (highlight) {
                view.frame = ({
                    CGRect frame = view.frame;
                    frame.size.height = self.frame.size.height + value;
                    frame.origin.y = - value;
                    frame;
                });
//
                icon.transform = CGAffineTransformMakeTranslation(0, -value*1.3);
                view.backgroundColor = [self darkerColorForColor:self.backgroundColor deep:_detlaDark*value/self.deltaHeight];
                label.alpha = value/self.deltaHeight;
                icon.tintColor = [self colorBetweenColor1:dark color2:[UIColor whiteColor] progress:value/self.deltaHeight];
            }
            else
            {
                view.frame = ({
                    CGRect frame = view.frame;
                    frame.size.height = self.frame.size.height + (self.deltaHeight - value);
                    frame.origin.y =  - self.deltaHeight + value;
                    frame;
                });
                icon.transform = CGAffineTransformMakeTranslation(0,  -(self.deltaHeight-value)*1.3);
                view.backgroundColor = [self darkerColorForColor:self.backgroundColor deep:_detlaDark*(1- value/self.deltaHeight)];
                label.alpha = 1 - value/self.deltaHeight;
                UIColor* color = [self colorBetweenColor1:self.tintColor color2:dark progress:value/self.deltaHeight];
                icon.tintColor = color;
            }
        } comeplte:^{
          
        }];
    }
    else
    {
        if (highlight) {
            view.frame = ({
                CGRect frame = view.frame;
                frame.size.height = self.frame.size.height + self.deltaHeight;
                frame.origin.y = - self.deltaHeight;
                frame;
            });
            icon.transform = CGAffineTransformMakeTranslation(0, - self.deltaHeight*1.3);
            view.backgroundColor = [self darkerColorForColor:self.backgroundColor deep:_detlaDark];
            label.alpha = 1;
            icon.tintColor = self.tintColor;
        }
        else
        {
            view.frame = ({
                CGRect frame = view.frame;
                frame.size.height = self.frame.size.height;
                frame.origin.y = 0;
                frame;
            });
            icon.transform = CGAffineTransformMakeTranslation(0, 0);
            view.backgroundColor = self.backgroundColor;
            label.alpha = 0;
            icon.tintColor = [self darkerColorForColor:self.backgroundColor deep:_detlaDark];
        }
    }
}

- (UIColor *)darkerColorForColor:(UIColor *)c deep:(CGFloat)deep
{
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MIN(MAX(r - deep, 0.0), 1)
                               green:MIN(MAX(g - deep, 0.0), 1)
                                blue:MIN(MAX(b - deep, 0.0), 1)
                               alpha:a];
    return nil;
}

- (UIColor *)darkerColorForColor:(UIColor *)c
{
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - 0.1, 0.0)
                               green:MAX(g - 0.1, 0.0)
                                blue:MAX(b - 0.1, 0.0)
                               alpha:a];
    return nil;
}

- (UIColor*)colorBetweenColor1:(UIColor*)color1 color2:(UIColor*)color2 progress:(CGFloat)progress
{
    CGFloat r1, r2, g1, g2, b1, b2, a1, a2;
    [color1 getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    [color2 getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
//    NSLog(@"%@",@(r1 + (r2-r1)*progress));
    UIColor *avg = [UIColor colorWithRed:MAX(MIN(r1 + (r2-r1)*progress, 1), 0)
                                   green:MAX(MIN(g1 + (g2-g1)*progress, 1), 0)
                                    blue:MAX(MIN(b1 + (b2-b1)*progress, 1), 0)
                                   alpha:MAX(MIN(a1 + (a2-a1)*progress, 1), 0)];
    return avg;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint position = [touch locationInView:self];
    NSUInteger idx = position.x /(self.frame.size.width / self.itemArray.count);
    [self selectTabIndex:idx animate:YES];
}

- (void)drawRect:(CGRect)rect
{
   
}

@end
