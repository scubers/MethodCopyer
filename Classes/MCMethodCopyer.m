//
//  MethodCopyer.m
//  MethodCopyer
//
//  Created by 王俊仁 on 2017/5/5.
//  Copyright © 2017年 J. All rights reserved.
//

#import "MCMethodCopyer.h"

#import <objc/runtime.h>

typedef NS_ENUM(NSInteger, MCMethodType) {
    MCMethodTypeClassMethod,
    MCMethodTypeInstanceMethod
};

@implementation MCMethodCopyer

+ (void)copyMethods:(NSArray<NSString *> *)methods
       fromProtocol:(Protocol *)aProtocol
          fromClass:(Class)fromClass
            toClass:(Class)toClass {

    [self _copyMethods:methods containOrNot:YES fromProtocol:aProtocol methodType:MCMethodTypeClassMethod isRequired:YES fromClass:fromClass toClass:toClass force:NO];
    [self _copyMethods:methods containOrNot:YES fromProtocol:aProtocol methodType:MCMethodTypeClassMethod isRequired:NO fromClass:fromClass toClass:toClass force:NO];

    [self _copyMethods:methods containOrNot:YES fromProtocol:aProtocol methodType:MCMethodTypeInstanceMethod isRequired:YES fromClass:fromClass toClass:toClass force:NO];
    [self _copyMethods:methods containOrNot:YES fromProtocol:aProtocol methodType:MCMethodTypeInstanceMethod isRequired:NO fromClass:fromClass toClass:toClass force:NO];

}

+ (void)replaceMethods:(NSArray<NSString *> *)methods
       fromProtocol:(Protocol *)aProtocol
          fromClass:(Class)fromClass
            toClass:(Class)toClass {

    [self _copyMethods:methods containOrNot:YES fromProtocol:aProtocol methodType:MCMethodTypeClassMethod isRequired:YES fromClass:fromClass toClass:toClass force:YES];
    [self _copyMethods:methods containOrNot:YES fromProtocol:aProtocol methodType:MCMethodTypeClassMethod isRequired:NO fromClass:fromClass toClass:toClass force:YES];

    [self _copyMethods:methods containOrNot:YES fromProtocol:aProtocol methodType:MCMethodTypeInstanceMethod isRequired:YES fromClass:fromClass toClass:toClass force:YES];
    [self _copyMethods:methods containOrNot:YES fromProtocol:aProtocol methodType:MCMethodTypeInstanceMethod isRequired:NO fromClass:fromClass toClass:toClass force:YES];
    
}

+ (void)copyMethodsExcept:(NSArray<NSString *> *)methods
             fromProtocol:(Protocol *)aProtocol
                fromClass:(Class)fromClass
                  toClass:(Class)toClass {

    [self _copyMethods:methods containOrNot:NO fromProtocol:aProtocol methodType:MCMethodTypeClassMethod isRequired:YES fromClass:fromClass toClass:toClass force:NO];
    [self _copyMethods:methods containOrNot:NO fromProtocol:aProtocol methodType:MCMethodTypeClassMethod isRequired:NO fromClass:fromClass toClass:toClass force:NO];

    [self _copyMethods:methods containOrNot:NO fromProtocol:aProtocol methodType:MCMethodTypeInstanceMethod isRequired:YES fromClass:fromClass toClass:toClass force:NO];
    [self _copyMethods:methods containOrNot:NO fromProtocol:aProtocol methodType:MCMethodTypeInstanceMethod isRequired:NO fromClass:fromClass toClass:toClass force:NO];
}

+ (void)replaceMethodsExcept:(NSArray<NSString *> *)methods
             fromProtocol:(Protocol *)aProtocol
                fromClass:(Class)fromClass
                  toClass:(Class)toClass {

    [self _copyMethods:methods containOrNot:NO fromProtocol:aProtocol methodType:MCMethodTypeClassMethod isRequired:YES fromClass:fromClass toClass:toClass force:YES];
    [self _copyMethods:methods containOrNot:NO fromProtocol:aProtocol methodType:MCMethodTypeClassMethod isRequired:NO fromClass:fromClass toClass:toClass force:YES];

    [self _copyMethods:methods containOrNot:NO fromProtocol:aProtocol methodType:MCMethodTypeInstanceMethod isRequired:YES fromClass:fromClass toClass:toClass force:YES];
    [self _copyMethods:methods containOrNot:NO fromProtocol:aProtocol methodType:MCMethodTypeInstanceMethod isRequired:NO fromClass:fromClass toClass:toClass force:YES];
}


