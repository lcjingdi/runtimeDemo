//
//  Person.m
//  runtimeDemo
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 lcjingdi. All rights reserved.
//

#import "Person.h"

@interface Person()
@property (nonatomic, assign) CGFloat wight;
@end

@implementation Person
{
    NSString *_xxoo;
}
- (void)test1 {
    NSLog(@"test1%s", __func__);
}
- (void)test2 {
    NSLog(@"test2%s", __func__);
}
+ (void)test3 {
    NSLog(@"test3%s", __func__);
}
@end
