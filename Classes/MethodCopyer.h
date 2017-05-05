//
//  MethodCopyer.h
//  MethodCopyer
//
//  Created by 王俊仁 on 2017/5/5.
//  Copyright © 2017年 J. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface MethodCopyer : NSObject

+ (void)copyMethodFromProtocol:(Protocol *)aProtocol fromClass:(Class)fromClass toClass:(Class)toClass;


+ (void)copyMethods:(NSArray<NSString *> *)methods fromProtocol:(Protocol *)aProtocol fromClass:(Class)fromClass toClass:(Class)toClass;


+ (void)copyMethodsExcept:(NSArray<NSString *> *)methods fromProtocol:(Protocol *)aProtocol fromClass:(Class)fromClass toClass:(Class)toClass;


@end
