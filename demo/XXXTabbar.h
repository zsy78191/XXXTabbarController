//
//  XXXTabbar.h
//  SimpleDictionary
//
//  Created by 张超 on 16/3/24.
//  Copyright © 2016年 gerinn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomEasingAnimation.h"
@interface XXXItem : NSObject
@property (nonatomic, copy) NSString* title;
@property (nonatomic, strong) UIImage* image;
XXXItem* makeItem(NSString* title, UIImage* image);
@end

IB_DESIGNABLE @interface XXXTabbar : UIControl

- (void)loadItems:(NSArray<XXXItem*>*)items;

@property (nonatomic, assign, readonly) NSUInteger selectTabIndex;
- (void)selectTabIndex:(NSUInteger)index animate:(BOOL)animate;




@end
