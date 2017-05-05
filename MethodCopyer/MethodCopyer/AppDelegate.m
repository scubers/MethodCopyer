//
//  AppDelegate.m
//  MethodCopyer
//
//  Created by J on 2016/12/22.
//  Copyright © 2016年 J. All rights reserved.
//

#import "AppDelegate.h"
#import "MethodCopyer.h"

@protocol FirstProtocol <NSObject>

@optional

- (void)firstMethodA;
- (void)firstMethodB;
+ (void)firstMethodC;

@end

@protocol SecondProtocol <FirstProtocol>

@optional

- (void)secondMethodA;
- (void)secondMethodB;
+ (void)secondMethodC;

@end


//////////////////////////////////////////////////////

@interface TestObj : NSObject <SecondProtocol>

@end

@implementation TestObj

- (void)firstMethodA {
    NSLog(@"%@: %@", self, NSStringFromSelector(_cmd));
}
- (void)firstMethodB{
    NSLog(@"%@: %@", self, NSStringFromSelector(_cmd));
}
+ (void)firstMethodC{
    NSLog(@"%@: %@", self, NSStringFromSelector(_cmd));
}

- (void)secondMethodA{
    NSLog(@"%@: %@", self, NSStringFromSelector(_cmd));
}
- (void)secondMethodB{
    NSLog(@"%@: %@", self, NSStringFromSelector(_cmd));
}
+ (void)secondMethodC{
    NSLog(@"%@: %@", self, NSStringFromSelector(_cmd));
}

@end

//////////////////////////////////////////////////////



@interface AppDelegate () <SecondProtocol>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"%d", YES == YES);
    NSLog(@"%d", YES == NO);
    NSLog(@"%d", NO == NO);

//    [MethodCopyer copyMethodFromProtocol:@protocol(FirstProtocol) methodType:MCMethodTypeInstanceMethod fromClass:[TestObj class] toClass:[AppDelegate class]];
//    [MethodCopyer copyMethodFromProtocol:@protocol(FirstProtocol) methodType:MCMethodTypeClassMethod fromClass:[TestObj class] toClass:[AppDelegate class]];
//    [MethodCopyer copyMethodFromProtocol:@protocol(SecondProtocol) methodType:MCMethodTypeClassMethod fromClass:[TestObj class] toClass:[AppDelegate class]];
//    [MethodCopyer copyMethodFromProtocol:@protocol(SecondProtocol) methodType:MCMethodTypeInstanceMethod fromClass:[TestObj class] toClass:[AppDelegate class]];

    [MethodCopyer copyMethodsExcept:@[
                                NSStringFromSelector(@selector(firstMethodA)),
//                                NSStringFromSelector(@selector(firstMethodC)),
                                ]
                 fromProtocol:@protocol(FirstProtocol)
                    fromClass:[TestObj class]
                      toClass:self.class];

    [self firstMethodB];
    [self.class firstMethodC];
    [self firstMethodA];

    [self secondMethodA];
    [self secondMethodB];
    [self.class secondMethodC];

    return YES;
}

- (void)firstMethodB {
    
}

@end
