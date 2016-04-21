//
//  ViewController.m
//  runtimeDemo
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 lcjingdi. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "Movie.h"
#import <objc/runtime.h>

@interface ViewController ()
@property (nonatomic, strong) Person *xiaoming;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self getClassMethod];
    
}






//拦截并替换方法
- (void)replaceMethod {
    Class PersionClass = object_getClass([self.xiaoming class]);
    Class ChangeClass = object_getClass([self class]);
    
    /// 源方法的SEL和Method
    SEL oriSEL = @selector(test1);
    Method oriMethod = class_getInstanceMethod(PersionClass, oriSEL);
    
    /// 交换方法的SEL和Method
    SEL cusSEL = @selector(change);
    Method cusMethod = class_getInstanceMethod(ChangeClass, cusSEL);
    
    BOOL addSuccess = class_addMethod(PersionClass, oriSEL, method_getImplementation(cusMethod), method_getTypeEncoding(cusMethod));
    if (addSuccess) {
        // 添加成功,将源方法的实现替换到交换方法的实现
        class_replaceMethod(ChangeClass, cusSEL, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    } else {
        // 添加失败：说明源方法已经有实现，直接将两个方法的实现交换即
        method_exchangeImplementations(oriMethod, cusMethod);
    }
}
- (void)change {
    NSLog(@"%@", @"change");
}
/** 获得协议列表 */
- (void)getProtocol {
    unsigned int count;
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList([Person class], &count);
    for (int i = 0; i<count; i++) {
        
    }
}
/** 获得类方法 */
- (void)getClassMethod {
    Class PersonClass = object_getClass([Person class]);
    SEL oriSEL = @selector(test3);
    Method cusMethod = class_getClassMethod(PersonClass, oriSEL);
}
/** 获得实例方法 */
- (void)getInstanceMethod {
    Person *p = [[Person alloc] init];
    Class instanceClass = object_getClass([p class]);
    SEL oriSEL = @selector(test1);
    Method cusMethod = class_getInstanceMethod(p, oriSEL);
}
/** 添加方法 */
- (void)addMethod {
//    BOOL addSucc = class_addMethod(xiaomingClass, oriSEL, method_getImplementation(cusMethod), method_getTypeEncoding(cusMethod));
}
/** 替换元方法实现 */
- (void)replace {
//    class_replaceMethod(toolClass, cusSEL, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
}

#pragma mark - 属性
/** 获取对象的所有属性名和属性值 */
- (NSDictionary *)allPropertyNamesAndValues:(NSObject *)aObject {
    NSMutableDictionary *resultDict = [NSMutableDictionary dictionary];
    unsigned int outCount = 0;
    objc_property_t *properties = class_copyPropertyList([Person class], &outCount);
    
    for (int i = 0; i < outCount; i++) {
        
        objc_property_t property = properties[i];
        
        //得到C属性名
        const char *name = property_getName(property);
        //得到OC属性名
        NSString *propertyName = [NSString stringWithUTF8String:name];
        //通过属性名拿到属性值
        id propertyValue = [aObject valueForKey:propertyName];
        
        //属性有值或者非空的情况下才保存
        if (propertyValue && propertyValue != nil) {
            [resultDict setObject:propertyValue forKey:propertyName];
        }
    }
    
    free(properties);
    
    return resultDict;
}

#pragma mark - 方法
/** 获取类的所有方法 */
- (void)allMethods:(Class)aClass {
    /*
     到的数据是一个Method数组，Method数据结构中包含了函数的名称、参数、返回值等信息
     其他一些相关函数：
     1.SEL method_getName(Method m) 由Method得到SEL
     2.IMP method_getImplementation(Method m)  由Method得到IMP函数指针
     3.const char *method_getTypeEncoding(Method m)  由Method得到类型编码信息
     4.unsigned int method_getNumberOfArguments(Method m)获取参数个数
     5.char *method_copyReturnType(Method m)  得到返回值类型名称
     6.IMP method_setImplementation(Method m, IMP imp)  为该方法设置一个新的实现
     */
    unsigned int count;
    Method *methodList = class_copyMethodList(aClass, &count);
    
    for (int i = 0; i < count ; i++) {
        Method method = methodList[i];
        // 获取方法名城，但是类型是一个SEL选择器类型
        SEL methodSEL = method_getName(method);
        // 获取C字符串
        const char *name = sel_getName(methodSEL);
        // 获得OC字符串方法名
        NSString *methodName = [NSString stringWithUTF8String:name];
        
        // 获取方法的参数列表
        int arguments = method_getNumberOfArguments(method);
        NSLog(@"方法名：%@, 参数个数:%d", methodName, arguments);
    }
    free(methodList);
}

#pragma mark - 获取对象成员变量的名称
- (NSArray *)allMemberVariables:(Class)aClass {
    /* 要获取对象的成员变量，可以通过class_copyIvarList方法来获取，通过ivar_getName来获取成员变量的名称。对于属性，会自动生成一个成员变量。*/
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList(aClass, &count);
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i++) {
        Ivar variable = ivars[i];
        
        const char *name = ivar_getName(variable);
        NSString *varName = [NSString stringWithUTF8String:name];
        
        [results addObject:varName];
    }
    
    free(ivars);
    
    return results;
}

#pragma mark - runtime用法
#pragma mark 动态修改成员变量
/**
 *  动态修改成员变量
 *
 *  @param object       对象
 *  @param variableName 属性名
 *  @param value        值
 */
- (void)dynamicMotifyObject:(id)object VariableName:(NSString *)variableName ToValue:(id)value{
    
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([object class], &count);
    for (int i = 0; i < count; i++) {
        Ivar variable = ivars[i];
        const char *name = ivar_getName(variable);
        NSString *varName = [NSString stringWithUTF8String:name];
        if ([varName isEqualToString:variableName]) {
            object_setIvar(object, variable, value);
            break;
        }
    }
    free(ivars);
}
#pragma mark 动态增加一个对象的方法
/**
 *  动态增加一个对象的方法
 *
 *  @param object      要增加方法的对象
 *  @param methodName  要增加方法的方法名
 *  @param pointMethod 要增加方法的C函数指针
 *  @param backValue   此方法的返回值"v@:" 意思是，v代表无返回值void，如果是i则代表int；@代表 id sel; : 代表 SEL _cmd;
 */
- (void)dynamicMotifyAddMethod:(id)object methodName:(SEL)methodName pointMethod:(IMP)pointMethod backValue:(NSString *)backValue {
    // 使用场景：在程序当中，假设XiaoMing的中没有`guess`这个方法，后来被Runtime添加一个名字叫guess的方法，最终再调用guess方法做出相应。那么，Runtime是如何做到的呢？
    class_addMethod([object class], methodName, (IMP)pointMethod, backValue.UTF8String);
    // 调用方法
    //    [object performSelector:methodName];
    // 编写实现
    /*
     注意：
     1. 必须有两个指定参数(id self,SEL _cmd)
     2. void的前面没有+、-号，因为只是C的代码。
     void guessAnswer(id self, SEL _cmd) {
     NSLog(@"i am from bei jing");
     }
     */
    
}
/** 动态交换两个方法的实现 */
- (void)changeMethod {
    Method m1 = class_getInstanceMethod([self.xiaoming class], @selector(test1));
    Method m2 = class_getInstanceMethod([self.xiaoming class], @selector(test2));
    
    method_exchangeImplementations(m1, m2);
}

@end
