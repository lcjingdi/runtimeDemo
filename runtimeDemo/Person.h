//
//  Person.h
//  runtimeDemo
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 lcjingdi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Person : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) CGFloat age;
- (void)test1;
- (void)test2;
+ (void)test3;
@end
