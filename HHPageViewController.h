//
//  HHPageViewController.h
//  WizerdAtom
//
//  Created by YURI_JOU on 16/4/6.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HHPageBar;
@interface HHPageViewController : UIViewController

@property (nonatomic, strong)HHPageBar *pageBar;

- (void)setViewControllers:(NSArray *)controllers;

@end