+ (void)copyMethodFromProtocol:(Protocol *)aProtocol fromClass:(Class)fromClass toClass:(Class)toClass {
    [self _copyMethods:nil containOrNot:NO fromProtocol:aProtocol methodType:MCMethodTypeClassMethod isRequired:YES fromClass:fromClass toClass:toClass force:NO];
    [self _copyMethods:nil containOrNot:NO fromProtocol:aProtocol methodType:MCMethodTypeClassMethod isRequired:NO fromClass:fromClass toClass:toClass force:NO];

    [self _copyMethods:nil containOrNot:NO fromProtocol:aProtocol methodType:MCMethodTypeInstanceMethod isRequired:YES fromClass:fromClass toClass:toClass force:NO];
    [self _copyMethods:nil containOrNot:NO fromProtocol:aProtocol methodType:MCMethodTypeInstanceMethod isRequired:NO fromClass:fromClass toClass:toClass force:NO];
}

+ (void)replaceMethodFromProtocol:(Protocol *)aProtocol fromClass:(Class)fromClass toClass:(Class)toClass {
    [self _copyMethods:nil containOrNot:NO fromProtocol:aProtocol methodType:MCMethodTypeClassMethod isRequired:YES fromClass:fromClass toClass:toClass force:YES];
    [self _copyMethods:nil containOrNot:NO fromProtocol:aProtocol methodType:MCMethodTypeClassMethod isRequired:NO fromClass:fromClass toClass:toClass force:YES];

    [self _copyMethods:nil containOrNot:NO fromProtocol:aProtocol methodType:MCMethodTypeInstanceMethod isRequired:YES fromClass:fromClass toClass:toClass force:YES];
    [self _copyMethods:nil containOrNot:NO fromProtocol:aProtocol methodType:MCMethodTypeInstanceMethod isRequired:NO fromClass:fromClass toClass:toClass force:YES];
}



+ (void)_copyMethods:(NSArray<NSString *> *)methods
        containOrNot:(BOOL)containOrNot
        fromProtocol:(Protocol *)aProtocol
          methodType:(MCMethodType)type
          isRequired:(BOOL)isRequired
           fromClass:(Class)fromClass
             toClass:(Class)toClass
               force:(BOOL)force
{

    BOOL isInstanceMethod = type == MCMethodTypeInstanceMethod;

    unsigned int count;
    struct objc_method_description *descs = protocol_copyMethodDescriptionList(aProtocol, isRequired, isInstanceMethod, &count);
    for (int i = 0; i < count; i++) {
        struct objc_method_description desc = descs[i];

        if ([methods containsObject:NSStringFromSelector(desc.name)] == containOrNot) {


            Method method;
            if (isInstanceMethod) {
                method = class_getInstanceMethod(fromClass, desc.name);
            } else {
                method = class_getClassMethod(fromClass, desc.name);
            }

            IMP imp = method_getImplementation(method);

            if (imp != nil) {
                BOOL flag = class_addMethod(isInstanceMethod ? toClass : objc_getMetaClass(class_getName(toClass)), desc.name, imp, desc.types);
                if (!flag) {
                    if (force) {
                        class_replaceMethod(isInstanceMethod ? toClass : objc_getMetaClass(class_getName(toClass)), desc.name, imp, desc.types);
                    } else {
                        NSLog(@"MechodCopyer Warning: copy method: [%@] from [%@] to [%@] fail", NSStringFromSelector(desc.name), NSStringFromClass(fromClass), NSStringFromClass(toClass));
                    }
                }
            }

        }
    }
    free(descs);
}

@end
