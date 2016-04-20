//
//  MainViewController.h
//  SimpleDictionary
//
//  Created by 张超 on 16/3/24.
//  Copyright © 2016年 gerinn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXXTabbar.h"


@interface XXXTabbarController : UIViewController
@property (weak, nonatomic) IBOutlet XXXTabbar *tabbar;

- (void)reloadData:(NSArray*)data;
- (__kindof UIViewController*)viewControllerAtIndex:(NSUInteger)idx;

@property (nonatomic, strong) UIColor* barTintColor;

@end