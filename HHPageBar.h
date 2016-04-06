//
//  HHPageBar.h
//  WizerdAtom
//
//  Created by YURI_JOU on 16/4/6.
//  Copyright © 2016年 oenius. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHPageBarItem : NSObject

- (instancetype)initWithTitle:(nullable NSString *)title image:(nullable UIImage *)image selectedImage:(nullable UIImage *)selectedImage;

@end

@interface HHPageBar : UIView

@property (nullable, nonatomic, copy) void(^handleSelectedAtIndex)(NSInteger pos);

@property(nullable, nonatomic, copy) NSArray<HHPageBarItem *> *items;        // get/set visible UITabBarItems. default is nil. changes not animated. shown in order
@property(nullable, nonatomic, strong) HHPageBarItem *selectedItem; // will show feedback based on mode. default is nil

@property(null_resettable, nonatomic, strong) UIColor *tintColor;
@property(nullable, nonatomic, strong) UIColor *barTintColor;  // default is nil

@end
