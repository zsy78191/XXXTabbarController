//
//  ViewController.m
//  demo
//
//  Created by 张超 on 16/4/20.
//  Copyright © 2016年 gerinn. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self reloadData:@[
                       makeItem(@"Favourite", [UIImage imageNamed:@"i1"]),
                       makeItem(@"Explore", [UIImage imageNamed:@"i2"]),
                       makeItem(@"Pictures", [UIImage imageNamed:@"i3"]),
                       makeItem(@"More", [UIImage imageNamed:@"i4"])
                       ]];
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)idx
{
    switch (idx) {
        case 0:
        {
            return [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController1"];
            break;
        }
        case 1:
        {
            return [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController2"];
            break;
        }
        case 2:
        {
            return [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController3"];
            break;
        }
        case 3:
        {
            return [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController4"];
            break;
        }
        default:
            break;
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
