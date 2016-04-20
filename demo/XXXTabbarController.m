//
//  MainViewController.m
//  SimpleDictionary
//
//  Created by 张超 on 16/3/24.
//  Copyright © 2016年 gerinn. All rights reserved.
//

#import "XXXTabbarController.h"
#import "XXXTabbar.h"
@interface XXXTabbarController() <UINavigationControllerDelegate>
{
   
}
@property (nonatomic, strong) NSMutableDictionary* subDictionary;
@end

@implementation XXXTabbarController

- (UIViewController *)viewControllerAtIndex:(NSUInteger)idx
{
    return nil;
}
 
#pragma mark - UIViewController

- (NSMutableDictionary *)subDictionary
{
    if (!_subDictionary) {
        _subDictionary = [NSMutableDictionary dictionary];
    }
    return _subDictionary;
}

- (void)hashViewController:(__kindof UIViewController*)vc atIndex:(NSUInteger)idx
{
    [self.subDictionary setValue:vc forKey:[NSString stringWithFormat:@"%@",@(idx)]];
}

- (__kindof UIViewController*)controllerAtIndex:(NSUInteger)idx
{
    return self.subDictionary[[NSString stringWithFormat:@"%@",@(idx)]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (UIColor *)barTintColor
{
    if (!_barTintColor) {
        _barTintColor = [UIColor blackColor];
    }
    return _barTintColor;
}

- (void)reloadData:(NSArray*)data
{
    NSArray* array = data;
    
    [self.tabbar loadItems:array];
    
//    self.tabbar.backgroundColor = self.barTintColor;
    
    [self.tabbar addTarget:self action:@selector(selectTabbarIndex:) forControlEvents:UIControlEventValueChanged];
    
    [self loadViewControllerAtIndex:0 animate:NO];
}

- (void)selectTabbarIndex:(id)sender
{
 
    [self loadViewControllerAtIndex:self.tabbar.selectTabIndex animate:YES];
}

- (void)loadViewControllerAtIndex:(NSUInteger)index animate:(BOOL)animate
{
    UIViewController* controller = [self controllerAtIndex:index];
    if (controller == [self.childViewControllers firstObject] && controller!=nil) {
        return;
    }
    
    __block UIView* oldView = nil;
    [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController*)obj setDelegate:nil];
        }
        if (obj.view) {
            oldView = [obj.view snapshotViewAfterScreenUpdates:YES];
            [obj removeFromParentViewController];
            [obj.view removeFromSuperview];
        }
    }];
    if (oldView) {
        [self.view insertSubview:oldView belowSubview:self.tabbar];
    }
    
 
    if (!controller) {
        if ([self respondsToSelector:@selector(viewControllerAtIndex:)]) {
             controller = [self viewControllerAtIndex:index];
        }
        
        if (controller) {
            [self hashViewController:controller atIndex:index];
        }
        
        if (!controller) {
            controller = [UIViewController new];
        }
    }
   
  
    
    [self addChildViewController:controller];
    [self.view insertSubview:controller.view belowSubview:self.tabbar];
    
    if (animate) {
        controller.view.transform = CGAffineTransformMakeScale(1.1, 1.1);
        controller.view.alpha = 0;
        
        [CustomEasingAnimation easingFrom:0 to:1 interval:0.24 timing:[CAMediaTimingFunction functionWithControlPoints:.25 :.1 :.25 :1] block:^(CGFloat value) {
            controller.view.alpha = value;
            controller.view.transform = CGAffineTransformMakeScale(1 + 0.1*(1-value), 1 + 0.1*(1-value));
            
            oldView.alpha = 1-value;
            oldView.transform = CGAffineTransformMakeScale(1 + 0.1*value, 1 + 0.1*value);
        } comeplte:^{
            [oldView removeFromSuperview];
        }];
    }

    if ([controller.view isKindOfClass:[UIScrollView class]]) {
        [(UIScrollView*)controller.view setContentInset:UIEdgeInsetsMake(0, 0, self.tabbar.frame.size.height, 0)];
    }
    
    if ([controller isKindOfClass:[UINavigationController class]]) {
        UIViewController* vc = [(UINavigationController*)controller topViewController];
        if ([vc.view isKindOfClass:[UIScrollView class]]) {
            [(UIScrollView*)vc.view setContentInset:({
                UIEdgeInsets inset = [(UIScrollView*)vc.view contentInset];
                inset.bottom = self.tabbar.frame.size.height;
                inset;
            })];
        }
        
        [(UINavigationController*)controller setDelegate:self];
    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (viewController.hidesBottomBarWhenPushed && viewController != [[navigationController viewControllers] firstObject] && self.tabbar.transform.ty == 0) {
        [CustomEasingAnimation easingFrom:0 to:self.tabbar.frame.size.height + 30 interval:0.14 timing:[CAMediaTimingFunction functionWithControlPoints:.25 :.1 :.25 :1] block:^(CGFloat value) {
            self.tabbar.transform = CGAffineTransformMakeTranslation(0, value);
        } comeplte:^{
            
        }];
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (!viewController.hidesBottomBarWhenPushed && self.tabbar.transform.ty != 0)
    {
        [CustomEasingAnimation easingFrom:self.tabbar.frame.size.height + 30 to:0 interval:0.1 timing:[CAMediaTimingFunction functionWithControlPoints:.25 :.1 :.25 :1] block:^(CGFloat value) {
            self.tabbar.transform = CGAffineTransformMakeTranslation(0, value);
        } comeplte:^{
            
        }];
    }
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [self.subDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, __kindof UIViewController*  _Nonnull obj, BOOL * _Nonnull stop) {
        [obj removeFromParentViewController];
        [obj.view removeFromSuperview];
    }];
    
    [self.subDictionary removeAllObjects];
}


@end
