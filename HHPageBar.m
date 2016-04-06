//
//  HHPageBar.m
//  WizerdAtom
//
//  Created by YURI_JOU on 16/4/6.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import "HHPageBar.h"

@interface HHPageBarItem()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *selectedimage;

@end

@implementation HHPageBarItem

- (instancetype)initWithTitle:(nullable NSString *)title image:(nullable UIImage *)image selectedImage:(nullable UIImage *)selectedImage
{
  self = [super init];
  if(self)
  {
    _title = title;
    _image = image;
    _selectedimage = selectedImage;
  }
  return self;
}

- (BOOL)isEqual:(id)object
{
  if([self.title isEqual:[object title]])
  {
    return YES;
  }
  return NO;
}

@end

@interface HHPageBar()
<
UIScrollViewDelegate
>

@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)NSArray *sepLines;
@property (nonatomic, strong)NSArray *itemBtns;

@end

@implementation HHPageBar

- (void)layoutSubviews
{
  [super layoutSubviews];
  [self layoutPageItems:self.itemBtns];
}

- (void)setItems:(NSArray<HHPageBarItem *> *)items
{
  [self removePageItems:self.itemBtns];
  
  NSMutableArray *itemBtns = [@[] mutableCopy];
  
  for(HHPageBarItem *item in items)
  {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:12.f];
    
    [button setTitle:item.title forState:UIControlStateNormal];
    [button setTitleColor:self.tintColor forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(handleAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if(item.selectedimage) [button setImage:item.selectedimage forState:UIControlStateSelected];
    if(item.image) [button setImage:item.image forState:UIControlStateNormal];
    [itemBtns addObject:button];
  }
  
  self.itemBtns = [itemBtns copy];
  
  [self layoutPageItems:itemBtns];
  
  _items = items;
}

- (void)handleAction:(UIButton *)button
{
  NSInteger pos = [self.itemBtns indexOfObject:button];
  if(pos != NSNotFound)
  {
    if(self.handleSelectedAtIndex) self.handleSelectedAtIndex(pos);
  }
}

- (void)removePageItems:(NSArray *)pageItems
{
  [pageItems valueForKey:@"removeFromSuperview"];
}

- (void)layoutPageItems:(NSArray *)pageItems
{
  NSInteger pos = 0;
  for(UIButton *button in pageItems)
  {
    CGFloat offset = pos * [self calWidth:pageItems];
    [self.scrollView addSubview:button];
    if(pos == 0) button.selected = YES;
    [button mas_remakeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(self.scrollView).offset(offset);
      make.top.bottom.equalTo(self);
      make.width.mas_equalTo([self calWidth:pageItems]);
    }];
    ++pos;
  }
}

- (CGFloat)calWidth:(NSArray *)pageItems
{
  NSInteger itemCount = pageItems.count < 5 ? pageItems.count : 5;
  CGFloat width = CGRectGetWidth(self.frame) / itemCount;
  return width;
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
    
    [self addSubview:scrollView];
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.edges.equalTo(self);
    }];
    
    _scrollView = scrollView;
  }
  return _scrollView;
}

- (void)setTintColor:(UIColor *)tintColor
{
  for(UIButton *button in self.itemBtns)
  {
    [button setTitleColor:tintColor forState:UIControlStateNormal];
  }
  _tintColor = tintColor;
}

- (void)setBarTintColor:(UIColor *)barTintColor
{
  self.scrollView.backgroundColor = barTintColor;
  _barTintColor = barTintColor;
}

- (void)setSelectedItem:(HHPageBarItem *)selectedItem
{
  NSInteger pos  = [self.items indexOfObject:selectedItem];
  
  if(pos != NSNotFound)
  {
    for(UIButton *button in self.itemBtns)
    {
      [button setSelected:NO];
    }
    [self.itemBtns[pos] setSelected:YES];
  }
}

@end
