//
//  RYTransitionInteractive.h
//  RYImagePicker
//
//  Created by Robert on 16/6/4.
//  Copyright © 2016年 Robert. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^GestureConifg)();

typedef NS_ENUM(NSUInteger, RYTransitionInteractiveGestureDirection) {
    RYTransitionInteractiveGestureDirectionLeft = 1 << 0,
    RYTransitionInteractiveGestureDirectionRight = 1 << 1,
    RYTransitionInteractiveGestureDirectionUp = 1 << 2,
    RYTransitionInteractiveGestureDirectionDown = 1 << 3
};

typedef NS_ENUM(NSUInteger, RYTransitionInteractiveType) {
    RYTransitionInteractiveTypePresent = 0,
    RYTransitionInteractiveTypeDismiss,
    RYTransitionInteractiveTypePush,
    RYTransitionInteractiveTypePop,
};


@interface RYTransitionInteractive : UIPercentDrivenInteractiveTransition

@property (nonatomic, assign) BOOL interation;

@property (nonatomic, copy) GestureConifg presentConifg;

@property (nonatomic, copy) GestureConifg pushConifg;

+ (instancetype)interactiveTransitionWithTransitionType:(RYTransitionInteractiveType)type GestureDirection:(RYTransitionInteractiveGestureDirection)direction;

- (void)addPanGestureForViewController:(UIViewController *)viewController;

@end
