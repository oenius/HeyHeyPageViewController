//
//  HHPageViewController.m
//  WizerdAtom
//
//  Created by YURI_JOU on 16/4/6.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import "HHPageViewController.h"
#import "HHPageBar.h"
#import "UIViewController+HHExtra.h"

@interface HHPageViewController ()
<
UIScrollViewDelegate
>

@property (nonatomic, strong)NSArray *viewControllers;
@property (nonatomic, strong)UIScrollView *scrollView;

@end

@implementation HHPageViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.pageBar.tintColor = [UIColor blackColor];
  self.pageBar.barTintColor = [UIColor whiteColor];
  
}

- (void)setViewControllers:(NSArray *)controllers
{
  [self removeControllers:_viewControllers];
  
  [self layoutViewControllers:controllers];
  
  _viewControllers = controllers;
}

- (void)layoutViewControllers:(NSArray *)controllers
{
  NSMutableArray *pageItems = [@[] mutableCopy];
  
  NSInteger pos = 0;
  
  self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame) * controllers.count, 0);
  for(UIViewController *controller in controllers)
  {
    if([controller isKindOfClass:[UIViewController class]])
    {
      CGFloat offset = CGRectGetWidth(self.view.frame) * pos;
      
      [self addChildViewController:controller];
      [self.scrollView addSubview:controller.view];

      [controller.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pageBar.mas_bottom);
        make.width.bottom.equalTo(self.view);
        make.left.equalTo(self.scrollView).offset(offset);
      }];
      
      if(controller.pageBarItem) [pageItems addObject:controller.pageBarItem];
      ++pos;
    }
  }
  
  [self.pageBar setItems:pageItems];
  [self.view bringSubviewToFront:self.pageBar];
}

- (void)removeControllers:(NSArray *)controllers
{
  for(UIViewController *controller in controllers)
  {
    if([controller isKindOfClass:[UIViewController class]])
    {
      [controller removeFromParentViewController];
      [controller.view removeFromSuperview];
    }
  }
}

- (UIScrollView *)scrollView
{
  if(!_scrollView)
  {
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.autoresizesSubviews = NO;
    
    scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
    scrollView.directionalLockEnabled = YES;
    
    scrollView.delegate = self;

    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self.view);
    }];
    _scrollView = scrollView;
  }
  return _scrollView;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
  //This is the index of the "page" that we will be landing at
  NSUInteger nearestIndex = (NSUInteger)(targetContentOffset->x / scrollView.bounds.size.width + 0.5f);
  
  HHPageBarItem *item = [self.viewControllers[nearestIndex] pageBarItem];
  [self.pageBar setSelectedItem:item];
  //Just to make sure we don't scroll past your content
  nearestIndex = MAX( MIN( nearestIndex, self.viewControllers.count - 1 ), 0 );
  
  //This is the actual x position in the scroll view
  CGFloat xOffset = nearestIndex * scrollView.bounds.size.width;
  
  //I've found that scroll views will "stick" unless this is done
  xOffset = xOffset==0?1:xOffset;
  
  //Tell the scroll view to land on our page
  *targetContentOffset = CGPointMake(xOffset, targetContentOffset->y);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
  if(! decelerate )
  {
    NSUInteger currentIndex = (NSUInteger)(scrollView.contentOffset.x / scrollView.bounds.size.width);
    
    [scrollView setContentOffset:CGPointMake(scrollView.bounds.size.width * currentIndex, 0) animated:YES];
  }
}

- (HHPageBar *)pageBar
{
  if(!_pageBar)
  {
    _pageBar = [[HHPageBar alloc]initWithFrame:CGRectZero];
    
    __weak typeof(self) weakScroll = self;
    [_pageBar setHandleSelectedAtIndex:^(NSInteger currentIndex) {
      [weakScroll.scrollView setContentOffset:CGPointMake(self.scrollView.bounds.size.width * currentIndex, 0) animated:YES];
      HHPageBarItem *item = [weakScroll.viewControllers[currentIndex] pageBarItem];
      [weakScroll.pageBar setSelectedItem:item];
    }];
    [self.view addSubview:_pageBar];
    [_pageBar mas_makeConstraints:^(MASConstraintMaker *make) {
      make.height.equalTo(@44);
      make.left.right.and.top.equalTo(self.view);
    }];
  }
  return _pageBar;
}

@end
