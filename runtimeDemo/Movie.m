//
//  Movie.m
//  runtimeDemo
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 lcjingdi. All rights reserved.
//

#import "Movie.h"
#import <objc/runtime.h>

@implementation Movie

- (void)encodeWithCoder:(NSCoder *)aCoder {
//    [aCoder encodeObject:_movieId forKey:@"id"];
//    [aCoder encodeObject:_movieName forKey:@"name"];
//    [aCoder encodeObject:_pic_url forKey:@"url"];
    
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
    }
    free(ivars);

}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([self class], &count);
        for (int i = 0; i < count ; i++) {
            Ivar ivar = ivars[i];
            const char *name = ivar_getName(ivar);
            NSString *key = [NSString stringWithUTF8String:name];
            
            id value = [aDecoder decodeObjectForKey:key];
            [self setValue:value forKey:key];
            
        }
        free(ivars);
    }
    return self;
}

- (NSString *)description {
    
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([self class], &count);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:count];
    for (int i = 0; i < count; i++) {
        
        Ivar ivar = ivars[i];
        const char *name = ivar_getName(ivar);
        NSString *ocName = [NSString stringWithUTF8String:name];
        
        id value = [self valueForKey:ocName];
        
        [dict setValue:value forKey:ocName];
    }
    
    return [dict description];
}



@end
