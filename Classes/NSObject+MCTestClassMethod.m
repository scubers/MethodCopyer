//
//  NSObject+MCTestClassMethod.m
//  MethodCopyer
//
//  Created by 王俊仁 on 2017/5/8.
//  Copyright © 2017年 J. All rights reserved.
//

#import "NSObject+MCTestClassMethod.h"
#import <objc/runtime.h>

@implementation NSObject (MCTestClassMethod)

+ (BOOL)respondsToClassMethod:(SEL)selector {
    Method m = class_getClassMethod(self, selector);
    return m != nil ?: NO;
}

@end
