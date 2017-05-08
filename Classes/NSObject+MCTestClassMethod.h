//
//  NSObject+MCTestClassMethod.h
//  MethodCopyer
//
//  Created by 王俊仁 on 2017/5/8.
//  Copyright © 2017年 J. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ClassMethodTestable <NSObject>

+ (BOOL)respondsToClassMethod:(SEL)selector;

@end


@interface NSObject (MCTestClassMethod) <ClassMethodTestable>

@end
