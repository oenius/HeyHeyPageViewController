//
//  UIViewController+HHExtra.m
//  WizerdAtom
//
//  Created by YURI_JOU on 16/4/6.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import "UIViewController+HHExtra.h"

static const void *kPageBarItem = &kPageBarItem;

@implementation UIViewController (HHExtra)
@dynamic pageBarItem;

- (HHPageBarItem *)pageBarItem
{
  return objc_getAssociatedObject(self, kPageBarItem);
}

- (void)setPageBarItem:(HHPageBarItem *)pageBarItem
{
  objc_setAssociatedObject(self, kPageBarItem, pageBarItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
