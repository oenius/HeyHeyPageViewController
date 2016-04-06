# HeyHeyPageViewController
HeyHeyPageViewController is a page view controller which can trans viewcontroller with swipe gesture

# 题记

> 总有些SBBBB产品经理，要做安卓体验的横滑效果。而我大概的看了下，没有较好的实现，所以HeyHeyPageViewController就这样。
> 在使用方式上， HeyHeyPageViewController 支持集成， storyboard 以及 init， 等多种方式使用。
> 在Api的实际上， HeyHeyPageViewController 尽量做到了，和UITabbarController，相类似的实现。  
> 之前用swift写过类似的功能[pageController](https://github.com/oenius/PageController)

If u do need it, do use & enjoy.

# 如何使用

```
  UIViewController *controller = [[UIViewController alloc]init];
  controller.view.backgroundColor = [UIColor orangeColor];
  controller.pageBarItem = [[HHPageBarItem alloc]initWithTitle:@"全部" image:nil selectedImage:nil];
  
  UIViewController *blurController = [UIViewController new];
  blurController.view.backgroundColor = [UIColor blueColor];
  blurController.pageBarItem = [[HHPageBarItem alloc]initWithTitle:@"每日一卦" image:nil selectedImage:nil];
  
  [self setViewControllers:@[ controller, blurController]];
  
  self.pageBar.tintColor = [UIColor whiteColor];
  self.pageBar.barTintColor = [UIColor defaultForeColor];
  
```
