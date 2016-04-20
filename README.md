# XXXTabbarController
A tabbar controller based UIViewController with special user interaction and design.
一个简单的TabbarController

![](https://raw.githubusercontent.com/zsy78191/XXXTabbarController/master/tabbar.gif)

## How to use
###Step 1
Make a subclass of XXXTabbarController.
```objc
#import "XXXTabbarController.h"
@interface ViewController : XXXTabbarController
```
###Step 2
In `ViewController` ViewDidLoad function , call reloadData selector just like this

```objc
 [self reloadData:@[
                       makeItem(@"Favourite", [UIImage imageNamed:@"i1"]),
                       makeItem(@"Explore", [UIImage imageNamed:@"i2"]),
                       makeItem(@"Pictures", [UIImage imageNamed:@"i3"]),
                       makeItem(@"More", [UIImage imageNamed:@"i4"])
                       ]];
```
first parameter with makeItem function is `Title`, second is name of icon image.
### Step 3
Rewrite this funcion return the instance of managed viewcontroller

```objc
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
```
### Step 4
Set tabbar frame and backgroundColor， tintColor at storyboard, `don't forget to link the tabbar to tabbarController`

![](https://raw.githubusercontent.com/zsy78191/XXXTabbarController/master/intro.png)

##More

1. XXXTabbarController use [CustomEasingAnimation](https://github.com/zsy78191/CustomEasingAnimation) to make easing aniamtion.
2. If you have any problem you can [e-mail](mailto:zcleeco@qq.com) me.


