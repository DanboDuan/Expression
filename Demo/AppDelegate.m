//
//  AppDelegate.m
//  Demo
//
//  Created by bob on 2019/2/11.
//  Copyright © 2019 bob. All rights reserved.
//

#import "AppDelegate.h"
#import "DemoViewController.h"

#import <Expression/ExpressionUtility.h>
#import <Expression/Expression.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[DemoViewController new]];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];

    NSString *theString = @"a👌3👌";
    theString = @"é";
//    theString = @"👌";
    NSLog(@"theString(%@)",theString);
    NSRange range ;
    for(NSUInteger i = 0; i < theString.length; i += range.length){
        range = [theString rangeOfComposedCharacterSequenceAtIndex:i];
        NSString *s = [theString substringWithRange:range];
        NSLog(@"(%@)",s);
    }

    NSString *t = [theString precomposedStringWithCanonicalMapping];
    NSString *s = [theString decomposedStringWithCanonicalMapping];
    NSLog(@"decomposed (%@) .length(%zd) %zd",s, s.length, [s lengthOfBytesUsingEncoding:NSUTF32StringEncoding] / 4);
    NSLog(@"precomposed (%@) .length(%zd) %zd",t, t.length, [t lengthOfBytesUsingEncoding:NSUTF32StringEncoding] / 4);
    NSLog(@"precomposed (%C) ", [t characterAtIndex:0]);
    NSLog(@"decomposed (%C)", [s characterAtIndex:0]);

    NSString *c = [[NSString stringWithFormat:@"%C",[t characterAtIndex:0]] decomposedStringWithCanonicalMapping];


    NSLog(@"s contain %@ ", [s containsString:c] ?@"YES":@"NO");
    NSLog(@"t contain %@ ", [t containsString:c] ?@"YES":@"NO");

    NSLog(@"theString(%@) theString.length(%zd) %zd",theString, theString.length, [theString lengthOfBytesUsingEncoding:NSUTF32StringEncoding] / 4);

    [Expression Test];
    return YES;
}

@end
